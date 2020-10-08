CURRENT-LANGUAGE = CURRENT-LANGUAGE.
DO TRANS:
    RUN cpp/cp0301.w.
    
    //quando o programa for fechado ‚ desfeito tudo que aconteceu dentro da transa‡Æo
    UNDO,LEAVE.

END.
