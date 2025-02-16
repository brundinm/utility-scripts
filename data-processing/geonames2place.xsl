<?xml version="1.0" encoding="UTF-8"?>
<!-- 
        * - Coder: MRB
        * - Created: Fri 27-Dec-2013
        * - Last modified: Thu 09-Jan-2014
        * - Purpose: XSLT stylesheet to transform the GeoNames database data dump to place entity records
        * - GeoNames database characteristics: over 8.5 million place name records
        * - Note: The GeoNames database dump was first processed using either the search-replace.awk or the search-replace.pl
        *   script files; these scripts are used to convert GeoNames codes into their English name equivalents, and output
        *   the results as a field-delimited CSV file.  The field-delimited CSV file was then converted to an XML file using
        *   either the csv2xml.awk or csv2xml.pl script files.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

    <xsl:template match="/">

        <!-- XML processing instruction statement -->
        <xsl:processing-instruction name="xml-model">href="http://cwrc.ca/schema/place.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>

        <!-- line feed character -->
        <xsl:text>&#x0A;</xsl:text>

        <cwrc>

            <!-- conditional operator here: if GeoNames name element has content, then process record -->
            <xsl:apply-templates select="root/row[normalize-space(name)]"/>

        </cwrc>

    </xsl:template>

    <xsl:template match="row">

        <entity>

            <place>

                <recordInfo>
                    <originInfo>
                        <projectId>GeoNames</projectId>

                        <!-- geonameid ==> recordIdentifer -->
                        <xsl:if test="normalize-space(geonameid) != ''">
                            <recordIdentifier source="geonameid">
                                <xsl:value-of select="normalize-space(geonameid)"/>
                            </recordIdentifier>
                        </xsl:if>

                        <!-- modificationDate ==> recordChangeDate -->
                        <xsl:if test="normalize-space(modificationDate) != ''">
                            <recordChangeDate>
                                <xsl:value-of select="normalize-space(modificationDate)"/>
                            </recordChangeDate>
                        </xsl:if>

                    </originInfo>

                    <!-- accessCondition statement -->
                    <accessCondition type="use and reproduction"
                        >Use of this public-domain resource is governed by the <a
                        href="http://creativecommons.org/licenses/by-nc/3.0/" rel="license"
                        >Creative Commons Attribution-NonCommercial 3.0 Unported License</a>.</accessCondition>

                </recordInfo>

                <identity>

                    <!-- name ==> preferredForm/namePart -->
                    <preferredForm>
                        <namePart>
                            <xsl:value-of select="normalize-space(name)"/>
                        </namePart>
                    </preferredForm>

                    <!-- alternatenames ==> variantForms/variant/namePart -->
                    <xsl:if test="normalize-space(alternatenames) != ''">
                        <variantForms>
                            <variant>
                                <namePart>
                                    <xsl:value-of select="normalize-space(alternatenames)"/>
                                </namePart>
                                <variantType>alternate names</variantType>
                            </variant>
                        </variantForms>
                    </xsl:if>

                </identity>

                <description>

                    <!-- latitude ==> latitude -->
                    <xsl:if test="normalize-space(latitude) != ''">
                        <latitude>
                            <xsl:value-of select="normalize-space(latitude)"/>
                        </latitude>
                    </xsl:if>

                    <!-- longitude ==> longitude -->
                    <xsl:if test="normalize-space(longitude) != ''">
                        <longitude>
                            <xsl:value-of select="normalize-space(longitude)"/>
                        </longitude>
                    </xsl:if>

                    <!-- featureClass ==> featureClass -->
                    <xsl:if test="normalize-space(featureClass) != ''">
                        <featureClass>
                            <xsl:value-of select="normalize-space(featureClass)"/>
                        </featureClass>
                    </xsl:if>

                    <!-- featureCode ==> featureCodeLabel -->
                    <xsl:if test="normalize-space(featureCode) != ''">
                        <featureCodeLabel>
                            <xsl:value-of select="normalize-space(featureCode)"/>
                        </featureCodeLabel>
                    </xsl:if>

                    <!-- countryCode ==> countryName -->
                    <xsl:if test="normalize-space(countryCode) != ''">
                        <countryName>
                            <xsl:value-of select="normalize-space(countryCode)"/>
                        </countryName>
                    </xsl:if>

                    <!-- admin1Code ==> firstAdministrativeDivision -->
                    <xsl:if test="normalize-space(admin1Code) != ''">
                        <firstAdministrativeDivision>
                            <xsl:value-of select="normalize-space(admin1Code)"/>
                        </firstAdministrativeDivision>
                    </xsl:if>

                    <!-- admin2Code ==> secondAdministrativeDivision -->
                    <xsl:if test="normalize-space(admin2Code) != ''">
                        <secondAdministrativeDivision>
                            <xsl:value-of select="normalize-space(admin2Code)"/>
                        </secondAdministrativeDivision>
                    </xsl:if>

                    <!-- elevation ==> elevation -->
                    <xsl:if test="normalize-space(elevation) != ''">
                        <elevation>
                            <xsl:value-of select="normalize-space(elevation)"/>
                        </elevation>
                    </xsl:if>

                    <!-- dem ==> averageElevation -->
                    <xsl:if test="normalize-space(dem) != ''">
                        <averageElevation>
                            <xsl:value-of select="normalize-space(dem)"/>
                        </averageElevation>
                    </xsl:if>

                    <!-- timezone ==> timeZoneOffset -->
                    <xsl:if test="normalize-space(timezone) != ''">
                        <timeZoneOffset>
                            <xsl:value-of select="normalize-space(timezone)"/>
                        </timeZoneOffset>
                    </xsl:if>

                </description>

            </place>

        </entity>

    </xsl:template>

</xsl:stylesheet>
