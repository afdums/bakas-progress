/* s¢ executar se ainda n∆o tiver pedido gerado */
    
FOR EACH pre-ped-item
    WHERE pre-ped-item.id-pre-ped-venda = 6428175
      AND pre-ped-item.nr-sequencia     = 40 EXCLUSIVE-LOCK:

    FOR EACH pre-ped-item-ordem OF pre-ped-item EXCLUSIVE-LOCK:

        DELETE pre-ped-item-ordem.

    END.

    DELETE pre-ped-item.

END.
