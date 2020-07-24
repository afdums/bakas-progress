{utp/ut-glob.i}
{include/i-epc200.i1}

{cep/ceapi001.i}

DEFINE TEMP-TABLE tt-movto-upc LIKE tt-movto.

DEFINE VARIABLE htt-movto AS HANDLE NO-UNDO.
DEFINE VARIABLE hqr-movto AS HANDLE NO-UNDO.
DEFINE VARIABLE hbf-movto AS HANDLE NO-UNDO.

DEFINE VARIABLE hbf-movto-upc AS HANDLE NO-UNDO.
DEFINE VARIABLE htt-erro  AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-erro
  FIELD i-sequen AS INTEGER
  FIELD cd-erro  AS INTEGER
  FIELD mensagem AS CHARACTER.

DEFINE VARIABLE d-total-req AS DECIMAL     NO-UNDO.

PROCEDURE piInicio-pi-valida-lote:

    DEF VAR l-alternativo AS LOGICAL NO-UNDO.

    DEFINE INPUT PARAMETER p-ind-event AS CHARACTER NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-epc.

    FOR EACH tt-epc NO-LOCK
       WHERE tt-epc.cod-event     = p-ind-event
         AND tt-epc.cod-parameter = "tt-movto(handle)":

        ASSIGN htt-movto = HANDLE(tt-epc.val-parameter)
               hbf-movto = htt-movto:DEFAULT-BUFFER-HANDLE. 

        hbf-movto:FIND-CURRENT(NO-LOCK).        

        ASSIGN hbf-movto-upc = TEMP-TABLE tt-movto-upc:DEFAULT-BUFFER-HANDLE.

        IF hbf-movto:AVAILABLE THEN DO:
            hbf-movto-upc:BUFFER-CREATE().
            hbf-movto-upc:BUFFER-COPY(hbf-movto).
        END.
         
    END.

    FIND FIRST tt-epc NO-LOCK
         WHERE tt-epc.cod-event     = p-ind-event
           AND tt-epc.cod-parameter = "tt-erro(handle)" NO-ERROR.
    IF AVAIL tt-epc THEN
        ASSIGN htt-erro = HANDLE(tt-epc.val-parameter)
               htt-erro = htt-erro:DEFAULT-BUFFER-HANDLE.

    FOR EACH tt-movto-upc
        WHERE LOOKUP(STRING(tt-movto-upc.esp-docto),"28,33") > 0
          AND tt-movto-upc.cod-estabel  = "151"
          AND tt-movto-upc.lote        <> ""
          AND tt-movto-upc.cod-dep      = "1"
          AND tt-movto-upc.tipo-trans   = 2 /*saida*/ NO-LOCK:

        /* se o material est† sendo enviado para bloqueio, nao valida fifo */
        IF tt-movto-upc.descricao-db <> "bloqueio" THEN DO:

            /* Se dando saida do 1 e entrada em outro valida fifo */
            IF CAN-FIND(FIRST tt-movto-upc
                        WHERE tt-movto-upc.cod-dep <> "1") THEN DO:
                RUN pi-valida-fifo.
            END.

        END.

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        ELSE
            RETURN "OK":U.

    END.

    /*FOR EACH tt-movto-upc
        WHERE tt-movto-upc.cod-estabel = "101" NO-LOCK:

        RUN pi-valida-movimentacao-amb.

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.

    END.*/

    FOR FIRST tt-movto-upc
        WHERE tt-movto-upc.cod-estabel  = "151"
          AND tt-movto-upc.lote        >= ""
          AND tt-movto-upc.cod-dep      = "504"
          AND tt-movto-upc.tipo-trans   = 1 /*entrada*/ NO-LOCK:

        /* HD 134129 */
        IF tt-movto-upc.esp-docto = 2 /*ACT*/  OR
           tt-movto-upc.esp-docto = 15 /*INV*/ THEN
            RETURN "OK":U.
        /* Fim HD 134129 */

        RUN pi-valida-504.

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        ELSE
            RETURN "OK":U.

    END.

    FOR FIRST tt-movto-upc,
        FIRST es-op-mae
       WHERE es-op-mae.nr-ord-prod = tt-movto-upc.nr-ord-prod NO-LOCK:
        
        IF tt-movto-upc.esp-docto <> 6 /*DIV*/ AND
           tt-movto-upc.esp-docto <> 2 /*ACT*/ THEN
            RUN pi-valida-op-mae.

    END.

    FOR FIRST tt-movto-upc
        WHERE tt-movto-upc.cod-dep      = "E02"
          AND tt-movto-upc.tipo-trans   = 2 /*saida*/
          AND tt-movto-upc.esp-docto    <> 2  /*ACT - acertos do calculo do medio     */  
          AND tt-movto-upc.esp-docto    <> 20 /*NFD - nota fiscal de devolucao        */  
          AND tt-movto-upc.esp-docto    <> 21 /*NFE - nota fiscal de entrada          */
          AND tt-movto-upc.esp-docto    <> 22 /*NFS - nota fiscal de saida            */
          AND tt-movto-upc.esp-docto    <> 23 /*NFT - nota fiscal de transferencia    */ 
          AND tt-movto-upc.esp-docto    <> 8 NO-LOCK:

        // se for no 105 n∆o precisa validar
        IF tt-movto-upc.cod-estabel <> "105" THEN
            RUN pi-valida-e02.

        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        ELSE
            RETURN "OK":U.

    END.

    /* HD 131140, verificar se a DEV n∆o Ç maior que a REQ no periodo, se for n∆o deixar fazer*/
    FOR EACH tt-movto-upc
        WHERE tt-movto-upc.esp-docto = 5 /*DEV*/ :

        IF tt-movto-upc.nr-ord-prod <> 0 THEN DO:
    
            ASSIGN d-total-req = 0.
            FOR EACH movto-mat
                WHERE movto-mat.nr-ord-prod = tt-movto-upc.nr-ord-prod
                  AND movto-mat.dt-trans    >= DATE(MONTH(tt-movto-upc.dt-trans),01,YEAR(tt-movto-upc.dt-trans))
                  AND movto-mat.dt-trans    <= tt-movto-upc.dt-trans
                  AND movto-mat.it-codigo    = tt-movto-upc.it-codigo
                  AND movto-mat.esp-docto    = 28 /* REQ */ NO-LOCK:
                ASSIGN d-total-req = d-total-req + movto-mat.quantidade.
            END.
    
            FOR EACH movto-mat
                WHERE movto-mat.nr-ord-prod = tt-movto-upc.nr-ord-prod
                  AND movto-mat.dt-trans    >= DATE(MONTH(tt-movto-upc.dt-trans),01,YEAR(tt-movto-upc.dt-trans))
                  AND movto-mat.dt-trans    <= tt-movto-upc.dt-trans
                  AND movto-mat.it-codigo    = tt-movto-upc.it-codigo
                  AND movto-mat.esp-docto    = 31 /* RRQ */ NO-LOCK:
                ASSIGN d-total-req = d-total-req - movto-mat.quantidade.
            END.
    
            FOR EACH movto-mat
                WHERE movto-mat.nr-ord-prod = tt-movto-upc.nr-ord-prod
                  AND movto-mat.dt-trans    >= DATE(MONTH(tt-movto-upc.dt-trans),01,YEAR(tt-movto-upc.dt-trans))
                  AND movto-mat.dt-trans    <= tt-movto-upc.dt-trans
                  AND movto-mat.it-codigo    = tt-movto-upc.it-codigo
                  AND movto-mat.esp-docto    = 5 /* DEV */ NO-LOCK:
                ASSIGN d-total-req = d-total-req - movto-mat.quantidade.
            END.
    
            IF d-total-req < tt-movto-upc.quantidade THEN DO:
                htt-erro:BUFFER-CREATE.
                ASSIGN htt-erro:BUFFER-FIELD(1):BUFFER-VALUE = 1
                       htt-erro:BUFFER-FIELD(2):BUFFER-VALUE = 2
                       htt-erro:BUFFER-FIELD(3):BUFFER-VALUE = "DEV maior que REQ para o item no periodo na OP!".
                RETURN "NOK":U.
            END.

        END.
    END.


    /* HD 131714 - Nao permitir baixar mais que a necessidade da OP */
    FOR EACH tt-movto-upc
        WHERE tt-movto-upc.esp-docto = 28 /*REQ*/ :

        IF tt-movto-upc.nr-ord-prod <> 0 THEN DO:

            FIND FIRST ITEM
                 WHERE ITEM.it-codigo = tt-movto-upc.it-codigo NO-LOCK NO-ERROR.

            //ALM02602,ALM026,ALM02601,ALM028,
            IF AVAIL ITEM AND
               LOOKUP(ITEM.fm-codigo,"ALM02803,ALM02001,ALM020") > 0 THEN DO:

                FIND FIRST ord-prod
                     WHERE ord-prod.nr-ord-prod = tt-movto-upc.nr-ord-prod NO-LOCK NO-ERROR.
                IF AVAIL ord-prod THEN DO:
                    ASSIGN d-total-req = 0.
                    FOR EACH movto-mat
                        WHERE movto-mat.nr-ord-prod = tt-movto-upc.nr-ord-prod
                          AND movto-mat.it-codigo    = tt-movto-upc.it-codigo
                          AND movto-mat.esp-docto    = 28 /* REQ */ NO-LOCK:
                        ASSIGN d-total-req = d-total-req + movto-mat.quantidade.
                    END.
               
                    FOR EACH movto-mat
                        WHERE movto-mat.nr-ord-prod = tt-movto-upc.nr-ord-prod
                          AND movto-mat.it-codigo    = tt-movto-upc.it-codigo
                          AND movto-mat.esp-docto    = 31 /* RRQ */ NO-LOCK:
                        ASSIGN d-total-req = d-total-req - movto-mat.quantidade.
                    END.
               
                    FOR EACH movto-mat
                        WHERE movto-mat.nr-ord-prod = tt-movto-upc.nr-ord-prod
                          AND movto-mat.it-codigo    = tt-movto-upc.it-codigo
                          AND movto-mat.esp-docto    = 5 /* DEV */ NO-LOCK:
                        ASSIGN d-total-req = d-total-req - movto-mat.quantidade.
                    END.

                    /* 3% de tolerancia de variacao */
                    FIND FIRST estrutura
                         WHERE estrutura.it-codigo = ord-prod.it-codigo
                           AND estrutura.es-codigo = tt-movto-upc.it-codigo NO-LOCK NO-ERROR.
                    IF NOT AVAIL estrutura THEN DO:

                        ASSIGN l-alternativo = NO.

                        FOR EACH estrutura
                            WHERE estrutura.it-codigo = ord-prod.it-codigo NO-LOCK:
                            FIND FIRST alternativo
                                 WHERE alternativo.it-codigo = estrutura.it-codigo
                                   AND alternativo.es-codigo = estrutura.es-codigo
                                   AND alternativo.al-codigo = tt-movto-upc.it-codigo NO-LOCK NO-ERROR.
                            IF AVAIL alternativo THEN
                                ASSIGN l-alternativo = YES.
                        END.

                        IF l-alternativo = NO THEN DO:
                            htt-erro:BUFFER-CREATE.
                            ASSIGN htt-erro:BUFFER-FIELD(1):BUFFER-VALUE = 1
                                   htt-erro:BUFFER-FIELD(2):BUFFER-VALUE = 2
                                   htt-erro:BUFFER-FIELD(3):BUFFER-VALUE = "Nao eh da estrutura do Item!".
                            RETURN "NOK":U.
                        END.
    
                    END.
                    ELSE DO:
                        IF ord-prod.cod-estabel <> "105" AND ord-prod.cod-estabel <> "121" AND ord-prod.cod-estabel <> "151" THEN DO: /*Solicitaá∆o por email 11/09 De: Jose para: Doglans.*/
                            IF INT((estrutura.quant-usada * ord-prod.qt-ordem) * 1.03 + 0.49999) < d-total-req + tt-movto-upc.quantidade THEN DO:
            
                                htt-erro:BUFFER-CREATE.
                                ASSIGN htt-erro:BUFFER-FIELD(1):BUFFER-VALUE = 1
                                       htt-erro:BUFFER-FIELD(2):BUFFER-VALUE = 2
                                       htt-erro:BUFFER-FIELD(3):BUFFER-VALUE = "Excede necessidade (+3%) da OP!".
                                RETURN "NOK":U.
            
                            END.
                        END.
                    END.
                END.

            END.

        END.

    END.

    /* HD 132768 - Nao permitir estornar se for o unico movimento do periodo e tiver SOB no periodo */
    FOR EACH tt-movto-upc
        WHERE tt-movto-upc.esp-docto = 8 /*EAC*/ :
        RUN pi-valida-estorno(INPUT tt-movto-upc.nr-ord-prod,
                              INPUT tt-movto-upc.dt-trans,
                              INPUT tt-movto-upc.nr-reporte).
        IF RETURN-VALUE = "NOK":U THEN DO:
            htt-erro:BUFFER-CREATE.
            ASSIGN htt-erro:BUFFER-FIELD(1):BUFFER-VALUE = 1
                   htt-erro:BUFFER-FIELD(2):BUFFER-VALUE = 2
                   htt-erro:BUFFER-FIELD(3):BUFFER-VALUE = "OP possui SOB e nao tem outro movimento de ACA".
            RETURN "NOK":U.
        END.
    END.


    /* HD 133501 - Nao permitir que o PCP realize REQ pelo CE0205 do dep¢sito 1 no estabel 121 */
    FOR EACH tt-movto-upc
        WHERE tt-movto-upc.cod-estabel = "121"
          AND tt-movto-upc.esp-docto = 28 /*REQ*/ :

        IF tt-movto-upc.cod-prog-orig = "v08in218" /*viewer do CE0205 que fica no registro da movimentacao*/ THEN DO:
            IF tt-movto-upc.nr-ord-prod <> 0 AND 
               tt-movto-upc.cod-depos = "1" THEN DO:

                IF NOT CAN-FIND(FIRST ord-manut
                                WHERE ord-manut.nr-ord-prod = tt-movto-upc.nr-ord-prod) THEN DO:
                    htt-erro:BUFFER-CREATE.
                    ASSIGN htt-erro:BUFFER-FIELD(1):BUFFER-VALUE = 1
                           htt-erro:BUFFER-FIELD(2):BUFFER-VALUE = 2
                           htt-erro:BUFFER-FIELD(3):BUFFER-VALUE = "OP nao pode requisitar em Dep 1".
                    RETURN "NOK":U.
                END.

            END.
        END.
    END.
    /* Fim HD 133501 */

