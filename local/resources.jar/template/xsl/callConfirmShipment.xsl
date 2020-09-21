<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="/Shipment">
	<xsl:element name="Shipment">
		<xsl:attribute name="ShipComplete">
                    <xsl:text>Y</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="ManifestBeingClosed">
                    <xsl:text>Y</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="LoadBeingConfirmed">
                    <xsl:text>Y</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="ShipmentKey">
                    <xsl:value-of select="@ShipmentKey"/>
		</xsl:attribute>
	</xsl:element>
	</xsl:template>
</xsl:stylesheet>