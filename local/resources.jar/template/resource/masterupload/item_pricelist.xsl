<!--
  Licensed Materials - Property of IBM
  5725-F55
  Copyright IBM Corporation 2011. All Rights Reserved.
  US Government Users Restricted Rights- Use, duplication or disclosure
  restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" omit-xml-declaration="yes" />
	
	<xsl:template match="/">
		<xsl:apply-templates select="PricelistLineList"/>
	</xsl:template>
	
	<xsl:template match="PricelistLineList">
		<PricelistLineList>	
			<xsl:attribute name="OrganizationCode">
				<xsl:value-of select="@OrganizationCode"/>
			</xsl:attribute>			
			<PricelistLine>
				<xsl:apply-templates select="Action"/>
				<xsl:apply-templates select="PricelistLine"/>
				<xsl:apply-templates select="PricelistHeader"/>
			</PricelistLine>
		</PricelistLineList>
	</xsl:template>
	
	<xsl:template match="Action">	
		<xsl:attribute name="Operation">
			<xsl:value-of select="@Action"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="PricelistLine">		
		<xsl:attribute name="ItemID">
			<xsl:value-of select="@ItemID"/>
		</xsl:attribute>
		<xsl:attribute name="StartDateActive">
			<xsl:value-of select="@StartDateActive"/>
		</xsl:attribute>
		<xsl:attribute name="EndDateActive">
			<xsl:value-of select="@EndDateActive"/>
		</xsl:attribute>
		<xsl:attribute name="PricingStatus">
			<xsl:value-of select="@PricingStatus"/>
		</xsl:attribute>
		<xsl:attribute name="ListPrice">
			<xsl:value-of select="@ListPrice"/>
		</xsl:attribute>		
	</xsl:template>
	
	
	<xsl:template match="PricelistHeader">
		<PricelistHeader >
			<xsl:attribute name="PricelistName">
				<xsl:value-of select="@PricelistName"/>
			</xsl:attribute>
		</PricelistHeader>							
	</xsl:template>	
	
	
</xsl:stylesheet>