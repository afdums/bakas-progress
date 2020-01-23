
/* caso o webservice nÃ£o conecte pro erro de HTTPSYS, copiar a DLL msvcr71.dll
   para system32 e SysWOW64 */
   
/*DEF INPUT PARAM p-num-dias AS INTEGER NO-UNDO.   */

DEF VAR c-saida-xml AS CHAR NO-UNDO.

DEF VAR c-arquivo AS CHAR NO-UNDO.

DEFINE VARIABLE hDoc  AS HANDLE  NO-UNDO.
DEFINE VARIABLE hRoot AS HANDLE  NO-UNDO.
DEFINE VARIABLE hText  AS HANDLE  NO-UNDO.
DEFINE VARIABLE lGood AS LOGICAL NO-UNDO.


DEF TEMP-TABLE tt-objeto NO-UNDO
    FIELD numero    AS CHAR FORMAT "x(13)"
    FIELD sigla     AS CHAR
    FIELD nome      AS CHAR FORMAT "x(30)"
    FIELD categoria AS CHAR
    FIELD erro      AS CHAR FORMAT "x(100)".

DEF TEMP-TABLE tt-evento NO-UNDO
    FIELD rw-tt-objeto  AS ROWID
    FIELD tipo          AS CHAR
    FIELD c-status      AS CHAR
    FIELD data          AS DATE
    FIELD hora          AS CHAR
    FIELD descricao     AS CHAR FORMAT "x(30)"
    FIELD detalhe       AS CHAR
    FIELD local         AS CHAR FORMAT "x(30)"
    FIELD codigo        AS CHAR
    FIELD cidade        AS CHAR
    FIELD uf            AS CHAR.

DEF TEMP-TABLE tt-nota-fiscal NO-UNDO
    FIELD rw-nota-fiscal AS ROWID
    FIELD objeto         AS CHAR
        INDEX id-objeto objeto.




ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY.

