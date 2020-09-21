<?xml version='1.0' encoding='utf-8' ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>	
	<xsl:template match="/">
	<xsl:element name="Location">
     		<xsl:for-each select="/LocationList/SKUDedication">
        			<xsl:attribute name="LocationId">
         				<xsl:value-of select="@LocationId"/>
      			</xsl:attribute>
      			<xsl:attribute name="Node">
              				<xsl:value-of select="@Node"/>
      			</xsl:attribute>
      		</xsl:for-each>
		<SKUDedications>
			<xsl:for-each select="/LocationList/SKUDedication">
		             		<xsl:copy-of select="."/>
			</xsl:for-each>
		</SKUDedications>
	</xsl:element>
      	</xsl:template>
</xsl:stylesheet>
				