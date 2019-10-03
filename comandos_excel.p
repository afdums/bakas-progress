DEF VAR ch-Excel AS COM-HANDLE NO-UNDO.
DEF VAR c-col    AS CHAR       NO-UNDO  EXTENT 26 INITIAL ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"].
DEF VAR i-linha  AS INTEGER    NO-UNDO.
DEF VAR i-col    AS INTEGER    NO-UNDO.


CREATE "excel.application" ch-Excel.

ch-Excel:DisplayAlerts = FALSE.
ch-Excel:WorkBooks:ADD().

ch-Excel:VISIBLE = FALSE NO-ERROR.

ch-Excel:Sheets:ITEM(1):SELECT.

/* gerar as cores dos excel para preenchimento de celula e Fonte (nos testes feitos s∆o encontradas 56 cores*/
DO i-linha = 1 TO 56:
    ASSIGN ch-Excel:range(c-col[1] + STRING(i-linha)):Interior:ColorIndex = i-linha NO-ERROR.
END.


ch-Excel:VISIBLE        = TRUE.

IF VALID-HANDLE(ch-Excel) THEN
    RELEASE OBJECT ch-Excel.

