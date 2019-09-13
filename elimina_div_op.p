DEF VAR i-nr-ord-prod LIKE ord-prod.nr-ord-prod NO-UNDO.
DEF VAR dt-trans-aux  AS   DATE                 NO-UNDO.

    
REPEAT:

    UPDATE i-nr-ord-prod
           dt-trans-aux
        WITH 1 COL SIDE-LABELS.

    FOR EACH movto-mat
        WHERE movto-mat.nr-ord-prod = i-nr-ord-prod
          AND movto-mat.esp-docto   = 6
          AND movto-mat.dt-trans    >= dt-trans-aux EXCLUSIVE-LOCK:
    
        IF movto-mat.quantidade > 0 THEN
            NEXT.
    
        DISP movto-mat.dt-trans
             movto-mat.quantidade
             movto-mat.valor-mat-m[1]
             movto-mat.valor-ggf-m[1]
             movto-mat.valor-mob-m[1].
        FOR EACH movto-estoq OF movto-mat EXCLUSIVE-LOCK:
            DISP movto-estoq.dt-trans.
            DELETE movto-estoq.
        END.
        DELETE movto-mat.
    END.
END.
