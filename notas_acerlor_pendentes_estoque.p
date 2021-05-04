FOR EACH nota-fiscal
    WHERE nota-fiscal.cod-emitente = 62900
      AND nota-fiscal.dt-emis-nota >= TODAY - 45
      AND nota-fiscal.ind-sit-nota >= 0 /*para completar indice*/ NO-LOCK:

    IF nota-fiscal.cod-estabel <> "101" THEN
        NEXT.

    IF nota-fiscal.serie <> "1" THEN
        NEXT.

    IF nota-fiscal.dt-cancela <> ? THEN
        NEXT.

    IF nota-fiscal.dt-confirma <> ? THEN
        NEXT.

    FIND FIRST esp-item-devol-consign
         WHERE esp-item-devol-consign.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.

    IF NOT AVAIL esp-item-devol-consign THEN
        NEXT.

    DISP nota-fiscal.nr-nota-fis
         nota-fiscal.dt-emis-nota
         nota-fiscal.dt-confirma
         nota-fiscal.dt-cancela
         esp-item-devol-consign.num-bobina
        WITH WIDTH 200.

END.
