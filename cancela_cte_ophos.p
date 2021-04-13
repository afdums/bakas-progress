for each nota-fiscal
    where nota-fiscal.cod-estabel = "01"
      and nota-fiscal.serie = "3"
      and nota-fiscal.nr-nota-fis = "0005323" no-lock:
      
	assign nota-fiscal.idi-sit-nf-eletro = 6.
      
end.


/*&glob val1 NF-e no gerada
&glob val2 Em processamento
&glob val3 Uso autorizado
&glob val4 Uso denegado
&glob val5 Documento Rejeitado
&glob val6 Documento Cancelado
&glob val7 Documento Inutilizado
&glob val8 Em processamento no aplicativo de transmisso
&glob val9 Em processamento na SEFAZ
&glob val10 Em processamento no SCAN
&glob val11 NF-e Gerada
&glob val12 NF-e em Processo de Cancelamento
&glob val13 NF-e em Processo de Inutiliza?o
&glob val14 NF-e Pendente de Retorno
&glob val15 EPEC recebido pelo SCE*/
