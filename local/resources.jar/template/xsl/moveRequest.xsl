<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <xsl:element name="MoveRequest">
            <xsl:attribute name="FromActivityGroup">
                <xsl:text>RECEIPT</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="Release">
                <xsl:text>Y</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="Node">
                <xsl:value-of select="/Receipt/@ReceivingNode"/>
            </xsl:attribute>
            <xsl:attribute name="ShipmentKey">
                <xsl:value-of select="/Receipt/@ShipmentKey"/>
            </xsl:attribute>
            <xsl:copy-of select="/Receipt/Shipment"/>
            <xsl:variable name="unique-items"  
	       select="Receipt/ReceiptLines/ReceiptLine[not
	       (@EnterpriseCode=preceding-sibling::ReceiptLine/@EnterpriseCode 
	       and @PalletId=preceding-sibling::ReceiptLine/@PalletId 
	       and @CaseId=preceding-sibling::ReceiptLine/@CaseId 
	       and @ItemID=preceding-sibling::ReceiptLine/@ItemID 
	       and @UnitOfMeasure=preceding-sibling::ReceiptLine/@UnitOfMeasure 
	       and @ProductClass=preceding-sibling::ReceiptLine/@ProductClass
	       and (@ShipByDate=preceding-sibling::ReceiptLine/@ShipByDate or not(@ShipByDate))
	       and @TagNumber=preceding-sibling::ReceiptLine/@TagNumber)]"/>
	       
            <xsl:element name="MoveRequestLines">
                <xsl:if test="(not(/Receipt/@PalletId) or  normalize-space(/Receipt/@PalletId) = &quot;&quot;) and (not(/Receipt/@CaseId) or normalize-space(/Receipt/@CaseId) = &quot;&quot;) and normalize-space(/Receipt/@OpenReceiptFlag) = &quot;Y&quot;">
			<xsl:for-each select="$unique-items ">
				<xsl:element name="MoveRequestLine">
					<xsl:attribute name="EnterpriseCode">
						<xsl:value-of select="/Receipt/@EnterpriseCode"/>
					</xsl:attribute>
					<xsl:attribute name="PalletId">
						<xsl:value-of select="@PalletId"/>
					</xsl:attribute>
					<xsl:attribute name="CaseId">
						<xsl:value-of select="@CaseId"/>
					</xsl:attribute>
					<xsl:attribute name="ItemId">
						<xsl:value-of select="@ItemID"/>
					</xsl:attribute>
					<xsl:attribute name="UnitOfMeasure">
						<xsl:value-of select="@UnitOfMeasure"/>
					</xsl:attribute>
					<xsl:attribute name="ProductClass">
						<xsl:value-of select="@ProductClass"/>
					</xsl:attribute>
					<xsl:attribute name="RequestQuantity">
					<xsl:value-of select="sum(/Receipt/ReceiptLines/ReceiptLine[
						@EnterpriseCode=current()/@EnterpriseCode and
						@PalletId=current()/@PalletId and
						@CaseId=current()/@CaseId and
						@ItemID=current()/@ItemID and
						@UnitOfMeasure=current()/@UnitOfMeasure and
						@ProductClass=current()/@ProductClass and
						(@ShipByDate=current()/@ShipByDate or not(@ShipByDate)) and
						@TagNumber=current()/@TagNumber]/@Quantity)"/>	
					</xsl:attribute>
					<xsl:attribute name="ShipByDate">
						<xsl:value-of select="@ShipByDate"/>
					</xsl:attribute>
					<xsl:attribute name="SourceLocationId">
						<xsl:value-of select="@LocationId"/>
					</xsl:attribute>
					<xsl:if test="normalize-space(@TagNumber) != &quot;&quot;">
						<xsl:element name="MoveRequestLineTag">
							<xsl:attribute name="TagNumber"><xsl:value-of select="@TagNumber"/></xsl:attribute>
						</xsl:element>
					</xsl:if>
					<xsl:if test="normalize-space(/Receipt/ReceivingDock/Zone/@MixReceiptNo) = &quot;N&quot;">
						<xsl:attribute name="ReceiptHeaderKey"><xsl:value-of select="/Receipt/@ReceiptHeaderKey"/></xsl:attribute>
					</xsl:if>
				</xsl:element>
			</xsl:for-each>
                </xsl:if>
               <xsl:if test="normalize-space(/Receipt/@PalletId) != &quot;&quot; 
				or normalize-space(/Receipt/@CaseId) != &quot;&quot; and normalize-space(/Receipt/@OpenReceiptFlag) = &quot;Y&quot;" >
                    <xsl:element name="MoveRequestLine">
			<xsl:attribute name="ReceiptHeaderKey">
				<xsl:value-of select="/Receipt/@ReceiptHeaderKey"/>
			</xsl:attribute>
			<xsl:attribute name="EnterpriseCode">
				<xsl:value-of select="/Receipt/@EnterpriseCode"/>
			</xsl:attribute>
			<xsl:attribute name="CaseId">
				<xsl:value-of select="/Receipt/@CaseId"/>
			</xsl:attribute>
			<xsl:attribute name="PalletId">
				<xsl:value-of select="/Receipt/@PalletId"/>
			</xsl:attribute>
                    </xsl:element>
                </xsl:if>
               <xsl:if test="normalize-space(/Receipt/@OpenReceiptFlag) != &quot;Y&quot;">
                    <xsl:element name="MoveRequestLine">
			<xsl:attribute name="ReceiptHeaderKey">
				<xsl:value-of select="/Receipt/@ReceiptHeaderKey"/>
			</xsl:attribute>
			<xsl:attribute name="EnterpriseCode">
				<xsl:value-of select="/Receipt/@EnterpriseCode"/>
			</xsl:attribute>
			<xsl:attribute name="SourceLocationId">
				<xsl:value-of select="/Receipt/@ReceivingDock"/>
			</xsl:attribute>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
