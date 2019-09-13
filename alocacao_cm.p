DEF VAR l-achou-gms AS LOGICAL                 NO-UNDO.
DEF VAR c-gms       AS CHAR    FORMAT "x(10)"  NO-UNDO.
DEF VAR d-tempo     AS DECIMAL                 NO-UNDO.

DEF TEMP-TABLE tt-resumo NO-UNDO
    FIELD ano        LIKE periodo.ano
    FIELD nr-periodo LIKE periodo.nr-periodo
    FIELD tempo      AS   DECIMAL.

DEF TEMP-TABLE tt-saldo NO-UNDO
    FIELD it-codigo    LIKE saldo-estoq.it-codigo
    FIELD qtidade-atu  LIKE saldo-estoq.qtidade-atu
    FIELD qtidade-disp LIKE saldo-estoq.qtidade-atu.

FIND LAST mgesp.cm-param
     WHERE cm-param.cod-estabel = "103"
       AND cm-param.ativo NO-LOCK NO-ERROR.

OUTPUT TO c:\temp\teste-pedido-tec.txt.
FOR EACH ped-venda
    WHERE ped-venda.cod-estabel = "103"
      AND ped-venda.cod-sit-ped < 3 NO-LOCK,
    EACH ped-item OF ped-venda NO-LOCK
    BY ped-item.dt-max-fat:

    IF ped-venda.log-cotacao THEN
        NEXT.

    IF ped-item.cod-sit-item > 2 THEN
        NEXT.

    IF (ped-item.qt-pedida - ped-item.qt-alocada) <= 0 THEN
        NEXT.

    ASSIGN c-gms       = "626"
           l-achou-gms = NO.

    ASSIGN d-tempo = 0.


    /*FIND FIRST tt-saldo
         WHERE tt-saldo.it-codigo = ped-item.it-codigo NO-ERROR.
    IF NOT AVAIL tt-saldo THEN
        RUN pi-saldo-estoq(INPUT ped-item.it-codigo).

    FIND FIRST tt-saldo
         WHERE tt-saldo.it-codigo = ped-item.it-codigo NO-ERROR.

    IF tt-saldo.qtidade-disp <= 0 THEN DO:
        ASSIGN d-saldo-ped = ped-item.qt-pedida - ped-item.qt-atendida.
    END.
    ELSE DO:

        IF ped-item.qt-pedida - ped-item.qt-atendida < tt-saldo.qtidade-disp THEN
            ASSIGN tt-saldo.qtidade-disp = tt-saldo.qtidade-disp - (ped-item.qt-pedida - ped-item.qt-atendida)
                   d-saldo-ped           = 0.
        ELSE
            ASSIGN d-saldo-ped           = (ped-item.qt-pedida - ped-item.qt-atendida) - tt-saldo.qtidade-disp
                   tt-saldo.qtidade-disp = 0.
            

    END.*/

    RUN pi-busca-gms(INPUT ped-item.it-codigo,
                     INPUT ped-item.qt-pedida - ped-item.qt-atendida).

    IF l-achou-gms THEN DO:
    //IF exten-ped-item.tipo-atend <> "E" AND exten-ped-item.dt-formadora = ? THEN DO:

        FIND FIRST exten-ped-item OF ped-item NO-LOCK NO-ERROR.

        FIND FIRST periodo
             WHERE periodo.cd-tipo     = 2 //Semanal
               AND periodo.dt-inicio  <= (IF ped-item.dt-max-fat < TODAY THEN TODAY ELSE ped-item.dt-max-fat)
               AND periodo.dt-termino >= (IF ped-item.dt-max-fat < TODAY THEN TODAY ELSE ped-item.dt-max-fat) NO-LOCK NO-ERROR.

        DISP ped-venda.nome-abrev
             ped-venda.nr-pedcli
             ped-venda.completo
             ped-item.it-codigo
             ped-item.dt-max-fat
             exten-ped-item.dt-formadora
             exten-ped-item.tipo-atend
             c-gms
             d-tempo
             periodo.ano        WHEN AVAIL periodo
             periodo.nr-periodo WHEN AVAIL periodo
             ped-item.qt-pedida - ped-item.qt-atendida COLUMN-LABEL "Saldo Ped"
            WITH WIDTH 300.

        FIND FIRST tt-resumo
             WHERE tt-resumo.ano        = (IF AVAIL periodo THEN periodo.ano ELSE 0)
               AND tt-resumo.nr-periodo = (IF AVAIL periodo THEN periodo.nr-periodo ELSE 0) NO-ERROR.
        IF NOT AVAIL tt-resumo THEN DO:
            CREATE tt-resumo.
            ASSIGN tt-resumo.ano        = (IF AVAIL periodo THEN periodo.ano ELSE 0)
                   tt-resumo.nr-periodo = (IF AVAIL periodo THEN periodo.nr-periodo ELSE 0)
                   tt-resumo.tempo      = 0.

        END.

        ASSIGN tt-resumo.tempo = tt-resumo.tempo + d-tempo.

    END.

