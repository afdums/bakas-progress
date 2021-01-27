DEF VAR d-horas-acumuladas AS DECIMAL FORMAT "->>>>9.999" NO-UNDO.

DEF VAR c-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.
DEF VAR c-gm-codigo   LIKE operacao.gm-codigo    NO-UNDO.

UPDATE c-cod-estabel
       c-gm-codigo
    WITH 1 COL SIDE-LABELS.
    
ASSIGN d-horas-acumuladas = 0.
FOR LAST mgesp.cm-param
    WHERE cm-param.cod-estabel = c-cod-estabel
      AND cm-param.ativo   = YES NO-LOCK:

    FOR EACH  cm-carga-dia 
        WHERE cm-carga-dia.nr-programa =  cm-param.nr-programa
          AND cm-carga-dia.gm-codigo   =  c-gm-codigo NO-LOCK
        BREAK BY cm-carga-dia.dt-producao:

        IF d-horas-acumuladas > 0 THEN //se a semana anterior ‚ positiva nÆo ‚ cumulativa
            ASSIGN d-horas-acumuladas = cm-carga-dia.carga-dia-disp.
        ELSE
            ASSIGN d-horas-acumuladas = d-horas-acumuladas + cm-carga-dia.carga-dia-disp.

        DISP cm-carga-dia.dt-producao
             cm-carga-dia.carga-dia-disp FORMAT "->>>9.999"
             d-horas-acumuladas.

    END.


END.
