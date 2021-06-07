FOR EACH familia-dbr EXCLUSIVE-LOCK:
    DISP familia-dbr.fm-codigo.

    PAUSE 0.

    ASSIGN familia-dbr.cod-malha-produtiv      = "TEC"
           familia-dbr.cod-pulmao              = "0"
           familia-dbr.cod-pulmao-proces       = "0"
           familia-dbr.num-max-dias-antecip    = 999
           familia-dbr.log-consid-consu        = YES
           familia-dbr.log-consid-planejto-nec = YES
           familia-dbr.log-mp-restrit          = YES
           familia-dbr.politica                = 1
           familia-dbr.qtd-pico-consumo        = 0
           familia-dbr.qtd-estoq-max           = 0.

    FOR EACH familia-estab-dbr OF familia-dbr EXCLUSIVE-LOCK:
        ASSIGN familia-estab-dbr.cod-malha-produtiv      = familia-dbr.cod-malha-produtiv
               familia-estab-dbr.cod-pulmao              = familia-dbr.cod-pulmao
               familia-estab-dbr.cod-pulmao-proces       = familia-dbr.cod-pulmao-proces
               familia-estab-dbr.num-max-dias-antecip    = familia-dbr.num-max-dias-antecip
               familia-estab-dbr.log-consid-consu        = familia-dbr.log-consid-consu
               familia-estab-dbr.log-consid-planejto-nec = familia-dbr.log-consid-planejto-nec
               familia-estab-dbr.log-mp-restrit          = familia-dbr.log-mp-restrit
               familia-estab-dbr.cdn-politic-item        = familia-dbr.politica
               familia-estab-dbr.qtd-pico-consumo        = familia-dbr.qtd-pico-consumo
               familia-estab-dbr.qtd-estoq-max           = familia-dbr.qtd-estoq-max.
    END.

    FOR EACH item-dbr OF familia-dbr EXCLUSIVE-LOCK:
        ASSIGN item-dbr.cod-malha-produtiv      = familia-dbr.cod-malha-produtiv
               item-dbr.cod-pulmao              = familia-dbr.cod-pulmao
               item-dbr.cod-pulmao-proces       = familia-dbr.cod-pulmao-proces
               item-dbr.num-max-dias-antecip    = familia-dbr.num-max-dias-antecip
               item-dbr.log-consid-consu        = familia-dbr.log-consid-consu
               item-dbr.log-consid-planejto-nec = familia-dbr.log-consid-planejto-nec
               item-dbr.log-mp-restrit          = familia-dbr.log-mp-restrit
               item-dbr.politica                = familia-dbr.politica
               item-dbr.qtd-pico-consumo        = familia-dbr.qtd-pico-consumo
               item-dbr.qtd-estoq-max           = familia-dbr.qtd-estoq-max.


        FOR EACH item-estab-dbr
            WHERE item-estab-dbr.it-codigo =item-dbr.it-codigo EXCLUSIVE-LOCK:
            ASSIGN item-estab-dbr.cod-malha-produtiv      = item-dbr.cod-malha-produtiv
                   item-estab-dbr.cod-pulmao              = item-dbr.cod-pulmao
                   item-estab-dbr.cod-pulmao-proces       = item-dbr.cod-pulmao-proces
                   item-estab-dbr.num-max-dias-antecip    = item-dbr.num-max-dias-antecip
                   item-estab-dbr.log-consid-consu        = item-dbr.log-consid-consu
                   item-estab-dbr.log-consid-planejto-nec = item-dbr.log-consid-planejto-nec
                   item-estab-dbr.log-mp-restrit          = item-dbr.log-mp-restrit
                   item-estab-dbr.politica                = item-dbr.politica
                   item-estab-dbr.qtd-pico-consumo        = item-dbr.qtd-pico-consumo
                   item-estab-dbr.qtd-estoq-max           = item-dbr.qtd-estoq-max.

        END.

    END.

END.
