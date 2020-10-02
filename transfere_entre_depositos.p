{etp/et2414.i}

{utp/ut-glob.i}

{cep/ceapi001k.i}

{cdp/cd0666.i}

DEF TEMP-TABLE tt-item NO-UNDO
    FIELD it-codigo  LIKE ITEM.it-codigo
    FIELD quantidade LIKE saldo-estoq.qtidade-atu.

DEF TEMP-TABLE tt_log_erro NO-UNDO
    FIELD ttv_num_cod_erro  AS INTEGER   FORMAT ">>>>,>>9" LABEL "Numero"         COLUMN-LABEL "Numero"
    FIELD ttv_des_msg_ajuda AS CHARACTER FORMAT "x(40)"    LABEL "Mensagem Ajuda" COLUMN-LABEL "Mensagem Ajuda"
    FIELD ttv_des_msg_erro  AS CHARACTER FORMAT "x(60)"    LABEL "Mensagem Erro"  COLUMN-LABEL "Inconsistencia".

INPUT FROM c:\temp\teste.csv.
REPEAT:
    CREATE tt-item.
    IMPORT DELIMITER ";" tt-item.
END.
INPUT CLOSE.

OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "\retorno.txt").

PUT UNFORMATTED
    "ITEM;Quantidade;Situacao;Codigo;Descricao"
    SKIP.

FOR EACH tt-item:


    IF tt-item.it-codigo = "" THEN
        NEXT.

    RUN pi-transfere-dep(INPUT TODAY, //data da movimentacao
                         INPUT "", //documento
                         INPUT "103", //estabelecimento
                         INPUT "107", //dep saida
                         INPUT "2", //dep entrada
                         INPUT "", //local de saida
                         INPUT "", //local de entrada
                         INPUT tt-item.it-codigo,
                         INPUT tt-item.quantidade).

    PUT UNFORMATTED
        tt-item.it-codigo
        ";"
        tt-item.quantidade
        ";".

    IF NOT CAN-FIND(FIRST tt-erro) AND NOT CAN-FIND(FIRST tt_log_erro) THEN
        PUT UNFORMATTED
            "SUCESSO"
            SKIP.
    ELSE
        PUT UNFORMATTED
            "ERRO"
            SKIP.

    FOR EACH tt_log_erro:
        PUT UNFORMATTED
            tt-item.it-codigo
            ";"
            tt-item.quantidade
            ";"
            "ERRO"
            ";"
            tt_log_erro.ttv_num_cod_erro 
            ";"
            tt_log_erro.ttv_des_msg_ajuda
            SKIP.
    END.

    FOR EACH tt-erro:
        PUT UNFORMATTED
            tt-item.it-codigo
            ";"
            tt-item.quantidade
            ";"
            "ERRO"
            ";"
            tt-erro.cd-erro
            ";"
            tt-erro.mensagem
            SKIP.
    END.
                         

END.
OUTPUT CLOSE.


