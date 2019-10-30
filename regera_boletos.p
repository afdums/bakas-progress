def var c-cod-estabel as char no-undo.
def var c-serie       as char no-undo.
def var c-nr-nota-fis as char no-undo.

assign c-cod-estabel = "04" /*estabelecimento da nota*/
       c-serie       = "2" /*serie da nota fiscal*/
       c-nr-nota-fis = "0066001" /*numero da nota fiscal*/
       .

for each fat-duplic
    where fat-duplic.cod-estabel = c-cod-estabel
       and fat-duplic.serie      = c-serie
       and fat-duplic.nr-fatura  = c-nr-nota-fis exclusive-lock:
       
    assign fat-duplic.char-1 = "".
end.  
