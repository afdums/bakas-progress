DEF VAR c-gm-1 AS CHAR NO-UNDO.
DEF VAR c-gm-2 AS CHAR NO-UNDO.

ASSIGN c-gm-1 = "700"
       c-gm-2 = "701".


OUTPUT TO c:\temp\hd132600.txt.
RUN pi-cadastra-alternativo(INPUT c-gm-1,
                            INPUT c-gm-2).

RUN pi-cadastra-alternativo(INPUT c-gm-2,
                            INPUT c-gm-1).
OUTPUT CLOSE.

PROCEDURE pi-cadastra-alternativo:
    DEF INPUT PARAM p-gm-prin AS CHAR NO-UNDO.
    DEF INPUT PARAM p-gm-alt  AS CHAR NO-UNDO.

    FOR EACH operacao
        WHERE operacao.gm-codigo = p-gm-prin NO-LOCK:

        FIND FIRST op-altern                  
             WHERE op-altern.num-id-operacao = operacao.num-id-operacao
               AND op-altern.gm-codigo       = p-gm-alt                 NO-LOCK NO-ERROR.

        IF NOT AVAIL op-altern THEN DO:
            RUN pi-cria(INPUT ROWID(operacao),
                        INPUT p-gm-alt).
        END.

    END.

END PROCEDURE.

PROCEDURE pi-cria:
    DEF INPUT PARAM p-rw-operacao AS ROWID NO-UNDO.
    DEF INPUT PARAM p-gm-alt      AS CHAR  NO-UNDO.

    DEF BUFFER b-operacao  FOR operacao.
    DEF BUFFER b-op-altern FOR op-altern.

    FIND FIRST b-operacao
         WHERE ROWID(b-operacao) = p-rw-operacao NO-LOCK NO-ERROR.

    IF AVAIL b-operacao THEN DO:

        PUT UNFORMATTED b-operacao.it-codigo
            ";"
            p-gm-alt
            SKIP.

        FIND LAST b-op-altern
             WHERE b-op-altern.num-id-operacao = b-operacao.num-id-operacao NO-LOCK NO-ERROR.

        CREATE op-altern.
        ASSIGN op-altern.op-altern         = (IF AVAIL b-op-altern THEN b-op-altern.op-altern + 10 ELSE 10)
               op-altern.num-id-operacao   = b-operacao.num-id-operacao
               op-altern.gm-codigo         = p-gm-alt
               op-altern.descricao         = b-operacao.descricao
               op-altern.qtd-pallet-produt = b-operacao.qtd-pallet-produt
               op-altern.tempo-prepar      = b-operacao.tempo-prepar
               op-altern.tempo-maquin      = b-operacao.tempo-maquin
               op-altern.tempo-homem       = b-operacao.tempo-homem
               op-altern.nr-unidades       = b-operacao.nr-unidades
               op-altern.un-med-tempo      = b-operacao.un-med-tempo.



    END.

END PROCEDURE.
