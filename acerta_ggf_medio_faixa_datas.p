DEF VAR d-dt-trans-ini AS DATE NO-UNDO.

UPDATE d-dt-trans-ini.

FOR EACH movto-estoq
    WHERE movto-estoq.cod-estabel = "105"
      AND movto-estoq.dt-trans    >= d-dt-trans-ini EXCLUSIVE-LOCK:

    IF movto-estoq.valor-ggf-m[1] <> ? THEN
        NEXT.

    DISP movto-estoq.nr-ord-prod.

    ASSIGN movto-estoq.valor-ggf-m[1] = (IF movto-estoq.valor-ggf-m[1] = ? THEN 0.01 ELSE movto-estoq.valor-ggf-m[1])
          movto-estoq.valor-ggf-m[2] = (IF movto-estoq.valor-ggf-m[2] = ? THEN 0 ELSE movto-estoq.valor-ggf-m[2])
          movto-estoq.valor-ggf-m[3] = (IF movto-estoq.valor-ggf-m[3] = ? THEN 0 ELSE movto-estoq.valor-ggf-m[3])
          movto-estoq.valor-mat-m[1] = (IF movto-estoq.valor-mat-m[1] = ? THEN 0.01 ELSE movto-estoq.valor-mat-m[1])
          movto-estoq.valor-mat-m[2] = (IF movto-estoq.valor-mat-m[2] = ? THEN 0 ELSE movto-estoq.valor-mat-m[2])
          movto-estoq.valor-mat-m[3] = (IF movto-estoq.valor-mat-m[3] = ? THEN 0 ELSE movto-estoq.valor-mat-m[3])
          movto-estoq.valor-mob-m[1] = (IF movto-estoq.valor-mob-m[1] = ? THEN 0 ELSE movto-estoq.valor-mob-m[1])
          movto-estoq.valor-mob-m[2] = (IF movto-estoq.valor-mob-m[2] = ? THEN 0 ELSE movto-estoq.valor-mob-m[2])
          movto-estoq.valor-mob-m[3] = (IF movto-estoq.valor-mob-m[3] = ? THEN 0 ELSE movto-estoq.valor-mob-m[3]).

END.
