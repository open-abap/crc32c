CLASS ltcl_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.
  PRIVATE SECTION.
    METHODS test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD test.

    DATA lv_xstr TYPE xstring.
    DATA lv_crc  TYPE zcl_crc32c=>ty_crc.

* https://crccalc.com/?crc=1122334455667788AABBCCDDEEFF&method=crc32&datatype=hex&outtype=0
    lv_xstr = '1122334455667788AABBCCDDEEFF'.

    lv_crc = zcl_crc32c=>run( lv_xstr ).

    cl_abap_unit_assert=>assert_not_initial( lv_crc ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'F44CB56B'
      act = lv_crc ).

  ENDMETHOD.

ENDCLASS.
