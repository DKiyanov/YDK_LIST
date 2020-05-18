*&---------------------------------------------------------------------*
*& Report  YDK_LIST_DEMO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ydk_list_demo.

PARAMETERS: pclmtd  RADIOBUTTON GROUP mod.
PARAMETERS: pclmtd2 RADIOBUTTON GROUP mod.
PARAMETERS: pclimtd RADIOBUTTON GROUP mod.
PARAMETERS: pform   RADIOBUTTON GROUP mod.

CLASS lcl_test DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS list_hello_world_cls
      IMPORTING
        !params TYPE ydk_list=>ty_param_tab
      CHANGING
        !event  TYPE sy-ucomm.

    METHODS list_hello_world
      IMPORTING
        !params TYPE ydk_list=>ty_param_tab
      CHANGING
        !event  TYPE sy-ucomm.
ENDCLASS.

CLASS lcl_test IMPLEMENTATION.
  METHOD list_hello_world_cls.
    PERFORM list_hello_world USING params CHANGING event.
  ENDMETHOD.

  METHOD list_hello_world.
    PERFORM list_hello_world USING params CHANGING event.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  PERFORM start.

FORM start.
  DATA: lv_message TYPE string VALUE 'Hello World'.
  DATA: lo_test TYPE REF TO lcl_test.

  CASE abap_true.
    WHEN pclmtd.
      ydk_list=>for_class_method(
        classname  = '\PROGRAM=YDK_LIST_DEMO\CLASS=LCL_TEST' " for local classes need to be specified absolute type name
        method     = 'LIST_HELLO_WORLD_CLS'
        params     = VALUE #( ( name = 'MSG' data = REF #( lv_message ) ) )
        width      = 30
        height     = 2
      ).
    WHEN pclmtd2.
      lo_test = NEW lcl_test( ).

      ydk_list=>for_instance(
        instance   = lo_test
        method     = 'LIST_HELLO_WORLD_CLS'
        params     = VALUE #( ( name = 'MSG' data = REF #( lv_message ) ) )
        width      = 30
        height     = 2
      ).
    WHEN pclimtd.
      lo_test = NEW lcl_test( ).

      ydk_list=>for_instance(
        instance   = lo_test
        method     = 'LIST_HELLO_WORLD'
        params     = VALUE #( ( name = 'MSG' data = REF #( lv_message ) ) )
        width      = 30
        height     = 2
      ).
    WHEN pform.
      ydk_list=>for_form(
*       callback_program =
        callback_form    = 'LIST_HELLO_WORLD'
        params           = VALUE #( ( name = 'MSG' data = REF #( lv_message ) ) )
        width            = 30
        height           = 2
      ).

  ENDCASE.
ENDFORM.

FORM list_hello_world
  USING
    params TYPE ydk_list=>ty_param_tab
  CHANGING
    event TYPE sy-ucomm.

  FIELD-SYMBOLS <msg> TYPE any.
  DATA: msg_ref TYPE REF TO data.

  CASE event.
    WHEN ydk_list=>ev_list.
      SET PF-STATUS 'DIALOG'.

      msg_ref = params[ name = 'MSG' ]-data.
      ASSIGN msg_ref->* TO <msg>.
      WRITE: / <msg>.
  ENDCASE.
ENDFORM.
