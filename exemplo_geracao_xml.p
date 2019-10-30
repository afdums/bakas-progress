DEFINE VARIABLE hSAXWriter AS HANDLE  NO-UNDO.
DEFINE VARIABLE lOK        AS LOGICAL NO-UNDO.

CREATE SAX-WRITER hSAXWriter.
hSAXWriter:FORMATTED = TRUE.


hSAXWriter:ENCODING = "UTF-8".

lOK = hSAXWriter:SET-OUTPUT-DESTINATION("file", "c:\temp\sw-example.xml").


lOK = hSAXWriter:START-DOCUMENT( ).

lOK = hSAXWriter:START-ELEMENT("RadanSchedule").
lOK = hSAXWriter:INSERT-ATTRIBUTE("xmlns" , "//www.radan.com/ns/rns").
lOK = hSAXWriter:START-ELEMENT("JobDetails").

lOK = hSAXWriter:WRITE-DATA-ELEMENT("Units", "mm").
lOK = hSAXWriter:WRITE-DATA-ELEMENT("JobName","W-1.9-CHAPA").
lOK = hSAXWriter:WRITE-DATA-ELEMENT("NextNestNum", "27").
lOK = hSAXWriter:WRITE-DATA-ELEMENT("Annotate", "y").
lOK = hSAXWriter:WRITE-DATA-ELEMENT("Plot", "n").
lOK = hSAXWriter:START-ELEMENT("SheetSource").
lOK = hSAXWriter:INSERT-ATTRIBUTE("source" , "single").
lOK = hSAXWriter:START-ELEMENT("Sheet").
lOK = hSAXWriter:WRITE-DATA-ELEMENT("Material", "SPCC").
lOK = hSAXWriter:WRITE-DATA-ELEMENT("Thickness", "1.6").
lOK = hSAXWriter:END-ELEMENT("Sheet").
lOK = hSAXWriter:END-ELEMENT("SheetSource").
lOK = hSAXWriter:END-ELEMENT("JobDetails").
lOK = hSAXWriter:END-ELEMENT("RadanSchedule").

lOK = hSAXWriter:END-DOCUMENT( ).


