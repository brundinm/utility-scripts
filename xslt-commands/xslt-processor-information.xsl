<?xml version="1.0" encoding="UTF-8"?>
<!-- 
# MRB: Fri 04-Aug-2017
# Purpose: XSLT stylesheet to determine XSLT processor version and vendor information
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" media-type="text/xml"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <xsl:message>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>Version: </xsl:text>
            <xsl:value-of select="system-property('xsl:version')"/>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>Vendor: </xsl:text>
            <xsl:value-of select="system-property('xsl:vendor')"/>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>Vendor URL: </xsl:text>
            <xsl:value-of select="system-property('xsl:vendor-url')"/>
            <xsl:text>&#10;</xsl:text>
            <xsl:text>DEBUG: Start code check</xsl:text>
        </xsl:message>
        <!-- Code to check here -->
        <xsl:message>DEBUG: End code check</xsl:message>
    </xsl:template>
</xsl:stylesheet>
