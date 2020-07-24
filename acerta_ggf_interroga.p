
/*6723060
6723054
6714829
6714832
6714830
6723056
6723055
6723049
6723071
6723064
6723062
6723047
*/

DEF TEMP-TABLE tt-ordem NO-UNDO
    FIELD nr-ord-produ LIKE ord-prod.nr-ord-prod.

INPUT FROM c:\temp\ordens-acerto.txt.
REPEAT:
    CREATE tt-ordem.
    IMPORT tt-ordem.
END.
INPUT CLOSE.

FOR EACH tt-ordem:

    IF tt-ordem.nr-ord-prod = 0 THEN
        NEXT.

    DISP tt-ordem.nr-ord-produ.

    PAUSE 0.

    FOR EACH movto-estoq
        WHERE movto-estoq.nr-ord-prod = tt-ordem.nr-ord-prod
          AND movto-estoq.valor-ggf-m[1] = ? EXCLUSIVE-LOCK:
        

        ASSIGN movto-estoq.valor-ggf-m[1] = (IF movto-estoq.valor-ggf-m[1] = ? THEN 0 ELSE movto-estoq.valor-ggf-m[1])
               movto-estoq.valor-ggf-m[2] = (IF movto-estoq.valor-ggf-m[2] = ? THEN 0 ELSE movto-estoq.valor-ggf-m[2])
               movto-estoq.valor-ggf-m[3] = (IF movto-estoq.valor-ggf-m[3] = ? THEN 0 ELSE movto-estoq.valor-ggf-m[3])
               movto-estoq.valor-mat-m[1] = (IF movto-estoq.valor-mat-m[1] = ? THEN 0 ELSE movto-estoq.valor-mat-m[1])
               movto-estoq.valor-mat-m[2] = (IF movto-estoq.valor-mat-m[2] = ? THEN 0 ELSE movto-estoq.valor-mat-m[2])
               movto-estoq.valor-mat-m[3] = (IF movto-estoq.valor-mat-m[3] = ? THEN 0 ELSE movto-estoq.valor-mat-m[3])
               movto-estoq.valor-mob-m[1] = (IF movto-estoq.valor-mob-m[1] = ? THEN 0 ELSE movto-estoq.valor-mob-m[1])
               movto-estoq.valor-mob-m[2] = (IF movto-estoq.valor-mob-m[2] = ? THEN 0 ELSE movto-estoq.valor-mob-m[2])
               movto-estoq.valor-mob-m[3] = (IF movto-estoq.valor-mob-m[3] = ? THEN 0 ELSE movto-estoq.valor-mob-m[3]).
    
    END.


END.

    

