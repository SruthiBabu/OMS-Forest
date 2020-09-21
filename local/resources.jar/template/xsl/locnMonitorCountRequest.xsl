<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="/Alert">
	<xsl:element name="MultiApi">
		<xsl:for-each select="Location">
			<xsl:element name="API">
				<xsl:attribute name="Name"><xsl:text>createCountRequest</xsl:text></xsl:attribute>
				<xsl:element name="Input">
					<xsl:element name="CreateCountRequest">
						<xsl:attribute name="Node"><xsl:value-of select="/Alert/@Node"/></xsl:attribute>
						<xsl:attribute name="RequestType">
						<xsl:text>DEFAULT</xsl:text></xsl:attribute>
						<xsl:attribute name="LocationId"><xsl:value-of select="@LocationId"/></xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:element>
	</xsl:template>
</xsl:stylesheet>