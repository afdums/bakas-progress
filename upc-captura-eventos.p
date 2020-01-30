def input param p-ind-event  as char          no-undo.
def input param p-ind-object as char          no-undo.
def input param p-wgh-object as handle        no-undo.
def input param p-wgh-frame  as widget-handle no-undo.
def input param p-cod-table  as char          no-undo.
def input param p-row-table  as rowid         no-undo.

OUTPUT TO c:\temp\upc-cp0302f.txt APPEND.
PUT UNFORMATTED "p-ind-event : " p-ind-event  SKIP
                "p-ind-object: " p-ind-object SKIP
                "p-wgh-object: " STRING(p-wgh-object) SKIP
                "p-wgh-frame : " STRING(p-wgh-frame)  SKIP
                "p-cod-table : " p-cod-table  SKIP
                "p-row-table : " STRING(p-row-table)  SKIP(2).
OUTPUT CLOSE.

                
RETURN RETURN-VALUE.

