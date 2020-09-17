&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Israel Alves de Freitas

  Created: NOV/2010

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


DEF VAR i     AS INTEGER.
DEF VAR stat  AS LOGICAL.

DEF NEW SHARED VAR lname   AS CHAR.
DEF NEW SHARED VAR c-campo AS CHAR.
DEF NEW SHARED VAR l-ok    AS LOGICAL.
DEF NEW SHARED VAR i-modo-busca AS INTEGER.

DEF NEW SHARED TEMP-TABLE tt-result
    FIELD tt-banco           AS CHAR
    FIELD tt-tabela          AS CHAR
    FIELD tt-nom-campo       AS CHAR
    FIELD tt-tipo            AS CHAR
    FIELD tt-formato         AS CHAR
    FIELD tt-decimais        AS INT
    FIELD tt-extent          AS INT.

Def Var Arquivo As Char No-undo.

Def Stream Saida.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME br-result

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-result

/* Definitions for BROWSE br-result                                     */
&Scoped-define FIELDS-IN-QUERY-br-result tt-result.tt-banco tt-result.tt-tabela tt-result.tt-nom-campo tt-result.tt-tipo tt-result.tt-formato tt-result.tt-decimais tt-result.tt-extent   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-result   
&Scoped-define SELF-NAME br-result
&Scoped-define OPEN-QUERY-br-result IF tg-ordem:CHECKED THEN    OPEN QUERY {&SELF-NAME} FOR EACH tt-result BY tt-tabela. ELSE    OPEN QUERY {&SELF-NAME} FOR EACH tt-result BY tt-banco.
&Scoped-define TABLES-IN-QUERY-br-result tt-result
&Scoped-define FIRST-TABLE-IN-QUERY-br-result tt-result


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-br-result}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btLista bt-fecha fi-campo bt-busca sl-bancos ~
tg-ordem rs-modo-busca br-result 
&Scoped-Define DISPLAYED-OBJECTS fi-campo sl-bancos tg-ordem rs-modo-busca 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-busca 
     LABEL "Busca" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-fecha DEFAULT 
     LABEL "&Fecha" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON btLista 
     LABEL "Lista" 
     SIZE 10 BY 1 TOOLTIP "Gera Lista de Tabelas encontradas".

DEFINE VARIABLE fi-campo AS CHARACTER FORMAT "X(256)":U 
     LABEL "Campo" 
     VIEW-AS FILL-IN 
     SIZE 26 BY 1 NO-UNDO.

DEFINE VARIABLE rs-modo-busca AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Total", 1,
"In¡cio", 2,
"Qualquer parte", 3
     SIZE 48 BY .81 NO-UNDO.

DEFINE VARIABLE sl-bancos AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT SCROLLBAR-VERTICAL 
     SIZE 20 BY 13.52 NO-UNDO.

DEFINE VARIABLE tg-ordem AS LOGICAL INITIAL no 
     LABEL "Ordenar por tabela" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-result FOR 
      tt-result SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-result
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-result C-Win _FREEFORM
  QUERY br-result DISPLAY
      tt-result.tt-banco     FORMAT "x(15)" LABEL "BANCO"
        tt-result.tt-tabela    FORMAT "x(25)" LABEL "TABELA"
        tt-result.tt-nom-campo FORMAT "x(20)" LABEL "CAMPO"   
        tt-result.tt-tipo      FORMAT "x(9)"  LABEL "TIPO"
        tt-result.tt-formato   FORMAT "x(20)" LABEL "FORMATO"
        tt-result.tt-decimais  FORMAT ">>>9"  LABEL "DECS"
        tt-result.tt-extent    FORMAT ">>>9"  LABEL "EXTENT"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 74 BY 11.76 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btLista AT ROW 1.48 COL 75 WIDGET-ID 2
     bt-fecha AT ROW 1.48 COL 88
     fi-campo AT ROW 1.52 COL 31 COLON-ALIGNED
     bt-busca AT ROW 1.52 COL 62
     sl-bancos AT ROW 2 COL 2 NO-LABEL
     tg-ordem AT ROW 2.76 COL 23
     rs-modo-busca AT ROW 2.76 COL 48 NO-LABEL
     br-result AT ROW 3.76 COL 23
     "Bancos conectados" VIEW-AS TEXT
          SIZE 19 BY .67 AT ROW 1.24 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 97.86 BY 15.29
         DEFAULT-BUTTON bt-fecha.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Busca campo em todos os BD's conectados - v1 - NOV/2010"
         HEIGHT             = 15.29
         WIDTH              = 97.8
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 97.8
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 97.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB br-result rs-modo-busca DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-result
/* Query rebuild information for BROWSE br-result
     _START_FREEFORM
IF tg-ordem:CHECKED THEN
   OPEN QUERY {&SELF-NAME} FOR EACH tt-result BY tt-tabela.
ELSE
   OPEN QUERY {&SELF-NAME} FOR EACH tt-result BY tt-banco.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE br-result */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Busca campo em todos os BD's conectados - v1 - NOV/2010 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Busca campo em todos os BD's conectados - v1 - NOV/2010 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-busca
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-busca C-Win
ON CHOOSE OF bt-busca IN FRAME DEFAULT-FRAME /* Busca */
DO:
    IF INPUT FRAME {&FRAME-NAME} fi-campo = '' THEN DO:
        MESSAGE "Nada para se fazer. Especifique um nome de campo." VIEW-AS ALERT-BOX WARNING.
        APPLY "ENTRY" TO fi-campo.
        RETURN NO-APPLY.
    END.
    FOR EACH tt-result:
        DELETE tt-result.
    END.
    SESSION:SET-WAIT-STATE("general").
    CLOSE QUERY  br-result.
    ASSIGN l-ok = FALSE
           c-campo = INPUT FRAME {&FRAME-NAME} fi-campo
           i-modo-busca = INPUT rs-modo-busca.
           
    DO i = 1 TO NUM-DBS:
       lname = LDBNAME (i).
       DELETE ALIAS "DICTDB".
       CREATE ALIAS "DICTDB" FOR DATABASE  VALUE (lname).
       RUN "BuscaCampoDB.p".
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}
    SESSION:SET-WAIT-STATE("").
    IF NOT l-ok THEN 
       MESSAGE "NÆo foi encontrado o campo " INPUT FRAME {&FRAME-NAME} fi-campo SKIP
               "em nenhum dos bancos conectados." VIEW-AS ALERT-BOX WARNING.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-fecha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-fecha C-Win
