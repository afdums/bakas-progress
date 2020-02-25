DEF TEMP-TABLE tt-aux NO-UNDO
        FIELD nome-relativo AS CHAR
        FIELD nome-absoluto AS CHAR
        FIELD atributos AS CHARACTER.
 
DEF TEMP-TABLE tt-arquivos NO-UNDO
        FIELD nome-relativo AS CHAR
        FIELD nome-absoluto AS CHAR
        FIELD recompilar    AS LOGICAL
        FIELD include       AS LOGICAL
        FIELD rec-include   AS LOGICAL
        FIELD seq           AS INTEGER.

DEF BUFFER b-tt-arquivos FOR tt-arquivos.

DEF VAR i-cont AS INTEGER NO-UNDO.

DEF VAR c-aux     AS CHAR NO-UNDO.
DEF VAR c-destino AS CHAR NO-UNDO.
DEF VAR c-origem  AS CHAR NO-UNDO.

ASSIGN c-origem  = "m:\produc\tuper"
       c-destino = "P:\totvs12\homologatuper".
 
RUN pi-percorre-dir(INPUT c-origem, INPUT-OUTPUT TABLE tt-arquivos, INPUT TABLE tt-aux).
 

FOR EACH tt-arquivos:

    IF tt-arquivos.nome-absoluto MATCHES "*tty*" OR
       tt-arquivos.nome-absoluto MATCHES "*OLD*" OR 
       tt-arquivos.nome-absoluto MATCHES "*wms*" OR 
       tt-arquivos.nome-absoluto MATCHES "*protrace*" THEN DO:
        DELETE tt-arquivos.
        NEXT.
    END.


    IF NOT tt-arquivos.nome-absoluto MATCHES "*.w*" AND
       NOT tt-arquivos.nome-absoluto MATCHES "*.p*" AND
       NOT tt-arquivos.nome-absoluto MATCHES "*.i*" THEN DO:
        DELETE tt-arquivos.
        NEXT.
    END.

    //programas do recebimento, deve recompilar por altera‡äes na temp-table
    /*IF tt-arquivos.nome-absoluto MATCHES "*2695*" OR
       tt-arquivos.nome-absoluto MATCHES "*2388*" OR
       tt-arquivos.nome-absoluto MATCHES "*3103*" THEN DO:
        ASSIGN tt-arquivos.recompilar = YES.
    END.*/


    
    RUN pi-localizar(INPUT  tt-arquivos.nome-absoluto,
                     OUTPUT tt-arquivos.recompilar).

    IF tt-arquivos.recompilar THEN DO:
        IF tt-arquivos.nome-absoluto MATCHES "*.i" OR
           tt-arquivos.nome-absoluto MATCHES "*.i1" THEN DO:
            ASSIGN tt-arquivos.include = YES.
        END.
    END.

END.


FOR EACH tt-arquivos
    WHERE tt-arquivos.include:


    FOR EACH b-tt-arquivos:

        IF tt-arquivos.recompilar THEN
            NEXT.


        RUN pi-localiza-include(INPUT  b-tt-arquivos.nome-absoluto,
                                INPUT tt-arquivos.nome-relativo,
                                OUTPUT tt-arquivos.rec-include).

    END.




END.

ASSIGN i-cont = 0.
OUTPUT TO c:\temp\programas.txt.
FOR EACH tt-arquivos:

    IF tt-arquivos.recompilar  = NO AND
       tt-arquivos.rec-include = NO THEN
        NEXT.

    IF tt-arquivos.include THEN
        NEXT.

    ASSIGN i-cont = i-cont + 1.
    ASSIGN tt-arquivos.seq = i-cont.

    DISP tt-arquivos.seq 
         tt-arquivos.nome-absoluto FORMAT "X(70)"
         tt-arquivos.nome-relativo FORMAT "X(70)"
         tt-arquivos.recompilar    FORMAT "S/N"
         tt-arquivos.include       FORMAT "S/N"
         tt-arquivos.rec-include   FORMAT "S/N"
        WITH WIDTH 250.

END.

OUTPUT CLOSE.


