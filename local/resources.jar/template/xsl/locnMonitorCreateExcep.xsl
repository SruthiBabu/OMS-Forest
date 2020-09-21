<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="/Alert">
	<xsl:element name="MultiApi">
		<xsl:for-each select="Location">
			<xsl:element name="API">
				<xsl:attribute name="Name"><xsl:text>createException</xsl:text></xsl:attribute>
				<xsl:element name="Input">
					<xsl:element name="Inbox">
						<xsl:attribute name="ExceptionType"><xsl:value-of select="/Alert/@AlertId"/></xsl:attribute>
						<xsl:attribute name="ShipnodeKey"><xsl:value-of select="/Alert/@Node"/></xsl:attribute>
						<xsl:attribute name="LocationId"><xsl:value-of select="@LocationId"/></xsl:attribute>
						<xsl:attribute name="EnterpriseKey"><xsl:value-of select="Inventory/@EnterpriseCode"/></xsl:attribute>
						<xsl:attribute name="ItemId"><xsl:value-of select="Inventory/@ItemId"/></xsl:attribute>
						<xsl:attribute name="DetailDescription">
                                                <xsl:value-of select="concat('ItemId=',(Inventory/@ItemId),' UOM=',(Inventory/@UnitOfMeasure),' ProductClass=',(Inventory/@ProductClass),' EnterpriseCode=',(Inventory/@EnterpriseCode),' Quantity=',(Inventory/@CurrentQuantity))"/>
                                                </xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:element>
	</xsl:template>
</xsl:stylesheet>