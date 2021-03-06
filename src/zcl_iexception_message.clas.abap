CLASS zcl_iexception_message DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    CONSTANTS:
      BEGIN OF date_interval,
        msgid TYPE symsgid VALUE 'ZILEARNING_MSG',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'BEGINDATE',
        attr2 TYPE scx_attrname VALUE 'ENDDATE',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF date_interval .

    CONSTANTS:
      BEGIN OF unauthorized,
        msgid TYPE symsgid VALUE 'ZILEARNING_MSG',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF unauthorized .

    CONSTANTS:
      BEGIN OF rejected_plan,
        msgid TYPE symsgid VALUE 'ZILEARNING_MSG',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF rejected_plan .

    CONSTANTS:
      BEGIN OF approved_plan,
        msgid TYPE symsgid VALUE 'ZILEARNING_MSG',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF approved_plan .

    CONSTANTS:
      BEGIN OF learning_status,
        msgid TYPE symsgid VALUE 'ZILEARNING_MSG',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'LEARNINGSTATUS',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF learning_status .

        CONSTANTS:
      BEGIN OF authorized_delete_operation,
        msgid TYPE symsgid VALUE 'ZILEARNING_MSG',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF authorized_delete_operation .

    METHODS constructor
      IMPORTING
        severity       TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid         LIKE if_t100_message=>t100key OPTIONAL
        previous       TYPE REF TO cx_root OPTIONAL
        begindate      TYPE zistartdate OPTIONAL
        enddate        TYPE zienddate OPTIONAL
        learningid     TYPE ziid OPTIONAL
        learningstatus TYPE ziid OPTIONAL.

    DATA begindate TYPE zistartdate READ-ONLY.
    DATA enddate TYPE zienddate READ-ONLY.
    DATA learningid TYPE string READ-ONLY.
    DATA learningstatus TYPE string READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_iexception_message IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
    me->if_abap_behv_message~m_severity = severity.
    me->begindate = begindate.
    me->enddate = enddate.
    me->learningid = |{ learningid ALPHA = OUT }|.
    me->learningstatus = |{ learningstatus ALPHA = OUT }|.
  ENDMETHOD.

ENDCLASS.
