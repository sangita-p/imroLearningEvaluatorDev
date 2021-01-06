CLASS zcl_ilearnstatus DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ilearnstatus IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zilearnstatus.
    DATA lt_learningstatus TYPE STANDARD TABLE OF zilearnstatus.

    lt_learningstatus = VALUE #( ( ls_uuid = '00000000000000000000000000000001' ls_id = '1' learning_status = 'New'  )
                                 ( ls_uuid = '00000000000000000000000000000002' ls_id = '2' learning_status = 'Send for Approval')
                                 ( ls_uuid = '00000000000000000000000000000003' ls_id = '3' learning_status = 'In Process'  )
                                 ( ls_uuid = '00000000000000000000000000000004' ls_id = '4' learning_status = 'Learning Outcome Planned')
                                 ( ls_uuid = '00000000000000000000000000000005' ls_id = '5' learning_status = 'Complete')
                               ).

    INSERT zilearnstatus FROM TABLE @lt_learningstatus.
    out->write( 'Learning Status Data Inserted.' ).
  ENDMETHOD.

ENDCLASS.
