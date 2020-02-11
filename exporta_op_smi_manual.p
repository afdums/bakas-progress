/* ATEN€¶O: Verificar se tem a ODBC cadastrada corretamente, no arquivo de log ir  aparecer se deu certo*/

DEF VAR c-arquivo-dir AS CHAR NO-UNDO.

DEF VAR i-nr-ord-prod LIKE ord-prod.nr-ord-prod NO-UNDO.

DEF BUFFER b-exporta-op-smi FOR exporta-op-smi.

ASSIGN c-arquivo-dir = "U:\ems206\logs\SMITUPER\" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + "\".

DOS SILENT VALUE('mkdir ' + c-arquivo-dir).

REPEAT:
    UPDATE i-nr-ord-prod.
    FIND FIRST exporta-op-smi
         WHERE exporta-op-smi.nr-ord-prod = i-nr-ord-prod NO-LOCK NO-ERROR.
    IF AVAIL exporta-op-smi THEN DO:
        IF exporta-op-smi.tipo = 1 THEN DO:
            FIND FIRST ord-prod
                 WHERE ord-prod.nr-ord-prod = exporta-op-smi.nr-ord-prod NO-LOCK NO-ERROR.
        END.
        ELSE DO:
            FIND FIRST plano_corte
                 WHERE plano_corte.num-plano = exporta-op-smi.nr-ord-prod NO-LOCK NO-ERROR.
            FIND FIRST ord-prod
                 WHERE ord-prod.nr-ord-prod = plano_corte.chave[1] NO-LOCK NO-ERROR.
        END.
        
        IF AVAIL ord-prod THEN DO:
        
            RUN etp/et3135.p(INPUT exporta-op-smi.nr-ord-prod,
                             INPUT exporta-op-smi.tipo).
        
            RUN etp/et3033smi.p(INPUT exporta-op-smi.nr-ord-prod,
                                INPUT exporta-op-smi.tipo).
        
            OUTPUT TO VALUE(c-arquivo-dir + "manual-" + STRING(exporta-op-smi.tipo) + " - " + STRING(exporta-op-smi.nr-ord-prod) + ".txt") APPEND.
        
            FOR EACH oper-ord
                WHERE oper-ord.nr-ord-prod = ord-prod.nr-ord-prod NO-LOCK:
            
                PUT UNFORMATTED
                    ord-prod.cod-estabel         ";"
                    exporta-op-smi.nr-ord-prod   ";"
                    ord-prod.it-codigo           ";"
                    oper-ord.gm-codigo           ";"
                    exporta-op-smi.criacao       ";"
                    NOW                          ";"
                    NOW - exporta-op-smi.criacao ";"
                    RETURN-VALUE
                    SKIP.
            
            END.
        
            IF RETURN-VALUE = "OK":U THEN DO:
            
                FIND FIRST b-exporta-op-smi
                     WHERE ROWID(b-exporta-op-smi) = ROWID(exporta-op-smi) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
                IF AVAIL b-exporta-op-smi THEN
                    DELETE b-exporta-op-smi.
            
            END.
        
            OUTPUT CLOSE.
        
        END.
        ELSE DO:
            FIND FIRST b-exporta-op-smi
                 WHERE ROWID(b-exporta-op-smi) = ROWID(exporta-op-smi) EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
            IF AVAIL b-exporta-op-smi THEN DO:
                OUTPUT TO VALUE(c-arquivo-dir + "manual-" + STRING(exporta-op-smi.tipo) + " - " + STRING(exporta-op-smi.nr-ord-prod) + ".txt") APPEND.
                PUT UNFORMATTED
                    "NAO EXPORTADO"
                    SKIP.
                OUTPUT CLOSE.
                DELETE b-exporta-op-smi.
            END.
        END.
    END.
    ELSE DO:
        MESSAGE "OP nao esta pendente de integracao"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.

END.
