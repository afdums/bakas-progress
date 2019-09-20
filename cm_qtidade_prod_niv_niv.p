DEF VAR c-nome-abrev   LIKE ped-venda.nome-abrev     NO-UNDO.
DEF VAR c-nr-pedcli    LIKE ped-venda.nr-pedcli      NO-UNDO.
DEF VAR i-nr-programa  LIKE cm-ped-item.nr-programa  NO-UNDO.
DEF VAR i-nr-sequencia LIKE cm-ped-item.nr-sequencia NO-UNDO.

UPDATE c-nome-abrev  
       c-nr-pedcli   
       i-nr-programa 
       i-nr-sequencia
    WITH 1 COL SIDE-LABELS.



FIND FIRST ped-venda
     WHERE ped-venda.nome-abrev = c-nome-abrev
       AND ped-venda.nr-pedcli  = c-nr-pedcli NO-LOCK NO-ERROR.
    
FOR EACH cm-ped-item
    WHERE cm-ped-item.nr-programa  = i-nr-programa
      AND cm-ped-item.nr-pedido    = ped-venda.nr-pedido
      AND cm-ped-item.nr-sequencia = i-nr-sequencia      NO-LOCK:

    DISP cm-ped-item EXCEPT id-cm-ped-item
        WITH 1 COL SIDE-LABELS.

    FOR EACH cm-ped-item-estr
        WHERE cm-ped-item-estr.id-cm-ped-item = cm-ped-item.id-cm-ped-item NO-LOCK
        BREAK BY cm-ped-item-estr.nr-nivel:

        DISP cm-ped-item-estr EXCEPT id-cm-ped-item-estr id-cm-ped-item
            WITH 1 COL SIDE-LABELS.

    END.

END.
