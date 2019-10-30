DEF TEMP-TABLE tt-item NO-UNDO
    FIELD gm-codigo          LIKE operacao.gm-codigo
    FIELD ultimo-aca         AS   DATE
    FIELD it-codigo          LIKE ITEM.it-codigo
    FIELD desc-item          LIKE ITEM.desc-item
    FIELD cod-obsoleto       LIKE ITEM.cod-obsoleto
    FIELD l-trefila          AS   LOGICAL
    FIELD compr-aca          AS   DECIMAL
    FIELD peso-aca           AS   DECIMAL
    FIELD it-reserva         LIKE ITEM.it-codigo
    FIELD desc-reserva       LIKE ITEM.desc-item
    FIELD compr-res          AS   DECIMAL
    FIELD peso-res           AS   DECIMAL
    FIELD quant-usada        LIKE estrutura.quant-usada
    FIELD compr-sobra        AS   DECIMAL
    FIELD peso-sobra         AS   DECIMAL
    FIELD peso-un-sobra      AS   DECIMAL
    FIELD erro               AS   CHAR
    FIELD peso-sobra-peso    AS   DECIMAL
    FIELD peso-un-sobra-peso AS   DECIMAL.

DEF VAR d-comprimento AS DECIMAL NO-UNDO.

DEF VAR c-gms AS CHAR NO-UNDO.

DISABLE TRIGGERS FOR LOAD OF estrutura.

ASSIGN c-gms = "811,851,861,871,832,830,550,551,823,824,827,821,822".

FOR EACH operacao
    WHERE LOOKUP(operacao.gm-codigo,c-gms) > 0 NO-LOCK:
    FIND FIRST ITEM
         WHERE ITEM.it-codigo = operacao.it-codigo NO-LOCK NO-ERROR.
    IF NOT AVAIL ITEM THEN
        NEXT.

    IF ITEM.cod-obsoleto <> 1 THEN
        NEXT.

    CREATE tt-item.
    ASSIGN tt-item.it-codigo    = operacao.it-codigo
           tt-item.desc-item    = ITEM.desc-item
           tt-item.cod-obsoleto = ITEM.cod-obsoleto
           tt-item.gm-codigo    = operacao.gm-codigo
           tt-item.peso-aca     = ITEM.peso-liquido.

    FIND LAST movto-estoq
         WHERE movto-estoq.it-codigo = operacao.it-codigo
           AND movto-estoq.esp-docto = 1                  NO-LOCK NO-ERROR.
    IF AVAIL movto-estoq THEN
        ASSIGN tt-item.ultimo-aca = movto-estoq.dt-trans.

    ASSIGN d-comprimento = 0.
    RUN pi-comprimento(INPUT  tt-item.desc-item,
                       OUTPUT d-comprimento).

    ASSIGN tt-item.compr-aca = d-comprimento.

    RUN pi-trefila(INPUT tt-item.it-codigo).

    // se passa na Trefila nao pode fazer negativo pois n∆o se sabe a proporá∆o.
    IF tt-item.l-trefila THEN DO:
        DELETE tt-item.
        NEXT.
    END.

    /* se j† tem negativo ignora o registro */
    FIND FIRST estrutura
         WHERE estrutura.it-codigo     = tt-item.it-codigo
           AND estrutura.data-inicio  <= TODAY
           AND estrutura.data-termino >= TODAY
           AND estrutura.quant-usada  <  0                 NO-LOCK NO-ERROR.
    IF AVAIL estrutura THEN DO:
        DELETE tt-item.
        NEXT.
    END.

    FIND FIRST estrutura
         WHERE estrutura.it-codigo     = tt-item.it-codigo
           AND estrutura.data-inicio  <= TODAY
           AND estrutura.data-termino >= TODAY             NO-LOCK NO-ERROR.

    IF NOT AVAIL estrutura THEN DO:
        DELETE tt-item.
        NEXT.
    END.

    ASSIGN tt-item.quant-usada = estrutura.quant-usada.

    FIND FIRST ITEM
         WHERE ITEM.it-codigo = estrutura.es-codigo NO-LOCK NO-ERROR.

    IF NOT AVAIL ITEM THEN DO:
        DELETE tt-item.
        NEXT.
    END.

    ASSIGN tt-item.it-reserva   = ITEM.it-codigo
           tt-item.desc-reserva = ITEM.desc-item
           tt-item.peso-res     = ITEM.peso-liquido.

    ASSIGN d-comprimento = 0.
    RUN pi-comprimento(INPUT  tt-item.desc-reserva,
                       OUTPUT d-comprimento).

    ASSIGN tt-item.compr-res = d-comprimento.

    ASSIGN tt-item.compr-sobra = INT(tt-item.compr-res - (tt-item.compr-aca / estrutura.quant-usada)).

    IF tt-item.compr-sobra <= 0 THEN DO:
        ASSIGN tt-item.erro = "Comprimento do cortado multiplicado pelo numero de cortados maior ou igual a do multiplo".
    END.
    ELSE DO:
        // peso da sobra Ç o peso por milimetro multiplicado pelo comprimento da sobra
        ASSIGN tt-item.peso-sobra    = (ITEM.peso-liquido / tt-item.compr-res) * tt-item.compr-sobra
               tt-item.peso-un-sobra = tt-item.peso-sobra * tt-item.quant-usada.
    END.

    ASSIGN tt-item.peso-sobra-peso    = tt-item.peso-res - (tt-item.peso-aca / tt-item.quant-usada)
           tt-item.peso-un-sobra-peso = tt-item.peso-sobra-peso * tt-item.quant-usada.
        

