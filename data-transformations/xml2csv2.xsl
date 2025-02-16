<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" />
 
 <!--
 - XSLT to convert XML file to a CSV file
 - can process simple XML file with two levels of descendant elements below the root
 - root element is "library", with each record element being "book"
 - the book element's child elements are defined in the variable "fieldArray"
 -->
 
  <xsl:variable name="delimiter" select="','" />
 
  <!-- define an array containing the fields we are interested in -->
  <xsl:variable name="fieldArray">
    <field>author</field>
    <field>title</field>
    <field>publishDate</field>
  </xsl:variable>
  <xsl:param name="fields" select="document('')/*/xsl:variable[@name='fieldArray']/*" />
 
  <xsl:template match="/">
 
    <!-- output the header row -->
    <xsl:for-each select="$fields">
      <xsl:if test="position() != 1">
        <xsl:value-of select="$delimiter"/>
      </xsl:if>
      <xsl:value-of select="." />
    </xsl:for-each>
 
    <!-- output newline -->
    <xsl:text>&#xa;</xsl:text>
 
    <xsl:apply-templates select="library/book"/>
  </xsl:template>
 
  <xsl:template match="book">
    <xsl:variable name="currNode" select="." />
 
    <!-- output the data row -->
    <!-- loop over the field names and find the value of each one in the xml -->
    <xsl:for-each select="$fields">
      <xsl:if test="position() != 1">
        <xsl:value-of select="$delimiter"/>
      </xsl:if>
      <xsl:value-of select="$currNode/*[name() = current()]" />
    </xsl:for-each>
 
    <!-- output newline -->
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
