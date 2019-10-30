FOR EACH mdfe-docto
    WHERE mdfe-docto.cod-estab     = "01"
      AND mdfe-docto.cod-num-mdfe  = "000006563"
      AND mdfe-docto.cod-ser-mdfe  = "4"        exclusive-lock:
      
      disp mdfe-docto.idi-sit-mdfe.
      
end.      

/*
CASE mdfe-docto.idi-sit-mdfe:
                WHEN 1 THEN NEXT.                                                          /*MDF-e N’o Gerado                              */
                WHEN 2 THEN IF mdfe-param-monit-usuar.log-uso-autoriza    = NO THEN NEXT.  /*MDF-e Autorizado                              */
                WHEN 3 THEN IF mdfe-param-monit-usuar.log-docto-rejtdo    = NO THEN NEXT.  /*MDF-e Rejeitado                               */
                WHEN 4 THEN IF mdfe-param-monit-usuar.log-docto-cancdo    = NO THEN NEXT.  /*MDF-e Cancelado                               */
                WHEN 5 THEN IF mdfe-param-monit-usuar.log-docto-encert    = NO THEN NEXT.  /*MDF-e Encerrado                               */
                WHEN 6 THEN IF mdfe-param-monit-usuar.log-procmto-aplicat = NO THEN NEXT.  /*Em processamento no aplicativo de transmiss’o */
                WHEN 7 THEN IF mdfe-param-monit-usuar.log-nao-gerad       = NO THEN NEXT.  /*MDF-e Gerado                                  */
                WHEN 8 THEN IF mdfe-param-monit-usuar.log-proces-cancel   = NO THEN NEXT.  /*MDF-e em Processo de Cancelamento             */
                WHEN 9 THEN IF mdfe-param-monit-usuar.log-proces-encert   = NO THEN NEXT.  /*MDF-e em Processo de Encerramento             */
            END CASE.*/