END.

OUTPUT TO c:\temp\teste-negativo-estrutura.csv.
EXPORT DELIMITER ";"
    "GM"
    "Ultima Producao"
    "Cortado"
    "Descricao Cortado"
    "Comprimento Cortado"
    "Peso Cortado"
    "Reserva"
    "Descricao Reserva"
    "Comprimento Reserva"
    "Peso Reserva"
    "Quant. Usada"
    "Comprimento Sobra"
    "Peso Sobra (base no comprimento)"
    "Peso Sobra por Cortado (base no comprimento)"
    "Erro (base no comprimento)"
    "Peso Sobra (base no peso)"
    "Peso Sobra por Cortado (base no peso)".
FOR EACH tt-item:
    EXPORT DELIMITER ";"
        tt-item
        EXCEPT cod-obsoleto l-trefila.

    /* descomentar o bloco abaixo para criar o negativo na estrutura */
/*     IF tt-item.peso-un-sobra-peso > 0 THEN                             */
/*         RUN pi-cria-sobra-estrutura(INPUT tt-item.it-codigo,           */
/*                                     INPUT tt-item.peso-un-sobra-peso). */

END.
OUTPUT CLOSE.

PROCEDURE pi-trefila:
    DEF INPUT PARAM p-item LIKE ITEM.it-codigo NO-UNDO.

    DEF BUFFER b-operacao FOR operacao.

    FOR EACH estrutura
        WHERE estrutura.it-codigo     = p-item
          AND estrutura.data-inicio  <= TODAY
          AND estrutura.data-termino >= TODAY NO-LOCK:
        IF CAN-FIND(FIRST b-operacao
                    WHERE b-operacao.it-codigo = estrutura.es-codigo
                      AND LOOKUP(b-operacao.gm-codigo,"300,310,315") > 0) THEN
            ASSIGN tt-item.l-trefila = YES.
    END.

END PROCEDURE.

PROCEDURE pi-comprimento:
    DEF INPUT  PARAM p-descricao   LIKE ITEM.desc-item NO-UNDO.
    DEF OUTPUT PARAM p-comprimento AS   INTEGER        NO-UNDO.

    ASSIGN p-descricao = UPPER(p-descricao).

    DEF VAR i-cont-x      AS INTEGER NO-UNDO.
    DEF VAR c-desc-ult-x  AS CHAR    NO-UNDO.
    DEF VAR c-comprimento AS CHAR    NO-UNDO.
    DEF VAR i-cont        AS INTEGER NO-UNDO.

    ASSIGN i-cont-x = NUM-ENTRIES(p-descricao,"X").

    IF p-descricao MATCHES "*inox*" OR
       p-descricao MATCHES "*DX*"   OR
       p-descricao MATCHES "*EXP*"  THEN
        ASSIGN i-cont-x = i-cont-x - 1.

    ASSIGN c-desc-ult-x = ENTRY(i-cont-x,p-descricao,"X").

    ASSIGN c-comprimento = "".
    DO i-cont = 1 TO LENGTH(c-desc-ult-x):
        IF INDEX("1234567890",SUBSTRING(c-desc-ult-x,i-cont,1)) > 0 THEN DO:
            ASSIGN c-comprimento = c-comprimento + SUBSTRING(c-desc-ult-x,i-cont,1).
        END.
        ELSE
            LEAVE.

    END.

    ASSIGN p-comprimento = INTEGER(c-comprimento).


END PROCEDURE.

PROCEDURE pi-cria-sobra-estrutura:
    DEF INPUT PARAM p-it-codigo LIKE ITEM.it-codigo        NO-UNDO.
    DEF INPUT PARAM p-peso      LIKE estrutura.quant-usada NO-UNDO.

    DEF BUFFER b-estrutura FOR estrutura.

    DEF VAR i-seq-aux AS INTEGER NO-UNDO.

    FIND FIRST estrutura
         WHERE estrutura.it-codigo = p-it-codigo
           AND estrutura.es-codigo = "9700000"   NO-LOCK NO-ERROR.
    IF NOT AVAIL estrutura THEN DO:

        FIND LAST estrutura
             WHERE estrutura.it-codigo = p-it-codigo NO-LOCK NO-ERROR.
        IF AVAIL estrutura THEN
            ASSIGN i-seq-aux = estrutura.sequencia + 10.

        //busca modelo
        FIND FIRST b-estrutura
             WHERE b-estrutura.it-codigo = "100562"
               AND b-estrutura.es-codigo = "970000" NO-LOCK NO-ERROR.
        IF AVAIL b-estrutura THEN DO:
            CREATE estrutura.
            ASSIGN estrutura.it-codigo    = p-it-codigo
                   estrutura.es-codigo    = "9700000"
                   estrutura.quant-usada  = p-peso * (-1)
                   estrutura.qtd-compon   = p-peso * (-1)
                   estrutura.quant-liquid = p-peso * (-1)
                   estrutura.sequencia    = i-seq-aux.

            BUFFER-COPY b-estrutura EXCEPT it-codigo
                                           es-codigo
                                           quant-usada
                                           qtd-compon
                                           quant-liquid
                                           sequencia
                TO estrutura.

        END.

    END.


    
END PROCEDURE.
    //(INPUT tt-item.it-codigo
       //                             INPUT tt-item.peso-un-sobra).
