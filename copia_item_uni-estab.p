DEF VAR c-estabel-de   LIKE estabelec.cod-estabel NO-UNDO.
DEF VAR c-estabel-para LIKE estabelec.cod-estabel NO-UNDO.

DEF BUFFER b-item-uni-estab FOR item-uni-estab.

DEF BUFFER b-fam-uni-estab FOR fam-uni-estab.

UPDATE "Estabelecimentos"
       c-estabel-de   LABEL "Copiar de"
       c-estabel-para LABEL "Para"
    WITH 1 COL SIDE-LABELS.
    
FOR EACH fam-uni-estab
    WHERE fam-uni-estab.cod-estabel = c-estabel-de NO-LOCK:
    DISP "Familia" fam-uni-estab.fm-codigo.
    PAUSE 0.

    IF NOT CAN-FIND(FIRST b-fam-uni-estab
                    WHERE b-fam-uni-estab.cod-estabel = c-estabel-para
                      AND b-fam-uni-estab.fm-codigo   = fam-uni-estab.fm-codigo) THEN DO:
        CREATE b-fam-uni-estab.
        ASSIGN b-fam-uni-estab.cod-estabel = c-estabel-para.
        BUFFER-COPY fam-uni-estab TO b-fam-uni-estab.
    END.


END.

        
FOR EACH item-uni-estab
    WHERE item-uni-estab.cod-estabel = c-estabel-de NO-LOCK:
    DISP "Item" item-uni-estab.it-codigo.
    PAUSE 0.

    IF NOT CAN-FIND(FIRST b-item-uni-estab
                    WHERE b-item-uni-estab.cod-estabel = c-estabel-para
                      AND b-item-uni-estab.it-codigo   = item-uni-estab.it-codigo) THEN DO:
        CREATE b-item-uni-estab.
        ASSIGN b-item-uni-estab.cod-estabel = c-estabel-para.
        BUFFER-COPY item-uni-estab TO b-item-uni-estab.
    END.


END.
