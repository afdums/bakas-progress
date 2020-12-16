PROCEDURE WinExec EXTERNAL "kernel32.dll":U:
    DEF INPUT  PARAM prg_name                          AS CHARACTER.
    DEF INPUT  PARAM prg_style                         AS SHORT.
END PROCEDURE.


DEF VAR c-arquivo AS CHAR NO-UNDO.

ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "arquivo-teste.txt".

OUTPUT TO VALUE(c-arquivo).
PUT UNFORMATTED
    "Teste de gravacao e abertura de arquivo".
OUTPUT CLOSE.

RUN winexec (INPUT "notepad.exe " + c-arquivo, INPUT 1).
