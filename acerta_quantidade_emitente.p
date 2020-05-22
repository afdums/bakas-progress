DEF TEMP-TABLE tt-bobina NO-UNDO
    FIELD lote LIKE saldo-estoq.lote.

/* a lista deve conter 1 coluna com os lotes das bobinas */
INPUT FROM C:\temp\teste-saldo-terc.txt.
REPEAT:
    CREATE tt-bobina.
    IMPORT tt-bobina.
END.
INPUT CLOSE.

OUTPUT TO c:\temp\saida.txt.
FOR EACH tt-bobina:
    IF tt-bobina.lote = "" THEN
        NEXT.

    FOR FIRST saldo-estoq
        WHERE saldo-estoq.lote = tt-bobina.lote NO-LOCK,
        FIRST movto-estoq OF saldo-estoq
        WHERE movto-estoq.esp-docto = 21 NO-LOCK:

    END.

    IF NOT AVAIL saldo-estoq THEN
        NEXT.

    DISP saldo-estoq.it-codigo
         tt-bobina.lote
        WITH WIDTH 200.


    FIND FIRST saldo-terc
         WHERE saldo-terc.it-codigo = saldo-estoq.it-codigo
           AND saldo-terc.lote      = tt-bobina.lote NO-LOCK NO-ERROR.

    FIND FIRST componente OF saldo-terc EXCLUSIVE-LOCK NO-ERROR.

    /* se a quantidade for maior que 1000 significa que foi lançada errada */
    IF AVAIL componente AND componente.qt-do-forn > 1000 THEN
        ASSIGN componente.qt-do-forn = componente.qt-do-forn / 1000.
    DISP componente.qt-do-forn
        WITH WIDTH 200.
    

END.
OUTPUT CLOSE.

