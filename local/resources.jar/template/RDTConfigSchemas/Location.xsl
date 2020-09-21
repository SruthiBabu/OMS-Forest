<?xml version='1.0' encoding='utf-8' ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>	
	<xsl:template match="/">
	<xsl:for-each select="/LocationList/Location">
		<xsl:element name="{name()}">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
		  </xsl:element>
	</xsl:for-each>		
	</xsl:template>
</xsl:stylesheet>
