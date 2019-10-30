DEF VAR c-estab LIKE estabelec.cod-estabel NO-UNDO.
DEF VAR c-item  LIKE ITEM.it-codigo        NO-UNDO.
DEF VAR i-ordem LIKE ord-prod.nr-ord-prod  NO-UNDO.
DEF VAR i-seq   AS   INTEGER               NO-UNDO.
DEF VAR dt-aux  AS   DATE                  NO-UNDO.

DEF BUFFER b-inv-col FOR inv-col.

REPEAT:
    UPDATE c-estab
           c-item
           i-ordem
           i-seq
           dt-aux
        WITH 1 COL SIDE-LABELS.
    FOR EACH inv-col
        WHERE inv-col.cod-estabel = c-estab
          AND inv-col.it-codigo   = c-item
          AND inv-col.nr-ord-prod = i-ordem
          AND inv-col.dt-corte    = dt-aux
          AND inv-col.nr-seq      = i-seq NO-LOCK:
        DISP inv-col.nr-seq
             inv-col.nr-cont
             inv-col.dt-corte.
        FIND FIRST b-inv-col
             WHERE ROWID(b-inv-col) = ROWID(inv-col) EXCLUSIVE-LOCK NO-ERROR.
        DELETE b-inv-col.
    END.
END.
