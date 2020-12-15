DEF VAR c-item LIKE ITEM.it-codigo NO-UNDO.

UPDATE c-item.

OUTPUT TO c:\temp\teste-nivel-mais-baixo.txt.
RUN pi-estrutura(INPUT c-item).

RUN pi-estrutura-inversa(INPUT c-item).
OUTPUT CLOSE.

PROCEDURE pi-estrutura:
    DEF INPUT PARAM p-item LIKE ITEM.it-codigo NO-UNDO.

    FIND FIRST ITEM
         WHERE ITEM.it-codigo = p-item EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL ITEM THEN DO:
        DISP "Abaixo"
             ITEM.it-codigo
             ITEM.niv-mais-bai.
    
        ASSIGN ITEM.niv-mais-bai = 0.
    END.

    FOR EACH estrutura
        WHERE estrutura.it-codigo = p-item NO-LOCK:

        RUN pi-estrutura(INPUT estrutura.es-codigo).


    END.

END PROCEDURE.

PROCEDURE pi-estrutura-inversa:
    DEF INPUT PARAM p-compon LIKE ITEM.it-codigo NO-UNDO.

    FIND FIRST ITEM
         WHERE ITEM.it-codigo = p-compon EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL ITEM THEN DO:
        DISP "Acima"
             ITEM.it-codigo
             ITEM.niv-mais-bai.
    
        ASSIGN ITEM.niv-mais-bai = 0.

    END.

    FOR EACH estrutura
        WHERE estrutura.es-codigo = p-compon NO-LOCK:

        RUN pi-estrutura-inversa(INPUT estrutura.it-codigo).


    END.

END PROCEDURE.
