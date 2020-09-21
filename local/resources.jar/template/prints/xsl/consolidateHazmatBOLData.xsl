<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    consolidateShipmentHazmatBOL.xsl
    Created on  July 18, 2005
    Author      Sudheer
    Description
        Consolidates the hazardous containers based upon the HazmatClass, ContainerType and computing total weight, number of containers.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
    <xsl:template match="/">
        <xsl:variable name="unique-containers" 	
            select="HazmatData/HazardousContainers/HazardousContainer[not(@HazmatClass=preceding-sibling::HazardousContainer/@HazmatClass and @ContainerType=preceding-sibling::HazardousContainer/@ContainerType)]"/>
        <HazmatData>
            <xsl:for-each select="HazmatData/@*">
                <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:copy-of select="HazmatData/FromAddress"/>  
            <xsl:copy-of select="HazmatData/ToAddress"/>          
            <HazardousContainers>      
                <xsl:for-each select="$unique-containers ">
                    <xsl:variable name="CurrenthazMat" select="current()/@HazmatClass"/>
                    <xsl:variable name="CurrentConType" select="current()/@ContainerType"/>
                    <xsl:variable name="Total-Crtns"
                        select="count(/HazmatData/HazardousContainers/HazardousContainer[@HazmatClass=$CurrenthazMat and @ContainerType=$CurrentConType])"/>
                    <HazardousContainer>
                        <xsl:attribute name="PkgQty">
                            <xsl:value-of select="$Total-Crtns"/>
                        </xsl:attribute>
                      
			<xsl:variable name="weight" select=" /HazmatData/HazardousContainers/HazardousContainer[@HazmatClass=current()/@HazmatClass and @ContainerType=current()/@ContainerType]/@ActualWeight"/>			
			<xsl:choose>
			   <xsl:when test="not($weight)">
			   </xsl:when>
			   <xsl:otherwise>
			      <xsl:attribute name="Weight"><xsl:value-of select="sum(/HazmatData/HazardousContainers/HazardousContainer[@HazmatClass=current()/@HazmatClass and @ContainerType=current()/@ContainerType]/@ActualWeight)"/>
			      </xsl:attribute>
			   </xsl:otherwise>
                        </xsl:choose>
                        <xsl:for-each select="@*">
                            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                        </xsl:for-each>   
                    </HazardousContainer>
                </xsl:for-each>
            </HazardousContainers> 
      </HazmatData>
    </xsl:template>
</xsl:stylesheet> 