END PROCEDURE.

PROCEDURE pi-valida-op-mae:

    htt-erro:BUFFER-CREATE.
    ASSIGN htt-erro:BUFFER-FIELD(1):BUFFER-VALUE = 1
           htt-erro:BUFFER-FIELD(2):BUFFER-VALUE = 2
           htt-erro:BUFFER-FIELD(3):BUFFER-VALUE = "IMPOSSIVEL MOVTO NA OP MAE!".
    RETURN "NOK":U.

END PROCEDURE. 

PROCEDURE pi-valida-fifo:
    DEF BUFFER b-saldo-estoq-fifo FOR saldo-estoq.

    IF tt-movto-upc.cod-dep = "1" AND tt-movto-upc.lote <> "" THEN DO:
        FIND FIRST usuar_grp_usuar
             WHERE usuar_grp_usuar.cod_grp_usuar = "ZB0"
               AND usuar_grp_usuar.cod_usuario   = c-seg-usuario NO-LOCK NO-ERROR.
        IF NOT AVAIL usuar_grp_usuar THEN DO: /*usuario nao pertence ao grupo que possui permissao para retirar material do deposito 1*/
            htt-erro:BUFFER-CREATE.
            ASSIGN htt-erro:BUFFER-FIELD(1):BUFFER-VALUE = 1
                   htt-erro:BUFFER-FIELD(2):BUFFER-VALUE = 2
                   htt-erro:BUFFER-FIELD(3):BUFFER-VALUE = "Sem permissao saida dep 1".
            RETURN "NOK":U.
        END.
        ELSE DO:
            /* se est† no grupo liberado verifica se est† pegando do lote mais antigo */
            FIND FIRST b-saldo-estoq-fifo
                 WHERE b-saldo-estoq-fifo.cod-depos   = tt-movto-upc.cod-depos
                   AND b-saldo-estoq-fifo.cod-estabel = tt-movto-upc.cod-estabel
                   AND b-saldo-estoq-fifo.cod-localiz = tt-movto-upc.cod-localiz
                   AND b-saldo-estoq-fifo.lote        = tt-movto-upc.lote
                   AND b-saldo-estoq-fifo.it-codigo   = tt-movto-upc.it-codigo
                   AND b-saldo-estoq-fifo.cod-refer   = tt-movto-upc.cod-refer   NO-LOCK NO-ERROR.
            
            IF CAN-FIND(FIRST saldo-estoq
                        WHERE saldo-estoq.cod-estabel  = b-saldo-estoq-fifo.cod-estabel
                          AND saldo-estoq.cod-depos    = b-saldo-estoq-fifo.cod-depos
                          AND saldo-estoq.it-codigo    = b-saldo-estoq-fifo.it-codigo
                          AND saldo-estoq.cod-refer    = b-saldo-estoq-fifo.cod-refer
                          AND saldo-estoq.dt-vali-lote < b-saldo-estoq-fifo.dt-vali-lote
                          AND saldo-estoq.qtidade-atu  > 0) THEN DO:
                htt-erro:BUFFER-CREATE.
                ASSIGN htt-erro:BUFFER-FIELD(1):BUFFER-VALUE = 1
                       htt-erro:BUFFER-FIELD(2):BUFFER-VALUE = 2
                       htt-erro:BUFFER-FIELD(3):BUFFER-VALUE = "Sem respeito FIFO".
                RETURN "NOK":U.
            END.
        END.
    END.


    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-valida-504:

    FIND FIRST usuar_grp_usuar
         WHERE usuar_grp_usuar.cod_grp_usuar = "ZDB"
           AND usuar_grp_usuar.cod_usuario   = c-seg-usuario NO-LOCK NO-ERROR.
    IF NOT AVAIL usuar_grp_usuar THEN DO: /*usuario nao pertence ao grupo que possui permissao para retirar material do deposito 1*/
        htt-erro:BUFFER-CREATE.
        ASSIGN htt-erro:BUFFER-FIELD(1):BUFFER-VALUE = 1
               htt-erro:BUFFER-FIELD(2):BUFFER-VALUE = 2
               htt-erro:BUFFER-FIELD(3):BUFFER-VALUE = "Sem permissao entrada dep 504".
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-valida-e02:

    FIND FIRST usuar_grp_usuar
         WHERE usuar_grp_usuar.cod_grp_usuar = "E02"
           AND usuar_grp_usuar.cod_usuario   = c-seg-usuario NO-LOCK NO-ERROR.
    IF NOT AVAIL usuar_grp_usuar THEN DO: /*usuario nao pertence ao grupo que possui permissao para retirar material do deposito 1*/
        htt-erro:BUFFER-CREATE.
        ASSIGN htt-erro:BUFFER-FIELD(1):BUFFER-VALUE = 1
               htt-erro:BUFFER-FIELD(2):BUFFER-VALUE = 2
               htt-erro:BUFFER-FIELD(3):BUFFER-VALUE = "Sem permissao saida E02".
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE. 

