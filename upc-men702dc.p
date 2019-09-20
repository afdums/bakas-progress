
{include/i-epc200.i1}

DEFINE INPUT PARAMETER p-ind-event AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.


DEFINE NEW GLOBAL SHARED VAR  wh-fam-com-2          AS WIDGET-HANDLE NO-UNDO.

/* OUTPUT TO u:\dums\men702dc.txt APPEND.            */
/* PUT UNFORMATTED "p-ind-event: " p-ind-event SKIP. */
/* FOR EACH tt-epc:                                  */
/*     EXPORT tt-epc.                                */
/* END.                                              */
/* PUT UNFORMATTED SKIP.                             */
/* OUTPUT CLOSE.                                     */


IF p-ind-event = "execution_program_1x":U THEN DO:
    FIND FIRST tt-epc
         WHERE tt-epc.cod-event = "execution_program_1x":U
           AND tt-epc.cod-parameter = "v_cod_prog_dtsul":U NO-ERROR.
    IF AVAIL tt-epc THEN DO:

        IF tt-epc.val-parameter = "CD0903":U THEN DO:
            IF VALID-HANDLE(wh-fam-com-2) THEN DO:
                RUN MESSAGE.p(INPUT "Programa ja aberto",
                              INPUT "Nao eh possivel abrir duas telas do mesmo programa").
                RETURN "NOK":U.
            END.

        END.

    END.
    
END.
