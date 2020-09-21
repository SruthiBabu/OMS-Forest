<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    consolidateShippersDeclaration.xsl
    Created on  September 29, 2005
    Author      V.V.V Srikant
    Description
        Consolidates the hazardous item based upon the HazmatClass. 
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>

    <!-- template rule matching source root element -->
    
    <xsl:template match="Manifest">
        <Manifest>
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
	    <xsl:copy-of select="ShipNodePersonInfo"/>
	    <HazardousLines>
	         <xsl:apply-templates select="HazardousLines/HazardousLine[not(./@HazardClass=preceding::HazardousLine/@HazardClass)]">
		 </xsl:apply-templates>
            </HazardousLines>
	 </Manifest>
    </xsl:template>

    <xsl:template match="HazardousLine">
       <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet> 