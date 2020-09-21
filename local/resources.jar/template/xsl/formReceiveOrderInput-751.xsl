<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="/">
	  <Receipt DocumentType="0005">
		<xsl:attribute name="ReceivingNode">
			<xsl:value-of select="ReceiptLineList/ReceiptLine/Receipt/@ReceivingNode"/>
		</xsl:attribute>
	    <Shipment>
			<xsl:attribute name="OrderNo">
				<xsl:value-of select="ReceiptLineList/ReceiptLine/@OrderNo"/>
			</xsl:attribute>
			<xsl:if test="(not(ReceiptLineList/ReceiptLine/@OrderNo) or  normalize-space(ReceiptLineList/ReceiptLine/@OrderNo) = &quot;&quot;)">
				<xsl:attribute name="ShipmentNo">
					<xsl:value-of select="ReceiptLineList/ReceiptLine/ShipmentLine/Shipment/@ShipmentNo"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="EnterpriseCode">
				<xsl:value-of select="ReceiptLineList/ReceiptLine/@EnterpriseCode"/>
			</xsl:attribute>
			<xsl:if test="normalize-space(ReceiptLineList/ReceiptLine/@ReleaseNo)!=&quot;0&quot;">
				<xsl:attribute name="ReleaseNo">
					<xsl:value-of select="ReceiptLineList/ReceiptLine/@ReleaseNo"/>
				</xsl:attribute>
			</xsl:if>
		</Shipment>
		<ReceiptLines>
        <xsl:for-each select="ReceiptLineList/ReceiptLine">
		<ReceiptLine>
			<xsl:copy-of select="@*"/>
			<xsl:if test="(OrderLine/@*)">
			  <OrderLine>
				<xsl:for-each select="OrderLine">
				<xsl:copy-of select="@*"/>
				</xsl:for-each>
			  </OrderLine>
			</xsl:if>
		</ReceiptLine>
        </xsl:for-each>
		</ReceiptLines>	  
	  </Receipt>
	</xsl:template>
</xsl:stylesheet>