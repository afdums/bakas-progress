/* BAKA PARA FAZER A DEVOLU€ÇO DE NFT - saldo deve estar no local de entrada da NF */
/* ATEN€ÇO - EXECUTE APENAS 1 VEZ PARA CADA NOTA */
/* ATEN€ÇO - PRIMEIRO TENTE CANCELAR A NF SE AINDA DENTRO DO PRAZO DE 24 HORAS */

{utp/ut-glob.i}

DEF VAR c-cod-estabel LIKE nota-fiscal.cod-estabel NO-UNDO.
DEF VAR c-serie       LIKE nota-fiscal.serie       NO-UNDO.
DEF VAR c-nr-nota-fis LIKE nota-fiscal.nr-nota-fis NO-UNDO.

UPDATE c-cod-estabel
       c-serie
       c-nr-nota-fis
    WITH 1 COL SIDE-LABELS.

FIND FIRST nota-fiscal
     WHERE nota-fiscal.cod-estabel = c-cod-estabel
       AND nota-fiscal.serie       = c-serie
       AND nota-fiscal.nr-nota-fis = c-nr-nota-fis NO-LOCK NO-ERROR.
IF AVAIL nota-fiscal THEN DO:

    FIND FIRST estabelec
         WHERE estabelec.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN DO:
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
    
            FOR EACH fat-ser-lote OF it-nota-fisc NO-LOCK:
    
                CREATE esp-movto-nft.
                ASSIGN esp-movto-nft.cod-estabel-ent = nota-fiscal.cod-estabel
                       esp-movto-nft.cod-estabel-sai = estabelec.cod-estabel
                       esp-movto-nft.cod-depos-ent   = fat-ser-lote.cod-depos
                       esp-movto-nft.cod-depos-sai   = fat-ser-lote.cod-depos
                       esp-movto-nft.cod-localiz-ent = fat-ser-lote.cod-localiz
                       esp-movto-nft.cod-localiz-sai = fat-ser-lote.cod-localiz
                       esp-movto-nft.lote-ent        = fat-ser-lote.nr-serlote
                       esp-movto-nft.lote-sai        = fat-ser-lote.nr-serlote
                       esp-movto-nft.it-codigo       = it-nota-fisc.it-codigo
                       esp-movto-nft.quantidade      = fat-ser-lote.qt-baixada[1]
                       esp-movto-nft.origem          = "industrializacao"
                       esp-movto-nft.data            = TODAY
                       esp-movto-nft.data-hora-trans = NOW
                       esp-movto-nft.nr-nota-fis     = ""
                       esp-movto-nft.serie           = ""
                       esp-movto-nft.usuario         = c-seg-usuario
                       esp-movto-nft.cod-agrupador   = "Z-" + nota-fiscal.nr-nota-fis.
    
            END.
    
        END.

        MESSAGE "NFT criada, acompanhe a transferencia pelo ET3103"
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

    END.
    ELSE DO:
        MESSAGE "Apenas notas entre estabelecimentos podem ser devolvidas"
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.

    
END.
ELSE DO:
    MESSAGE "Nota Fiscal nao encontrada"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END.
