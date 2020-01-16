&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-livre 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i XX9999 9.99.99.999}

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i <programa> <m¢dulo>}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


CREATE WIDGET-POOL. 

DEFINE VARIABLE I                   AS INT.
DEFINE VARIABLE X                   AS LOG.
DEFINE VARIABLE J              AS INT NO-UNDO.
DEF VAR h-acomp AS HANDLE NO-UNDO.
DEF VAR c-diretorio AS CHAR NO-UNDO.
DEFINE VARIABLE linha as char format "x(290)".
DEFINE VARIABLE arquivo AS CHARACTER no-undo FORMAT 'x(30)'.
DEF VAR cont AS INTEGER NO-UNDO.

DEF TEMP-TABLE tt-dirarqui NO-UNDO 
FIELD dirarqui AS CHAR FORMAT "X(80)". 

DEF TEMP-TABLE tt-programa NO-UNDO 
FIELD programa AS char FORMAT "X(30)". 

DEF TEMP-TABLE tt-diretorio NO-UNDO 
FIELD diretorio AS char FORMAT "X(100)". 

DEF TEMP-TABLE tt-resultado NO-UNDO 
FIELD programa AS char FORMAT "X(30)" 
FIELD contem AS char FORMAT "X(100)"
FIELD num-linha AS INT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-livre
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-button RECT-2 gerar RADIO-SET ~
fill-programa BUTTON-1 BUTTON-2 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET fill-programa dir-raiz dir-temp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-livre AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-programa 
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-livre MENUBAR
       SUB-MENU  mi-programa    LABEL "&Nome-do-Programa"
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-1 
     LABEL "Buscar" 
     SIZE 7.86 BY 1.42.

DEFINE BUTTON BUTTON-2 
     LABEL "Buscar" 
     SIZE 7.86 BY 1.42.

DEFINE BUTTON gerar 
     LABEL "Gerar" 
     SIZE 11.43 BY 1.29 TOOLTIP "Gerar arquivo de Dependˆncias".

DEFINE VARIABLE dir-raiz AS CHARACTER FORMAT "X(256)":U 
     LABEL "Diret¢rio Raiz" 
     VIEW-AS FILL-IN 
     SIZE 64.57 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE dir-temp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Diret¢rio Temp" 
     VIEW-AS FILL-IN 
     SIZE 64.57 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE fill-programa AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cod Programa" 
     VIEW-AS FILL-IN 
     SIZE 29.43 BY 1 NO-UNDO.

DEFINE VARIABLE RADIO-SET AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Programa", 1,
"Diret¢rio", 2
     SIZE 26.29 BY 1.17 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 7.58.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.72 BY 1.75
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     gerar AT ROW 1.17 COL 41.57 WIDGET-ID 16
     RADIO-SET AT ROW 3.08 COL 35.86 NO-LABEL WIDGET-ID 18
     fill-programa AT ROW 4.88 COL 14.14 COLON-ALIGNED WIDGET-ID 22
     BUTTON-1 AT ROW 6.42 COL 81.14 WIDGET-ID 8
     dir-raiz AT ROW 6.63 COL 14.29 COLON-ALIGNED WIDGET-ID 4
     BUTTON-2 AT ROW 8.38 COL 81.14 WIDGET-ID 10
     dir-temp AT ROW 8.58 COL 14.29 COLON-ALIGNED WIDGET-ID 12
     rt-button AT ROW 1 COL 1
     RECT-2 AT ROW 2.75 COL 1.57 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.46 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-livre
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-livre ASSIGN
         HIDDEN             = YES
         TITLE              = "Template Livre <Insira complemento>"
         HEIGHT             = 9.46
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-livre:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-livre 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-livre.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-livre
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN dir-raiz IN FRAME f-cad
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dir-temp IN FRAME f-cad
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
THEN w-livre:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-livre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON END-ERROR OF w-livre /* Template Livre <Insira complemento> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-livre w-livre
ON WINDOW-CLOSE OF w-livre /* Template Livre <Insira complemento> */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 w-livre
ON CHOOSE OF BUTTON-1 IN FRAME f-cad /* Buscar */
DO:
  DEFINE VARIABLE cPath1 AS CHAR.

  ASSIGN dir-raiz:SCREEN-VALUE = "".

