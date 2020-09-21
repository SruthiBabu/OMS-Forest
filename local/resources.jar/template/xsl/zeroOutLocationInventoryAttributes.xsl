<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
    <xsl:output indent="yes"/>
    <xsl:template match="/">
	<xsl:element name="Message">
		<xsl:attribute name="FlowName">
			<xsl:text>ZEROOUT_LOCATION_INV</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="TransactionKey">
			<xsl:text>ZEROOUT_LOCATION_INV</xsl:text>
		</xsl:attribute>
		<xsl:element name="AgentDetails">
			<xsl:element name="MessageXml">
				<xsl:attribute name="Action">
					<xsl:text>Get</xsl:text>
				</xsl:attribute>
				
					<xsl:attribute name="Node">
						<xsl:value-of select="/ZeroOutLocationInventory/@Node"/>
					</xsl:attribute>
					<xsl:attribute name="EnterpriseCode">
						<xsl:value-of select="/ZeroOutLocationInventory/@EnterpriseCode"/>
					</xsl:attribute>
					<xsl:attribute name="LocationId">
						<xsl:value-of select="/ZeroOutLocationInventory/Source/@LocationId"/>
					</xsl:attribute>
					<xsl:attribute name="ReasonCode">
						<xsl:value-of select="/ZeroOutLocationInventory/Audit/@ReasonCode"/>
					</xsl:attribute>
					<xsl:attribute name="ReasonText">
						<xsl:value-of select="/ZeroOutLocationInventory/Audit/@ReasonText"/>
					</xsl:attribute>
				

			</xsl:element>
		</xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