ON CHOOSE OF bt-fecha IN FRAME DEFAULT-FRAME /* Fecha */
DO:
  &IF DEFINED (adm-panel) <> 0 &THEN
      RUN dispatch IN THIS-PROCEDURE ('exit').
  &ELSE
      APPLY "CLOSE":U TO THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLista
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLista C-Win
ON CHOOSE OF btLista IN FRAME DEFAULT-FRAME /* Lista */
DO:
    Assign Arquivo = "c:\temp\"
                   + "busca_campo_lista_tabela.csv".


    Find First tt-result No-error.

    If  Not Available tt-result Then Do:
        Message "Nenum registro a ser listado"
            View-as Alert-box.
        Return No-apply.
    End.


    Output Stream Saida To Value (arquivo).

     Export Stream Saida Delimiter ";"      
         "Banco"    
         "Tabela"   
         "Nome Campo"
         "Tipo"     
         "Formato"  
         "Decimais" 
         "Extent".  



    For Each tt-result:
        Export Stream Saida  Delimiter ";"
            tt-result.tt-banco    
            tt-result.tt-tabela   
            tt-result.tt-nom-campo
            tt-result.tt-tipo     
            tt-result.tt-formato  
            tt-result.tt-decimais 
            tt-result.tt-extent.   



    End.

    Output Stream Saida Close.

    Message "Arquivo Gerado " Arquivo
        View-as Alert-box.



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-ordem C-Win
ON VALUE-CHANGED OF tg-ordem IN FRAME DEFAULT-FRAME /* Ordenar por tabela */
DO:
  CLOSE QUERY  br-result.
  {&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-result
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  ASSIGN stat = sl-bancos:LIST-ITEMS = ''.
  DO i = 1 TO NUM-DBS:
     lname = LDBNAME (i).
     ASSIGN stat = sl-bancos:ADD-LAST(lname).
  END.
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY fi-campo sl-bancos tg-ordem rs-modo-busca 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btLista bt-fecha fi-campo bt-busca sl-bancos tg-ordem rs-modo-busca 
         br-result 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Prog2 C-Win 
PROCEDURE Prog2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
    FOR EACH dictdb._field WHERE 
         dictdb._field._field-name = INPUT FRAME {&FRAME-NAME} fi-campo:

/*     MESSAGE  INPUT FRAME {&FRAME-NAME} fi-campo VIEW-AS ALERT-BOX. */

  FIND dictdb._file WHERE 
       RECID(dictdb._file) = dictdb._field._file-recid NO-LOCK NO-ERROR.

  IF AVAIL dictdb._file THEN DO:
      CREATE tt-result.                                     
      ASSIGN tt-result.tt-banco     = X                       
             tt-result.tt-tabela    = dictdb._file._file-name
             tt-result.tt-nom-campo = dictdb._field._field-name               
             tt-result.tt-tipo      = dictdb._field._data-type               
             tt-result.tt-formato   = dictdb._field._format
             tt-result.tt-decimais  = dictdb._field._decimals
             tt-result.tt-extent    = dictdb._field._extent.
      ASSIGN l-ok = TRUE.
  END.
             /*
             MESSAGE dictdb._file._file-name VIEW-AS ALERT-BOX.  
             */
END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