OUTPUT TO c:\temp\script-recompilacao.p.
PUT UNFORMATTED
    'DEF VAR h-acomp AS HANDLE NO-UNDO.'                   SKIP
    'DEF VAR i-time  AS INT    NO-UNDO.'                   SKIP(2)
    'ASSIGN i-time = TIME.'                                SKIP(2)
    'RUN utp/ut-acomp.p PERSISTENT SET h-acomp.'           SKIP
    'RUN pi-inicializar IN h-acomp(INPUT "Recompilacao").' SKIP(2)
    'OUTPUT TO c:\temp\log-recompilaca.txt.'               SKIP(2).

    FOR EACH tt-arquivos
        BREAK BY tt-arquivos.seq:

        IF tt-arquivos.recompilar  = NO AND
           tt-arquivos.rec-include = NO THEN
            NEXT.

        IF tt-arquivos.include THEN
            NEXT.


        ASSIGN c-aux = REPLACE(tt-arquivos.nome-absoluto,c-origem,c-destino)
               c-aux = REPLACE(c-aux,tt-arquivos.nome-relativo,"").

        PUT UNFORMATTED
            'RUN pi-acompanhar IN h-acomp(INPUT STRING(TIME - i-time)'  + ' + "s ' + STRING(tt-arquivos.seq) + '/' + STRING(i-cont) + ' - ' + tt-arquivos.nome-relativo + '").' SKIP
            'PUT UNFORMATTED STRING(TIME,"HH:MM:SS") " COMPILE ' + tt-arquivos.nome-absoluto + '" SKIP.' SKIP
            'COMPILE "' + tt-arquivos.nome-absoluto + '" SAVE INTO "' + c-aux + '" NO-ERROR.' SKIP.

    END.

PUT UNFORMATTED
    SKIP
    'RUN pi-finalizar IN h-acomp.' SKIP
    'OUTPUT CLOSE.'.
OUTPUT CLOSE.


/*
    Objetivo: percorre a partir de um diret¢rio raiz e guarda todos os arquivos encontrados
    em pastas e subpastas na temp-table passada por parƒmetro.
*/
PROCEDURE pi-percorre-dir:
    DEF INPUT PARAM c-dir AS CHAR NO-UNDO. /* diret¢rio para busca de arquivos */
    DEF INPUT-OUTPUT PARAM TABLE FOR tt-arquivos. /* tt que guardar  o nome relativo e absoluto dos arquivos encontrados */
    DEF INPUT PARAM TABLE FOR tt-aux. /* tt usada para capturar informa‡äes dos arquivos/diret¢rios atrav‚s do OS-DIR */
 
    INPUT FROM OS-DIR(c-dir) CONVERT SOURCE "iso8859-1".
    REPEAT: /* varre o diret¢rio */
        EMPTY TEMP-TABLE tt-aux. /* garante que tt ter  sempre apenas um registro */
        CREATE tt-aux.
        IMPORT tt-aux.
 
        FIND FIRST tt-aux. /* aponta para o registro */
 
        IF TRIM(tt-aux.nome-relativo) <> ""
                AND TRIM(tt-aux.nome-relativo) <> "."
                AND TRIM(tt-aux.nome-relativo) <> ".." THEN DO:
 
            IF tt-aux.atributos = "D" THEN /* se objeto lido for uma pasta, executa recursivamente a mesma procedure em busca dos arquivos dentro desta pasta */
                RUN pi-percorre-dir(INPUT tt-aux.nome-absoluto, INPUT-OUTPUT TABLE tt-arquivos, INPUT TABLE tt-aux).
            ELSE DO: /* senÆo, guarda nome absoluto e relativo do arquivo dentro da tt respons vel */
                CREATE tt-arquivos.
                ASSIGN tt-arquivos.nome-absoluto = LOWER(tt-aux.nome-absoluto)
                       tt-arquivos.nome-relativo = LOWER(tt-aux.nome-relativo).
 
            END.
        END.
 
    END. /* REPEAT */
 
    INPUT CLOSE.
    EMPTY TEMP-TABLE tt-aux.
 
END. /* PROCEDURE pi-percorre-dir */


PROCEDURE pi-localizar:
    DEF INPUT  PARAM p-arquivo   AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM p-recompila AS LOGICAL NO-UNDO.

    DEF VAR c-linha AS CHAR NO-UNDO.

    INPUT FROM VALUE(p-arquivo).
    REPEAT:

        IMPORT UNFORMATTED c-linha.

        /*IF c-linha MATCHES "*ut-glob*"  OR
           c-linha MATCHES "*QUERY*"    OR
           c-linha MATCHES "*wt-docto*" THEN*/
        IF c-linha MATCHES "*certificad*" THEN
            ASSIGN p-recompila = YES.

        IF p-recompila THEN
            LEAVE.
    END.
    INPUT CLOSE.


END PROCEDURE.

PROCEDURE pi-localiza-include:
    DEF INPUT PARAM  p-arquivo   AS CHAR    NO-UNDO.
    DEF INPUT PARAM  p-busca     AS CHAR    NO-UNDO.
    DEF OUTPUT PARAM p-recompila AS LOGICAL NO-UNDO.

    DEF VAR c-linha AS CHAR NO-UNDO.

    INPUT FROM VALUE(p-arquivo).
    REPEAT:

        IMPORT UNFORMATTED c-linha.

        IF c-linha MATCHES "*" + p-busca + "*" THEN
            ASSIGN p-recompila = YES.

        IF p-recompila THEN
            LEAVE.
    END.
    INPUT CLOSE.


END PROCEDURE.
