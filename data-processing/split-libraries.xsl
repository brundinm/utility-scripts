<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:mods="http://www.loc.gov/mods/v3">

    <!--
        * given a collection of RSC libraries and archives records 
        * split it into several individual files and save to disk
        * with each file containing an individual item
        *
        * edit VAR_FILENAME_PREFIX to reflect the path to write the files
    -->

    <xsl:output encoding="UTF-8" method="xml" indent="yes" omit-xml-declaration="no"/>

    <!-- MRB: set prefix for RSC libraries and archives file name -->
    <xsl:variable name="VAR_FILENAME_PREFIX" select="'data/record'"/>

    <xsl:template match="/">
        <xsl:apply-templates select="root/record"/>
    </xsl:template>

    <xsl:template match="record">


        <xsl:variable name="VAR_FILENAME_SUFFIX">
            <xsl:text>.xml</xsl:text>
        </xsl:variable>
        <xsl:variable name="filename"
            select="concat($VAR_FILENAME_PREFIX, format-number(position(),'000000'), $VAR_FILENAME_SUFFIX )"/>


        <xsl:result-document indent="yes" href="{$filename}" omit-xml-declaration="no"
            encoding="UTF-8" method="xml">

			<!-- MRB: set rsc.rng schema location -->
            <xsl:processing-instruction name="xml-model">href="http://cwrc.ca/schemas/rsc.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>

            <!-- line feed character -->
            <xsl:text>&#x0A;</xsl:text>
			
            <xsl:copy-of select="." copy-namespaces="no"/>

        </xsl:result-document>

    </xsl:template>

</xsl:stylesheet>
