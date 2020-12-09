def var l-txt as char no-undo.
   
l-txt = "Jose                           Araujo".
   
l-txt = TRIM( l-txt ).  
DO WHILE INDEX( l-txt, "  " ) > 0:      
   l-txt = REPLACE( l-txt, "  ", " " ).
   l-txt = REPLACE( l-txt, "  ", " " ).
END.  

message TRIM(l-txt)
   VIEW-AS ALERT-BOX INFO BUTTONS OK.