END.

PUT UNFORMATTED
    SKIP(3).

FOR EACH tt-resumo:
    DISP tt-resumo.
END.

OUTPUT CLOSE.

PROCEDURE pi-busca-gms:
    DEF INPUT PARAM p-item LIKE ITEM.it-codigo NO-UNDO.
    DEF INPUT PARAM p-qtde AS   DECIMAL        NO-UNDO.


    FIND FIRST tt-saldo
         WHERE tt-saldo.it-codigo = ped-item.it-codigo NO-ERROR.
    IF NOT AVAIL tt-saldo THEN
        RUN pi-saldo-estoq(INPUT ped-item.it-codigo).

    FIND FIRST tt-saldo
         WHERE tt-saldo.it-codigo = ped-item.it-codigo NO-ERROR.

    IF tt-saldo.qtidade-disp <= 0 THEN DO:
        ASSIGN p-qtde = ped-item.qt-pedida - ped-item.qt-atendida.
    END.
    ELSE DO:

        IF ped-item.qt-pedida - ped-item.qt-atendida < tt-saldo.qtidade-disp THEN
            ASSIGN tt-saldo.qtidade-disp = tt-saldo.qtidade-disp - (ped-item.qt-pedida - ped-item.qt-atendida)
                   p-qtde                = 0.
        ELSE
            ASSIGN p-qtde                = (ped-item.qt-pedida - ped-item.qt-atendida) - tt-saldo.qtidade-disp
                   tt-saldo.qtidade-disp = 0.
            

    END.

    FOR EACH operacao
        WHERE operacao.it-codigo     = p-item
          AND operacao.data-inicio  <= TODAY
          AND operacao.data-termino >= TODAY NO-LOCK:
        IF LOOKUP(operacao.gm-codigo,c-gms) > 0 THEN DO:
            ASSIGN d-tempo = d-tempo + (p-qtde * (operacao.tempo-maquin / operacao.nr-unidades)).
            ASSIGN l-achou-gms = YES.
        END.
    END.

    /* se nao achou a GM ainda na estrutura continua explodindo */
    FOR EACH estrutura
        WHERE estrutura.it-codigo = p-item
          AND estrutura.data-inicio <= TODAY
          AND estrutura.data-termino >= TODAY NO-LOCK:
        RUN pi-busca-gms(INPUT estrutura.es-codigo,
                         INPUT p-qtde * estrutura.quant-usada).
    END.

END PROCEDURE.

PROCEDURE pi-saldo-estoq:
    DEF INPUT PARAM p-item LIKE saldo-estoq.it-codigo NO-UNDO.

    FIND FIRST tt-saldo
         WHERE tt-saldo.it-codigo = p-item NO-ERROR.
    IF NOT AVAIL saldo-estoq THEN DO:

        CREATE tt-saldo.
        ASSIGN tt-saldo.it-codigo = p-item.

        FOR EACH saldo-estoq
            WHERE saldo-estoq.it-codigo   = p-item
              AND saldo-estoq.cod-estabel = "103"
              AND saldo-estoq.cod-localiz = ""      NO-LOCK:

            IF saldo-estoq.qtidade-atu <= 0 THEN
                NEXT.

            ASSIGN tt-saldo.qtidade-atu  = tt-saldo.qtidade-atu  + saldo-estoq.qtidade-atu  
                   tt-saldo.qtidade-disp = tt-saldo.qtidade-disp + saldo-estoq.qtidade-atu. 
    
        END.

    END.

END PROCEDURE.