PROCEDURE pi-transfere-dep:
   DEF INPUT  PARAM p-data          AS   DATE                    NO-UNDO.
   DEF INPUT  PARAM p-nro-docto     AS   CHAR                    NO-UNDO.
   DEF INPUT  PARAM p-cod-estabel   LIKE estabelec.cod-estabel   NO-UNDO.
   DEF INPUT  PARAM p-it-codigo     LIKE saldo-estoq.it-codigo   NO-UNDO.
   DEF INPUT  PARAM p-cod-dep-orig  LIKE saldo-estoq.cod-dep     NO-UNDO.
   DEF INPUT  PARAM p-cod-dep-dest  LIKE saldo-estoq.cod-dep     NO-UNDO.
   DEF INPUT  PARAM p-cod-local-sai LIKE saldo-estoq.cod-localiz NO-UNDO.
   DEF INPUT  PARAM p-cod-local-ent LIKE saldo-estoq.cod-localiz NO-UNDO.
   DEF INPUT  PARAM p-quantidade    LIKE saldo-estoq.qtidade-atu NO-UNDO.

   DEF VAR c-ct-codigo    AS CHAR   NO-UNDO.
   DEF VAR c-sc-codigo    AS CHAR   NO-UNDO.
   DEF VAR h_api_cta_ctbl AS HANDLE NO-UNDO.
   DEF VAR h-ceapi001k    AS HANDLE NO-UNDO.

   EMPTY TEMP-TABLE tt_log_erro.

   EMPTY TEMP-TABLE tt-movto.

   EMPTY TEMP-TABLE tt-erro.

   FIND FIRST param-global NO-LOCK NO-ERROR.
   FIND FIRST param-estoq  NO-LOCK NO-ERROR.

   ASSIGN c-ct-codigo = TRIM(param-estoq.ct-tr-transf)
          c-sc-codigo = TRIM(param-estoq.sc-tr-transf).

   FIND FIRST ITEM
        WHERE ITEM.it-codigo = p-it-codigo NO-LOCK NO-ERROR.

   RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.
                
   RUN pi_valida_conta_contabil IN h_api_cta_ctbl (INPUT  param-global.empresa-prin,       /* EMPRESA EMS2 */
                                                   INPUT  p-cod-estabel,        /* ESTABELECIMENTO EMS2 */
                                                   INPUT  "",                             /* UNIDADE NEG–CIO */
                                                   INPUT  "",                             /* PLANO CONTAS */ 
                                                   INPUT  c-ct-codigo,                    /* CONTA */
                                                   INPUT  "",                             /* PLANO CCUSTO */ 
                                                   INPUT  c-sc-codigo,                    /* CCUSTO */
                                                   INPUT  p-data,        /* DATA TRANSACAO */
                                                   OUTPUT TABLE tt_log_erro).             /* ERROS */

   IF CAN-FIND(tt_log_erro) OR RETURN-VALUE = "NOK" THEN
       RETURN.
   
   IF VALID-HANDLE (h_api_cta_ctbl) THEN DO:
      DELETE PROCEDURE h_api_cta_ctbl.
      ASSIGN h_api_cta_ctbl = ?.
   END.

   

   create tt-movto.
   assign tt-movto.cod-versao-integracao = 1
          tt-movto.cod-prog-orig         = "CE0206"
          tt-movto.dt-trans              = p-data
          tt-movto.nro-docto             = p-nro-docto
          tt-movto.serie-docto           = ""
          tt-movto.cod-depos             = p-cod-dep-orig
          tt-movto.cod-estabel           = p-cod-estabel
          tt-movto.it-codigo             = ITEM.it-codigo
          tt-movto.cod-refer             = ""
          tt-movto.cod-localiz           = p-cod-local-sai
          tt-movto.lote                  = ""
          tt-movto.quantidade            = p-quantidade
          tt-movto.un                    = ITEM.un
          tt-movto.tipo-trans            = 2  /* 1 = Entrada, 2 = Saðda */
          tt-movto.esp-docto             = 33 /* TRA */
          tt-movto.usuario               = c-seg-usuario
          tt-movto.ct-codigo             = c-ct-codigo
          tt-movto.sc-codigo             = c-sc-codigo.
   /* FINAL  - SAIDA DA ORIGEM */


   CREATE tt-movto.
   ASSIGN tt-movto.cod-versao-integracao = 1
          tt-movto.cod-prog-orig         = "CE0206"
          tt-movto.dt-trans              = p-data
          tt-movto.nro-docto             = p-nro-docto
          tt-movto.serie-docto           = ""
          tt-movto.cod-depos             = p-cod-dep-dest
          tt-movto.cod-estabel           = p-cod-estabel
          tt-movto.it-codigo             = ITEM.it-codigo
          tt-movto.cod-refer             = ""
          tt-movto.cod-localiz           = p-cod-local-ent
          tt-movto.lote                  = ""
          tt-movto.quantidade            = p-quantidade
          tt-movto.un                    = ITEM.un
          tt-movto.tipo-trans            = 1  /* 1 = Entrada, 2 = Saðda */
          tt-movto.esp-docto             = 33 /* TRA */
          tt-movto.usuario               = c-seg-usuario
          tt-movto.ct-codigo             = c-ct-codigo
          tt-movto.sc-codigo             = c-sc-codigo.
   /* FINAL  - ENTRADA NO DESTINO */


   /* Criar localizacao de entrada se nÆo exisitir*/
   IF NOT CAN-FIND(FIRST localizacao
                   WHERE localizacao.cod-estabel = tt-movto.cod-estabel
                     AND localizacao.cod-depos   = tt-movto.cod-depos
                     AND localizacao.cod-localiz = tt-movto.cod-localiz) THEN DO:
       CREATE localizacao.
       ASSIGN localizacao.cod-estabel = tt-movto.cod-estabel   
              localizacao.cod-depos   = tt-movto.cod-depos     
              localizacao.cod-localiz = tt-movto.cod-localiz
              localizacao.descricao   = tt-movto.cod-localiz.
       RELEASE localizacao.
   END.                    

   FOR EACH bc-etiqueta
       WHERE bc-etiqueta.it-codigo     = ITEM.it-codigo
         AND bc-etiqueta.cod-estabel   = p-cod-estabel
         AND bc-etiqueta.cod-dep       = p-cod-dep-orig
         AND bc-etiqueta.dt-expedicao  = ? EXCLUSIVE-LOCK:
       ASSIGN bc-etiqueta.cod-dep      = p-cod-dep-dest. 
   END.

   RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.

   IF VALID-HANDLE(h-ceapi001k) THEN DO:
   
      RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                     INPUT-OUTPUT TABLE tt-erro,
                                     INPUT YES).

      DELETE PROCEDURE h-ceapi001k.

   END.

END PROCEDURE.