/*   SYSTEM-DIALOG GET-FILE cPath TITLE "Escolha um" FILTERS "Arquivo Tipo (*.*)" "*.TXT" */
/*                 USE-FILENAME UPDATE OKpressed.                                         */

  SYSTEM-DIALOG GET-DIR cPath1 TITLE "" .


  dir-raiz = "".
  I = NUM-ENTRIES(cPath1,"\").
  DO J = 1 TO I:
     Assign dir-raiz = dir-raiz + ENTRY(J,cPath1,"\") + "\" No-error.
  END.
  
  IF I = 0 THEN dir-raiz = "C:".
  DISPLAY dir-raiz WITH FRAME {&FRAME-NAME}.

  STATUS INPUT "Aguarde... Selecionando diret¢rio".
/*   RUN PegaArquivos No-error. */
  STATUS INPUT "Fim de sele‡Æo". 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 w-livre
ON CHOOSE OF BUTTON-2 IN FRAME f-cad /* Buscar */
DO:
  DEFINE VARIABLE cPath2 AS CHAR.

  ASSIGN dir-temp:SCREEN-VALUE = "".
  
/*   SYSTEM-DIALOG GET-FILE cPath TITLE "Escolha um" FILTERS "Arquivo Tipo (*.*)" "*.TXT" */
/*                 USE-FILENAME UPDATE OKpressed.                                         */

  SYSTEM-DIALOG GET-DIR cPath2 TITLE "" .


  dir-temp = "".
  I = NUM-ENTRIES(cPath2,"\").
  DO J = 1 TO I:
     Assign dir-temp = dir-temp + ENTRY(J,cPath2,"\") + "\" No-error.
  END.
  
  IF I = 0 THEN dir-temp = "C:".
  DISPLAY dir-temp WITH FRAME {&FRAME-NAME}.

  STATUS INPUT "Aguarde... Selecionando diret¢rio".
/*   RUN PegaArquivos No-error. */
  STATUS INPUT "Fim de sele‡Æo". 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gerar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gerar w-livre
ON CHOOSE OF gerar IN FRAME f-cad /* Gerar */
DO:

 IF INT (RADIO-SET:SCREEN-VALUE IN FRAME {&FRAME-NAME} )  = 1 THEN DO:

     IF (fill-programa:SCREEN-VALUE = "")THEN DO:

               run esp/message.p (input "Informe um programa v lido!",
                                  input "").
               RETURN.
         END.
         ELSE DO:

             RUN pi-executar.

         END.

    END.

    IF INT (RADIO-SET:SCREEN-VALUE IN FRAME {&FRAME-NAME} )  = 2 THEN DO:

         IF (dir-raiz:SCREEN-VALUE = "" OR dir-temp:SCREEN-VALUE = "")THEN DO:

               run esp/message.p (input "Selecione um diret¢rio v lido!",
                                  input "Diret¢rio raiz e tempor rio devem ser informados!").
               RETURN.
         END.
         ELSE DO:

             RUN pi-executar.

         END.

    END.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-livre
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-livre
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-livre
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-programa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-programa w-livre
ON MENU-DROP OF MENU mi-programa /* Nome-do-Programa */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-livre
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-livre
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET w-livre
ON VALUE-CHANGED OF RADIO-SET IN FRAME f-cad
DO:

 IF INT (RADIO-SET:SCREEN-VALUE IN FRAME {&FRAME-NAME} )  = 1 THEN DO:

     fill-programa:SENSITIVE = TRUE.

     ASSIGN dir-raiz:SCREEN-VALUE = "".
     ASSIGN dir-temp:SCREEN-VALUE = "".

    END.
    ELSE DO:

     ASSIGN fill-programa:SCREEN-VALUE = "".
     fill-programa:SENSITIVE = FALSE.




    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-livre 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-livre  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 2,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.17 , 74.14 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             gerar:HANDLE IN FRAME f-cad , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-livre  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-livre  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-livre)
  THEN DELETE WIDGET w-livre.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-livre  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY RADIO-SET fill-programa dir-raiz dir-temp 
      WITH FRAME f-cad IN WINDOW w-livre.
  ENABLE rt-button RECT-2 gerar RADIO-SET fill-programa BUTTON-1 BUTTON-2 
      WITH FRAME f-cad IN WINDOW w-livre.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-livre.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-livre 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-livre 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-livre 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run pi-before-initialize.

  {include/win-size.i}

  {utp/ut9000.i "XX9999" "9.99.99.999"}

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

     fill-programa:SENSITIVE = TRUE.

  /* Code placed here will execute AFTER standard behavior.    */

  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar w-livre 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF VAR arqpath AS CHAR NO-UNDO.
DEF VAR diretorio AS CHAR NO-UNDO.
DEF VAR exporta AS CHAR NO-UNDO.

ASSIGN c-diretorio = dir-raiz:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
ASSIGN arqpath = dir-temp:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "arqpath.txt".
ASSIGN diretorio = dir-temp:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "diretorio.txt".
ASSIGN exporta = dir-temp:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "export-relacao-programas.csv".

/* RUN utp/ut-acomp.p PERSISTENT SET h-acomp.                */
/*                                                           */
/* RUN pi-inicializar IN h-acomp(INPUT "Lendo Diretorios").  */
/* RUN pi-acompanhar IN h-acomp(INPUT "Varrendo diretorio"). */

STATUS INPUT 'Varrendo diretorio ...'.


IF INT (RADIO-SET:SCREEN-VALUE IN FRAME {&FRAME-NAME} )  = 1 THEN DO:


    /*Consulta arquivos com sua path*/                                                                                                                                      
 DOS SILENT DIR /s /b /a:a-h VALUE(c-diretorio) > VALUE(arqpath). /*copia arquivos e subdiretorio para o arquivo c:\temp\arqpath.txt*/ 
 INPUT FROM VALUE(arqpath) NO-ECHO.                                                                                                  
 REPEAT:
     CREATE tt-dirarqui. /*copia os programas do arquivo para a temp-table*/                                                          
     IMPORT UNFORMATTED tt-dirarqui.                                                                                                  
 END.                                                                                                                                 
 INPUT CLOSE.      


 /*Lista apenas os diret½rios*/                                                                                                    
 DOS SILENT dir /s /b /a:d VALUE(c-diretorio) > VALUE(diretorio). /*copia arquivos e subdiretorio para o arquivo c:\temp\diretorio.txt*/
 INPUT FROM VALUE(diretorio) NO-ECHO.                                                                                               
 REPEAT:                                                                                                                           
     CREATE tt-diretorio. /*copia os programas do arquivo para a temp-table*/                                                       
     IMPORT UNFORMATTED tt-diretorio.                                                                                               
                                                                                                                                   
 END.                                                                                                                              
 INPUT CLOSE.


 /*Capturar todos os programas e jogar em uma temp-table*/    
/*  for each tt-diretorio:                                                                                                  */
/*                                                                                                                          */
/*         /*Consulta arquivos do diret½rio*/                                                                               */
/*         INPUT FROM OS-DIR(diretorio) NO-ATTR-LIST.                                                                       */
/*         REPEAT :                                                                                                         */
/*         IMPORT arquivo.                                                                                                  */
/*         IF (arquivo BEGINS '.' or INDEX(arquivo,".p") = 0  and INDEX(arquivo,".w") = 0 and INDEX(arquivo,".i") = 0) THEN */
/*         NEXT.                                                                                                            */
IF NOT AVAIL tt-programa THEN DO:
            create tt-programa.
            assign tt-programa.programa = fill-programa:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

END.
/*         END. */
/*              */
/*  end.        */


for each tt-programa:

    for each tt-dirarqui:
        ASSIGN cont = 1.

        IF (tt-dirarqui.dirarqui BEGINS '.' or INDEX(tt-dirarqui.dirarqui,".p") = 0  and INDEX(tt-dirarqui.dirarqui,".w") = 0 and INDEX(tt-dirarqui.dirarqui,".i") = 0) THEN
        NEXT.           
            INPUT FROM value(tt-dirarqui.dirarqui).
            REPEAT
            while true:
            import unformatted linha.
            ASSIGN cont = cont + 1.

/*             DISP linha WITH 1 COL WIDTH 550. */
            PROCESS EVENTS.
    
                if index(replace(linha, "*", ""), programa) <> 0 then do:
    
                   create tt-resultado.
                   assign tt-resultado.num-linha = cont - 1
                          tt-resultado.programa = tt-programa.programa
                          tt-resultado.contem = tt-dirarqui.dirarqui.


            end.

        End.
                 
    end.
end.

output to VALUE(exporta).


for each tt-resultado:

    put tt-resultado.num-linha ";"
        tt-resultado.programa ";"
        tt-resultado.contem skip.

end.

STATUS INPUT 'Fim!'.

MESSAGE "Geradono diret¢rio temp!"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* RUN pi-finalizar IN h-acomp. */


OUTPUT CLOSE.     

END.







IF INT (RADIO-SET:SCREEN-VALUE IN FRAME {&FRAME-NAME} )  = 2 THEN DO:

/*Consulta arquivos com sua path*/                                                                                                                                      
 DOS SILENT DIR /s /b /a:a-h VALUE(c-diretorio) > VALUE(arqpath). /*copia arquivos e subdiretorio para o arquivo c:\temp\arqpath.txt*/ 
 INPUT FROM VALUE(arqpath) NO-ECHO.                                                                                                  
 REPEAT:
     CREATE tt-dirarqui. /*copia os programas do arquivo para a temp-table*/                                                          
     IMPORT UNFORMATTED tt-dirarqui.                                                                                                  
 END.                                                                                                                                 
 INPUT CLOSE.      


 /*Lista apenas os diret½rios*/                                                                                                    
 DOS SILENT dir /s /b /a:d VALUE(c-diretorio) > VALUE(diretorio). /*copia arquivos e subdiretorio para o arquivo c:\temp\diretorio.txt*/
 INPUT FROM VALUE(diretorio) NO-ECHO.                                                                                               
 REPEAT:                                                                                                                           
     CREATE tt-diretorio. /*copia os programas do arquivo para a temp-table*/                                                       
     IMPORT UNFORMATTED tt-diretorio.                                                                                               
                                                                                                                                   
 END.                                                                                                                              
 INPUT CLOSE.


 /*Capturar todos os programas e jogar em uma temp-table*/    
 for each tt-diretorio:

        /*Consulta arquivos do diret½rio*/
        INPUT FROM OS-DIR(tt-diretorio.diretorio) NO-ATTR-LIST.        
        REPEAT :       
        IMPORT arquivo.       
        IF (arquivo BEGINS '.' or INDEX(arquivo,".p") = 0  and INDEX(arquivo,".w") = 0 and INDEX(arquivo,".i") = 0) THEN
        NEXT.                                      

            create tt-programa.
            assign tt-programa.programa = arquivo.
        END.

 end.


for each tt-programa:

    for each tt-dirarqui:
        ASSIGN cont = 1.

        IF (tt-dirarqui.dirarqui BEGINS '.' or INDEX(tt-dirarqui.dirarqui,".p") = 0  and INDEX(tt-dirarqui.dirarqui,".w") = 0 and INDEX(tt-dirarqui.dirarqui,".i") = 0) THEN
        NEXT.           
            INPUT FROM value(tt-dirarqui.dirarqui).
            REPEAT
            while true:
            import unformatted linha.
            ASSIGN cont = cont + 1.

/*             DISP linha WITH 1 COL WIDTH 550. */
            PROCESS EVENTS.
    
                if index(replace(linha, "*", ""), tt-programa.programa) <> 0 then do:
    
                   create tt-resultado.
                   assign tt-resultado.num-linha = cont - 1
                          tt-resultado.programa = tt-programa.programa
                          tt-resultado.contem = tt-dirarqui.dirarqui.


            end.

        End.
                 
    end.
end.

output to VALUE(exporta).


for each tt-resultado:

    put tt-resultado.num-linha ";"
        tt-resultado.programa ";"
        tt-resultado.contem skip.

end.

MESSAGE "Geradono diret¢rio temp!"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* RUN pi-finalizar IN h-acomp. */
STATUS INPUT 'Fim!'.

OUTPUT CLOSE. 

END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-livre  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-livre, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-livre 
PROCEDURE state-changed :
/*:T -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

