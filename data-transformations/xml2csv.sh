#!/bin/bash
# Commands to convert an XML file into a CSV file

# Note: if the XML file being processed has namespaces,
# will have to reference the namespaces: can use aliases
# in front of the elements if define the full namespace
# -- can use "-N" or "_" (for the default namespace) in
# XMLStarlet, and use "declare namespace" or "_" (for the
# default namespace) in Saxon-HE and BaseX; or can just
# delete the namespaces from the file being processed

# XMLStarlet -- command line XML/XSLT toolkit written in C
# (implements XPath 1.0 and XSLT 1.0)
#xml sel -T -t -m "//record" -v "concat(place,',',place/@type,',',latitude,',',longitude)" -n input.xml

# Saxon-HE (Home Edition) -- XSLT and XQuery processor written
# in Java (implements XPath 3.0, XSLT 2.0, and XQuery 3.0)
#java -cp $HOME/java/programs/Saxon-HE/saxon9he.jar net.sf.saxon.Query -s:"input.xml" -qs:"declare option saxon:output 'omit-xml-declaration=yes'; string-join(/root/record/(concat(place,',',place/@type,',',latitude,',',longitude,'&#xA;')))"

# BaseX -- XML database engine and XQuery/XPath processor written
# in Java (implements XPath 3.0, XSLT 2.0, and XQuery 3.0); uses
# the saxon9he.jar JAR file
#java -cp $HOME/java/programs/BaseX/BaseX.jar org.basex.BaseX -i input.xml -q "string-join(/root/record/(concat(place,',',place/@type,',',latitude,',',longitude,'&#xA;')))"

# sed command to later add header row as first line of the output
# file after the query command output has been written out
#sed -i '1 i\place,type,latitude,longitude' output.csv

