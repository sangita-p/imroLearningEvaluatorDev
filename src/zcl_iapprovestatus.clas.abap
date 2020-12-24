CLASS zcl_iapprovestatus DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_iapprovestatus IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM ziapprovestatus.
    DATA lt_approvalstatus TYPE STANDARD TABLE OF ziapprovestatus.

    lt_approvalstatus = VALUE #( ( as_uuid = '00000000000000000000000000000001' as_id = '1' approval_status = 'Open'  )
                                 ( as_uuid = '00000000000000000000000000000002' as_id = '2' approval_status = 'Approved'  )
                                 ( as_uuid = '00000000000000000000000000000003' as_id = '3' approval_status = 'Rejected') ).

    INSERT ziapprovestatus FROM TABLE @lt_approvalstatus.
    out->write( 'Approval Status Data Inserted.' ).
  ENDMETHOD.

ENDCLASS.
