<?xml version = "1.0" encoding = "UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:output indent="yes"/>
		<xsl:template match="/Manifest">			
		<Manifest>
			<xsl:variable name="NumberOfRecords">
				<xsl:value-of select="Loads/@TotalNumberOfRecords"/>
			</xsl:variable>
			 <xsl:for-each select="@*">
				<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
			  </xsl:for-each>
				<xsl:choose>
					<xsl:when test="number($NumberOfRecords) &lt; 5">
					   <xsl:attribute name="LabelFormatId"><xsl:text>LTL_MANIFEST_SINGLEPAGE</xsl:text></xsl:attribute>
					 </xsl:when>
					<xsl:otherwise>
					   <xsl:attribute name="LabelFormatId"><xsl:text>LTL_MANIFEST</xsl:text></xsl:attribute>
					</xsl:otherwise>
				     </xsl:choose>
			<xsl:copy-of select="Carrier"/>
			<xsl:copy-of select="ShipNode"/>
			<xsl:copy-of select="Loads"/>
		</Manifest>
	</xsl:template>
</xsl:stylesheet>