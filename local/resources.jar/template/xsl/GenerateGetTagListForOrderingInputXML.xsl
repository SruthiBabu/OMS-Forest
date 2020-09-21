<?xml version='1.0'?>
<!-- Stylesheet for transforming GetTagListForOrderingUE xml to getTagListForOrdering 
	input xml -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" />
	<xsl:strip-space elements="*" />
	<xsl:template match="/">
		<xsl:apply-templates select="RequestedTagInfo"/>
	</xsl:template>
	
	<xsl:template match="RequestedTagInfo">
		<xsl:element name="Tag">
			<xsl:attribute name="BatchNo"><xsl:value-of select="@BatchNo" /></xsl:attribute>
			<xsl:attribute name="LotAttribute1"><xsl:value-of select="@LotAttribute1" /></xsl:attribute>
			<xsl:attribute name="LotAttribute2"><xsl:value-of select="@LotAttribute2" /></xsl:attribute>
			<xsl:attribute name="LotAttribute3"><xsl:value-of select="@LotAttribute3" /></xsl:attribute>
			<xsl:attribute name="LotKeyReference"><xsl:value-of select="@LotKeyReference" /></xsl:attribute>
			<xsl:attribute name="LotNumber"><xsl:value-of select="@LotNumber" /></xsl:attribute>
			<xsl:attribute name="ManufacturingDate"><xsl:value-of select="@ManufacturingDate" /></xsl:attribute>
			<xsl:attribute name="RevisionNo"><xsl:value-of select="@RevisionNo" /></xsl:attribute>
			<xsl:for-each select="InventoryItem">
				<xsl:element name="InventoryItem">
					<xsl:attribute name="InventoryOrganizationCode"><xsl:value-of select="@InventoryOrganizationCode" /></xsl:attribute>
					<xsl:attribute name="ItemID"><xsl:value-of select="@ItemID" /></xsl:attribute>
					<xsl:attribute name="OrganizationCode"><xsl:value-of select="@OrganizationCode" /></xsl:attribute>
					<xsl:attribute name="ProductClass"><xsl:value-of select="@ProductClass" /></xsl:attribute>
					<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="@UnitOfMeasure" /></xsl:attribute>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>

