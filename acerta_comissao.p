DEFINE VARIABLE i-comissao AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-acomp    AS HANDLE      NO-UNDO.

UPDATE i-comissao LABEL "Comissao"
    WITH 1 COL SIDE-LABELS.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp(INPUT "Ajustando percentual").

FIND FIRST para-ped EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL para-ped THEN
    ASSIGN para-ped.perc-max-com = i-comissao.

FOR EACH param_estab_comis EXCLUSIVE-LOCK:
    ASSIGN param_estab_comis.val_perc_max_comis = i-comissao.
END.

FOR EACH repres_financ EXCLUSIVE-LOCK:
    ASSIGN repres_financ.val_perc_comis_max = i-comissao.
END.

RUN pi-finalizar IN h-acomp.
