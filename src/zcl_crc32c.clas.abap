CLASS zcl_crc32c DEFINITION PUBLIC.
  PUBLIC SECTION.
    TYPES ty_crc TYPE x LENGTH 4.

    CLASS-METHODS run
      IMPORTING
        iv_xstring TYPE xstring
      RETURNING
        VALUE(rv_crc) TYPE ty_crc.
  PRIVATE SECTION.
    CLASS-DATA crc32_map TYPE xstring.
ENDCLASS.

CLASS zcl_crc32c IMPLEMENTATION.
  METHOD run.
* https://en.wikipedia.org/wiki/Cyclic_redundancy_check

    CONSTANTS: magic_nr  TYPE x LENGTH 4 VALUE '82F63B78',
               mffffffff TYPE x LENGTH 4 VALUE 'FFFFFFFF',
               m7fffffff TYPE x LENGTH 4 VALUE '7FFFFFFF',
               m00ffffff TYPE x LENGTH 4 VALUE '00FFFFFF',
               m000000ff TYPE x LENGTH 4 VALUE '000000FF',
               m000000   TYPE x LENGTH 3 VALUE '000000'.

    DATA: cindex  TYPE x LENGTH 4,
          low_bit TYPE x LENGTH 4,
          len     TYPE i,
          nindex  TYPE i,
          crc     TYPE x LENGTH 4 VALUE mffffffff,
          x4      TYPE x LENGTH 4,
          idx     TYPE x LENGTH 4.

    IF xstrlen( crc32_map ) = 0.
      DO 256 TIMES.
        cindex = sy-index - 1.
        DO 8 TIMES.
          low_bit = '00000001'.
          low_bit = cindex BIT-AND low_bit.   " c & 1
          cindex = cindex DIV 2.
          cindex = cindex BIT-AND m7fffffff. " c >> 1 (top is zero, but in ABAP signed!)
          IF low_bit IS NOT INITIAL.
            cindex = cindex BIT-XOR magic_nr.
          ENDIF.
        ENDDO.
        CONCATENATE crc32_map cindex INTO crc32_map IN BYTE MODE.
      ENDDO.
    ENDIF.

    len = xstrlen( iv_xstring ).
    DO len TIMES.
      nindex = sy-index - 1.
      CONCATENATE m000000 iv_xstring+nindex(1) INTO idx IN BYTE MODE.
      idx = ( crc BIT-XOR idx ) BIT-AND m000000ff.
      idx = idx * 4.
      x4  = crc32_map+idx(4).
      crc = crc DIV 256.
      crc = crc BIT-AND m00ffffff. " c >> 8
      crc = x4 BIT-XOR crc.
    ENDDO.
    crc = crc BIT-XOR mffffffff.

    rv_crc = crc.

  ENDMETHOD.
ENDCLASS.