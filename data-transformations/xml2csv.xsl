<?xml version="1.0" encoding="UTF-8"?>
<!--
Run this XSLT tranform to convert input XML to output CSV:
xsltproc: xsltproc xml2csv.xsl input.xml
XMLStarlet: xml tr xml2csv.xsl input.xml 
 -->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method="text" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/root/record">
        <xsl:value-of select="normalize-space(concat(place,',',place/@type,',',latitude,',',longitude))"/>
        <xsl:text>&#xD;&#xA;</xsl:text>
    </xsl:template>

</xsl:stylesheet>