PROCEDURE pi-valida-estorno:
    DEF INPUT PARAM p-ordem      LIKE ord-prod.nr-ord-prod   NO-UNDO.
    DEF INPUT PARAM p-dt-trans   AS   DATE                   NO-UNDO.
    DEF INPUT PARAM p-nr-reporte LIKE movto-estoq.nr-reporte NO-UNDO.

    DEF BUFFER b-movto-estorno-aca FOR movto-estoq.
    DEF BUFFER b-movto-estorno-est FOR movto-estoq.
    DEF BUFFER b-movto-estorno-sob FOR movto-estoq.

    DEF BUFFER b-ord-prod-aca FOR ord-prod.

    DEF VAR dt-ini AS DATE NO-UNDO.
    DEF VAR dt-fim AS DATE NO-UNDO.

    DEF VAR l-tem-outro-aca AS LOGICAL NO-UNDO.

    // primeiro dia do màs do movimento
    ASSIGN dt-ini = DATE(MONTH(p-dt-trans),01,YEAR(p-dt-trans)).

    // ultimo dia do màs do movimento
    IF MONTH(dt-ini) = 12 THEN
        ASSIGN dt-fim = DATE(12,31,YEAR(p-dt-trans)).
    ELSE
        ASSIGN dt-fim = DATE(MONTH(p-dt-trans) + 1,1,YEAR(p-dt-trans)) - 1.

    ASSIGN l-tem-outro-aca = YES.

    /* se tiver SOB no periodo nao relacionado a movimento de reporte deve validar se tem outro ACA para absorver a variaá∆o de custo */
    IF CAN-FIND(FIRST b-movto-estorno-sob
                WHERE b-movto-estorno-sob.nr-ord-prod  = p-ordem
                  AND b-movto-estorno-sob.dt-trans    >= dt-ini
                  AND b-movto-estorno-sob.dt-trans    <= dt-fim
                  AND b-movto-estorno-sob.esp-docto    = 35
                  AND b-movto-estorno-sob.nr-reporte   = 0) THEN DO:

        FIND FIRST b-ord-prod-aca
             WHERE b-ord-prod-aca.nr-ord-prod = p-ordem NO-LOCK NO-ERROR.

        IF AVAIL b-ord-prod-aca THEN DO:

            ASSIGN l-tem-outro-aca = NO.

            FOR EACH b-movto-estorno-aca
                WHERE b-movto-estorno-aca.nr-ord-prod  = p-ordem
                  AND b-movto-estorno-aca.dt-trans    >= dt-ini
                  AND b-movto-estorno-aca.dt-trans    <= dt-fim
                  AND b-movto-estorno-aca.esp-docto    = 1
                  AND b-movto-estorno-aca.it-codigo    = b-ord-prod-aca.it-codigo
                  AND b-movto-estorno-aca.nr-reporte  <> p-nr-reporte /*diferente do movimento que esta sendo estornado*/ NO-LOCK:

                /* se esta estornado nao considera pois nao eh mais valido paraa absorver custos */
                IF CAN-FIND(FIRST b-movto-estorno-est
                            WHERE b-movto-estorno-est.nr-ord-prod = b-movto-estorno-aca.nr-ord-prod
                              AND b-movto-estorno-est.nr-reporte  = b-movto-estorno-aca.nr-reporte
                              AND b-movto-estorno-est.esp-docto   = 8)                            THEN
                    NEXT.

                ASSIGN l-tem-outro-aca = YES.

                /* se achar um valido ja eh o suficiente, pode parar de procurarr */
                LEAVE.

            END.
        END.


    END.

    IF l-tem-outro-aca THEN
        RETURN "OK":U.
    ELSE
        RETURN "NOK":U.

