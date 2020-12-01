{pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new("spdf-teste", "c:\temp\quadro-pdf.pdf").    
RUN pdf_set_PaperType("spdf-teste","A4").

RUN pdf_new_page2("spdf-teste","Portrait").    

RUN pdf_set_font("spdf-teste","Times-Roman",5.0).

def var i-linha as integer no-undo.

def var i-col as integer no-undo.

assign i-linha = 835.

do i-col = 1 to 700:

   if i-col mod 100 = 0 then
      RUN pdf_text_xy ("spdf-teste",i-col / 100, i-col, i-linha). // STREAM, CONTEUDO, COLUNA, LINHA
      
   if i-col mod 10 = 0 then
      RUN pdf_text_xy ("spdf-teste",(i-col mod 100)/ 10, i-col, i-linha - 6). // STREAM, CONTEUDO, COLUNA, LINHA

   if i-col mod 5 = 0 then do:
      RUN pdf_text_xy ("spdf-teste",i-col mod 10, i-col, i-linha - 10). // STREAM, CONTEUDO, COLUNA, LINHA
   end.
   
end.

do i-linha = 820 to 1 by -5:

    RUN pdf_text_xy ("spdf-teste",i-linha, 580, i-linha). // STREAM, CONTEUDO, COLUNA, LINHA
    
end.


RUN pdf_close("spdf-teste").
