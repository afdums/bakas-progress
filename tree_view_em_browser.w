&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
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

  Author: 

  Created: 

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
DEF TEMP-TABLE tt-estrutura NO-UNDO
    FIELD visivel     AS   LOGICAL
    FIELD nivel       AS   CHAR
    FIELD r-pai       AS   ROWID
    FIELD it-codigo   LIKE estrutura.it-codigo
    FIELD es-codigo   LIKE estrutura.es-codigo
    FIELD quant-usada LIKE estrutura.quant-usada.

DEF BUFFER b-tt-estrutura FOR tt-estrutura.

DEF VAR r-corrente AS ROWID NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME br-estrutura

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-estrutura

/* Definitions for BROWSE br-estrutura                                  */
&Scoped-define FIELDS-IN-QUERY-br-estrutura tt-estrutura.nivel + tt-estrutura.es-codigo tt-estrutura.quant-usada   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-estrutura   
&Scoped-define SELF-NAME br-estrutura
&Scoped-define QUERY-STRING-br-estrutura FOR EACH tt-estrutura WHERE tt-estrutura.visivel NO-LOCK
&Scoped-define OPEN-QUERY-br-estrutura OPEN QUERY {&SELF-NAME} FOR EACH tt-estrutura WHERE tt-estrutura.visivel NO-LOCK.
&Scoped-define TABLES-IN-QUERY-br-estrutura tt-estrutura
&Scoped-define FIRST-TABLE-IN-QUERY-br-estrutura tt-estrutura


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-br-estrutura}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-carrega c-acabado br-estrutura ~
bt-expandir bt-contrair 
&Scoped-Define DISPLAYED-OBJECTS c-acabado 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-carrega 
     LABEL "Carregar" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-contrair 
     LABEL "Contrair Tudo" 
     SIZE 15 BY 1.13.

DEFINE BUTTON bt-expandir 
     LABEL "Expandir Tudo" 
     SIZE 15 BY 1.13.

DEFINE VARIABLE c-acabado AS CHARACTER FORMAT "X(256)":U 
     LABEL "Acabado" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-estrutura FOR 
      tt-estrutura SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-estrutura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-estrutura C-Win _FREEFORM
  QUERY br-estrutura NO-LOCK DISPLAY
      tt-estrutura.nivel + tt-estrutura.es-codigo FORMAT "x(40)" COLUMN-LABEL "Componente"
      tt-estrutura.quant-usada
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 70 BY 11.5 ROW-HEIGHT-CHARS .83 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     bt-carrega AT ROW 1.96 COL 52 WIDGET-ID 4
     c-acabado AT ROW 2 COL 20 COLON-ALIGNED WIDGET-ID 2
     br-estrutura AT ROW 3.75 COL 5.43 WIDGET-ID 200
     bt-expandir AT ROW 15.25 COL 5.43 WIDGET-ID 6
     bt-contrair AT ROW 15.25 COL 20.29 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 78.72 BY 16 WIDGET-ID 100.


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
         TITLE              = "Browser Emulando TreeView"
         HEIGHT             = 16
         WIDTH              = 78.72
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
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
/* BROWSE-TAB br-estrutura c-acabado DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-estrutura
/* Query rebuild information for BROWSE br-estrutura
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-estrutura WHERE tt-estrutura.visivel NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-estrutura */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Browser Emulando TreeView */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Browser Emulando TreeView */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-estrutura
&Scoped-define SELF-NAME br-estrutura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-estrutura C-Win
ON MOUSE-SELECT-DBLCLICK OF br-estrutura IN FRAME DEFAULT-FRAME /* Browse 1 */
DO:
  FIND CURRENT tt-estrutura NO-ERROR.
  IF AVAIL tt-estrutura THEN DO:
      ASSIGN r-corrente = ROWID(tt-estrutura).
      FOR EACH b-tt-estrutura
          WHERE b-tt-estrutura.r-pai = ROWID(tt-estrutura):

          IF b-tt-estrutura.visivel = NO THEN DO:
            ASSIGN b-tt-estrutura.visivel = YES.
          END.
          ELSE DO:
              ASSIGN b-tt-estrutura.visivel = NO.
              RUN pi-fecha(INPUT ROWID(b-tt-estrutura)).
          END.
      END.

      {&OPEN-QUERY-br-estrutura}

      REPOSITION br-estrutura TO ROWID r-corrente.

  END.

  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-carrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-carrega C-Win
ON CHOOSE OF bt-carrega IN FRAME DEFAULT-FRAME /* Carregar */
DO:
  EMPTY TEMP-TABLE tt-estrutura.

  CREATE tt-estrutura.
  ASSIGN tt-estrutura.visivel     = YES
         tt-estrutura.nivel       = ""
         tt-estrutura.it-codigo   = c-acabado:SCREEN-VALUE
         tt-estrutura.es-codigo   = c-acabado:SCREEN-VALUE
         tt-estrutura.r-pai       = ?
         tt-estrutura.quant-usada = 1.

  RUN pi-estrutura(INPUT c-acabado:SCREEN-VALUE,
                   INPUT "",
                   INPUT 1,
                   INPUT ROWID(tt-estrutura)).

  {&OPEN-QUERY-br-estrutura}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-contrair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-contrair C-Win
ON CHOOSE OF bt-contrair IN FRAME DEFAULT-FRAME /* Contrair Tudo */
DO:
  RUN pi-exp-con(INPUT NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-expandir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-expandir C-Win
ON CHOOSE OF bt-expandir IN FRAME DEFAULT-FRAME /* Expandir Tudo */
DO:
  RUN pi-exp-con(INPUT YES).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DISPLAY c-acabado 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE bt-carrega c-acabado br-estrutura bt-expandir bt-contrair 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-estrutura C-Win 
PROCEDURE pi-estrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-item  LIKE estrutura.it-codigo   NO-UNDO.
    DEF INPUT PARAM p-nivel AS   CHAR                  NO-UNDO.
    DEF INPUT PARAM p-qtde  LIKE estrutura.quant-usada NO-UNDO.
    DEF INPUT PARAM p-pai   AS   ROWID                 NO-UNDO.

    FOR EACH estrutura
        WHERE estrutura.it-codigo     = p-item
          AND estrutura.data-inicio  <= TODAY
          AND estrutura.data-termino >= TODAY NO-LOCK:

        CREATE tt-estrutura.
        ASSIGN tt-estrutura.visivel     = NO
               tt-estrutura.nivel       = p-nivel + "     "
               tt-estrutura.it-codigo   = estrutura.it-codigo
               tt-estrutura.es-codigo   = estrutura.es-codigo
               tt-estrutura.quant-usada = estrutura.quant-usada * p-qtde
               tt-estrutura.r-pai       = p-pai.

        RUN pi-estrutura(INPUT tt-estrutura.es-codigo,
                         INPUT p-nivel + "     ",
                         INPUT tt-estrutura.quant-usada,
                         INPUT ROWID(tt-estrutura)).

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exp-con C-Win 
PROCEDURE pi-exp-con :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-acao AS LOGICAL NO-UNDO.

FOR EACH tt-estrutura
    WHERE tt-estrutura.r-pai <> ?:
    ASSIGN tt-estrutura.visivel = p-acao.
END.
{&OPEN-QUERY-br-estrutura}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-fecha C-Win 
PROCEDURE pi-fecha :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-pai AS ROWID NO-UNDO.

FOR EACH b-tt-estrutura
    WHERE b-tt-estrutura.r-pai = p-pai:
    ASSIGN b-tt-estrutura.visivel = NO.
    RUN pi-fecha(INPUT ROWID(b-tt-estrutura)).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

