DEF TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo LIKE ITEM.it-codigo.

//INPUT FROM c:\temp\itens-482.txt.

DEF VAR c-docto AS CHAR    NO-UNDO.
DEF VAR i-cont  AS INTEGER NO-UNDO.

ASSIGN c-docto = "0052353,0052372,0052418,0052512,0052513,0052514,0052515,0052590".

DO i-cont = 1 TO NUM-ENTRIES(c-docto):
    FOR EACH docum-est
        WHERE docum-est.cod-estabel = "525"
          AND docum-est.serie-docto = "1"
          AND docum-est.nro-docto = ENTRY(i-cont,c-docto) NO-LOCK:
    
        DISP docum-est.nro-docto
             docum-est.dt-trans.

        PAUSE 0.

        FOR EACH item-doc-est OF docum-est NO-LOCK:

            IF NOT CAN-FIND(FIRST tt-item
                            WHERE tt-item.it-codigo = item-doc-est.it-codigo) THEN DO:
                CREATE tt-item.
                ASSIGN tt-item.it-codigo = item-doc-est.it-codigo.
            END.
             
        END.
    
    END.
END.

/*

REPEAT:
    CREATE tt-item.
    IMPORT tt-item.
END.
INPUT CLOSE.*/


FOR EACH tt-item:
    IF tt-item.it-codigo = "" THEN
        NEXT.

    FIND FIRST item-uni-estab
         WHERE item-uni-estab.it-codigo = tt-item.it-codigo 
           AND item-uni-estab.cod-estabel = "525" EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL item-uni-estab THEN DO:
        DISP item-uni-estab.it-codigo
             item-uni-estab.cod-estabel.
        ASSIGN item-uni-estab.perm-saldo-neg = 1.
        PAUSE 0.
    END.

END.
