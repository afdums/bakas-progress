FOR EACH param-xml EXCLUSIVE-LOCK:
    DISP param-xml.cod-estabel.

    ASSIGN param-xml.arquivo-entr  = "U:\ems206\ConexaoNFeTeste\entrada-trat\"
           param-xml.arquivo-saida = "U:\ems206\ConexaoNFeTeste\entrada-bkp\".

    /* Caminho da TESTE: U:\ems206\ConexaoNFe\TESTE */

    DISP param-xml.arquivo-entr    FORMAT "X(50)" //trat
         param-xml.arquivo-saida   FORMAT "X(50)" //bkp
        WITH 1 COL SIDE-LABELS.

    PAUSE 0.
END.
