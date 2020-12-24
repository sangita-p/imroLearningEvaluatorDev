CLASS zcl_ilearnoutcome DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ilearnoutcome IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zilearnoutcome.
    DATA lt_learningoutcome TYPE STANDARD TABLE OF zilearnoutcome.

    lt_learningoutcome = VALUE #( ( lo_uuid = '00000000000000000000000000000001' lo_id = '1' learning_outcome = 'POC'  )
                                  ( lo_uuid = '00000000000000000000000000000002' lo_id = '2' learning_outcome = 'Project'  )
                                  ( lo_uuid = '00000000000000000000000000000003' lo_id = '3' learning_outcome = 'Certification')
                                  ( lo_uuid = '00000000000000000000000000000004' lo_id = '4' learning_outcome = 'Webinar')
                                  ( lo_uuid = '00000000000000000000000000000005' lo_id = '5' learning_outcome = 'Expert Session')
                                  ( lo_uuid = '00000000000000000000000000000006' lo_id = '6' learning_outcome = 'Presentation')
                                  ( lo_uuid = '00000000000000000000000000000007' lo_id = '7' learning_outcome = 'Demo')
                                  ).

    INSERT zilearnoutcome FROM TABLE @lt_learningoutcome.
    out->write( 'Learning Outcome Data Inserted.' ).
  ENDMETHOD.

ENDCLASS.
