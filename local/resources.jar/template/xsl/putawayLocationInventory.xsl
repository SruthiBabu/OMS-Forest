<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:key name="distinct-location-enterprise" match="Location" use="concat(@LocationId,Inventory/@EnterpriseCode)"/>
	<xsl:template match="/Alert">
	<xsl:element name="MoveRequest">
		<xsl:attribute name="ForActivityCode">
			<xsl:text>STORAGE</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="FromActivityGroup">
			<xsl:text>RECEIPT</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="Release">
			<xsl:text>Y</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="Node">
			<xsl:value-of select="@Node"/>
		</xsl:attribute>
		<xsl:variable name="unique-location-enterprise"  select="//Location[generate-id()=generate-id(key('distinct-location-enterprise',concat(@LocationId,Inventory/@EnterpriseCode)))]"/>
		<xsl:element name="MoveRequestLines">
			<xsl:for-each select="$unique-location-enterprise">
				<xsl:element name="MoveRequestLine">
					<xsl:if test="( /Alert/@AlertId = &quot;NON_ZERO_INVENTORY&quot; )">
						<xsl:attribute name="SourceLocationId"><xsl:value-of select="@LocationId"/></xsl:attribute>
					</xsl:if>
					<xsl:for-each select="Inventory">
					        <xsl:attribute name="ItemId"><xsl:value-of select="@ItemId"/></xsl:attribute>
						<xsl:attribute name="EnterpriseCode"><xsl:value-of select="@EnterpriseCode"/></xsl:attribute>																
						<xsl:attribute name="ProductClass"><xsl:value-of select="@ProductClass"/></xsl:attribute>	
						<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="@UnitOfMeasure"/></xsl:attribute>
						<xsl:attribute name="InventoryStatus"><xsl:value-of select="@InventoryStatus"/></xsl:attribute>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:element>
</xsl:template>
</xsl:stylesheet>