END PROCEDURE.


PROCEDURE pi-valida-movimentacao-amb:

    FIND FIRST usuar_grp_usuar
         WHERE usuar_grp_usuar.cod_grp_usuar = "SUP"
           AND usuar_grp_usuar.cod_usuario   = c-seg-usuario NO-LOCK NO-ERROR.
    IF NOT AVAIL usuar_grp_usuar THEN DO:
        FIND FIRST ITEM
             WHERE ITEM.it-codigo = tt-movto-upc.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM AND ITEM.desc-item BEGINS "AMB" THEN DO:

            IF ITEM.ge-codigo = 10 THEN
               RETURN "OK":U.

            IF ITEM.it-codigo = "1003016" OR
               ITEM.it-codigo = "970058" THEN
                RETURN "OK":U.

            IF tt-movto-upc.esp-docto = 33 /*TRA*/ THEN DO:

                IF tt-movto-upc.esp-docto    = 22 /*NFS*/ AND
                   tt-movto-upc.cod-emitente = 62900      THEN
                    RETURN "OK":U.

                htt-erro:BUFFER-CREATE.
                ASSIGN htt-erro:BUFFER-FIELD(1):BUFFER-VALUE = 1
                       htt-erro:BUFFER-FIELD(2):BUFFER-VALUE = 2
                       htt-erro:BUFFER-FIELD(3):BUFFER-VALUE = "ITEM AMB nao pode ser transferido entre depositos, nem entre estabelecimentos, nem faturado para clientes que nao seja o cliente 62900".
        
                RETURN "NOK":U.
                
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.
