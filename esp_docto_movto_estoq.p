DEF TEMP-TABLE tt-esp-docto NO-UNDO
    FIELD codigo    AS INTEGER
    FIELD sigla     AS CHAR
    FIELD descricao AS CHAR.

DEF VAR c-lista AS CHAR NO-UNDO.

ASSIGN c-lista =
        "1;ACA;Reporte da produção"
        + "|2;ACT;Acerto automático gerado pelo cálculo do preço médio"
        + "|3;CAC;Implementação futura"
        + "|4;DD;Implantação de saldos em ordens de produção"
        + "|5;DEV;Devolução de requisição de materiais"
        + "|6;DIV;Transações diversas"
        + "|7;DRM;Devolução de requisição de material eletrônica"
        + "|8;EAC;Estorno de reporte de produção"
        + "|9;EGF;Implementação futura"
        + "|10;BEM;Implementação futura"
        + "|11;EPR;Entrada produtos rurais"
        + "|12;TSL;Transferência de saldo entre itens"
        + "|13;GTN;Goods transfer note ou Nota de transferência"
        + "|14;ICM;Imposto de circulação de mercadorias"
        + "|15;INV;Inventário"
        + "|16;IPL;Implantação de saldo"
        + "|17;MOB;Contabilização de mão-de-obra"
        + "|18;NC;Nota complementar Exemplo: Despesa acessória na NFE - Nota fiscal de entrada e Nota de rateio"
        + "|19;NF;Nota fiscal"
        + "|20;NFD;Nota fiscal de devolução"
        + "|21;NFE;Nota fiscal de entrada"
        + "|22;NFS;Nota fiscal de saída"
        + "|23;NFT;Nota fiscal de transferência entre estabelecimentos"
        + "|24;PRA;Purchase return aknowledgment ou NFD - Nota devolução de compra"
        + "|25;REF;Refugo"
        + "|26;RCS;Requisição de consignado"
        + "|27;RDD;Requisição de débito direto"
        + "|28;REQ;Requisição"
        + "|29;RFS;Requisição de item físico"
        + "|30;RM;Requisição de material eletrônica"
        + "|31;RRQ;Retorno de requisição, via produção"
        + "|32;STR;Substituição tributária"
        + "|33;TRA;Transferência entre depósitos"
        + "|34;ZZZ;Implementação futura"
        + "|35;SOB;Sobra"
        + "|36;EDD;Estorno de implantação de saldo em ordens de produção"
        + "|37;VAR;Variação de custo padrão"
        + "|38;ROP;Refugo por operação".

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
