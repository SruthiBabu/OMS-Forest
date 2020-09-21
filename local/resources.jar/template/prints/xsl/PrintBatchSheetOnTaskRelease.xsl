<?xml version='1.0' encoding='utf-8' ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>	
	<xsl:template match="/">
		<xsl:element name="Batch">
			<xsl:attribute name="IsBatch">
				<xsl:text>N</xsl:text>
			</xsl:attribute>
			<xsl:if test="normalize-space(/TaskList/@BatchNo) != &quot;&quot;">
				<xsl:attribute name="IsBatch">
					<xsl:text>Y</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="PrintContainerLabel">
					<xsl:text>Y</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="BatchNo">
					<xsl:value-of select="/TaskList/@BatchNo"/>
				</xsl:attribute>
				<xsl:attribute name="OrganizationCode">
				<xsl:value-of select="/TaskList/@OrganizationCode"/>
				</xsl:attribute>
			 </xsl:if>
		</xsl:element>	
	</xsl:template>
</xsl:stylesheet>