DEF TEMP-TABLE tt-item
    FIELD cod-estabel  LIKE ITEM.cod-estabel
    FIELD ge-codigo    LIKE ITEM.ge-codigo
    FIELD it-codigo    LIKE ITEM.it-codigo
    FIELD un           LIKE ITEM.un
    FIELD desc-item    LIKE ITEM.desc-item
    FIELD class-fiscal LIKE ITEM.class-fiscal
    FIELD qtidade-atu  LIKE saldo-estoq.qtidade-atu
    FIELD quantidade   AS   DECIMAL EXTENT 4
    FIELD valor        AS   DECIMAL EXTENT 4
    INDEX id-primario it-codigo cod-estabel.

DEF VAR d-quantidade AS DECIMA NO-UNDO.

FOR EACH ITEM NO-LOCK:

    DISP ITEM.it-codigo.

    PAUSE 0.

    FOR EACH saldo-estoq
        WHERE saldo-estoq.it-codigo   = ITEM.it-codigo NO-LOCK:

        FIND FIRST tt-item
             WHERE tt-item.it-codigo   = saldo-estoq.it-codigo
               AND tt-item.cod-estabel = saldo-estoq.cod-estabel NO-ERROR.
        IF NOT AVAIL tt-item THEN DO:
            CREATE tt-item.
            ASSIGN tt-item.cod-estabel  = saldo-estoq.cod-estabel
                   tt-item.ge-codigo    = ITEM.ge-codigo
                   tt-item.it-codigo    = ITEM.it-codigo
                   tt-item.un           = ITEM.un
                   tt-item.desc-item    = ITEM.desc-item
                   tt-item.class-fiscal = ITEM.class-fiscal
                   tt-item.qtidade-atu  = 0.
        END.

        ASSIGN tt-item.qtidade-atu = tt-item.qtidade-atu + saldo-estoq.qtidade-atu
               tt-item.quantidade[4] = tt-item.qtidade-atu
               tt-item.quantidade[3] = tt-item.qtidade-atu
               tt-item.quantidade[2] = tt-item.qtidade-atu
               tt-item.quantidade[1] = tt-item.qtidade-atu.




    END.

END.

FOR EACH tt-item:

    FOR EACH movto-estoq
        WHERE movto-estoq.it-codigo   = tt-item.it-codigo
          AND movto-estoq.cod-estabel = tt-item.cod-estabel
          AND movto-estoq.dt-trans    >= 01/01/2019
        BREAK BY movto-estoq.dt-trans:

        IF movto-estoq.tipo-trans = 1 THEN
            ASSIGN d-quantidade = movto-estoq.quantidade * (-1).
        ELSE
            ASSIGN d-quantidade = movto-estoq.quantidade.

        IF movto-estoq.dt-trans >= 01/01/2020 THEN DO:
            ASSIGN tt-item.quantidade[4] = tt-item.quantidade[4] + d-quantidade.

            IF movto-estoq.esp-docto = 21 THEN DO:
                ASSIGN tt-item.valor[4] = (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) / movto-estoq.quantidade.

            END.

        END.

        IF movto-estoq.dt-trans >= 10/01/2019 THEN DO:

            ASSIGN tt-item.quantidade[3] = tt-item.quantidade[3] + d-quantidade.

            IF movto-estoq.esp-docto = 21 THEN DO:
                ASSIGN tt-item.valor[3] = (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) / movto-estoq.quantidade.

            END.

        END.

        IF movto-estoq.dt-trans >= 07/01/2019 THEN DO:
            ASSIGN tt-item.quantidade[2] = tt-item.quantidade[2] + d-quantidade.

            IF movto-estoq.esp-docto = 21 THEN DO:
                ASSIGN tt-item.valor[2] = (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) / movto-estoq.quantidade.

            END.
        END.

        IF movto-estoq.dt-trans >= 04/01/2019 THEN DO:
            ASSIGN tt-item.quantidade[1] = tt-item.quantidade[1] + d-quantidade.

            IF movto-estoq.esp-docto = 21 THEN DO:
                ASSIGN tt-item.valor[1] = (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) / movto-estoq.quantidade.

            END.

        END.

    END.

    IF tt-item.valor[1] = 0 THEN DO:

        FOR EACH movto-estoq
            WHERE movto-estoq.it-codigo   = tt-item.it-codigo
              AND movto-estoq.cod-estabel = tt-item.cod-estabel
            BREAK BY movto-estoq.dt-trans DESC:

            IF movto-estoq.esp-docto = 21 THEN DO:
                ASSIGN tt-item.valor[1] = (movto-estoq.valor-mat-m[1] + movto-estoq.valor-mob-m[1] + movto-estoq.valor-ggf-m[1]) / movto-estoq.quantidade.

                LEAVE.
            END.

        END.
    END.


END.

OUTPUT TO c:\temp\saldo-serra.CSV.

PUT unformatted
    "Estab;GE;Item;Unid Medida;Descricao;Classificacao;Saldo Trim 1;Val Un Trim 1;Val Tot Trim 1;Saldo Trim 2;Val Un Trim 2;Val Tot Trim 2;Saldo Trim 3;Val Un Trim 3;Val Tot Trim 3;Saldo Trim 4;Val Un Trim 4;Val Tot Trim 4"
    SKIP.


FOR EACH tt-item:

    IF tt-item.quantidade[1] + tt-item.quantidade[2] + tt-item.quantidade[3] + tt-item.quantidade[4] = 0 THEN
        NEXT.


    EXPORT
        DELIMITER ";"
    tt-item.cod-estabel
    tt-item.ge-codigo
    tt-item.it-codigo   
    tt-item.un 
    tt-item.desc-item   
    tt-item.class-fiscal
    /*tt-item.qtidade-atu */
    tt-item.quantidade[1]
    tt-item.valor[1]
    (tt-item.quantidade[1]  * tt-item.valor[1])
    tt-item.quantidade[2]
    tt-item.valor[2]
    (tt-item.quantidade[2]  * tt-item.valor[2])
    tt-item.quantidade[3]
    tt-item.valor[3]
    (tt-item.quantidade[3]  * tt-item.valor[3])
    tt-item.quantidade[4]
    tt-item.valor[4]
    (tt-item.quantidade[4]  * tt-item.valor[4]).
END.

OUTPUT CLOSE.
