DEF VAR i-tempo AS INTEGER NO-UNDO.

DEF VAR i-cont-qt-faturada AS INTEGER NO-UNDO.
DEF VAR i-cont-qt-coletada AS INTEGER NO-UNDO.

DEF VAR c-cod-estabel     AS CHAR NO-UNDO.
DEF VAR c-serie           AS CHAR NO-UNDO.
DEF VAR c-nr-nota-fis-ini AS CHAR NO-UNDO.
DEF VAR c-nr-nota-fis-fim AS CHAR NO-UNDO.

ASSIGN c-cod-estabel     = "121"
       c-serie           = "1"
       c-nr-nota-fis-ini = "0095530"
       c-nr-nota-fis-fim = "0095530".

DEF BUFFER bf-nota-fiscal FOR nota-fiscal.

ASSIGN i-cont-qt-faturada = 0.

ASSIGN i-tempo = TIME.
FIND FIRST bf-nota-fiscal NO-LOCK
      WHERE bf-nota-fiscal.cod-estabel = c-cod-estabel
        AND bf-nota-fiscal.serie       = c-serie
        AND bf-nota-fiscal.nr-nota-fis = c-nr-nota-fis-ini NO-ERROR.

FOR EACH nota-fiscal NO-LOCK
    WHERE nota-fiscal.cod-estabel  = c-cod-estabel
      AND nota-fiscal.serie        = c-serie
      AND nota-fiscal.nr-nota-fis >= c-nr-nota-fis-ini
      AND nota-fiscal.nr-nota-fis <= c-nr-nota-fis-fim
      AND nota-fiscal.cod-emitente = bf-nota-fiscal.cod-emitente,
     EACH it-nota-fisc OF nota-fiscal NO-LOCK:

    ASSIGN i-cont-qt-faturada = i-cont-qt-faturada + it-nota-fisc.qt-faturada[1].

END.

SELECT COUNT(*) INTO i-cont-qt-coletada FROM conf-nf-etiq
    WHERE conf-nf-etiq.cod-estabel = c-cod-estabel
      AND conf-nf-etiq.serie       = c-serie
      AND conf-nf-etiq.nr-nota-fis = c-nr-nota-fis-ini.

DISP i-cont-qt-faturada
     i-cont-qt-coletada
     TIME - i-tempo.
