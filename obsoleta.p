DISABLE TRIGGERS FOR LOAD OF ITEM.
DISABLE TRIGGERS FOR LOAD OF item-uni-estab.

DEF TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo.

INPUT FROM VALUE("c:\temp\obsoletar.txt").
REPEAT:
    CREATE tt-item.
    IMPORT tt-item.
END.
INPUT CLOSE.

FOR EACH tt-item:

    DISP tt-item.it-codigo.

    PAUSE 0.

    FIND FIRST ITEM
         WHERE ITEM.it-codigo = tt-item.it-codigo EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL ITEM THEN DO:
        ASSIGN ITEM.cod-obsoleto = 1.
        FOR EACH item-uni-estab
             WHERE item-uni-estab.it-codigo = ITEM.it-codigo EXCLUSIVE-LOCK:
            ASSIGN item-uni-estab.cod-obsoleto= ITEM.cod-obsoleto.
        END.
    END.

END.
