CLASS zcl_ilearningeval DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ilearningeval IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zilearningeval.
*    DATA lt_learning TYPE STANDARD TABLE OF zilearningeval.
*
*    lt_learning = VALUE #(
*        ( learning_uuid = '00000000000000000000000000000001' learning_id = '1' employee_id = '51683650' employee_name = 'Sangita Purkayastha' employee_band = ' E3.1' core_skill = 'HANA' topic_to_learn = 'HANA'
*    learning_mode = 'OpenSAP' learning_source = 'http://www.opensap.com' learning_outcome_id = '1' learning_status_id = '1' start_date = '20201210'
*    end_date = '20201214' last_changed_date = '20201214' hours_invested = '10' hours_of_outcome = '10' creation_date = '20201210')
*
*         ( learning_uuid = '00000000000000000000000000000002' learning_id = '2' employee_id = '51683650' employee_name = 'Sangita Purkayastha' employee_band = ' E3.1' core_skill = 'HANA' topic_to_learn = 'HANA'
*    learning_mode = 'OpenSAP' learning_source = 'http://www.opensap.com' learning_outcome_id = '2' learning_status_id = '2' start_date = '20201210'
*    end_date = '20201214' last_changed_date = '20201214' hours_invested = '10' hours_of_outcome = '10' creation_date = '20201210' )
*
*  ).
*
*    INSERT zilearningeval FROM TABLE @lt_learning.
    out->write( 'Learning Data Inserted.' ).
  ENDMETHOD.

ENDCLASS.
