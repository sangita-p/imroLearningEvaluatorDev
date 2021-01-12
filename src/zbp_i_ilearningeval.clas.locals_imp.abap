CLASS lhc_Learning DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Learning RESULT result.

    METHODS approveLearning FOR MODIFY
      IMPORTING keys FOR ACTION Learning~approveLearning RESULT result.

    METHODS rejectLearning FOR MODIFY
      IMPORTING keys FOR ACTION Learning~rejectLearning RESULT result.

    METHODS setApproveRejectDate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Learning~setApproveRejectDate.

    METHODS setLastUpdateDate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Learning~setLastUpdateDate.

    METHODS calculateLearningID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Learning~calculateLearningID.

    METHODS setCreationDate FOR DETERMINE ON SAVE
      IMPORTING keys FOR Learning~setCreationDate.

    METHODS setInitialApprovalStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR Learning~setInitialApprovalStatus.

    METHODS setInitialLearningStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR Learning~setInitialLearningStatus.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Learning~validateDates.

    METHODS validateLearningStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR Learning~validateLearningStatus.

ENDCLASS.

CLASS lhc_Learning IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
    ENTITY Learning
      FIELDS ( ApprovalStatusId LearningStatusId ) WITH CORRESPONDING #( keys )
    RESULT DATA(learnings)
    FAILED failed.

    result = VALUE #( FOR learning IN learnings
                      " When Approval Status = 2 (Approved), then the Approve Learning Plan action button is disabled
                      LET is_accepted = COND #( WHEN learning-ApprovalStatusId = '2'
                                                THEN if_abap_behv=>fc-o-disabled
                                                ELSE if_abap_behv=>fc-o-enabled  )
                       " When Approval Status = 3 (Rejected), then the Reject Learning Plan action button is disabled
                          is_rejected = COND #( WHEN learning-ApprovalStatusId = '3'
                                                THEN if_abap_behv=>fc-o-disabled
                                                ELSE if_abap_behv=>fc-o-enabled )

                      IN ( %tky                 = learning-%tky
                           %action-approveLearning = is_accepted
                           %action-rejectLearning = is_rejected

                           " When Learning Plan is Rejected(3), it cannot be updated
                            %features-%update = COND #( WHEN learning-ApprovalStatusId = '3'
                                                        THEN if_abap_behv=>fc-f-read_only
                                                        ELSE if_abap_behv=>fc-f-unrestricted )
                           " When Learning Plan is Approved(2) or Rejected(3), it cannot be deleted
                            %features-%delete = COND #( WHEN learning-ApprovalStatusId = '2' OR learning-ApprovalStatusId = '3'
                                                        THEN if_abap_behv=>fc-o-disabled
                                                        ELSE if_abap_behv=>fc-o-enabled )
                ) ).
  ENDMETHOD.

  METHOD approveLearning.
    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
            ENTITY Learning
              FIELDS ( LearningStatusId ApprovalStatusId ) WITH CORRESPONDING #( keys )
            RESULT DATA(learnings).

    DATA wa_learnings TYPE zi_ilearningeval.
    DATA ls_learnings TYPE zi_ilearningeval.

    LOOP AT learnings INTO wa_learnings.
      ls_learnings-LearningStatusId = wa_learnings-LearningStatusId.
      ls_learnings-ApprovalStatusId = wa_learnings-ApprovalStatusId.
    ENDLOOP.

    " If Learning Plan is Rejected (3) then display message 'This learning plan cannot be Approved as it is already Rejected'
    IF ls_learnings-ApprovalStatusId = '3'.
      READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
      ENTITY Learning
        FIELDS ( ApprovalStatusId ) WITH CORRESPONDING #( keys )
      RESULT DATA(ll_learnings).

      LOOP AT ll_learnings INTO DATA(ll_learning).
        APPEND VALUE #(  %tky        = ll_learning-%tky
                         %state_area = 'REJECTED_PLAN' )
          TO reported-learning.

        APPEND VALUE #( %tky = ll_learning-%tky ) TO failed-learning.
        APPEND VALUE #( %tky               = ll_learning-%tky
                        %state_area        = 'REJECTED_PLAN'
                        %msg               = NEW zcl_iexception_message(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcl_iexception_message=>rejected_plan ) ) TO reported-learning.
      ENDLOOP.
    ENDIF.

    " If LearningStatus = Sent for Approval (2), only then the learning plan can be approved
    IF ls_learnings-LearningStatusId = '2' AND ls_learnings-ApprovalStatusId <> '3'.

      " Set the new Approval Status as Approved (2) and Learning Status as In Process (3)
      MODIFY ENTITIES OF zi_ilearningeval IN LOCAL MODE
        ENTITY Learning
           UPDATE
             FIELDS ( ApprovalStatusId LearningStatusId )
             WITH VALUE #( FOR key IN keys
                             ( %tky         = key-%tky
                               ApprovalStatusId = '2'
                               LearningStatusId = '3' ) )
        FAILED failed
        REPORTED reported.

      " Fill the response table
      READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
        ENTITY Learning
          ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(new_learnings).

      result = VALUE #( FOR new_learning IN new_learnings
                          ( %tky   = new_learning-%tky
                            %param = new_learning ) ).

    " If LearningStatus = New (1) then display the message 'This learning plan cannot be Approved/Rejected as Learning Status is New'
    ELSEIF ls_learnings-LearningStatusId = '1' AND ls_learnings-ApprovalStatusId <> '3'.
      READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
      ENTITY Learning
        FIELDS ( LearningStatusId ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_learnings).

      LOOP AT lt_learnings INTO DATA(learning).
        APPEND VALUE #(  %tky        = learning-%tky
                         %state_area = 'VALID_LEARNING_STATUS' )
          TO reported-learning.

        APPEND VALUE #( %tky = learning-%tky ) TO failed-learning.
        APPEND VALUE #( %tky               = learning-%tky
                        %state_area        = 'VALID_LEARNING_STATUS'
                        %msg               = NEW zcl_iexception_message(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcl_iexception_message=>unauthorized ) ) TO reported-learning.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD rejectLearning.
    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
            ENTITY Learning
              FIELDS ( LearningStatusId ApprovalStatusId ) WITH CORRESPONDING #( keys )
            RESULT DATA(learnings).

    DATA wa_learnings TYPE zi_ilearningeval.
    DATA ls_learnings TYPE zi_ilearningeval.

    LOOP AT learnings INTO wa_learnings.
      ls_learnings-LearningStatusId = wa_learnings-LearningStatusId.
      ls_learnings-ApprovalStatusId = wa_learnings-ApprovalStatusId.
    ENDLOOP.

    " If ApprovalStatus = 2 (Approved), then display the message 'This learning plan cannot be Rejected as it is already Approved'
    IF ls_learnings-ApprovalStatusId = '2'.
      READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
      ENTITY Learning
        FIELDS ( ApprovalStatusId ) WITH CORRESPONDING #( keys )
      RESULT DATA(l_learnings).

      LOOP AT l_learnings INTO DATA(l_learning).
        APPEND VALUE #(  %tky        = l_learning-%tky
                         %state_area = 'APPROVED_PLAN' )
          TO reported-learning.

        APPEND VALUE #( %tky = l_learning-%tky ) TO failed-learning.
        APPEND VALUE #( %tky               = l_learning-%tky
                        %state_area        = 'APPROVED_PLAN'
                        %msg               = NEW zcl_iexception_message(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcl_iexception_message=>approved_plan ) ) TO reported-learning.
      ENDLOOP.
    ENDIF.

    " If LearningStatus = Sent for Approval (2), only then it can be approved/rejected
    IF ls_learnings-LearningStatusId = '2' AND ls_learnings-ApprovalStatusId <> '3'.

      " Set the new status as approved
      MODIFY ENTITIES OF zi_ilearningeval IN LOCAL MODE
        ENTITY Learning
           UPDATE
             FIELDS ( ApprovalStatusId LearningStatusId )
             WITH VALUE #( FOR key IN keys
                             ( %tky         = key-%tky
                               ApprovalStatusId = '3' ) )
        FAILED failed
        REPORTED reported.

      " Fill the response table
      READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
        ENTITY Learning
          ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(new_learnings).

      result = VALUE #( FOR new_learning IN new_learnings
                          ( %tky   = new_learning-%tky
                            %param = new_learning ) ).

      " If LearningStatus = New (1) then display the message 'This learning plan cannot be Approved/Rejected as Learning Status is New'
    ELSEIF ls_learnings-LearningStatusId = '1' AND ls_learnings-ApprovalStatusId <> '3'.
      READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
      ENTITY Learning
        FIELDS ( LearningStatusId ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_learnings).

      LOOP AT lt_learnings INTO DATA(learning).
        APPEND VALUE #(  %tky        = learning-%tky
                         %state_area = 'VALID_LEARNING_STATUS' )
          TO reported-learning.

        APPEND VALUE #( %tky = learning-%tky ) TO failed-learning.
        APPEND VALUE #( %tky               = learning-%tky
                        %state_area        = 'VALID_LEARNING_STATUS'
                        %msg               = NEW zcl_iexception_message(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcl_iexception_message=>unauthorized ) ) TO reported-learning.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD setApproveRejectDate.
  ENDMETHOD.

  METHOD setLastUpdateDate.
  ENDMETHOD.

  METHOD calculateLearningID.
    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
    ENTITY Learning
      FIELDS ( LearningId ) WITH CORRESPONDING #( keys )
    RESULT DATA(learnings).

    " remove lines where LearningID is already filled.
    DELETE learnings WHERE LearningId IS NOT INITIAL.

    " anything left ?
    CHECK learnings IS NOT INITIAL.

    " Select max LearningID
    SELECT SINGLE
        FROM  zilearningeval
        FIELDS MAX( learning_id ) AS learningID
        INTO @DATA(max_learningid).

    " Set the Learning ID
    MODIFY ENTITIES OF zi_ilearningeval IN LOCAL MODE
    ENTITY Learning
      UPDATE
        FROM VALUE #( FOR learning IN learnings INDEX INTO i (
          %tky                  = learning-%tky
          LearningId            = max_learningid + i
          %control-LearningId   = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).
    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD setCreationDate.
  ENDMETHOD.

  METHOD setInitialApprovalStatus.
    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
             ENTITY Learning
               FIELDS ( ApprovalStatusId ) WITH CORRESPONDING #( keys )
             RESULT DATA(learnings).

    " Remove all learning instance data with defined status
    DELETE learnings WHERE ApprovalStatusId IS NOT INITIAL.
    CHECK learnings IS NOT INITIAL.

    " Set LastChangedDate
    MODIFY ENTITIES OF zi_ilearningeval IN LOCAL MODE
    ENTITY Learning
      UPDATE
        FIELDS ( ApprovalStatusId )
        WITH VALUE #( FOR learning IN learnings
                      ( %tky         = learning-%tky
                        ApprovalStatusId = '1' ) )
    REPORTED DATA(update_reported).
    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD setInitialLearningStatus.
    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
              ENTITY Learning
                FIELDS ( LearningStatusId ) WITH CORRESPONDING #( keys )
              RESULT DATA(learnings).

    " Remove all learning instance data with defined status
    DELETE learnings WHERE LearningStatusId IS NOT INITIAL.
    CHECK learnings IS NOT INITIAL.

    " Set LastChangedDate
    MODIFY ENTITIES OF zi_ilearningeval IN LOCAL MODE
    ENTITY Learning
      UPDATE
        FIELDS ( LearningStatusId )
        WITH VALUE #( FOR learning IN learnings
                      ( %tky         = learning-%tky
                        LearningStatusId = '1' ) )
    REPORTED DATA(update_reported).
    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validateDates.
  ENDMETHOD.

  METHOD validateLearningStatus.
  ENDMETHOD.

ENDCLASS.
