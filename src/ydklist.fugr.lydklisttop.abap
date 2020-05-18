FUNCTION-POOL ydklist NO STANDARD PAGE HEADING.

INCLUDE <%_list>.

DATA: rcallback_program  LIKE sy-repid.
DATA: rcallback_form(30) TYPE c.

DATA: rclassname TYPE string.
DATA: rinstance TYPE REF TO object.
DATA: rmethod TYPE string.
FIELD-SYMBOLS <rparams> TYPE ydk_list=>ty_param_tab.
DATA: rptab TYPE abap_parmbind_tab.

DATA: gcall_mode TYPE c.

DATA: exit_dlg TYPE c.

FIELD-SYMBOLS: <gvar>.
FIELD-SYMBOLS: <gtab> TYPE STANDARD TABLE.

*&---------------------------------------------------------------------*
*&      Form  CALLEVENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->AEVENT     text
*      -->ACTIVE     text
*----------------------------------------------------------------------*
FORM callevent USING aevent active.
  DATA: event LIKE sy-ucomm.

  DATA: pageindex  LIKE sy-cpage,
        lineindex  LIKE sy-staro,
        columnind  LIKE sy-staco,
        cursorcol  LIKE sy-cucol,
        cursorrow  LIKE sy-curow,
        cursor_set TYPE c,
        lin        TYPE i.

  IF active = 'X'.
    pageindex = sy-cpage.
    lineindex = sy-staro.
    columnind = sy-staco.

    GET CURSOR LINE cursorrow OFFSET cursorcol.
    IF sy-subrc = 0.
      cursor_set = 'X'.
    ENDIF.

    cursorcol = sy-cucol.
    cursorrow = sy-curow.
  ENDIF.

  event = aevent.
  PERFORM xcallevent USING event.

  CASE event.
    WHEN ydk_list=>rcm_canc.
      exit_dlg = 'C'.
      sy-subrc = 4.
      LEAVE LIST-PROCESSING.
    WHEN ydk_list=>rcm_okay.
      exit_dlg = 'O'.
      CLEAR sy-subrc.
      LEAVE LIST-PROCESSING.
  ENDCASE.

  CHECK active = 'X'.

  CASE event.
    WHEN ydk_list=>rcm_restart.
      PERFORM xcallevent USING: ydk_list=>ev_start, ydk_list=>ev_list.

      SUBTRACT 1 FROM sy-lsind.
    WHEN ydk_list=>rcm_new.
      PERFORM xcallevent USING ydk_list=>ev_list.
    WHEN ydk_list=>rcm_renew.
      PERFORM xcallevent USING ydk_list=>ev_list.

      SUBTRACT 1 FROM sy-lsind.
    WHEN ydk_list=>rcm_refresh.
      PERFORM xcallevent USING ydk_list=>ev_list.

      IF sy-linno < lineindex.
*      lineindex = 0.
*      lineindex = sy-linno - 2.
      ENDIF.

      SCROLL LIST INDEX sy-lsind TO PAGE   pageindex
                                    LINE   lineindex.
      SCROLL LIST INDEX sy-lsind TO COLUMN columnind.
      IF cursor_set = 'X'.
        SET CURSOR cursorcol cursorrow.
      ENDIF.

      SUBTRACT 1 FROM sy-lsind.
  ENDCASE.
ENDFORM.                    "CALLEVENT

*&---------------------------------------------------------------------*
*&      Form  XCALLEVENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->EVENT      text
*----------------------------------------------------------------------*
FORM xcallevent USING event.
  CASE gcall_mode.
    WHEN 'X'.
      PERFORM (rcallback_form)
      IN PROGRAM (rcallback_program)
      TABLES <gtab>
      USING event <gvar>
      IF FOUND.
    WHEN 'T'.
      PERFORM (rcallback_form)
      IN PROGRAM (rcallback_program)
      TABLES <gtab>
      USING event
      IF FOUND.
    WHEN 'V'.
      PERFORM (rcallback_form)
      IN PROGRAM (rcallback_program)
      USING event <gvar>
      IF FOUND.
    WHEN ' '.
      PERFORM (rcallback_form)
      IN PROGRAM (rcallback_program)
      USING event
      IF FOUND.
    WHEN 'I'.
      PERFORM fill_ptab CHANGING event.
      CALL METHOD rinstance->(rmethod) PARAMETER-TABLE rptab.
    WHEN 'S'.
      PERFORM fill_ptab CHANGING event.
      CALL METHOD (rclassname)=>(rmethod) PARAMETER-TABLE rptab.
    WHEN 'P'.
      IF <rparams> IS ASSIGNED AND <rparams> IS NOT INITIAL.
        PERFORM (rcallback_form)
        IN PROGRAM (rcallback_program)
        USING
          <rparams>
        CHANGING
          event
        IF FOUND.
      ELSE.
        PERFORM (rcallback_form)
        IN PROGRAM (rcallback_program)
        CHANGING
          event
        IF FOUND.
      ENDIF.
  ENDCASE.
ENDFORM.                    "XCALLEVENT

FORM fill_ptab CHANGING event.
  rptab = VALUE #( ( name = 'EVENT' value = REF #( event ) kind = cl_abap_objectdescr=>changing ) ).

  IF <rparams> IS ASSIGNED AND <rparams> IS NOT INITIAL.
    INSERT VALUE #( name = 'PARAMS' value = REF #( <rparams> ) ) INTO TABLE rptab.
  ENDIF.
ENDFORM.

*----------------------------------------------------------------------*
*  MODULE LIST OUTPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE list OUTPUT.
  IF NOT exit_dlg IS INITIAL.
    CASE exit_dlg.
      WHEN 'C'.
        sy-subrc = 4.
      WHEN 'O'.
        sy-subrc = 0.
    ENDCASE.
    CLEAR exit_dlg.

    SET SCREEN 0. LEAVE SCREEN.
  ENDIF.

  LEAVE TO LIST-PROCESSING.
  PERFORM callevent USING: ydk_list=>ev_start ' ', ydk_list=>ev_list ' '.
  SET SCREEN 0. LEAVE SCREEN.
ENDMODULE.                 " LIST  OUTPUT

TOP-OF-PAGE.
  PERFORM callevent USING ydk_list=>ev_top ' '.

TOP-OF-PAGE DURING LINE-SELECTION.
  PERFORM callevent USING ydk_list=>ev_topd ' '.

AT LINE-SELECTION.
  PERFORM callevent USING ydk_list=>ev_line 'X'.

AT USER-COMMAND.
  PERFORM callevent USING sy-ucomm 'X'.
