{utp\ut-glob.i}

DEF VAR i-cont AS INTEGER NO-UNDO.

ASSIGN c-seg-usuario = "heliohj".

DEF TEMP-TABLE tt-ped-item NO-UNDO
    FIELD it-codigo       LIKE ped-item.it-codigo
    FIELD nome-abrev     LIKE ped-item.nome-abrev
    FIELD nr-pedcli      LIKE ped-item.nr-pedcli
    FIELD dt-min-fat-old  AS CHAR
    FIELD dt-min-fat-nova LIKE ped-item.dt-min-fat
    FIELD nr-sequencia    LIKE ped-item.nr-sequencia
    FIELD situacao AS CHAR FORMAT "x(100)".

DEF VAR i-dia-max-fat AS INTEGER NO-UNDO.

DEF BUFFER b-ped-item FOR ped-item.

INPUT FROM U:\dums\altera_data_saida\HD142121.txt.
REPEAT:
    CREATE tt-ped-item.
    IMPORT DELIMITER ";" tt-ped-item.
END.
INPUT CLOSE.

FOR EACH tt-ped-item:

    IF tt-ped-item.nr-sequencia = 0 THEN
        SELECT COUNT(*) INTO i-cont FROM ped-item 
               WHERE ped-item.nr-pedcli  = tt-ped-item.nr-pedcli
                 AND ped-item.it-codigo  = tt-ped-item.it-codigo.
    ELSE
        SELECT COUNT(*) INTO i-cont FROM ped-item 
               WHERE ped-item.nr-pedcli    = tt-ped-item.nr-pedcli
                 AND ped-item.it-codigo    = tt-ped-item.it-codigo
                 AND ped-item.nr-sequencia = tt-ped-item.nr-sequencia.

    IF i-cont = 0 THEN DO:
        ASSIGN tt-ped-item.situacao = "Registro nao encontrado".
    END.
    ELSE DO:
        IF i-cont > 1 THEN DO:
            ASSIGN tt-ped-item.situacao = "Registro duplicado, informe a sequencia".
        END.
        ELSE DO:

            FOR EACH ped-item
                WHERE ped-item.nr-pedcli    = tt-ped-item.nr-pedcli
                  AND ped-item.it-codigo    = tt-ped-item.it-codigo NO-LOCK:

                IF tt-ped-item.nr-sequencia  > 0                        AND
                   ped-item.nr-sequencia    <> tt-ped-item.nr-sequencia THEN
                    NEXT.
        
                ASSIGN i-dia-max-fat = ped-item.dt-max-fat - ped-item.dt-min-fat.
        
                ASSIGN tt-ped-item.situacao = "Alterado".
        
                FIND FIRST b-ped-item
                     WHERE ROWID(b-ped-item) = ROWID(ped-item) EXCLUSIVE-LOCK NO-ERROR.
                IF AVAIL b-ped-item THEN
                    ASSIGN b-ped-item.dt-min-fat = tt-ped-item.dt-min-fat-nova
                           b-ped-item.dt-max-fat = b-ped-item.dt-min-fat + i-dia-max-fat.
        
            END.

        END.
    END.    

END.

OUTPUT TO U:\dums\altera_data_saida\HD142121-log.txt.  
FOR EACH tt-ped-item:
    DISP tt-ped-item
        WITH WIDTH 200.
END.
OUTPUT CLOSE.
