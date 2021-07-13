CURRENT-LANGUAGE = CURRENT-LANGUAGE.

DEF VAR c-arquivo AS CHAR NO-UNDO.

RUN etp/et2443-csv.p(INPUT "101",
                     OUTPUT c-arquivo).

MESSAGE "Arguivo gerado: " + c-arquivo
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
