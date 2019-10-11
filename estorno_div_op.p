DEF TEMP-TABLE tt-ordem NO-UNDO
    FIELD nr-ord-prod LIKE ord-prod.nr-ord-prod.

INPUT FROM c:\temp\estorno.txt.
REPEAT:
    CREATE tt-ordem.
    IMPORT tt-ordem.
END.
INPUT CLOSE.

FOR EACH tt-ordem:
    IF tt-ordem.nr-ord-prod = 0 THEN
        NEXT.

    FOR EACH movto-estoq
        WHERE movto-estoq.nr-ord-prod  = tt-ordem.nr-ord-prod
          AND movto-estoq.dt-trans    >= 10/01/2019
          AND movto-estoq.esp-docto    = 6                    EXCLUSIVE-LOCK:

        DISP movto-estoq.nr-ord-prod.

        PAUSE 0.
        
        FIND FIRST movto-mat OF movto-estoq EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL movto-mat THEN
            DELETE movto-mat.

        DELETE movto-estoq.
                .
    END.


END.
