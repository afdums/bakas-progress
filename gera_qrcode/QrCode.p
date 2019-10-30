/*
****** Autor: Darckles Almeida
****** Data: 14/03/2016
****** Objetivo: Gerar QRCODE via Progress 4GL.
*/

USING ThoughtWorks.QRCode.Codec.*.
USING System.Drawing.*.

    DEF VAR i-ix            AS INT.
    DEF VAR c-local         AS CHAR.
    DEF VAR c-arquivo       AS CHAR. 
    DEF VAR c-texto         AS CHAR.
     
    DEFINE VARIABLE c-QrCode AS ThoughtWorks.QRCode.Codec.QRCodeEncoder NO-UNDO.
    DEFINE VARIABLE c-imagem  AS System.Drawing.Image  NO-UNDO.
    
    
        REPEAT i-ix = 1 TO (NUM-ENTRIES(FILE-INFO:FILE-NAME,'\') - 1):  
                ASSIGN c-local    =  c-local + '\' + ENTRY(i-ix, FILE-INFO:FILE-NAME,'\').
        END.
        MESSAGE c-local
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ASSIGN c-local = "\c:\temp".
            
        ASSIGN  c-local     = SUBSTRING(c-local,2,5000)
                c-arquivo   = "Qrcode.jpg"
                c-local     = c-local + "\" + c-arquivo
                c-texto     = "12345".
         MESSAGE 1
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
        c-QrCode = NEW QRCodeEncoder().
        MESSAGE 2
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
            c-QrCode:QRCodeVersion = 0.
            MESSAGE 3
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            c-imagem = c-QrCode:Encode(c-texto).
            MESSAGE 4
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            DELETE OBJECT c-QrCode.
            MESSAGE 5 SKIP c-local
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            c-imagem:Save(c-local,System.Drawing.Imaging.ImageFormat:jpeg).
            MESSAGE 6
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
                   MESSAGE c-local
                       VIEW-AS ALERT-BOX INFO BUTTONS OK.
      //  OS-COMMAND VALUE(c-local).



