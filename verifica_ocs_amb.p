DEF BUFFER b-ordem-compra FOR ordem-compra.

OUTPUT TO c:\temp\ocs.txt.
FOR EACH ordem-compra NO-LOCK
   WHERE ordem-compra.cod-emitente = 62900
     AND ordem-compra.situacao  = 2: // Confirmado

    FIND FIRST ITEM
         WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.

    IF NOT AVAIL ITEM OR ITEM.ge-codigo = 5 OR ITEM.ge-codigo = 97 THEN
        NEXT.

    FIND FIRST esp-item-devol-consign
         WHERE esp-item-devol-consign.numero-ordem = ordem-compra.numero-ordem NO-LOCK NO-ERROR.
    IF AVAIL esp-item-devol-consign THEN DO:

        FIND FIRST esp-recompra-amb-xml
             WHERE esp-recompra-amb-xml.lote = esp-item-devol-consign.lote-filho NO-LOCK NO-ERROR.
        
        FIND FIRST docum-est
             WHERE docum-est.cod-chave-aces-nf-eletro = esp-recompra-amb-xml.cod-chave-aces-nf-eletro NO-LOCK NO-ERROR.

        DISP ordem-compra.numero-ordem
             ordem-compra.it-codigo
             ordem-compra.dat-ordem
             ordem-compra.qt-solic
             esp-item-devol-consign.num-bobina
             esp-recompra-amb-xml.cod-chave-aces-nf-eletro WHEN AVAIL esp-recompra-amb-xml
             esp-recompra-amb-xml.emissao-nfe              WHEN AVAIL esp-recompra-amb-xml
             docum-est.dt-trans                            WHEN AVAIL docum-est
            WITH WIDTH 200.

        /*IF AVAIL esp-recompra-amb-xml AND AVAIL docum-est THEN DO:
            FIND FIRST b-ordem-compra
                 WHERE ROWID(b-ordem-compra) = ROWID(ordem-compra) EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL b-ordem-compra THEN
                ASSIGN b-ordem-compra.situacao = 4. //Eliminada
        END.*/

    END.

    /*IF esp-item-devol-consign.cod-localiz <> "" THEN
        NEXT.

    ASSIGN d-oc-amb = d-oc-amb + ordem-compra.qt-solic.*/
    
END.
OUTPUT CLOSE.
