{include/i-epc200.i1}

DEF INPUT PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-epc.

OUTPUT TO c:\temp\eventos.txt APPEND.
PUT UNFORMATTED
    SKIP(2)
    "p-ind-event: " p-ind-event
    SKIP(2).
FOR EACH tt-epc:

    PUT UNFORMATTED
        "tt-epc.cod-event    : " tt-epc.cod-event     SKIP
        "tt-epc.cod-parameter: " tt-epc.cod-parameter SKIP
        "tt-epc.val-parameter: " tt-epc.val-parameter SKIP
        SKIP(2).
END.
OUTPUT CLOSE.
