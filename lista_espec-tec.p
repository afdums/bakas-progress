OUTPUT TO c:\temp\espec-tec-103.txt.
EXPORT DELIMITER ";"
    "Nr Especificacao"
    "Cliente"
    "Nome Abrev"
    "Nome"
    "Item"
    "Situacao"
    "Descricao"
    "Norma Tubo"
    "Norma Aco"
    "Nova Norma Aco".

FOR EACH espec-tec NO-LOCK:

    FIND FIRST ITEM
         WHERE ITEM.it-codigo = espec-tec.it-codigo NO-LOCK NO-ERROR.

    IF NOT AVAIL ITEM OR ITEM.cod-estabel <> "103" THEN
        NEXT.

    FIND FIRST emitente
         WHERE emitente.cod-emitente = espec-tec.cod-emitente NO-LOCK NO-ERROR.
    

    EXPORT DELIMITER ";"
         espec-tec.nr-espec
         emitente.cod-emitente
         emitente.nome-abrev
         emitente.nome-emit
         espec-tec.it-codigo
         ENTRY(ITEM.cod-obsoleto,"Ativo,Obsoleto Ordens Automaticas,Obsoleto Ordens Manuais,Totalmente Obsoleto")
         ITEM.desc-item
         espec-tec.norma-tubo
         espec-tec.norma-aco.

END.
OUTPUT CLOSE.
