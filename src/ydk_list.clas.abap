class YDK_LIST definition
  public
  final
  create public .

public section.

  types TY_LIST_EVENT type STRING .
  types TY_RET_COMMAND type STRING .
  types:
    BEGIN OF ty_param,
        name TYPE string,
        data TYPE REF TO data,
      END   OF ty_param .
  types:
    ty_param_tab TYPE STANDARD TABLE OF ty_param WITH DEFAULT KEY .

  class-data EV_START type TY_LIST_EVENT read-only value 'START'. "#EC NOTEXT
  class-data EV_LIST type TY_LIST_EVENT read-only value 'LIST'. "#EC NOTEXT
  class-data EV_TOP type TY_LIST_EVENT read-only value 'TOP'. "#EC NOTEXT
  class-data EV_TOPD type TY_LIST_EVENT read-only value 'TOPD'. "#EC NOTEXT
  class-data EV_LINE type TY_LIST_EVENT read-only value 'LINE'. "#EC NOTEXT
  class-data RCM_NEW type TY_RET_COMMAND read-only value 'NEW'. "#EC NOTEXT
  class-data RCM_RENEW type TY_RET_COMMAND read-only value 'RENEW'. "#EC NOTEXT
  class-data RCM_REFRESH type TY_RET_COMMAND read-only value 'REFRESH'. "#EC NOTEXT
  class-data RCM_RESTART type TY_RET_COMMAND read-only value 'RESTART'. "#EC NOTEXT
  class-data RCM_CANC type TY_RET_COMMAND read-only value 'CANC'. "#EC NOTEXT
  class-data RCM_OKAY type TY_RET_COMMAND read-only value 'OKAY'. "#EC NOTEXT

  class-methods FOR_INSTANCE
    importing
      !INSTANCE type ref to OBJECT
      !METHOD type CLIKE
      !PARAMS type TY_PARAM_TAB optional
      !ROW type I default 10
      !COL type I default 10
      !WIDTH type I optional
      !HEIGHT type I optional
    returning
      value(RET) type SY-SUBRC .
  class-methods FOR_CLASS_METHOD
    importing
      !CLASSNAME type CLIKE
      !METHOD type CLIKE
      !PARAMS type TY_PARAM_TAB optional
      !ROW type I default 10
      !COL type I default 10
      !WIDTH type I optional
      !HEIGHT type I optional
    returning
      value(RET) type SY-SUBRC .
  class-methods FOR_FORM
    importing
      !CALLBACK_PROGRAM type CLIKE optional
      !CALLBACK_FORM type CLIKE
      !PARAMS type TY_PARAM_TAB optional
      !ROW type I default 10
      !COL type I default 10
      !WIDTH type I optional
      !HEIGHT type I optional
    returning
      value(RET) type SY-SUBRC .
protected section.
private section.
ENDCLASS.



CLASS YDK_LIST IMPLEMENTATION.


  METHOD for_class_method.
    CALL FUNCTION 'YDK_LIST_FOR_CLASS'
      EXPORTING
        classname = classname
        method    = method
        col       = col
        row       = row
        width     = width
        height    = height
        params    = params
      EXCEPTIONS
        cancel    = 1
        OTHERS    = 2.
    ret = sy-subrc.
  ENDMETHOD.


  METHOD for_form.
    DATA: lcallback_program TYPE sy-repid.
    IF callback_program IS INITIAL.
      CALL 'AB_GET_CALLER' ID 'PROGRAM' FIELD lcallback_program.
    ELSE.
      lcallback_program = callback_program.
    ENDIF.

    CALL FUNCTION 'YDK_LIST_FOR_FORM'
      EXPORTING
        callback_program = lcallback_program
        callback_form    = callback_form
        col              = col
        row              = row
        width            = width
        height           = height
        params           = params
      EXCEPTIONS
        cancel           = 1
        OTHERS           = 2.
    ret = sy-subrc.
  ENDMETHOD.


  METHOD for_instance.
* callback instance method defenition:
*  METHODS <method name>
*    importing
*      !PARAMS type YDK_LIST=>TY_PARAM_TAB
*      !EVENT type SY-UCOMM
*    exporting
*      !RET_COMMAND type SY-UCOMM .

    CALL FUNCTION 'YDK_LIST_FOR_INSTANCE'
      EXPORTING
        instance = instance
        method   = method
        col      = col
        row      = row
        width    = width
        height   = height
        params   = params
      EXCEPTIONS
        cancel   = 1
        OTHERS   = 2.
    ret = sy-subrc.
  ENDMETHOD.
ENDCLASS.
