DEF VAR i-num-pedido LIKE pedido-compr.num-pedido  NO-UNDO.
DEF VAR c-erro       AS   CHAR                     NO-UNDO.
DEF VAR c-lote       LIKE esp-lote-consignado.lote NO-UNDO.

UPDATE c-lote.

FIND FIRST esp-lote-consignado
     WHERE esp-lote-consignado.lote = c-lote EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL esp-lote-consignado THEN DO:

    ASSIGN esp-lote-consignado.num-pedido = 0.

    RUN etp/et3175-pedido-compr.p(INPUT esp-lote-consignado.lote,
                                  OUTPUT i-num-pedido,
                                  OUTPUT c-erro).

    IF esp-lote-consignado.num-pedido <> 0 THEN DO:
        RUN etp/et3178-pedido-compr.p(INPUT esp-lote-consignado.lote,
                                      INPUT i-num-pedido).
    END.
    ELSE DO:
        MESSAGE c-erro
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.

END.
ELSE DO:
    MESSAGE "LOTE NAO ENCONTRADO"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END.

