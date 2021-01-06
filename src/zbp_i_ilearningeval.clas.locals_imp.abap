CLASS lhc_Learning DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF approval_status,
        open     TYPE i VALUE '1', " Open
        approved TYPE i VALUE '2', " Approved
        rejected TYPE i VALUE '3', " Rejected
      END OF approval_status.

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

    METHODS setInitialLearningStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR Learning~setInitialLearningStatus.

    METHODS setInitialApprovalStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR Learning~setInitialApprovalStatus.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Learning~validateDates.

ENDCLASS.

CLASS lhc_Learning IMPLEMENTATION.

  METHOD get_instance_features.
    " Read the approval status of the existing learnings
    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
      ENTITY Learning
        FIELDS ( ApprovalStatusId ) WITH CORRESPONDING #( keys )
      RESULT DATA(learnings)
      FAILED failed.

    result =
      VALUE #(
        FOR learning IN learnings
          LET is_accepted =   COND #( WHEN learning-ApprovalStatusId = approval_status-approved
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              is_rejected =   COND #( WHEN learning-ApprovalStatusId = approval_status-rejected
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled
                                      )
          IN
            ( %tky                 = learning-%tky
              %action-approveLearning = is_accepted
              %action-rejectLearning = is_rejected
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
    ENDLOOP.

    " If LearningStatus = Sent for Approval (2), only then it can be approved
    IF ls_learnings-LearningStatusId = '2'.

      " Set the new status as approved
      MODIFY ENTITIES OF zi_ilearningeval IN LOCAL MODE
        ENTITY Learning
           UPDATE
             FIELDS ( ApprovalStatusId LearningStatusId )
             WITH VALUE #( FOR key IN keys
                             ( %tky         = key-%tky
                               ApprovalStatusId = approval_status-approved
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

    " If LearningStatus = New (1) then it cannot be approved
    ELSEIF ls_learnings-LearningStatusId = '1'.
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
*    " Set the new overall status
*    MODIFY ENTITIES OF zi_ilearningeval IN LOCAL MODE
*      ENTITY Learning
*         UPDATE
*           FIELDS ( ApprovalStatusId )
*           WITH VALUE #( FOR key IN keys
*                           ( %tky         = key-%tky
*                             ApprovalStatusId = approval_status-rejected ) )
*      FAILED failed
*      REPORTED reported.
*
*    " Fill the response table
*    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
*      ENTITY Learning
*        ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(new_learnings).
*
*    result = VALUE #( FOR new_learning IN new_learnings
*                        ( %tky   = new_learning-%tky
*                          %param = new_learning ) ).

    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
          ENTITY Learning
            FIELDS ( LearningStatusId ApprovalStatusId ) WITH CORRESPONDING #( keys )
          RESULT DATA(learnings).

    DATA wa_learnings TYPE zi_ilearningeval.
    DATA ls_learnings TYPE zi_ilearningeval.

    LOOP AT learnings INTO wa_learnings.
      ls_learnings-LearningStatusId = wa_learnings-LearningStatusId.
    ENDLOOP.

    " If LearningStatus = Sent for Approval (2), only then it can be approved/rejected
    IF ls_learnings-LearningStatusId = '2'.

      " Set the new status as approved
      MODIFY ENTITIES OF zi_ilearningeval IN LOCAL MODE
        ENTITY Learning
           UPDATE
             FIELDS ( ApprovalStatusId LearningStatusId )
             WITH VALUE #( FOR key IN keys
                             ( %tky         = key-%tky
                               ApprovalStatusId = approval_status-rejected
                               LearningStatusId = '3'
                          ) )
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

    " If LearningStatus = New (1) then it cannot be approved/rejected
    ELSEIF ls_learnings-LearningStatusId = '1'.
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
    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
            ENTITY Learning
              FIELDS ( ApprovalStatusId ApproveRejectDate ) WITH CORRESPONDING #( keys )
            RESULT DATA(learnings).

    " Remove all learning instance data
    DELETE learnings WHERE ApproveRejectDate IS NOT INITIAL.
    CHECK learnings IS NOT INITIAL.

    DATA wa_learnings TYPE zi_ilearningeval.
    DATA ls_learnings TYPE zi_ilearningeval.

    LOOP AT learnings INTO wa_learnings.
      ls_learnings-ApprovalStatusId = wa_learnings-ApprovalStatusId.
    ENDLOOP.
*
    IF ls_learnings-ApprovalStatusId = '2' OR ls_learnings-ApprovalStatusId = '3'.
      " Set LastChangedDate
      MODIFY ENTITIES OF zi_ilearningeval IN LOCAL MODE
      ENTITY Learning
        UPDATE
          FIELDS ( ApproveRejectDate )
          WITH VALUE #( FOR learning IN learnings
                        ( %tky         = learning-%tky
                          ApproveRejectDate = cl_abap_context_info=>get_system_date( ) ) )
      REPORTED DATA(update_reported).
      reported = CORRESPONDING #( DEEP update_reported ).
    ENDIF.

  ENDMETHOD.

  METHOD setLastUpdateDate.
    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
            ENTITY Learning
              FIELDS ( LastChangedDate ) WITH CORRESPONDING #( keys )
            RESULT DATA(learnings).

    " Remove all learning instance data
    DELETE learnings WHERE LastChangedDate IS NOT INITIAL.
    CHECK learnings IS NOT INITIAL.

    " Set LastChangedDate
    MODIFY ENTITIES OF zi_ilearningeval IN LOCAL MODE
    ENTITY Learning
      UPDATE
        FIELDS ( LastChangedDate )
        WITH VALUE #( FOR learning IN learnings
                      ( %tky         = learning-%tky
                        LastChangedDate = cl_abap_context_info=>get_system_date( ) ) )
    REPORTED DATA(update_reported).
    reported = CORRESPONDING #( DEEP update_reported ).

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
    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
            ENTITY Learning
              FIELDS ( CreationDate ) WITH CORRESPONDING #( keys )
            RESULT DATA(learnings).

    " Remove all learning instance data
    DELETE learnings WHERE CreationDate IS NOT INITIAL.
    CHECK learnings IS NOT INITIAL.

    " Set LastChangedDate
    MODIFY ENTITIES OF zi_ilearningeval IN LOCAL MODE
    ENTITY Learning
      UPDATE
        FIELDS ( CreationDate )
        WITH VALUE #( FOR learning IN learnings
                      ( %tky         = learning-%tky
                        CreationDate = cl_abap_context_info=>get_system_date( ) ) )
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

  METHOD validateDates.
    " Read relevant travel instance data
    READ ENTITIES OF zi_ilearningeval IN LOCAL MODE
      ENTITY Learning
        FIELDS ( LearningId StartDate EndDate ) WITH CORRESPONDING #( keys )
      RESULT DATA(learnings).

    LOOP AT learnings INTO DATA(learning).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = learning-%tky
                       %state_area = 'VALIDATE_DATES' )
        TO reported-learning.

      IF learning-EndDate < learning-StartDate.
        APPEND VALUE #( %tky = learning-%tky ) TO failed-learning.
        APPEND VALUE #( %tky               = learning-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcl_iexception_message(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcl_iexception_message=>date_interval
                                                 begindate = learning-StartDate
                                                 enddate   = learning-EndDate
                                                 )
                       ) TO reported-learning.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
