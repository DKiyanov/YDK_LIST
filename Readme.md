## Class for generating and displaying ABAP listings
The functionality of ABAP listings is of course very outdated.
However, the use of this technology is appropriate in some cases, for example when displaying information dialog boxes with simple functionality.
This package allows you to output modal and non-modal ABAP listings. 
It allows to implement any functionality that is possible in ABAP listing technology.

To install this on SAP server, use [abapGit](https://docs.abapgit.org/)

Here is a program that displays a dialog box with "Hello World":
```ABAP
CLASS lcl_test DEFINITION.
  PUBLIC SECTION.
    METHODS show_hello_world.

    METHODS list_hello_world
      IMPORTING
        !params TYPE ydk_list=>ty_param_tab
      CHANGING
        !event  TYPE sy-ucomm.
ENDCLASS.

CLASS lcl_test IMPLEMENTATION.
  METHOD show_hello_world.
    ydk_list=>for_instance(
      instance   = me
      method     = 'LIST_HELLO_WORLD'
      params     = VALUE #( ( name = 'MSG' data = REF #( 'Hello World' ) ) )
      width      = 30
      height     = 2
    ).
  ENDMETHOD.

  METHOD list_hello_world.
    FIELD-SYMBOLS <msg> TYPE any.
    DATA: msg_ref TYPE REF TO data.

    CASE event.
      WHEN ydk_list=>ev_list.
        SET PF-STATUS 'DIALOG'.

        msg_ref = params[ name = 'MSG' ]-data.
        ASSIGN msg_ref->* TO <msg>.
        WRITE: / <msg>.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  PERFORM start.

FORM start.
  DATA: lo_test TYPE REF TO lcl_test.
  lo_test = NEW lcl_test( ).
  lo_test->show_hello_world( ).
ENDFORM.
```
![Hello_world](Hello_world.png)

All variants to start listing output are shown in the program [YDK_LIST_DEMO](src/ydk_list_demo.prog.abap)

Here is a small demo showing the possibilities of this outdated technology:  
![demo](demo.gif)