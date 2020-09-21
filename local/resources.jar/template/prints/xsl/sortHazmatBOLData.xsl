<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    sortShipmentHazmatBOL.xsl
    Created on  July 18, 2005
    Author      Sudheer
    Description
        Sorting the hazardous containers based on the HazmatClass.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
    <xsl:template match="/">
        <HazmatData>
            <xsl:for-each select="HazmatData/@*">
                <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:copy-of select="HazmatData/FromAddress"/>  
            <xsl:copy-of select="HazmatData/ToAddress"/>          
            <HazardousContainers>      
                <xsl:for-each select="HazmatData/HazardousContainers/HazardousContainer">
                    <xsl:sort select="@HazmatClass" order="ascending"/>
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </HazardousContainers> 
        </HazmatData>
    </xsl:template>
</xsl:stylesheet> 