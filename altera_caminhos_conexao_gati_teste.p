DEF VAR c-caminho-espec AS CHAR NO-UNDO.

ASSIGN c-caminho-espec = "u:\ems206\ConexaoNFeTeste\".
    
FOR EACH param-xml EXCLUSIVE-LOCK:

    DISP param-xml.cod-estabel.

    ASSIGN param-xml.arquivo-entr  = c-caminho-espec + "entrada-trat"
           param-xml.arquivo-saida = c-caminho-espec + "entrada-bkp"
           param-xml.arquivo-mde   = c-caminho-espec + "retorno"
           param-xml.arq-entrada-cce = c-caminho-espec + "retorno".


    PAUSE 0.

END.
