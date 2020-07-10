def var c-nome-abrev like ped-venda.nome-abrev no-undo.
def var c-nr-pedcli  like ped-venda.nr-pedcli  no-undo.

def buffer b-ped-venda for ped-venda.

assign c-nome-abrev = "ana paula ap"
       c-nr-pedcli  = "646005".

def var h-bodi159cal as handle no-undo.

run dibo/bodi159cal.p persistent set h-bodi159cal.



/*find first ped-venda
     where ped-venda.nome-abrev = c-nome-abrev
       and ped-venda.nr-pedcli  = c-nr-pedcli  no-lock no-error.*/
       
output to c:\temp\teste-ped-venda-8080.txt.   
for each ped-venda
    where ped-venda.dt-implant >= today - 90
      and ped-venda.cod-sit-ped <= 2 no-lock:
     
    disp ped-venda.nome-abrev
         ped-venda.nr-pedcli
         ped-venda.cod-cond-pag
         ped-venda.dt-implant
         ped-venda.vl-liq-abe
         ped-venda.vl-liq-ped
         ped-venda.vl-tot-ped
         with width 300.             
       
    /*
    find first ped-item of ped-venda
          where ped-item.it-codigo = "10.01.31230" no-lock no-error.
    if not avail ped-item then
          next.*/
    
    run calculateOrder in h-bodi159cal(input rowid(ped-venda)).
    
    find first b-ped-venda
         where b-ped-venda.nome-abrev = ped-venda.nome-abrev
           and b-ped-venda.nr-pedcli  = ped-venda.nr-pedcli  no-lock no-error.
           
    disp b-ped-venda.vl-liq-abe
         b-ped-venda.vl-liq-ped
         b-ped-venda.vl-tot-ped
         with width 300.
         
end.         
output close.
