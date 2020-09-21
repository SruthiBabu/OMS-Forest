<?xml version='1.0' encoding='utf-8' ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>	
	<xsl:template match="/">
		<xsl:if test="/Entity/@EntityName = &quot;YFS_SHIPMENT&quot;">
			<xsl:element name="Shipment">
				<xsl:attribute name="ShipmentKey">
					<xsl:value-of select="/Entity/@EntityKey"/>
				</xsl:attribute>
				<xsl:attribute name="EntityName">
					<xsl:text>YFS_SHIPMENT</xsl:text>
				</xsl:attribute>
				<xsl:for-each select="/Entity/ExpectedDate">
				    <xsl:if test="@PlannedDateType = &quot;SHIPMENT&quot;"> 
					<xsl:attribute name="ExpectedShipmentDate">
						<xsl:value-of select="@PlannedDate"/>
					</xsl:attribute>
				    </xsl:if>
				    <xsl:if test="@PlannedDateType = &quot;PICK&quot;"> 
					<xsl:attribute name="ExpectedPickDate">
						<xsl:value-of select="@PlannedDate"/>
					</xsl:attribute>
				    </xsl:if>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>