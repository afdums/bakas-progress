DEF TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita AS RAW.
   
DEF VAR raw-param AS RAW NO-UNDO.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino          AS   INTEGER
    FIELD arquivo          AS   CHARACTER FORMAT "x(35)":U
    FIELD usuario          AS   CHARACTER FORMAT "x(12)":U
    FIELD data-exec        AS   DATE
    FIELD hora-exec        AS   INTEGER 
    FIELD modelo           AS   CHARACTER FORMAT "x(35)":U
    FIELD i-numero-ordem   LIKE ordem-compra.numero-ordem
    FIELD atualiza         AS   LOGICAL.

{utp/ut-glob.i}

DEF VAR d-alocado-antes LIKE prazo-compra.dec-1.

OUTPUT TO U:\ems206\logs\SPCC035\aloca-oc-resumo.txt APPEND.
FOR EACH ordem-compra
    WHERE ordem-compra.situacao <> 4 // eliminada
      AND ordem-compra.situacao <> 6 // recebida
    NO-LOCK,
    EACH prazo-compra OF ordem-compra NO-LOCK:

    IF prazo-compra.dec-1 = 0 THEN
        NEXT.

    ASSIGN d-alocado-antes = prazo-compra.dec-1.

    EMPTY TEMP-TABLE tt-param.

    CREATE tt-param.
    ASSIGN tt-param.usuario         = c-seg-usuario
           tt-param.destino         = 3
           tt-param.arquivo         = "U:\ems206\logs\SPCC035\" + STRING(ordem-compra.numero-ordem) + "_" + REPLACE(STRING(TODAY),"/","-") + "_" + REPLACE(STRING(TIME,"HH:MM:SS"),":","-") + ".txt"
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.modelo          = ""
           tt-param.i-numero-ordem  = ordem-compra.numero-ordem
           tt-param.atualiza        = NO. // NO = Simula ou YES = Executa


    RAW-TRANSFER tt-param TO raw-param.
    
    RUN spp/ccp/spcc035rp.p(INPUT raw-param,
                            INPUT TABLE tt-raw-digita).

    DISP ordem-compra.numero-ordem
         ordem-compra.nr-contrato
         ordem-compra.data-emissao
         prazo-compra.parcela
         d-alocado-antes
         prazo-compra.dec-1
        WITH WIDTH 200.

    LEAVE.

END.
OUTPUT CLOSE.
