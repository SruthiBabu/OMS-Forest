<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 	xmlns:oa="http://www.openapplications.org/oagis/9" 	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation" 	xmlns:_prc="http://www.ibm.com/xmlns/prod/commerce/9/price" 	xmlns:mm="http://WCToSSFSMediationModule" 	xmlns="http://www.sterlingcommerce.com/documentation/YPM/getItemPriceUE/output" 	xmlns:scwc="http://www.sterlingcommerce.com/scwc/" 	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData" 	extension-element-prefixes="ValueMaps" 	version="1.0">
	<xsl:param name="scwc:ValueMapsData" />
	<xsl:output	method="xml"	encoding="UTF-8"	omit-xml-declaration="yes"	indent="no" />
	<xsl:strip-space elements="*" />
	
	<xsl:template match="/ResponseData/Body/Errors">
		<xsl:copy-of select="/ResponseData/Body/Errors"/>
	  </xsl:template>	
	
	<xsl:template name="ShowEntitledPriceToItemPrice" match="/ResponseData/Body/_prc:ShowEntitledPrice">
		<xsl:variable	name="ShowEntitledPrice"	select="/ResponseData/Body/_prc:ShowEntitledPrice" />
		<xsl:variable	name="ItemPriceCorrelation"	select="/ResponseData/context/correlation" />
		
		<xsl:variable	name="dataArea"	select="$ShowEntitledPrice/_prc:DataArea" />
		<ItemPrice SuppressRuleExecution="Y">
			<xsl:attribute name="BuyerUserId">
				<xsl:value-of select="$ItemPriceCorrelation/@BuyerUserId" />
			</xsl:attribute>
			<xsl:attribute name="CustomerID">
				<xsl:value-of select="$ItemPriceCorrelation/@CustomerID" />
			</xsl:attribute>
			<xsl:attribute name="EnterpriseCode">
				<xsl:value-of select="$ItemPriceCorrelation/@EnterpriseCode" />
			</xsl:attribute>
			<xsl:attribute name="OrganizationCode">
				<xsl:value-of select="$ItemPriceCorrelation/@OrganizationCode" />
			</xsl:attribute>
			<xsl:attribute name="Currency">
				<xsl:value-of	select="$dataArea/_prc:EntitledPrice[1]/_prc:UnitPrice/_wcf:Price/@currency" />
			</xsl:attribute>
			<xsl:if test="normalize-space($ItemPriceCorrelation/@PricingDate)!=''">
				<xsl:attribute name="PricingDate">
					<xsl:value-of select="$ItemPriceCorrelation/@PricingDate" />
				</xsl:attribute>
			</xsl:if>
			<LineItems>
				<xsl:for-each select="$dataArea/_prc:EntitledPrice">
					<xsl:variable	name="itemID"	select="_prc:CatalogEntryIdentifier/_wcf:ExternalIdentifier/_wcf:PartNumber">
					</xsl:variable>
					<xsl:variable name="lineId">
						<xsl:for-each select="$dataArea/_prc:EntitledPrice">
							<xsl:variable	name="count"	select="number(position())">
							</xsl:variable>
							<xsl:variable	name="temp"	select="$ItemPriceCorrelation/LineItems/LineItem[$count]/@ItemID">
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$temp=$itemID">
									<xsl:value-of select="$ItemPriceCorrelation/LineItems/LineItem[$count]/@LineID" />
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</xsl:variable>
					<LineItem PercentAdjustment="0">
						<xsl:variable	name="unitPrice"	select="_prc:UnitPrice/_wcf:Price" />
						<xsl:variable	name="quantity"	select="_prc:UnitPrice/_wcf:Quantity" />
						<xsl:variable	name="uomOfWC"	select="_prc:UnitPrice/_wcf:Quantity/@uom" />
						<!-- <xsl:variable name="uomOfSC" select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='wcUOMToscUOM']/mm:Entry[@key=$uomOfWC]/text()" 	/> --><xsl:variable	name="uomOfSC"	select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcUOMToscUOM', $uomOfWC)" />
						<xsl:variable	name="lineAdjustment"	select="number(0)" />
						<xsl:choose>
							<xsl:when test="$quantity">
								<xsl:variable	name="extendedPrice"	select="number($unitPrice)*number($quantity)" />
								<xsl:attribute name="ExtendedPrice">
									<xsl:value-of select="$extendedPrice" />
								</xsl:attribute>
								<xsl:attribute name="LinePrice">
									<xsl:value-of select="$extendedPrice + $lineAdjustment" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable	name="extendedPrice"	select="number($unitPrice)*1" />
								<xsl:attribute name="ExtendedPrice">
									<xsl:value-of select="$extendedPrice" />
								</xsl:attribute>
								<xsl:attribute name="LinePrice">
									<xsl:value-of select="$extendedPrice + $lineAdjustment" />
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:attribute name="LineAdjustment">
							<xsl:value-of select="$lineAdjustment" />
						</xsl:attribute>
						<xsl:attribute name="LineID">
							<xsl:value-of select="$lineId" />
						</xsl:attribute>
						<xsl:attribute name="ItemID">
							<xsl:value-of select="$itemID" />
						</xsl:attribute>
						<xsl:attribute name="UnitPrice">
							<xsl:value-of select="$unitPrice" />
						</xsl:attribute>
						<xsl:attribute name="Quantity">
							<xsl:value-of select="$quantity" />
						</xsl:attribute>
						<xsl:attribute name="UnitOfMeasure">
							<xsl:value-of select="$uomOfSC" />
						</xsl:attribute>
						<xsl:attribute name="ListPrice">
							<xsl:value-of select="$unitPrice" />
						</xsl:attribute>
						<LineAdjustments>
							<Adjustment AdjustmentApplied="0" />
						</LineAdjustments>
						<xsl:if test="_prc:RangePrice">
						<SelectedPricelistLine>
							<PricelistLineQuantityTierList>
								<xsl:for-each select="_prc:RangePrice">
									<xsl:variable	name="rangePriceUomOfWC"	select="_prc:MinimumQuantity/@uom" />
									<!-- <xsl:variable name="rangePriceUomOfSC" select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='wcUOMToscUOM']/mm:Entry[@key=$rangePriceUomOfWC]/text()" 	/> --><xsl:variable	name="rangePriceUomOfSC"	select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcUOMToscUOM', $rangePriceUomOfWC)" />
									<PricelistLineQuantityTier>
										<xsl:if test="normalize-space(_prc:MinimumQuantity)!=''">
											<xsl:attribute name="FromQuantity">
												<xsl:value-of select="number(_prc:MinimumQuantity)" />
											</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="UnitOfMeasure">
											<xsl:value-of select="$rangePriceUomOfSC" />
										</xsl:attribute>
										<xsl:if test="normalize-space(_prc:MaximumQuantity)!=''">
											<xsl:attribute name="ToQuantity">
												<xsl:value-of select="number(_prc:MaximumQuantity)+1" />
											</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="UnitPrice">
											<xsl:value-of select="_prc:Value" />
										</xsl:attribute>
										<xsl:attribute name="ListPrice">
											<xsl:value-of select="_prc:Value" />
										</xsl:attribute>
									</PricelistLineQuantityTier>
								</xsl:for-each>
							</PricelistLineQuantityTierList>
						</SelectedPricelistLine>
						</xsl:if>
					</LineItem>
				</xsl:for-each>
			</LineItems>
		</ItemPrice>
	</xsl:template>
	
</xsl:stylesheet>