<?xml version="1.0"?>

<!-- MRB: Fri 11-Oct-2013
	
	Purpose: XSLT standalone stylesheet to convert a file from CSV to XML
	
	Description: The original standalone XSLT stylesheet CSV to XML converter by Andrew Welch can be found here:
	http://andrewjwelch.com/code/xslt/csv/csv-to-xml_v2.html
		
	Modified the XSLT stylesheet csv2xml.xsl (the original file was named xsv-to-xml_v2.xslt) in the following ways:
	
	(1) Changed the character encoding from "US-ASCII" to "UTF-8".
	(2) Changed the path to the source CSV file from "file:///c:/csv.csv" to
	"file:///c:/users/brundin/temp/geonames/places.txt".
	(3) Changed the CSV field delimiter marker from a "," (which is "&#44;", but "," was used in
	the original code) to "&#x9;", i.e., a "tab" character.
	(4) Changed the newline, line break, or end-of line (EOL) marker from a Unix, Linux, BSD, Mac OS X line feed
	"&#xA;" LF, '\n') to a Microsoft Windows carriage return and line feed sequence "&#xD;&#xA;" (CR+LF, '\r\n').
	Note: the GeoNames data use a Unix newline character of line feed ("&#xA;"), but after downloading the data, the
	GeoNames data were changed from LF to CR+LF using the Vim editor.
	(5) Changed the references to header field names for each data cell from attributes (i.e.,
	<elem name="field-name">) to elements (i.e., <field-name>).
	
	To pre-process the input CSV file, open the CSV file in the Vim editor and do the following:
	
	(1) Check that the first line of the CSV file contains the header field names, with the field names separated by the appropriate field delimiter character.
	(2) Set the character encoding to UTF-8 using this command: :set encoding=utf-8 | set fileencoding=utf-8
	(3) Check the file format option to see if the line ending characters are Unix LF or Windows CR+LF using this command: :set ff? ffs?
	(4) Change the newline markers from Unix LF (or a mixture of CR+LF and LF) to Windows CR+LF, using this command: :update | e ++ff=dos | w
	Note: to change the newline markers from Windows CR+LF to Unix LF, use this command: :update | e ++ff=dos | setlocal ff=unix | w
	
	To run the standalone csv2xml.xsl stylesheet on the input CSV file, do the following in the csv2xml.xsl file:
	
	(1) Set the character encoding (e.g., UTF-8, or ISO-8859-1).
	(2) Set the path to the source CSV file (e.g., file:///c:/users/brundin/temp/geonames/places.txt).
	(3) Set the CSV field delimiter character or character code (e.g., ",", or "&#x9;").
	(4) Set the newline marker as LF or CR+LF (i.e., "&#xA;", or "&#xD;&#xA;").
	(5) Set the header field name references for each data cell to either attributes (i.e., <elem name="field-name"> or elements (i.e., <field-name>).
	
	Then from the Windows Command command prompt, run the following command:
	
	java.exe -cp "C:\Program Files (x86)\Java\jre7\lib\saxon9he.jar" net.sf.saxon.Transform -o:c:/users/brundin/temp/geonames/output.xml -it:main csv2xml.xsl
	
	where the classpath to the Java JRE has already been set, the path to the Saxon XSLT processor jar file is provided, the path to the output XML file
	output.xml is provided, "main" is the initial template, and the standalone XSLT stylesheet csv2xml.xsl is in the same directory that the Windows
	Command command is being run from.
-->
  		
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="fn"
	exclude-result-prefixes="xs fn">

<!-- MRB: (1) changed the character encoding from "US-ASCII" to "UTF-8" -->
<xsl:output indent="yes" encoding="utf-8"/>
	
	<!-- MRB: (2) changed the path to the source CSV file from "file:///c:/csv.csv" to
		"file:///c:/users/brundin/temp/geonames/places.txt" -->
	<xsl:param name="pathToCSV" select="'file:///c:/users/brundin/temp/geonames/places.txt'"/>

<xsl:function name="fn:getTokens" as="xs:string+">
	<xsl:param name="str" as="xs:string"/>
		<!-- MRB: (3) changed the CSV field delimiter marker from a "," to a "&#x9;" (i.e., a
		"tab" character) -->
		<xsl:analyze-string select="concat($str, '&#x9;')" regex='(("[^"]*")+|[^&#x9;]*)&#x9;'>
			<xsl:matching-substring>
				<xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")'/>
			</xsl:matching-substring>
		</xsl:analyze-string>
</xsl:function>

<xsl:template match="/" name="main">
	<xsl:choose>
		<xsl:when test="unparsed-text-available($pathToCSV)">
			<xsl:variable name="csv" select="unparsed-text($pathToCSV)"/>
			<!-- MRB: (4) changed the newline marker from a Unix LF ("&#xA;") to a Microsoft
			Windows CR+LF ("&#xD;&#xA;") -->
			<xsl:variable name="lines" select="tokenize($csv, '&#xD;&#xA;')" as="xs:string+"/>
			<xsl:variable name="elemNames" select="fn:getTokens($lines[1])" as="xs:string+"/>
			<root>
				<xsl:for-each select="$lines[position() > 1]">
					<record>
						<xsl:variable name="lineItems" select="fn:getTokens(.)" as="xs:string+"/>

						<xsl:for-each select="$elemNames">
							<xsl:variable name="pos" select="position()"/>
							<!-- MRB: (5) changed the header field name references for each data
								cell from attributes (i.e., <elem name"field-name">) as in
								
								<elem name="{.}">
									<xsl:value-of select="$lineItems[$pos]"/>
								</elem>
								
								to elements (i.e., <field-name>) as in
								
								<xsl:element name="{.}">
									<xsl:value-of select="$lineItems[$pos]"/>
								</xsl:element>
								
							-->
							<xsl:element name="{.}">
								<xsl:value-of select="$lineItems[$pos]"/>
							</xsl:element>
						</xsl:for-each>
					</record>
				</xsl:for-each>
			</root>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>Cannot locate : </xsl:text><xsl:value-of select="$pathToCSV"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>