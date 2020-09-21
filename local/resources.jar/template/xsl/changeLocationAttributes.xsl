<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
    <xsl:output indent="yes"/>
    <xsl:template match="/">
	<xsl:element name="Message">
		<xsl:attribute name="FlowName">
			<xsl:text>RECALC_LOCN_DIMENSIONS</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="TransactionKey">
			<xsl:text>RECALC_LOCN_DIMENSIONS</xsl:text>
		</xsl:attribute>
		<xsl:element name="AgentDetails">
			<xsl:element name="MessageXml">
				<xsl:attribute name="Action">
					<xsl:text>Get</xsl:text>
				</xsl:attribute>
				<xsl:if test="normalize-space(/Item/@ItemID) != &quot;&quot;">
					<xsl:attribute name="RecalcReason">
						<xsl:text>ItemSizeChange</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ItemID">
						<xsl:value-of select="/Item/@ItemID"/>
					</xsl:attribute>
					<xsl:attribute name="EnterpriseCode">
						<xsl:value-of select="/Item/@OrganizationCode"/>
					</xsl:attribute>
					<xsl:attribute name="UnitOfMeasure">
						<xsl:value-of select="/Item/@UnitOfMeasure"/>
					</xsl:attribute>
					<xsl:attribute name="OldUnitWeight">
						<xsl:value-of select="/Item/@OldUnitWeight"/>
					</xsl:attribute>
					<xsl:attribute name="OldUnitWeightUOM">
						<xsl:value-of select="/Item/@OldUnitWeightUOM"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="normalize-space(/LocationSize/@LocationSizeCode) != &quot;&quot;">
					<xsl:attribute name="RecalcReason">
						<xsl:text>LocationSizeChange</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="Node">
						<xsl:value-of select="LocationSize/@Node"/>
					</xsl:attribute>
					<xsl:attribute name="LocationSizeCode">
						<xsl:value-of select="/LocationSize/@LocationSizeCode"/>
					</xsl:attribute>
					<xsl:attribute name="AgentCriteriaGroup">
						<xsl:value-of select="/LocationSize/@AgentCriteriaGroup"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="normalize-space(/Location/@LocationId) != &quot;&quot;">
					<xsl:attribute name="RecalcReason">
						<xsl:text>LocationSizeChange</xsl:text>
					</xsl:attribute>
						<!-- If LocationId is Passed set the action to Execute -->
					<xsl:attribute name="Action">
						<xsl:text>Execute</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="LocationId">
						<xsl:value-of select="Location/@LocationId"/>
					</xsl:attribute>
					<xsl:attribute name="ZoneId">
						<xsl:value-of select="Location/@ZoneId"/>
					</xsl:attribute>
					<xsl:attribute name="Node">
						<xsl:value-of select="Location/@Node"/>
					</xsl:attribute>
					<xsl:attribute name="LocationSizeCode">
						<xsl:value-of select="/Location/@LocationSizeCode"/>
					</xsl:attribute>
					<xsl:attribute name="AgentCriteriaGroup">
						<xsl:value-of select="/Location/@AgentCriteriaGroup"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:element>
		</xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
