{utp/utapi009.i}

{btb/btb009za.i}

run btb/btapi910za.p (INPUT "super",
                      INPUT "a420966",
                      OUTPUT TABLE tt-erros).

if can-find(first tt-erros) then do:
    FOR EACH tt-erros:
        MESSAGE "Erro: " SKIP
                 tt-erros.cod-erro SKIP
                tt-erros.desc-erro
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.
end.
else do:
    run C:\Totvs\kill\lean_kill.w.
end.

quit.
