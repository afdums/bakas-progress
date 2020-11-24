DEF VAR c-arquivo AS CHAR    NO-UNDO.
DEF VAR l-ok      AS LOGICAL NO-UNDO.

SYSTEM-DIALOG GET-FILE c-arquivo
       FILTERS "*.xls" "*.xls",
               "*.xlsx" "*.xlsx",
               "*.*" "*.*"
       DEFAULT-EXTENSION "xls"
       INITIAL-DIR "spool" 
       SAVE-AS
       USE-FILENAME
       UPDATE l-ok.

if  l-ok = yes then do:
    MESSAGE c-arquivo
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
end.
