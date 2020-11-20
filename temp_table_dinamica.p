DEF VAR tth     AS HANDLE NO-UNDO.
DEF VAR bh      AS HANDLE NO-UNDO.
DEF VAR qh      AS HANDLE NO-UNDO.
DEF VAR i-field AS INT    NO-UNDO.

DEF VAR i   AS INT    NO-UNDO.

CREATE TEMP-TABLE tth.

//ADD-NEW-FIELD ( field-name-exp , datatype-exp[ , extent-exp[ , format-exp   [ , initial-exp[ , label-exp[ , column-label-exp ]]]]] ) 
tth:ADD-NEW-FIELD("id", "integer", 0, "999").
tth:ADD-NEW-FIELD("desc", "character", 0, "x(20)").
tth:ADD-NEW-FIELD("data", "date", 0, "99/99/999").
tth:TEMP-TABLE-PREPARE("tt-din").


bh = tth:DEFAULT-BUFFER-HANDLE.

/* caso seja necessário base o tipo do campo */
//DISP bh:BUFFER-FIELD("id"):DATA-TYPE FORMAT "x(30)".
/* caso seja necessário fazer o formado do campo */
//DISP bh:BUFFER-FIELD("id"):FORMAT FORMAT "x(30)".


DO i = 1 TO 20:

    bh:BUFFER-CREATE.
    ASSIGN bh:BUFFER-FIELD("id"):BUFFER-VALUE() = i
           bh:BUFFER-FIELD("desc"):BUFFER-VALUE() = "Registro " + STRING(i)
           bh:BUFFER-FIELD("data"):BUFFER-VALUE() = TODAY + i.

END.

CREATE QUERY qh.
qh:SET-BUFFERS(bh).
qh:QUERY-PREPARE("FOR EACH tt-din").
qh:QUERY-OPEN().

OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "relatorio.txt").
REPEAT:
    qh:GET-NEXT().

    IF qh:QUERY-OFF-END THEN
        LEAVE.

    DO i-field = 1 TO bh:NUM-FIELDS:

        PUT UNFORMATTED
            bh:BUFFER-FIELD(i-field):NAME ": " bh:BUFFER-FIELD(i-field):BUFFER-VALUE() //caso queira imprimir pelo nome do campo substitua o i-field pelo campo
            SKIP.

    END.

    PUT UNFORMATTED
        SKIP(1).

END.
OUTPUT CLOSE.

qh:QUERY-CLOSE().
bh:BUFFER-RELEASE().
DELETE OBJECT tth.
DELETE OBJECT qh.

MESSAGE "Relatorio em: " SESSION:TEMP-DIRECTORY + "relatorio.txt"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
