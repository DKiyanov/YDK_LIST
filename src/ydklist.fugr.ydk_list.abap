FUNCTION ydk_list.
*"----------------------------------------------------------------------
*"*"Локальный интерфейс:
*"  IMPORTING
*"     REFERENCE(CALLBACK_PROGRAM) TYPE  SY-REPID OPTIONAL
*"     REFERENCE(CALLBACK_FORM)
*"     REFERENCE(COL) DEFAULT 5
*"     REFERENCE(ROW) DEFAULT 5
*"     REFERENCE(WIDTH) OPTIONAL
*"     REFERENCE(HEIGHT) OPTIONAL
*"  EXCEPTIONS
*"      CANCEL
*"----------------------------------------------------------------------

  DATA: rcol TYPE i.
  DATA: brow TYPE i.

  DATA: lcallback_program LIKE sy-repid.
  DATA: lcallback_form(30) TYPE c.

  DATA: lcall_mode TYPE c.
  DATA: subrc LIKE sy-subrc.

  FIELD-SYMBOLS: <lvar>.
  FIELD-SYMBOLS: <ltab> TYPE ANY TABLE.

  lcallback_program = rcallback_program.
  lcallback_form    = rcallback_form.

  lcall_mode        = gcall_mode.
  gcall_mode = ' '.
  exit_dlg   = ' '.

  rcallback_program = callback_program.
  IF rcallback_program IS INITIAL.
    CALL 'AB_GET_CALLER' ID 'PROGRAM' FIELD rcallback_program.
  ENDIF.

  rcallback_form    = callback_form.

  IF width IS INITIAL AND height IS INITIAL.
    CALL SCREEN 0100.
  ELSE.
    rcol = col + width.
    brow = row + height.
    CALL SCREEN 0110 STARTING AT col row
                     ENDING   AT rcol brow.
  ENDIF.
  subrc = sy-subrc.

  rcallback_program  = lcallback_program.
  rcallback_form     = lcallback_form.

  gcall_mode        = lcall_mode.

  IF subrc <> 0.
    RAISE cancel.
  ENDIF.
ENDFUNCTION.
