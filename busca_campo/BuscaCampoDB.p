/*****************************************************************
PROGRAMA: PROC2.P
AUTOR: SERGEI SAFAR
EM: JUL/2003

ESTE PROGRAMA  CHAMADO PELO BUSCAMPO.W
BUSCAMPO.W INFORMA EM QUAIS BANCOS / TABELAS UM DETERMINADO CAMPO SE ENCONTRA.
PODE-SE FAZER BUSCA PELO NOME COMPLETO DO CAMPO, PELO INICIOD ELE, OU POR QUALQUER PARTE.
EXEMPLO DE BUSCA:

TOTAL: it-codigo -> Retorna bancos e tabelas onde se encontram campos
                    cujos nomes sejam "it-codigo".
INICIO: it-c     -> Retorna bancos e tabelas onde se encontram campos cujos nomes
                    iniciem por "it-c".
QUALQUER PARTE: codigo -> Retorna bancos e tabelas onde se encontram campos
                cujos nomes contenham a palavra "codigo" em qualquer posicao.

*****************************************************************/
DEF SHARED TEMP-TABLE tt-result
    FIELD tt-banco           AS CHAR
    FIELD tt-tabela          AS CHAR
    FIELD tt-nom-campo       AS CHAR
    FIELD tt-tipo            AS CHAR
    FIELD tt-formato         AS CHAR
    FIELD tt-decimais        AS INT
    FIELD tt-extent          AS INT.

DEF SHARED VAR c-campo      AS CHAR.
DEF SHARED VAR l-ok         AS LOGICAL.
DEF SHARED VAR lname        AS CHAR.
DEF SHARED VAR i-modo-busca AS INTEGER.

CASE i-modo-busca:
    WHEN 1 THEN DO:
        FOR EACH dictdb._field WHERE 
                 dictdb._field._field-name = c-campo:

        /*     MESSAGE  INPUT FRAME {&FRAME-NAME} fi-campo VIEW-AS ALERT-BOX. */

          FIND dictdb._file WHERE 
               RECID(dictdb._file) = dictdb._field._file-recid NO-LOCK NO-ERROR.

          IF AVAIL dictdb._file THEN DO:
              CREATE tt-result.                                     
              ASSIGN tt-result.tt-banco     = lname                       
                     tt-result.tt-tabela    = dictdb._file._file-name
                     tt-result.tt-nom-campo = dictdb._field._field-name               
                     tt-result.tt-tipo      = dictdb._field._data-type               
                     tt-result.tt-formato   = dictdb._field._format
                     tt-result.tt-decimais  = dictdb._field._decimals
                     tt-result.tt-extent    = dictdb._field._extent.
              ASSIGN l-ok = TRUE.
          END.
                     /*
                     MESSAGE dictdb._file._file-name VIEW-AS ALERT-BOX.  
                     */
        END.
    END.
    WHEN 2 THEN DO:
        FOR EACH dictdb._field WHERE 
                 dictdb._field._field-name BEGINS c-campo:

        /*     MESSAGE  INPUT FRAME {&FRAME-NAME} fi-campo VIEW-AS ALERT-BOX. */

          FIND dictdb._file WHERE 
               RECID(dictdb._file) = dictdb._field._file-recid NO-LOCK NO-ERROR.

          IF AVAIL dictdb._file THEN DO:
              CREATE tt-result.                                     
              ASSIGN tt-result.tt-banco     = lname                       
                     tt-result.tt-tabela    = dictdb._file._file-name
                     tt-result.tt-nom-campo = dictdb._field._field-name               
                     tt-result.tt-tipo      = dictdb._field._data-type               
                     tt-result.tt-formato   = dictdb._field._format
                     tt-result.tt-decimais  = dictdb._field._decimals
                     tt-result.tt-extent    = dictdb._field._extent.
              ASSIGN l-ok = TRUE.
          END.
                     /*
                     MESSAGE dictdb._file._file-name VIEW-AS ALERT-BOX.  
                     */
        END.
    END.
    WHEN 3 THEN DO:
        ASSIGN c-campo = '*' + c-campo + '*'.
        FOR EACH dictdb._field WHERE 
                 dictdb._field._field-name MATCHES c-campo:

        /*     MESSAGE  INPUT FRAME {&FRAME-NAME} fi-campo VIEW-AS ALERT-BOX. */

          FIND dictdb._file WHERE 
               RECID(dictdb._file) = dictdb._field._file-recid NO-LOCK NO-ERROR.

          IF AVAIL dictdb._file THEN DO:
              CREATE tt-result.                                     
              ASSIGN tt-result.tt-banco     = lname                       
                     tt-result.tt-tabela    = dictdb._file._file-name
                     tt-result.tt-nom-campo = dictdb._field._field-name               
                     tt-result.tt-tipo      = dictdb._field._data-type               
                     tt-result.tt-formato   = dictdb._field._format
                     tt-result.tt-decimais  = dictdb._field._decimals
                     tt-result.tt-extent    = dictdb._field._extent.
              ASSIGN l-ok = TRUE.
          END.
                     /*
                     MESSAGE dictdb._file._file-name VIEW-AS ALERT-BOX.  
                     */
        END.
    END.
END CASE.

