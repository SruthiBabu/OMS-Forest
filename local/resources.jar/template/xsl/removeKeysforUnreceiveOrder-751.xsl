<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method='xml'  />
<xsl:preserve-space elements="*" />
<xsl:template match="Receipt">
	<xsl:element name="Receipt">
			<xsl:attribute name="SuppressSupplyUpdate">
	                <xsl:text>Y</xsl:text>
	        </xsl:attribute>
		<xsl:for-each select="@*">
			<xsl:if test="not(contains(name(.),'Key')) ">
				<xsl:copy-of select="."/>
			</xsl:if>
		</xsl:for-each>
		<ReceiptLines>	
			<xsl:for-each select="ReceiptLines/ReceiptLine">
					<ReceiptLine>
				<xsl:for-each select="@*">
					<xsl:if test="not(contains(name(.),'Key')) ">
						<xsl:copy-of select="."/>
					</xsl:if>
				</xsl:for-each>
					</ReceiptLine>
		</xsl:for-each>
		</ReceiptLines>
		<xsl:copy-of select="Shipment"/>
		<xsl:copy-of select="Audit"/>
	</xsl:element>	
</xsl:template>
</xsl:stylesheet>