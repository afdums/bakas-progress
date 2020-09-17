DEF TEMP-TABLE tt-prog_dtsul LIKE prog_dtsul.
DEF TEMP-TABLE tt-tab_dic_dtsul LIKE tab_dic_dtsul.

DEF VAR i-opcao AS INTEGER NO-UNDO.
DEF VAR c-dir   AS CHAR    NO-UNDO.

DISP "1 - Exportar"
     "2 - Eliminar"
     "3 - Importar"
    WITH 1 COL FRAME abc.

UPDATE i-opcao LABEL "Opcao"
       c-dir   LABEL "Diretorio" FORMAT "X(30)"
    WITH 1 COL FRAME abc SIDE-LABELS.

CASE i-opcao:
    WHEN 1 THEN DO:
        OUTPUT TO VALUE(c-dir + "\prog_dtsul.d").
        FOR EACH prog_dtsul
            WHERE prog_dtsul.nom_prog_upc <> "" 
               OR prog_dtsul.nom_prog_dpc <> "" NO-LOCK:
            EXPORT prog_dtsul.
        END.
        OUTPUT CLOSE.
        OUTPUT TO VALUE(c-dir + "\tab_dic_dtsul.d").
        FOR EACH tab_dic_dtsul
            WHERE tab_dic_dtsul.nom_prog_upc_gat_delete <> ""
               OR tab_dic_dtsul.nom_prog_upc_gat_write  <> ""
               OR tab_dic_dtsul.cod_livre_1             <> ""
               OR tab_dic_dtsul.cod_livre_2             <> "" NO-LOCK:
            EXPORT tab_dic_dtsul.
        END.
        OUTPUT CLOSE.
    END.
    WHEN 2 THEN DO:
        OUTPUT TO VALUE(c-dir + "\prog_dtsul.d").
        FOR EACH prog_dtsul
            WHERE prog_dtsul.nom_prog_upc <> ""
               OR prog_dtsul.nom_prog_dpc <> "" EXCLUSIVE-LOCK:
            EXPORT prog_dtsul.
            ASSIGN prog_dtsul.nom_prog_upc = ""
                   prog_dtsul.nom_prog_dpc = "".
        END.
        OUTPUT CLOSE.
        OUTPUT TO VALUE(c-dir + "\tab_dic_dtsul.d").
        FOR EACH tab_dic_dtsul
            WHERE tab_dic_dtsul.nom_prog_upc_gat_delete <> ""
               OR tab_dic_dtsul.nom_prog_upc_gat_write  <> ""
               OR tab_dic_dtsul.cod_livre_1             <> ""
               OR tab_dic_dtsul.cod_livre_2             <> "" EXCLUSIVE-LOCK:
            EXPORT tab_dic_dtsul.
            ASSIGN tab_dic_dtsul.nom_prog_upc_gat_delete = ""
                   tab_dic_dtsul.nom_prog_upc_gat_write  = ""
                   tab_dic_dtsul.cod_livre_1             = ""
                   tab_dic_dtsul.cod_livre_2             = "".
        END.
        OUTPUT CLOSE.
    END.
    WHEN 3 THEN DO:
        INPUT FROM VALUE(c-dir + "\prog_dtsul.d").
        REPEAT:
            CREATE tt-prog_dtsul.
            IMPORT tt-prog_dtsul.
        END.
        INPUT CLOSE.
        INPUT FROM VALUE(c-dir + "\tab_dic_dtsul.d").
        REPEAT:
            CREATE tt-tab_dic_dtsul.
            IMPORT tt-tab_dic_dtsul.
        END.
        INPUT CLOSE.
        FOR EACH tt-prog_dtsul:
            FIND FIRST prog_dtsul
                 WHERE prog_dtsul.cod_prog_dtsul = tt-prog_dtsul.cod_prog_dtsul EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL prog_dtsul THEN
                ASSIGN prog_dtsul.nom_prog_upc = tt-prog_dtsul.nom_prog_upc
                       prog_dtsul.nom_prog_dpc = tt-prog_dtsul.nom_prog_dpc.
        END.
        FOR EACH tt-tab_dic_dtsul:
            FIND FIRST tab_dic_dtsul
                 WHERE tab_dic_dtsul.cod_tab_dic_dtsul = tt-tab_dic_dtsul.cod_tab_dic_dtsul EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL tab_dic_dtsul THEN DO:
                ASSIGN tab_dic_dtsul.nom_prog_upc_gat_delete = tt-tab_dic_dtsul.nom_prog_upc_gat_delete
                       tab_dic_dtsul.nom_prog_upc_gat_write  = tt-tab_dic_dtsul.nom_prog_upc_gat_write
                       tab_dic_dtsul.cod_livre_1             = tt-tab_dic_dtsul.cod_livre_1
                       tab_dic_dtsul.cod_livre_2             = tt-tab_dic_dtsul.cod_livre_2.
            END.
        END.
    END.
END CASE.
