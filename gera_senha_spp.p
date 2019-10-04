
DEF VAR p-nome-programa AS CHAR FORMAT "x(20)" NO-UNDO.

UPDATE p-nome-programa.

DEF VAR i AS INT NO-UNDO.
DEF VAR i-length AS INT NO-UNDO.
DEF VAR i-asc AS INT NO-UNDO.
DEF VAR i-asc-programa AS INT  NO-UNDO.
def var i-senha         as INT. 
def var i-teste         as INT. 
def var i-valida        as INT .
def var i-dia           as integer.
def var i-mes           as integer.
def var i-ano           as integer.

ASSIGN i-length = LENGTH(p-nome-programa).

REPEAT i = 1 TO i-length:
    ASSIGN i-asc = ASC(SUBSTRING(p-nome-programa,i,1))
           i-asc-programa = i-asc-programa + i-asc.
END.

assign i-dia = day(today)
       i-mes = month(today) 
       i-ano = year(today).
 
if i-dia <= 15 then
   i-dia = 1.
else 
   i-dia = 2. 

assign i-teste = (i-dia * 30) + (i-mes * 12) + (i-ano * 365) + i-asc-programa.

assign i-valida = i-teste / ((int(substring(string(i-teste),1,1))) * 6  +
                  (int(substring(string(i-teste),2,1))) * 5  +
                  (int(substring(string(i-teste),3,1))) * 4  +
                  (int(substring(string(i-teste),4,1))) * 3  +
                  (int(substring(string(i-teste),5,1))) * 2  +
                  (int(substring(string(i-teste),6,1))) * 1).

MESSAGE i-valida
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
