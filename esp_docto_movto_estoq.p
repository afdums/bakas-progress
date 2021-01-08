DEF TEMP-TABLE tt-esp-docto NO-UNDO
    FIELD codigo    AS INTEGER
    FIELD sigla     AS CHAR
    FIELD descricao AS CHAR.

DEF VAR c-lista AS CHAR NO-UNDO.

ASSIGN c-lista =
        "1;ACA;Reporte da produ��o"
        + "|2;ACT;Acerto autom�tico gerado pelo c�lculo do pre�o m�dio"
        + "|3;CAC;Implementa��o futura"
        + "|4;DD;Implanta��o de saldos em ordens de produ��o"
        + "|5;DEV;Devolu��o de requisi��o de materiais"
        + "|6;DIV;Transa��es diversas"
        + "|7;DRM;Devolu��o de requisi��o de material eletr�nica"
        + "|8;EAC;Estorno de reporte de produ��o"
        + "|9;EGF;Implementa��o futura"
        + "|10;BEM;Implementa��o futura"
        + "|11;EPR;Entrada produtos rurais"
        + "|12;TSL;Transfer�ncia de saldo entre itens"
        + "|13;GTN;Goods transfer note ou Nota de transfer�ncia"
        + "|14;ICM;Imposto de circula��o de mercadorias"
        + "|15;INV;Invent�rio"
        + "|16;IPL;Implanta��o de saldo"
        + "|17;MOB;Contabiliza��o de m�o-de-obra"
        + "|18;NC;Nota complementar Exemplo: Despesa acess�ria na NFE - Nota fiscal de entrada e Nota de rateio"
        + "|19;NF;Nota fiscal"
        + "|20;NFD;Nota fiscal de devolu��o"
        + "|21;NFE;Nota fiscal de entrada"
        + "|22;NFS;Nota fiscal de sa�da"
        + "|23;NFT;Nota fiscal de transfer�ncia entre estabelecimentos"
        + "|24;PRA;Purchase return aknowledgment ou NFD - Nota devolu��o de compra"
        + "|25;REF;Refugo"
        + "|26;RCS;Requisi��o de consignado"
        + "|27;RDD;Requisi��o de d�bito direto"
        + "|28;REQ;Requisi��o"
        + "|29;RFS;Requisi��o de item f�sico"
        + "|30;RM;Requisi��o de material eletr�nica"
        + "|31;RRQ;Retorno de requisi��o, via produ��o"
        + "|32;STR;Substitui��o tribut�ria"
        + "|33;TRA;Transfer�ncia entre dep�sitos"
        + "|34;ZZZ;Implementa��o futura"
        + "|35;SOB;Sobra"
        + "|36;EDD;Estorno de implanta��o de saldo em ordens de produ��o"
        + "|37;VAR;Varia��o de custo padr�o"
        + "|38;ROP;Refugo por opera��o".

DEF VAR i-cont-lista AS INTEGER NO-UNDO.
DEF VAR c-registro   AS CHAR    NO-UNDO.

DO i-cont-lista = 1 TO NUM-ENTRIES(c-lista,"|"):

    ASSIGN c-registro = ENTRY(i-cont-lista,c-lista,"|").

    CREATE tt-esp-docto.
    ASSIGN tt-esp-docto.codigo    = INT(ENTRY(1,c-registro,";"))
           tt-esp-docto.sigla     = ENTRY(2,c-registro,";")
           tt-esp-docto.descricao = ENTRY(3,c-registro,";").

END.

FOR EACH tt-esp-docto:
    DISP tt-esp-docto.
END.
