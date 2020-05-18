FUNCTION YDK_LIST_FOR_FORM.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     REFERENCE(CALLBACK_PROGRAM) TYPE  CLIKE OPTIONAL
*"     REFERENCE(CALLBACK_FORM) TYPE  CLIKE
*"     REFERENCE(COL) DEFAULT 5
*"     REFERENCE(ROW) DEFAULT 5
*"     REFERENCE(WIDTH) OPTIONAL
*"     REFERENCE(HEIGHT) OPTIONAL
*"     REFERENCE(PARAMS) TYPE  YDK_LIST=>TY_PARAM_TAB OPTIONAL
*"  EXCEPTIONS
*"      CANCEL
*"----------------------------------------------------------------------

  DATA: rcol TYPE i.
  DATA: brow TYPE i.

  DATA: lcallback_program LIKE sy-repid.
  DATA: lcallback_form(30) TYPE c.
  FIELD-SYMBOLS <lparams> TYPE ydk_list=>ty_param_tab.

  DATA: lcall_mode TYPE c.
  DATA: subrc LIKE sy-subrc.

  CLEAR exit_dlg.

  lcallback_program = rcallback_program.
  lcallback_form    = rcallback_form.
  IF <rparams> IS ASSIGNED.
    ASSIGN <rparams> TO <lparams>.
    UNASSIGN <rparams>.
  ENDIF.
  lcall_mode = gcall_mode.

  rcallback_program = callback_program.
  IF rcallback_program IS INITIAL.
    CALL 'AB_GET_CALLER' ID 'PROGRAM' FIELD rcallback_program.
  ENDIF.

  rcallback_form    = callback_form.
  IF params IS SUPPLIED AND params IS NOT INITIAL.
    ASSIGN params TO <rparams>.
  ENDIF.

  gcall_mode = 'P'.

  IF width IS INITIAL AND height IS INITIAL.
    CALL SCREEN 0100.
  ELSE.
    rcol = col + width.
    brow = row + height.
    CALL SCREEN 0110 STARTING AT col row
                     ENDING   AT rcol brow.
  ENDIF.
  subrc = sy-subrc.

  rcallback_program = lcallback_program.
  rcallback_form    = lcallback_form.
  UNASSIGN <rparams>.
  IF <lparams> IS ASSIGNED.
    ASSIGN <lparams> TO <rparams>.
  ENDIF.

  IF subrc <> 0.
    RAISE cancel.
  ENDIF.
ENDFUNCTION.
