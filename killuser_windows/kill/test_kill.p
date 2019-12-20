DEF TEMP-TABLE tt-usuario NO-UNDO
    FIELD selecionado AS LOGICAL
    FIELD usuario     AS CHAR FORMAT "x(20)"
    FIELD base        AS CHAR FORMAT "x(20)"
    FIELD id          AS INTEGER
    FIELD computador  AS CHAR FORMAT "x(20)"
    FIELD conexao     AS DATETIME.
current-language = current-language.
    
    def var h-aux as handle no-undo.
    
    run killapi.p persistent set h-aux.
    
run pi-retorna-usuarios   in h-aux (input "todas",
input 1,
input "super",
output table tt-usuario).

for each tt-usuario
where id = 105:
disp tt-usuario.
assign tt-usuario.selecionado = yes.
end.

def var c-erro as char no-undo.
run pi-desconecta-usuarios in h-aux(input table tt-usuario,
output  c-erro).

Message c-erro view-as alert-box.
