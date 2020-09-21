<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="Receipt">
		<xsl:element name="ReceiptLine">
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="RelevantItemLinesOnly">
				<xsl:text>Y</xsl:text>
			</xsl:attribute>
			<xsl:if test="(not(/Receipt/@PalletId) or  normalize-space(/Receipt/@PalletId) = &quot;&quot;) and (not(/Receipt/@CaseId) or normalize-space(/Receipt/@CaseId) = &quot;&quot;)">
				<xsl:attribute name="ReceiptLineKey">
						<xsl:value-of select="/Receipt/ReceiptLines/ReceiptLine/@ReceiptLineKey"/>
				</xsl:attribute>
			</xsl:if>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
