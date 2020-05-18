FUNCTION ydk_list_ex.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(CALLBACK_PROGRAM) TYPE  SY-REPID OPTIONAL
*"     REFERENCE(CALLBACK_FORM)
*"     REFERENCE(COL) DEFAULT 5
*"     REFERENCE(ROW) DEFAULT 5
*"     REFERENCE(WIDTH) OPTIONAL
*"     REFERENCE(HEIGHT) OPTIONAL
*"  CHANGING
*"     VALUE(VAR) OPTIONAL
*"     VALUE(TAB) OPTIONAL
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


  CLEAR exit_dlg.

  rcallback_program = callback_program.
  IF rcallback_program IS INITIAL.
    CALL 'AB_GET_CALLER' ID 'PROGRAM' FIELD rcallback_program.
  ENDIF.

  rcallback_form    = callback_form.

  IF <gvar> IS ASSIGNED. ASSIGN <gvar> TO <lvar>. ENDIF.
  IF <gtab> IS ASSIGNED. ASSIGN <gtab> TO <ltab>. ENDIF.

  UNASSIGN <gvar>.
  UNASSIGN <gtab>.

  IF var IS SUPPLIED. ASSIGN var TO <gvar>. ENDIF.
  IF tab IS SUPPLIED. ASSIGN tab TO <gtab>. ENDIF.

  IF  <gvar> IS ASSIGNED
  AND <gtab> IS ASSIGNED.
    gcall_mode = 'X'.
  ELSEIF <gtab> IS ASSIGNED.
    gcall_mode = 'T'.
  ELSEIF <gvar> IS ASSIGNED.
    gcall_mode = 'V'.
  ELSE.
    gcall_mode = ' '.
  ENDIF.


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

  UNASSIGN <gvar>.
  UNASSIGN <gtab>.
  IF <lvar> IS ASSIGNED. ASSIGN <lvar> TO <gvar>. ENDIF.
  IF <ltab> IS ASSIGNED. ASSIGN <ltab> TO <gtab>. ENDIF.

  gcall_mode        = lcall_mode.

  IF subrc <> 0.
    RAISE cancel.
  ENDIF.
ENDFUNCTION.
