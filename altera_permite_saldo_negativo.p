DEF BUFFER b-item           FOR ITEM.
DEF BUFFER b-item-uni-estab FOR item-uni-estab.

DEF VAR i-perm-saldo-neg LIKE ITEM.perm-saldo-neg NO-UNDO.
DEF VAR i-ge-codigo      LIKE ITEM.ge-codigo      NO-UNDO.

UPDATE i-perm-saldo-neg
       i-ge-codigo
    WITH 1 COL SIDE-LABELS.
    
FOR EACH ITEM
    WHERE ITEM.ge-codigo = i-ge-codigo NO-LOCK:

    DISP ITEM.it-codigo.

    PAUSE 0.

    IF ITEM.perm-saldo-neg <> i-perm-saldo-neg THEN DO:
        FIND FIRST b-item
             WHERE ROWID(b-item) = ROWID(ITEM) EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL b-item THEN
            ASSIGN b-item.perm-saldo-neg = i-perm-saldo-neg.
    END.

    FOR EACH item-uni-estab
         WHERE item-uni-estab.it-codigo = ITEM.it-codigo NO-LOCK:

        IF item-uni-estab.perm-saldo-neg <> i-perm-saldo-neg THEN DO:

            FIND FIRST b-item-uni-estab
                 WHERE ROWID(b-item-uni-estab) = ROWID(item-uni-estab) EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL b-item-uni-estab THEN
                ASSIGN b-item-uni-estab.perm-saldo-neg = i-perm-saldo-neg.

        END.


    END.



END.
