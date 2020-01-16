DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.
    
def var h-bodi135ems5 as handle no-undo.    


DEF TEMP-TABLE RowErrorsAux NO-UNDO LIKE RowErrors.

output to c:\temp\erros-5.txt.
for each nota-fiscal
    where nota-fiscal.cod-estabel = "01"
      and nota-fiscal.serie = "3"
      and nota-fiscal.nr-nota-fis = "0005058" exclusive-lock:
      
      update nota-fiscal.dt-cancela.
      
      /*if nota-fiscal.dt-cancela <> ? then*/
        disp nota-fiscal.cod-estabel
             nota-fiscal.nr-nota-fis
             nota-fiscal.dt-emis-nota.
      
      
      /*message nota-fiscal.idi-sit-nf-eletro view-as alert-box.
      assign nota-fiscal.idi-sit-nf-eletro = 0.*/
      
      
      run dibo/bodi135ems5.p persistent set h-bodi135ems5.
    
                RUN integraEms5 in h-bodi135ems5 (input rowid(nota-fiscal),
                                                  input yes,
                                                  OUTPUT TABLE RowErrorsAux). /* integracao ems5.00 */
                                                  
                                                  
    for each rowerrorsAux:
        export rowerrorsAux.
    end.                                                  
                                                  
end.     
output close. 


/*&glob val1 NF-e nÆo gerada
&glob val2 Em processamento
&glob val3 Uso autorizado
&glob val4 Uso denegado
&glob val5 Documento Rejeitado
&glob val6 Documento Cancelado
&glob val7 Documento Inutilizado
&glob val8 Em processamento no aplicativo de transmissÆo
&glob val9 Em processamento na SEFAZ
&glob val10 Em processamento no SCAN
&glob val11 NF-e Gerada
&glob val12 NF-e em Processo de Cancelamento
&glob val13 NF-e em Processo de Inutiliza‡Æo
&glob val14 NF-e Pendente de Retorno
&glob val15 EPEC recebido pelo SCE*/