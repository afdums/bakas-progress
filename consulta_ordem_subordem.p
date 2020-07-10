RUN pi-sub-ordem(INPUT 6741849).

PROCEDURE pi-sub-ordem:
    DEF INPUT PARAM p-ordem LIKE ord-prod.nr-ord-prod NO-UNDO.

    FOR FIRST ext-reserva
        WHERE ext-reserva.nr-ord-prod = p-ordem
          AND ext-reserva.ord-gerada  <> 0 NO-LOCK:
        DISP ext-reserva.nr-ord-prod FORMAT ">>>,>>>,>>9"
             ext-reserva.it-codigo
             ext-reserva.ord-gerada FORMAT ">>>,>>>,>>9"
            WITH 1 COL SIDE-LABELS.

        RUN pi-sub-ordem(INPUT ext-reserva.ord-gerada).

    END.
END PROCEDURE.
