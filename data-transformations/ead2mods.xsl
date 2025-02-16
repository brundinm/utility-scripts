<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:mods="http://www.loc.gov/mods/v3">


<xsl:output method="xml" media-type="text/html" indent="yes"/>
<xsl:strip-space elements="*"/>
<xsl:param name="cid"/>
<xsl:param name="lan"/>
<xsl:param name="gac"/>
<xsl:param name="oid"/>

<xsl:template match="/">
<mods:mods ID="{$oid}" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-2.xsd">
<xsl:apply-templates select="//c[@id=$cid]"/> 
</mods:mods>
</xsl:template>

<xsl:template match="c">
<xsl:apply-templates select="did/unittitle"/>
<xsl:apply-templates select="controlaccess/famname[@role != 'subject']|controlaccess/persname[@role != 'subject']|controlaccess/corpname[@role != 'subject']"/>
<xsl:apply-templates select="did/physdesc/genreform"/>
<xsl:choose>
<xsl:when test="did/unittitle/imprint">
<mods:originInfo>
<mods:place>
<mods:placeTerm type="code" authority="marccountry"><xsl:value-of select="$gac"/></mods:placeTerm>
<mods:placeTerm type="text"><xsl:value-of select="did/unittitle/imprint/geogname"/></mods:placeTerm>
</mods:place>
<mods:publisher><xsl:value-of select="did/unittitle/imprint/publisher"/></mods:publisher>
<mods:dateIssued encoding="w3cdtf" keyDate="yes"><xsl:value-of select="did/unittitle/imprint/date"/></mods:dateIssued>
</mods:originInfo>
</xsl:when>
<xsl:otherwise>
<mods:originInfo>
<mods:place>
<mods:placeTerm type="text">
<xsl:apply-templates select="did/unittitle/geogname"/>
</mods:placeTerm>
<xsl:if test="$gac !='X'">
<mods:placeTerm type="code" authority="margac"><xsl:value-of select="$gac"/></mods:placeTerm>
</xsl:if>
</mods:place>
<mods:dateCreated encoding="w3cdtf" keyDate="yes">
<xsl:value-of select="descendant::unitdate/@normal"/>
</mods:dateCreated>
</mods:originInfo>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$lan !='X'">
<mods:language>
<mods:languageTerm type="code" authority="iso639-2b">
<xsl:value-of select="$lan"/>
</mods:languageTerm>
</mods:language>
</xsl:if>
<xsl:apply-templates select="did/physdesc"/>
<xsl:apply-templates select="scopecontent"/>
<xsl:apply-templates select="acqinfo"/>
<xsl:apply-templates select="controlaccess/famname[@role = 'subject']|controlaccess/persname[@role = 'subject']|controlaccess/corpname[@role = 'subject']"/>
<xsl:apply-templates select="controlaccess/subject"/>
<xsl:apply-templates select="controlaccess/geogname" mode="subject"/>
<mods:relatedItem type="host" displayLabel="Collection:">
<mods:titleInfo>
<mods:title>Brown Archival and Manuscript Collections Online</mods:title> 
</mods:titleInfo>
<mods:identifier type="URI">http://dl.lib.brown.edu/bamco/index.html</mods:identifier> 
<mods:identifier type="COLID">5</mods:identifier>
</mods:relatedItem>
</xsl:template>

<xsl:template match="genreform">
<mods:genre authority="aat"><xsl:value-of select="./@normal"/></mods:genre>
</xsl:template>

<xsl:template match="subject">
<mods:subject>
<mods:topic><xsl:value-of select="."/></mods:topic>
</mods:subject>
</xsl:template>

<xsl:template match="geogname" mode="subject">
<mods:subject>
<mods:geographic><xsl:value-of select="."/></mods:geographic>
</mods:subject>
</xsl:template>

<xsl:template match="persname[@role = 'subject']">
<mods:subject>
<mods:name type="personal">
<mods:namePart><xsl:value-of select="text()"/></mods:namePart>
</mods:name>
</mods:subject>
</xsl:template>

<xsl:template match="corpname[@role = 'subject']">
<mods:subject>
<mods:name type="corporate">
<mods:namePart><xsl:value-of select="text()"/></mods:namePart>
</mods:name>
</mods:subject>
</xsl:template>

<xsl:template match="famname[@role = 'subject']">
<mods:subject>
<mods:name type="family">
<mods:namePart><xsl:value-of select="text()"/></mods:namePart>
</mods:name>
</mods:subject>
</xsl:template>

<xsl:template match="persname[@role != 'subject']">
<mods:name type="personal">
<mods:namePart><xsl:value-of select="text()"/></mods:namePart>
<mods:role><mods:roleTerm type="text"><xsl:value-of select="./@role"/></mods:roleTerm></mods:role>
</mods:name>
</xsl:template>

<xsl:template match="corpname[@role != 'subject']">
<mods:name type="corporate">
<mods:namePart><xsl:value-of select="text()"/></mods:namePart>
<mods:role><mods:roleTerm type="text"><xsl:value-of select="./@role"/></mods:roleTerm></mods:role>
</mods:name>
</xsl:template>

<xsl:template match="famname[@role != 'subject']">
<mods:name type="family">
<mods:namePart><xsl:value-of select="text()"/></mods:namePart>
<mods:role><mods:roleTerm type="text"><xsl:value-of select="./@role"/></mods:roleTerm></mods:role>
</mods:name>
</xsl:template>

<xsl:template match="unittitle">
<xsl:choose>
<xsl:when test="title">
<mods:titleInfo>
<mods:title><xsl:apply-templates select="title"/></mods:title>
</mods:titleInfo>
</xsl:when>
<xsl:otherwise>
<mods:titleInfo>
<mods:title><xsl:apply-templates select="text()"/></mods:title>
<xsl:apply-templates select="unitdate"/>
</mods:titleInfo>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="unitdate">
	<mods:subTitle><xsl:value-of select="."/></mods:subTitle>
</xsl:template>

<xsl:template match="physdesc">
	<xsl:apply-templates select="extent"/>
</xsl:template>

<xsl:template match="extent">
	<mods:physicalDescription>
		<mods:extent><xsl:value-of select="."/></mods:extent>
	</mods:physicalDescription>
</xsl:template>

<xsl:template match="scopecontent">
	<mods:abstract><xsl:value-of select="."/></mods:abstract>
</xsl:template>

<xsl:template match="acqinfo">
	<mods:identifier type="local" displayLabel="Manuscript Accession No.">
		<xsl:value-of select="."/>
	</mods:identifier>
</xsl:template>

</xsl:stylesheet>