ASSIGN c-arquivo = REPLACE(c-arquivo,"/","\").

IF NOT c-arquivo MATCHES "*\" THEN
    ASSIGN  c-arquivo = c-arquivo + "\".

MESSAGE c-arquivo
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

RUN pi-consulta-ws.

RUN pi-abre-xml.

RUN pi-grava-eventos.

PROCEDURE pi-consulta-ws:

    DEF VAR hWebService AS HANDLE NO-UNDO.
    DEF VAR hPort       AS HANDLE NO-UNDO.
    DEF VAR hOperacao   AS HANDLE NO-UNDO.

    DEFINE VAR usuario   AS CHARACTER NO-UNDO.
    DEFINE VAR senha     AS CHARACTER NO-UNDO.
    DEFINE VAR tipo      AS CHARACTER NO-UNDO.
    DEFINE VAR resultado AS CHARACTER NO-UNDO.
    DEFINE VAR lingua    AS CHARACTER NO-UNDO.
    DEFINE VAR objetos   AS CHARACTER NO-UNDO.
    DEFINE VAR retorno   AS LONGCHAR NO-UNDO.
    
    ASSIGN usuario   = ""
           senha     = ""
           tipo      = ""
           resultado = ""
           lingua    = "".

    ASSIGN c-saida-xml = c-arquivo + "xml-correios-" + REPLACE(STRING(TODAY),"/","-") + "-" + STRING(TIME) + ".xml".

    /*FOR EACH nota-fiscal USE-INDEX ch-sit-nota
        WHERE nota-fiscal.dt-emis-nota >= TODAY - p-num-dias
          AND nota-fiscal.ind-sit-nota <> 4 /*cancelada*/
          AND nota-fiscal.dt-confirma  <> ? NO-LOCK:
    
        /*FIND FIRST te_nota_fiscal OF nota-fiscal NO-LOCK NO-ERROR.
    
        IF AVAIL te_nota_fiscal THEN DO:
            IF LENGTH(te_nota_fiscal.objeto) = 13 THEN DO:
                ASSIGN objetos = objetos + te_nota_fiscal.objeto.
    
                CREATE tt-nota-fiscal.
                ASSIGN tt-nota-fiscal.rw-nota-fiscal = ROWID(nota-fiscal)
                       tt-nota-fiscal.objeto         = te_nota_fiscal.objeto.
    
            END.
        END.*/
    
    END.*/
    
    ASSIGN objetos = "DP026676385BR" +
                     "DP026676399BR" +
                     "DP026676408BR" +
                     "DP026676411BR" +
                     "DP026676425BR" +
                     "DP026676439BR" +
                     "DP026676442BR" +
                     "DP026676456BR" +
                     "DP026676460BR" +
                     "OG392193104BR" +
                     "OG392193118BR" +
                     "OG392193121BR" +
                     "OG392193135BR" +
                     "OG392193149BR".
    
    CREATE SERVER hWebService.
    
    hWebService:CONNECT("-WSDL 'http://webservice.correios.com.br/service/rastro/Rastro.wsdl' ") NO-ERROR.
    
    IF NOT hWebService:CONNECTED() THEN DO:
        DEFINE VARIABLE errmsg AS CHARACTER NO-UNDO INIT "SERVER NOT CONNECTED~n".
        DEFINE VARIABLE i-cont AS INTEGER NO-UNDO.
        DO i-cont = 1 TO ERROR-STATUS:NUM-MESSAGES:
            errmsg = errmsg + ERROR-STATUS:GET-MESSAGE(i-cont) + '~n'.
        END.
    
        MESSAGE errmsg VIEW-AS ALERT-BOX ERROR.
    
        STOP.
    END.
    
    RUN Service SET hPort ON hWebService.
    
    /* chamada passando cada node como parametro */
    RUN buscaEventos IN hPort (INPUT usuario,
                               INPUT senha,
                               INPUT tipo,
                               INPUT resultado,
                               INPUT lingua,
                               INPUT objetos,
                               OUTPUT retorno).
    
    /*retorno = REPLACE(retorno,"!ISO8859-1!","").*/
    OUTPUT TO VALUE(c-saida-xml).
    PUT UNFORMATTED STRING(retorno).
    OUTPUT CLOSE.
    
    hWebService:DISCONNECT().
    DELETE OBJECT hWebService.

END PROCEDURE.

PROCEDURE pi-abre-xml:

    CREATE X-DOCUMENT hDoc.
    CREATE X-NODEREF hRoot.
    CREATE X-NODEREF hText.
    
    hDoc:LOAD("file", c-saida-xml, TRUE) NO-ERROR.
    hDoc:GET-DOCUMENT-ELEMENT(hRoot).
    
    OUTPUT TO VALUE(c-arquivo + "SCM001-NOS-" + REPLACE(STRING(TODAY),"/","-") + "-" + STRING(TIME) + ".txt.").
    RUN pi-extrai-no(hRoot, 1).
    OUTPUT CLOSE.
    
    DELETE OBJECT hDoc.
    DELETE OBJECT hRoot.

END PROCEDURE.

PROCEDURE pi-extrai-no:
  DEFINE INPUT PARAMETER hParent AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER iLevel  AS INTEGER NO-UNDO.

  DEF VAR c-node-value AS CHAR NO-UNDO.

  DEFINE VARIABLE ix       AS INTEGER NO-UNDO.
  DEFINE VARIABLE hNoderef AS HANDLE  NO-UNDO.

  CREATE X-NODEREF hNoderef.

  REPEAT ix = 1 TO hParent:NUM-CHILDREN:
    lGood = hParent:GET-CHILD(hNoderef, ix).
    IF NOT lGood THEN LEAVE.
    IF hNoderef:SUBTYPE <> "element" THEN
        NEXT.

    IF hNoderef:NUM-CHILDREN > 0 THEN DO:
        hNoderef:GET-CHILD(hText, 1).
        c-node-value = hText:NODE-VALUE.
    END.
    ELSE DO:
        c-node-value = "".
    END.

    CASE iLevel:
      WHEN 2 THEN DO:
          CASE hNoderef:NAME:
              WHEN "numero" THEN DO:
                  CREATE tt-objeto.
                  ASSIGN tt-objeto.numero         = c-node-value.
              END.
              WHEN "sigla" THEN DO:
                  IF AVAIL tt-objeto THEN
                      ASSIGN tt-objeto.sigla      = c-node-value.
              END.
              WHEN "nome" THEN DO:
                  IF AVAIL tt-objeto THEN
                      ASSIGN tt-objeto.nome       = c-node-value.
              END.
              WHEN "categoria" THEN DO:
                  IF AVAIL tt-objeto THEN
                      ASSIGN tt-objeto.categoria  = c-node-value.
              END.
              WHEN "erro" THEN DO:
                  IF AVAIL tt-objeto THEN
                      ASSIGN tt-objeto.erro       = c-node-value.
              END.
          END CASE.
      END.
      WHEN 3 THEN DO:
          CASE hNoderef:NAME:
              WHEN "tipo" THEN DO:
                  CREATE tt-evento.
                  ASSIGN tt-evento.rw-tt-objeto = ROWID(tt-objeto)
                         tt-evento.tipo        = c-node-value.
              END.
              WHEN "status" THEN DO:
                  IF AVAIL tt-evento THEN
                      ASSIGN tt-evento.c-status = c-node-value.
              END.
              WHEN "data" THEN DO:
                  IF AVAIL tt-evento THEN
                      ASSIGN tt-evento.data = DATE(c-node-value).
              END.
              WHEN "hora" THEN DO:
                  IF AVAIL tt-evento THEN
                      ASSIGN tt-evento.hora = c-node-value.
              END.
              WHEN "descricao" THEN DO:
                  IF AVAIL tt-evento THEN
                      ASSIGN tt-evento.descricao = c-node-value.
              END.
              WHEN "detalhe" THEN DO:
                  IF AVAIL tt-evento THEN
                      ASSIGN tt-evento.detalhe = c-node-value.
              END.
              WHEN "local" THEN DO:
                  IF AVAIL tt-evento THEN
                      ASSIGN tt-evento.local = c-node-value.
              END.
              WHEN "codigo" THEN DO:
                  IF AVAIL tt-evento THEN
                      ASSIGN tt-evento.codigo = c-node-value.
              END.
              WHEN "cidade" THEN DO:
                  IF AVAIL tt-evento THEN
                      ASSIGN tt-evento.cidade = c-node-value.
              END.
              WHEN "uf" THEN DO:
                  IF AVAIL tt-evento THEN
                      ASSIGN tt-evento.uf = c-node-value.
              END.
          END CASE.

      END.
    END.

    PUT UNFORMATTED
        "hNoderef:NAME           : " hNoderef:NAME    SKIP
        "hNoderef:SUBTYPE        : " hNoderef:SUBTYPE SKIP
        "c-node-value            : " c-node-value     SKIP
        "iLevel                  : " iLevel           SKIP(2).
        
    RUN pi-extrai-no(hNoderef, (iLevel + 1)).

  END.

  DELETE OBJECT hNoderef.
END PROCEDURE.


PROCEDURE pi-grava-eventos:
    OUTPUT TO VALUE(c-arquivo + "SCM001-" + REPLACE(STRING(TODAY),"/","-") + "-" + STRING(TIME) + ".txt.").
    FOR EACH tt-objeto:
        DISP tt-objeto
            WITH WIDTH 200.
    
        /*FIND FIRST tt-nota-fiscal
             WHERE tt-nota-fiscal.objeto = tt-objeto.numero NO-ERROR.
        IF AVAIL tt-nota-fiscal THEN DO:*/
    
            /*FIND FIRST nota-fiscal
                 WHERE ROWID(nota-fiscal) = tt-nota-fiscal.rw-nota-fiscal NO-LOCK NO-ERROR.*/
    
            /*verificar se a tabela encontrará o último registro de evento ou se precisa for last pela data e hora do evento*/
            /*FIND LAST movto_rastreio OF nota-fiscal NO-LOCK NO-ERROR.*/
    
            IF tt-objeto.erro <> "" THEN DO:
                /*IF movto_rastreio.descricao <> tt-objeto.erro THEN DO:
                    CREATE movto_rastreio.
                    ASSIGN movto_rastreio.tipo    = "ERRO"
                           movto_rastreio.data    = TODAY
                           movto_rastreio.hora    = STRING(TIME,"HH:MM")
                           movto_rastreio.detalhe = tt-objeto.erro.
                END.*/
            END.
            ELSE DO:
                FOR EACH tt-evento
                    WHERE tt-evento.rw-tt-objeto = ROWID(tt-objeto)
                      /*AND tt-evento.data >= movto_rastreio.data*/ :
    
                    /* só testa a data no where pois a hora depende da data */
                    /*IF tt-evento.data  = movto_rastreio.data AND
                       tt-evendo.hora <= movto_rastreio.hora THEN
                        NEXT.
    
                    CREATE movto_rastreio.
                    ASSIGN movto_rastreio.tipo      = tt-evento.tipo
                           movto_rastreio.c-status  = tt-evento.c-status
                           movto_rastreio.data      = tt-evento.data
                           movto_rastreio.hora      = tt-evento.hora
                           movto_rastreio.descricao = tt-evento.descricao
                           movto_rastreio.detalhe   = tt-evento.detalhe
                           movto_rastreio.local     = tt-evento.local
                           movto_rastreio.codigo    = tt-evento.codigo
                           movto_rastreio.cidade    = tt-evento.cidade
                           movto_rastreio.uf        = tt-evento.uf.*/
    
                    DISP tt-evento EXCEPT rw-tt-objeto
                        WITH WIDTH 200.
                END.
            END.
        /*END.*/
    
    END.
    OUTPUT CLOSE.

END PROCEDURE.
