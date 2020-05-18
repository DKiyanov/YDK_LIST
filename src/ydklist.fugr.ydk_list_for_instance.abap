FUNCTION ydk_list_for_instance.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INSTANCE) TYPE REF TO  OBJECT
*"     REFERENCE(METHOD) TYPE  CLIKE
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

  DATA: linstance TYPE REF TO object.
  DATA: lmethod TYPE string.
  FIELD-SYMBOLS <lparams> TYPE ydk_list=>ty_param_tab.

  DATA: lcall_mode TYPE c.
  DATA: subrc LIKE sy-subrc.

  CLEAR exit_dlg.

  linstance  = rinstance.
  lmethod    = rmethod.
  IF <rparams> IS ASSIGNED.
    ASSIGN <rparams> TO <lparams>.
    UNASSIGN <rparams>.
  ENDIF.
  lcall_mode = gcall_mode.

  rinstance  = instance.
  rmethod    = method.
  IF params IS SUPPLIED AND params IS NOT INITIAL.
    ASSIGN params TO <rparams>.
  ENDIF.

  gcall_mode = 'I'.

  IF width IS INITIAL AND height IS INITIAL.
    CALL SCREEN 0100.
  ELSE.
    rcol = col + width.
    brow = row + height.
    CALL SCREEN 0110 STARTING AT col row
                     ENDING   AT rcol brow.
  ENDIF.
  subrc = sy-subrc.

  rinstance  = linstance.
  rmethod    = lmethod.
  UNASSIGN <rparams>.
  IF <lparams> IS ASSIGNED.
    ASSIGN <lparams> TO <rparams>.
  ENDIF.

  IF subrc <> 0.
    RAISE cancel.
  ENDIF.
ENDFUNCTION.
