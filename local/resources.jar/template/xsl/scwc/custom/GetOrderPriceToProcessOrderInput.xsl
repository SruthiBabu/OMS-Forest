<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2016 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:datetime="http://exslt.org/dates-and-times" xmlns:xalan="http://xml.apache.org/xalan" xmlns:mm="http://WCToSSFSMediationModule" xmlns:oa="http://www.openapplications.org/oagis/9" xmlns:udt="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1" xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation" xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order" xmlns:ypm="http://www.sterlingcommerce.com/documentation/YPM/getOrderPriceUE/input" xmlns:scwc="http://www.sterlingcommerce.com/scwc/"  xmlns:java="http://xml.apache.org/xslt/java" xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData" 
exclude-result-prefixes="scwc udt xalan java" extension-element-prefixes="datetime ValueMaps" version="1.0">
	<xsl:param name="scwc:ValueMapsData"/>
	<xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>
	<xsl:strip-space elements="*"/>
	<!-- The rule represents a custom mapping: "Order" to "_ord:ProcessOrder". -->
	<xsl:template name="OrderToProcessOrder" >
		<xsl:param name="Order"/>
		<xsl:variable name="OrganizationCode">
			<xsl:value-of select="$Order/@OrganizationCode"/>
		</xsl:variable>
		<xsl:variable name="storeId">
			<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $OrganizationCode)"/>
		</xsl:variable>
		<xsl:variable name="carrierServiceCode">
			<xsl:value-of select="$Order/Shipping/@CarrierServiceCode"/>
		</xsl:variable>
		<xsl:variable name="scCarrier">
			<xsl:value-of select="$Order/Shipping/@Carrier"/>
		</xsl:variable>
		<xsl:variable name="wcCarrierServiceCode">
			<!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='carrierServiceCodeToShipModeCode']/mm:Entry[@key=$carrierServiceCode]/text()" 
				/> -->
			<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'carrierServiceCodeToShipModeCode', $carrierServiceCode)"/>
		</xsl:variable>
		<xsl:variable name="shipModeCode">
			<xsl:choose>
				<xsl:when test="string-length($wcCarrierServiceCode) &gt; 0">
					<xsl:value-of select="$wcCarrierServiceCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$carrierServiceCode"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="wcCarrier">
			<!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='scacToCarrier']/mm:Entry[@key=$scCarrier]/text()" 
				/> -->
			<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'scacToCarrier', $scCarrier)"/>
		</xsl:variable>
		<xsl:variable name="scCurrency">
			<xsl:value-of select="$Order/@Currency"/>
		</xsl:variable>
		<xsl:variable name="wcCurrency">
			<!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='scCurrencyToWcCurency']/mm:Entry[@key=$scCurrency]/text()" 
				/> -->
			<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'scCurrencyToWcCurency', $scCurrency)"/>
		</xsl:variable>
		<xsl:variable name="currency">
			<xsl:choose>
				<xsl:when test="string-length($wcCurrency) &gt; 0">
					<xsl:value-of select="$wcCurrency"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$scCurrency"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="OrderNo">
			<xsl:value-of select="$Order/@OrderNo"/>
		</xsl:variable>
		<xsl:variable name="ordRef">
			<xsl:value-of select="$Order/@OrderReference"/>
		</xsl:variable>
		<_ord:ProcessOrder releaseID="">
			<oa:ApplicationArea xsi:type="_wcf:ApplicationAreaType">
				<oa:CreationDateTime xsi:type="udt:DateTimeType">
		            <xsl:variable name="datePattern">yyyy-MM-dd'T'HH:mm:ss'Z'</xsl:variable>
			    <xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new($datePattern), java:java.util.Date.new())" />
				</oa:CreationDateTime>
				<_wcf:BusinessContext>
					<_wcf:ContextData name="storeId">
						<xsl:value-of select="$storeId"/>
					</_wcf:ContextData>
				</_wcf:BusinessContext>
			</oa:ApplicationArea>
			<_ord:DataArea>
				<oa:Process>
					<oa:ActionCriteria>
						<oa:ActionExpression actionCode="CalculateExternally" expressionLanguage="_wcf:XPath">/Order[1]
						</oa:ActionExpression>
					</oa:ActionCriteria>
				</oa:Process>
				<_ord:Order>
					<_ord:OrderIdentifier>
						<xsl:choose>
							<xsl:when test="normalize-space(/Order/@CartId) !=''">
								<_wcf:UniqueID>
									<xsl:value-of select="/Order/@CartId"/>
								</_wcf:UniqueID>
							</xsl:when>
							<xsl:when test="starts-with($OrderNo, 'WC_')">
								<_wcf:UniqueID>
									<xsl:value-of select="substring-after($OrderNo, 'WC_')"/>
								</_wcf:UniqueID>
							</xsl:when>
							<xsl:otherwise>
								<_wcf:ExternalOrderID>
									<xsl:value-of select="$ordRef"/>
								</_wcf:ExternalOrderID>
							</xsl:otherwise>
						</xsl:choose> 
					</_ord:OrderIdentifier>
					<xsl:if test="string-length($storeId) &gt; 0">
						<_ord:StoreIdentifier>
							<_wcf:UniqueID>
								<xsl:value-of select="$storeId"/>
							</_wcf:UniqueID>
						</_ord:StoreIdentifier>
					</xsl:if>
					<_ord:BuyerIdentifier>
						<_wcf:ExternalIdentifier>
							<_wcf:Identifier>
								<xsl:value-of select="$Order/@BuyerUserId"/>
							</_wcf:Identifier>
						</_wcf:ExternalIdentifier>
					</_ord:BuyerIdentifier>
					<_ord:OrderTypeCode>
						<xsl:text>ORD</xsl:text>
					</_ord:OrderTypeCode>
					<_ord:OrderAmount>
						<_wcf:TotalShippingCharge>
							<xsl:attribute name="currency">
								<xsl:value-of select="$currency"/>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="string-length($Order/Shipping/@ShippingCharge) &gt; 0">
									<xsl:value-of select="$Order/Shipping/@ShippingCharge"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>0</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</_wcf:TotalShippingCharge>
					</_ord:OrderAmount>
					<!-- ShippingMode.Code information will be hard code mapped in xml, just as storeId -->
					<_ord:OrderShippingInfo>
						<_ord:ShippingMode>
							<_ord:ShippingModeIdentifier>
								<_ord:ExternalIdentifier>
									<_ord:ShipModeCode>
										<xsl:value-of select="$shipModeCode"/>
									</_ord:ShipModeCode>
									<_ord:Carrier>
										<xsl:choose>
											<xsl:when test="string-length($wcCarrier) &gt; 0">
												<xsl:value-of select="$wcCarrier"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$scCarrier"/>
											</xsl:otherwise>
										</xsl:choose>
									</_ord:Carrier>
								</_ord:ExternalIdentifier>
							</_ord:ShippingModeIdentifier>
						</_ord:ShippingMode>
					</_ord:OrderShippingInfo>
					<!-- map order item -->
					<xsl:for-each select="$Order/OrderLines/OrderLine[string-length(normalize-space(@ParentLineID)) = 0]">
						<!-- Kit pricing support -->
						<xsl:variable name="KitLineID">
							<xsl:value-of select="@LineID"/>
						</xsl:variable>
						<xsl:variable name="isKit">
							<xsl:choose>
								<xsl:when test="count(../OrderLine[@ParentLineID = $KitLineID]) &gt; 0">
									<xsl:text>Y</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>N</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!-- Prepare variables and values, includes: unitPrice, quantity, freeGiftQuantity, quantityNotFreeGift -->
						<xsl:variable name="unitprice">
							<xsl:choose>
								<xsl:when test="string-length(@UnitPrice) &gt; 0">
									<xsl:value-of select="@UnitPrice"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>0</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="quantity">
							<xsl:choose>
								<xsl:when test="string-length(@Quantity) &gt; 0">
									<xsl:value-of select="@Quantity"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>0</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!-- add free gift handling logic here -->
						<xsl:variable name="sumOfAwardAmount">
							<xsl:value-of select="sum(Awards/Award/@AwardAmount[(../@AwardType='FreeGift') and (string-length(../@AwardAmount &gt; 0))])"/>
						</xsl:variable>
						<xsl:variable name="freeGiftQuantity">
							<xsl:choose>
								<xsl:when test="$sumOfAwardAmount &lt; 0">
									<xsl:choose>
										<xsl:when test="$unitprice &gt; 0">
											<xsl:value-of select="number(0 - $sumOfAwardAmount) div $unitprice"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$quantity"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>0</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="quantityNotFreeGift">
							<xsl:value-of select="$quantity - $freeGiftQuantity"/>
						</xsl:variable>
						<!-- add isPriceForInformationOnly logic here -->
						<xsl:variable name="isPriceForInformationOnly">
							<xsl:choose>
								<xsl:when test="@IsLinePriceForInformationOnly = 'Y'">
									<xsl:text>true</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>false</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="isPriceLocked">
							<xsl:choose>
								<xsl:when test="@IsPriceLocked = 'Y'">
									<xsl:text>true</xsl:text>
								</xsl:when>
								<!-- Kit pricing support -->
								<xsl:otherwise>
									<xsl:if test="count(../OrderLine[@ParentLineID = $KitLineID and @IsPriceLocked = 'Y']) &gt; 0">
										<xsl:text>true</xsl:text>
									</xsl:if>
									<xsl:if test="count(../OrderLine[@ParentLineID = $KitLineID and @IsPriceLocked = 'Y']) = 0">
										<xsl:text>false</xsl:text>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="uomOfSC">
							<xsl:value-of select="@UnitOfMeasure"/>
						</xsl:variable>
						<xsl:variable name="uomOfWC">
							<!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='wcUOMToscUOM']/mm:Entry[text()=$uomOfSC]/@key"/> -->
							<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'wcUOMToscUOM', $uomOfSC)"/>
						</xsl:variable>
						<xsl:variable name="orderItemcarrierServiceCode">
							<xsl:value-of select="Shipping/@CarrierServiceCode"/>
						</xsl:variable>
						<xsl:variable name="orderItemscCarrier">
							<xsl:value-of select="Shipping/@Carrier"/>
						</xsl:variable>
						<xsl:variable name="orderItemwcCarrierServiceCode">
							<!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='carrierServiceCodeToShipModeCode']/mm:Entry[@key=$orderItemcarrierServiceCode]/text()" 
								/> -->
							<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'carrierServiceCodeToShipModeCode', $orderItemcarrierServiceCode)"/>
						</xsl:variable>
						<xsl:variable name="orderItemshipModeCode">
							<xsl:choose>
								<xsl:when test="string-length($orderItemwcCarrierServiceCode) &gt; 0">
									<xsl:value-of select="$orderItemwcCarrierServiceCode"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$orderItemcarrierServiceCode"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="orderItemwcCarrier">
							<!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='scacToCarrier']/mm:Entry[@key=$orderItemscCarrier]/text()" 
								/> -->
							<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'scacToCarrier', $orderItemscCarrier)"/>
						</xsl:variable>
						<xsl:variable name="lineShippingCharge">
							<xsl:choose>
								<xsl:when test="string-length(Shipping/@ShippingCharge) &gt; 0">
									<xsl:value-of select="Shipping/@ShippingCharge"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>0</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!-- If this line is totally a free gift, then set the shipping charge to free gift order item -->
						<xsl:variable name="freeGiftShippingCharge">
							<xsl:choose>
								<xsl:when test="$freeGiftQuantity &gt; 0">
									<xsl:choose>
										<xsl:when test="$quantityNotFreeGift &gt; 0 ">
											<xsl:text>0</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$lineShippingCharge"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>0</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<!-- Add normal order item section -->
						<xsl:if test="$quantityNotFreeGift &gt; 0">
							<_ord:OrderItem>
								<_ord:OrderItemIdentifier>
									<_wcf:ExternalOrderItemID>
										<xsl:value-of select="@LineID"/>
									</_wcf:ExternalOrderItemID>
								</_ord:OrderItemIdentifier>
								<_ord:CatalogEntryIdentifier>
									<_wcf:ExternalIdentifier>
										<_wcf:PartNumber>
											<xsl:value-of select="@ItemID"/>
										</_wcf:PartNumber>
									</_wcf:ExternalIdentifier>
								</_ord:CatalogEntryIdentifier>
								<_ord:Quantity>
									<xsl:attribute name="uom">
										<xsl:value-of select="$uomOfWC"/>
									</xsl:attribute>
									<xsl:value-of select="$quantityNotFreeGift"/>
								</_ord:Quantity>
								<_ord:OrderItemAmount>
									<xsl:attribute name="freeGift">false</xsl:attribute>
									<xsl:attribute name="isPriceForInformationOnly">
										<xsl:value-of select="$isPriceForInformationOnly"/>
									</xsl:attribute>
									<xsl:attribute name="priceOverride">
										<xsl:value-of select="$isPriceLocked"/>
									</xsl:attribute>
									<_wcf:UnitPrice>
										<_wcf:Price>
											<xsl:attribute name="currency">
												<xsl:value-of select="$currency"/>
											</xsl:attribute>
											<!-- Kit pricing support -->
											<xsl:choose>
												<xsl:when test="$isKit = 'Y'">
													<xsl:variable name="tempUnitPriceSumOfComponents">
														<xsl:call-template name="sumUnitPriceOfComponents">
															<xsl:with-param name="componentNodes" select="../OrderLine[@ParentLineID = $KitLineID and (not(@IsLinePriceForInformationOnly) or @IsLinePriceForInformationOnly = 'N')]"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:variable name="kitUnitPriceTotal">
														<xsl:value-of select="$tempUnitPriceSumOfComponents"/>
													</xsl:variable>
													<xsl:value-of select="format-number($unitprice + $kitUnitPriceTotal,'#.00000')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$unitprice"/>
												</xsl:otherwise>
											</xsl:choose>
										</_wcf:Price>
									</_wcf:UnitPrice>
									<_wcf:OrderItemPrice>
										<xsl:attribute name="currency">
											<xsl:value-of select="$currency"/>
										</xsl:attribute>
										<!-- Kit pricing support -->
										<xsl:choose>
											<xsl:when test="$isKit = 'Y'">
												<xsl:variable name="tempSumOfComponents">
													<xsl:call-template name="sumOfComponents">
														<xsl:with-param name="componentNodes" select="../OrderLine[@ParentLineID = $KitLineID and (not(@IsLinePriceForInformationOnly) or @IsLinePriceForInformationOnly = 'N')]"/>
													</xsl:call-template>
												</xsl:variable>
												<xsl:variable name="kitTotal">
													<xsl:value-of select="$tempSumOfComponents"/>
												</xsl:variable>
												<xsl:value-of select="format-number($unitprice * $quantityNotFreeGift + $kitTotal,'#.00000')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$unitprice * $quantityNotFreeGift"/>
											</xsl:otherwise>
										</xsl:choose>
									</_wcf:OrderItemPrice>
									<_wcf:ShippingCharge>
										<xsl:attribute name="currency">
											<xsl:value-of select="$currency"/>
										</xsl:attribute>
										<xsl:value-of select="$lineShippingCharge"/>
									</_wcf:ShippingCharge>
								</_ord:OrderItemAmount>
								<!-- add shipping mode id information here, order level shipping mode is applicable for each 
									order item -->
								<_ord:OrderItemShippingInfo>
									<_ord:ShippingMode>
										<_ord:ShippingModeIdentifier>
											<_ord:ExternalIdentifier>
												<_ord:ShipModeCode>
													<xsl:value-of select="$orderItemshipModeCode"/>
												</_ord:ShipModeCode>
												<_ord:Carrier>
													<xsl:choose>
														<xsl:when test="string-length($orderItemwcCarrier) &gt; 0">
															<xsl:value-of select="$orderItemwcCarrier"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$orderItemscCarrier"/>
														</xsl:otherwise>
													</xsl:choose>
												</_ord:Carrier>
											</_ord:ExternalIdentifier>
										</_ord:ShippingModeIdentifier>
									</_ord:ShippingMode>
								</_ord:OrderItemShippingInfo>
								<_ord:CorrelationGroup>
									<xsl:value-of select="@LineID"/>
								</_ord:CorrelationGroup>
								<!-- Kit pricing support -->
								<xsl:if test="$isKit = 'Y' and $isPriceLocked = 'false'">
									<!-- populate Kit components -->
									<xsl:variable name="parentQuantity">
										<xsl:value-of select="$quantity"/>
									</xsl:variable>
									<xsl:for-each select="../OrderLine[@ParentLineID = $KitLineID]">
										<_ord:OrderItemComponent>
											<_ord:CatalogEntryIdentifier>
												<_wcf:ExternalIdentifier>
													<_wcf:PartNumber>
														<xsl:value-of select="@ItemID"/>
													</_wcf:PartNumber>
												</_wcf:ExternalIdentifier>
											</_ord:CatalogEntryIdentifier>
											<xsl:variable name="componentQuantity">
												<xsl:choose>
													<xsl:when test="string-length(@Quantity) &gt; 0 and $parentQuantity &gt; 0">
														<xsl:value-of select="format-number(@Quantity div $parentQuantity, '#.0')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>0</xsl:text>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="componentUnitprice">
												<xsl:choose>
													<xsl:when test="string-length(@UnitPrice) &gt; 0">
														<xsl:value-of select="@UnitPrice"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>0</xsl:text>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="uomForSC">
												<xsl:choose>
													<xsl:when test="string-length(@UnitOfMeasure) &gt; 0">
														<xsl:value-of select="@UnitOfMeasure"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>EACH</xsl:text>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="uomForWC">
												<!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='wcUOMToscUOM']/mm:Entry[text()=$uomForSC]/@key"/> -->
												<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'wcUOMToscUOM', $uomForSC)"/>
											</xsl:variable>
											<_ord:Quantity>
												<xsl:attribute name="uom">
													<xsl:value-of select="$uomForWC"/>
												</xsl:attribute>
												<xsl:value-of select="$componentQuantity"/>
											</_ord:Quantity>
											<_ord:UnitPrice>
												<xsl:value-of select="$componentUnitprice"/>
											</_ord:UnitPrice>
										</_ord:OrderItemComponent>
									</xsl:for-each>
								</xsl:if>
							</_ord:OrderItem>
						</xsl:if>
						<!-- Add free gift item if have -->
						<xsl:if test="$freeGiftQuantity &gt; 0">
							<_ord:OrderItem>
								<_ord:OrderItemIdentifier>
									<_wcf:ExternalOrderItemID>
										<xsl:choose>
											<xsl:when test="$quantityNotFreeGift &gt; 0">
												<xsl:value-of select="@LineID"/>
												<xsl:text>F</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@LineID"/>
											</xsl:otherwise>
										</xsl:choose>
									</_wcf:ExternalOrderItemID>
								</_ord:OrderItemIdentifier>
								<_ord:CatalogEntryIdentifier>
									<_wcf:ExternalIdentifier>
										<_wcf:PartNumber>
											<xsl:value-of select="@ItemID"/>
										</_wcf:PartNumber>
									</_wcf:ExternalIdentifier>
								</_ord:CatalogEntryIdentifier>
								<_ord:Quantity>
									<xsl:attribute name="uom">
										<xsl:value-of select="$uomOfWC"/>
									</xsl:attribute>
									<xsl:value-of select="$freeGiftQuantity"/>
								</_ord:Quantity>
								<_ord:OrderItemAmount>
									<xsl:attribute name="freeGift">true</xsl:attribute>
									<xsl:attribute name="isPriceForInformationOnly">
										<xsl:value-of select="$isPriceForInformationOnly"/>
									</xsl:attribute>
									<xsl:attribute name="priceOverride">
										<xsl:value-of select="$isPriceLocked"/>
									</xsl:attribute>
									<_wcf:UnitPrice>
										<_wcf:Price>
											<xsl:attribute name="currency">
												<xsl:value-of select="$currency"/>
											</xsl:attribute>
											<xsl:value-of select="$unitprice"/>
										</_wcf:Price>
									</_wcf:UnitPrice>
									<_wcf:OrderItemPrice>
										<xsl:attribute name="currency">
											<xsl:value-of select="$currency"/>
										</xsl:attribute>
										<xsl:value-of select="$unitprice * $freeGiftQuantity"/>
									</_wcf:OrderItemPrice>
									<_wcf:ShippingCharge>
										<xsl:attribute name="currency">
											<xsl:value-of select="$currency"/>
										</xsl:attribute>
										<xsl:value-of select="$freeGiftShippingCharge"/>
									</_wcf:ShippingCharge>
								</_ord:OrderItemAmount>
								<!-- add shipping mode id information here, order level shipping mode is applicable for each 
									order item -->
								<_ord:OrderItemShippingInfo>
									<_ord:ShippingMode>
										<_ord:ShippingModeIdentifier>
											<_ord:ExternalIdentifier>
												<_ord:ShipModeCode>
													<xsl:value-of select="$orderItemshipModeCode"/>
												</_ord:ShipModeCode>
												<_ord:Carrier>
													<xsl:choose>
														<xsl:when test="string-length($orderItemwcCarrier) &gt; 0">
															<xsl:value-of select="$orderItemwcCarrier"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$orderItemscCarrier"/>
														</xsl:otherwise>
													</xsl:choose>
												</_ord:Carrier>
											</_ord:ExternalIdentifier>
										</_ord:ShippingModeIdentifier>
									</_ord:ShippingMode>
								</_ord:OrderItemShippingInfo>
								<!-- set freegift's CorrelationGroup -->
								<_ord:CorrelationGroup>
									<xsl:value-of select="@LineID"/>
								</_ord:CorrelationGroup>
							</_ord:OrderItem>
						</xsl:if>
					</xsl:for-each>
					<xsl:variable name="paymentType">
						<xsl:value-of select="$Order/PaymentMethod/@PaymentType"/>
					</xsl:variable>
					<!-- <xsl:variable name="paymentTypeForMapping" select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='wcPaymentMethodToSCPaymentType']/mm:Entry[text()=$paymentType]/@key"/> -->
					<xsl:variable name="paymentTypeForMapping" select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'wcPaymentMethodToSCPaymentType', $paymentType)"/>
					<xsl:variable name="wcPaymentMethodValue">
						<xsl:choose>
							<xsl:when test="string-length($paymentTypeForMapping) &gt; 0">
								<xsl:value-of select="$paymentTypeForMapping"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$paymentType"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- Payment method information mapping -->
					<xsl:if test="string-length($paymentType) &gt; 0">
						<_ord:OrderPaymentInfo>
							<_ord:PaymentInstruction>
								<_ord:PaymentMethod>
									<_ord:PaymentMethodName>
										<xsl:choose>
											<xsl:when test="$paymentType = 'CREDIT_CARD'">
												<xsl:variable name="creditCardTypeForMapping" select="$Order/PaymentMethod/@CreditCardType"/>
												<!-- <xsl:variable name="paymentMethodForMapping" select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='scCreditCardTypeTowcCreditCardTypeForCreditCard']/mm:Entry[@key=$creditCardTypeForMapping]/text()"/> -->
												<xsl:variable name="paymentMethodForMapping" select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'scCreditCardTypeTowcCreditCardTypeForCreditCard', $creditCardTypeForMapping)"/>
												<xsl:if test="string-length($paymentMethodForMapping) &gt; 0">
													<xsl:value-of select="$paymentMethodForMapping"/>
												</xsl:if>
												<xsl:if test="string-length($paymentMethodForMapping) = 0">
													<xsl:value-of select="$creditCardTypeForMapping"/>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$wcPaymentMethodValue"/>
											</xsl:otherwise>
										</xsl:choose>
									</_ord:PaymentMethodName>
								</_ord:PaymentMethod>
							</_ord:PaymentInstruction>
						</_ord:OrderPaymentInfo>
					</xsl:if>
					<_ord:CalculationInfo>
						<_ord:Usage>
							<xsl:text>-1,-7</xsl:text>
						</_ord:Usage>
						<_ord:PriceUpdateFlag>
							<xsl:text>AlwaysUpdate</xsl:text>
						</_ord:PriceUpdateFlag>
						<xsl:for-each select="$Order/ManualAdjustments/ManualAdjustment">
							<_ord:ExtraAdjustments>
								<xsl:choose>
									<xsl:when test="string-length(@AdjustmentID) &gt; 0 and @AdjustmentID != -11 and @AdjustmentID != -12 ">
										<_ord:CalculationCodeIdentifier>
											<_wcf:UniqueID>
												<xsl:text>-11</xsl:text>
											</_wcf:UniqueID>
										</_ord:CalculationCodeIdentifier>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="string-length(@AdjustmentID) &gt; 0">
											<_ord:CalculationCodeIdentifier>
												<_wcf:UniqueID>
													<xsl:value-of select="@AdjustmentID"/>
												</_wcf:UniqueID>
											</_ord:CalculationCodeIdentifier>
										</xsl:if>
										<xsl:if test="string-length(@AdjustmentID) = 0">
											<_ord:CalculationCodeIdentifier>
												<_wcf:UniqueID>
													<xsl:text>-11</xsl:text>
												</_wcf:UniqueID>
											</_ord:CalculationCodeIdentifier>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
								<_ord:IsOverrideExistingAdjustments>
									<xsl:text>false</xsl:text>
								</_ord:IsOverrideExistingAdjustments>
								<_ord:AdjustmentApplyPolicy>
									<xsl:text>FixedReplacement</xsl:text>
								</_ord:AdjustmentApplyPolicy>
								<_ord:AdjustmentApplyAmount>
									<xsl:variable name="orderAdjustment">
										<xsl:choose>
											<xsl:when test="string-length(@Adjustment) &gt; 0">
												<xsl:value-of select="@Adjustment"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>0</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="$orderAdjustment"/>
								</_ord:AdjustmentApplyAmount>
								<_ord:OrderItemIdentifier>
									<_wcf:ExternalOrderItemID>
										<xsl:text/>
									</_wcf:ExternalOrderItemID>
								</_ord:OrderItemIdentifier>
							</_ord:ExtraAdjustments>
						</xsl:for-each>
						<xsl:for-each select="$Order/OrderLines/OrderLine">
							<xsl:variable name="lineID">
								<xsl:value-of select="@LineID"/>
							</xsl:variable>
							<xsl:variable name="lineQuantity">
								<xsl:choose>
									<xsl:when test="string-length(@Quantity) &gt; 0">
										<xsl:value-of select="@Quantity"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>0</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<!-- Only if the quantity >0, we need to pass in the manual adjustment..That happens on order 
								cancel scenario -->
							<xsl:if test="number($lineQuantity) &gt; 0">
								<xsl:for-each select="ManualAdjustments/ManualAdjustment">
									<xsl:variable name="lineAdjustmentPerUnit">
										<xsl:choose>
											<xsl:when test="string-length(@AdjustmentPerUnit) &gt; 0">
												<xsl:value-of select="@AdjustmentPerUnit"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>0</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="lineAdjustmentPerLine">
										<xsl:choose>
											<xsl:when test="string-length(@AdjustmentPerLine) &gt; 0">
												<xsl:value-of select="@AdjustmentPerLine"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>0</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<_ord:ExtraAdjustments>
										<_ord:CalculationCodeIdentifier>
											<_wcf:UniqueID>
												<xsl:text>-10</xsl:text>
											</_wcf:UniqueID>
										</_ord:CalculationCodeIdentifier>
										<_ord:IsOverrideExistingAdjustments>
											<xsl:text>false</xsl:text>
										</_ord:IsOverrideExistingAdjustments>
										<_ord:AdjustmentApplyPolicy>
											<xsl:text>FixedReplacement</xsl:text>
										</_ord:AdjustmentApplyPolicy>
										<_ord:AdjustmentApplyAmount>
											<xsl:variable name="adjustmentValue">
												<xsl:value-of select="$lineQuantity * $lineAdjustmentPerUnit + $lineAdjustmentPerLine"/>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="string-length($adjustmentValue) &gt; 0">
													<xsl:value-of select="$adjustmentValue"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>0</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</_ord:AdjustmentApplyAmount>
										<_ord:OrderItemIdentifier>
											<_wcf:ExternalOrderItemID>
												<xsl:value-of select="$lineID"/>
											</_wcf:ExternalOrderItemID>
										</_ord:OrderItemIdentifier>
									</_ord:ExtraAdjustments>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="$Order/@PricingDate">
							<_ord:PricingDate>
								<xsl:value-of select="$Order/@PricingDate"/>
							</_ord:PricingDate>
						</xsl:if>
					</_ord:CalculationInfo>
					<!-- map coupon and promotion code -->
					<xsl:for-each select="$Order/Coupons/Coupon">
						<xsl:if test="string-length(@CouponID) &gt; 0 ">
							<_ord:PromotionCode>
								<_ord:Code>
									<xsl:value-of select="@CouponID"/>
								</_ord:Code>
							</_ord:PromotionCode>
						</xsl:if>
					</xsl:for-each>
				</_ord:Order>
			</_ord:DataArea>
		</_ord:ProcessOrder>
	</xsl:template>
	<!-- Kit pricing support-use recursion instead of java for efficiency consideration -->
	<xsl:template name="sumOfComponents">
		<xsl:param name="componentNodes"/>
		<xsl:param name="sum" select="0"/>
		<xsl:variable name="curr" select="$componentNodes[1]"/>
		<xsl:if test="$curr">
			<xsl:variable name="runningsum" select="$sum + $curr/@UnitPrice * $curr/@Quantity"/>
			<xsl:call-template name="sumOfComponents">
				<xsl:with-param name="componentNodes" select="$componentNodes[position() &gt; 1]"/>
				<xsl:with-param name="sum" select="$runningsum"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not($curr)">
			<xsl:value-of select="$sum"/>
		</xsl:if>
	</xsl:template>
	<!-- Kit unit pricing support-use recursion instead of java for efficiency consideration -->
	<xsl:template name="sumUnitPriceOfComponents">
		<xsl:param name="componentNodes"/>
		<xsl:param name="sum" select="0"/>
		<xsl:variable name="curr" select="$componentNodes[1]"/>
		<xsl:if test="$curr">
			<xsl:variable name="runningsum" select="$sum + $curr/@UnitPrice"/>
			<xsl:call-template name="sumUnitPriceOfComponents">
				<xsl:with-param name="componentNodes" select="$componentNodes[position() &gt; 1]"/>
				<xsl:with-param name="sum" select="$runningsum"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="not($curr)">
			<xsl:value-of select="$sum"/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
