<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
(C) Copyright IBM Corp. 2005, 2016 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:mm="http://WCToSSFSMediationModule"
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order"
	xmlns="http://www.sterlingcommerce.com/documentation/YFS/createOrder/input"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
    xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps" 
	exclude-result-prefixes="xalan mm _wcf _ord"
	version="1.0">
	
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="no" />
	<xsl:strip-space elements="*" />
	<xsl:param name="scwc:ValueMapsData"/>
	
  <xsl:template name="ProcessOrderToOrder" match="/">
    <xsl:param name="ProcessOrder"/>
    <xsl:variable name="order" select="/_ord:ProcessOrder/_ord:DataArea/_ord:Order" />
		
		<xsl:variable name="storeId"><xsl:value-of select="$order/_ord:StoreIdentifier/_wcf:UniqueID/text()" /></xsl:variable>
		<xsl:variable name="OrganizationCode">
			<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $storeId)" />
		</xsl:variable>
		
		<Order>
			<xsl:attribute name="OrderNo">
				<xsl:text>WC_</xsl:text><xsl:value-of select="$order/_ord:OrderIdentifier/_wcf:UniqueID" />
			</xsl:attribute>
			<xsl:attribute name="EnterpriseCode"><xsl:value-of select="$OrganizationCode" /></xsl:attribute>
			<xsl:attribute name="SellerOrganizationCode"><xsl:value-of select="$OrganizationCode" /></xsl:attribute>			
			<xsl:attribute name="BuyerUserId"><xsl:value-of select="$order/_ord:BuyerIdentifier/_wcf:ExternalIdentifier/_wcf:Identifier" /></xsl:attribute>
			<xsl:attribute name="AuthorizedClient">WCS</xsl:attribute>
			<xsl:attribute name="EntryType">WCS</xsl:attribute>
			<xsl:attribute name="OrderDate">
					<xsl:value-of select="$order/_ord:PlacedDate" />
				</xsl:attribute>
			<xsl:attribute name="ValidatePromotionAward">N</xsl:attribute>
			<xsl:attribute name="BypassPricing">Y</xsl:attribute>
			
			<!-- FEP5 and FEP3 enhancement -->
			<xsl:choose>
				<xsl:when test="normalize-space($order/@shipAsComplete)!=''">
					<xsl:if test="$order/@shipAsComplete='true'">
						<xsl:attribute name="IsShipComplete">Y</xsl:attribute>
					</xsl:if>
					<xsl:if test="$order/@shipAsComplete='false'">
						<xsl:attribute name="IsShipComplete">N</xsl:attribute>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:attribute name="CarrierServiceCode">
			<xsl:variable name="wcShipModeCode1" select="$order/_ord:OrderShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:ShipModeCode" />
			<xsl:variable name="tempShipModeCode1"><xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'carrierServiceCodeToShipModeCode', $wcShipModeCode1)" /></xsl:variable>
			<xsl:choose>
				<xsl:when test="string-length(normalize-space($tempShipModeCode1)) &gt; 0">
					<xsl:value-of select="$tempShipModeCode1" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$wcShipModeCode1" />
				</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>

			<xsl:attribute name="SCAC">
			<xsl:variable name="wcCarrierCode1" select="$order/_ord:OrderShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:Carrier" />
			<xsl:variable name="tempCarrierCode1"><xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'scacToCarrier', $wcCarrierCode1)" /></xsl:variable>
			<xsl:choose>
				<xsl:when test="string-length(normalize-space($tempCarrierCode1)) &gt; 0">
					<xsl:value-of select="$tempCarrierCode1" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$wcCarrierCode1" />
				</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			
			
			<PriceInfo>
			<xsl:attribute name="Currency">
				<xsl:variable name="currencyToCurrencyName" select="$order/_ord:OrderAmount/_wcf:TotalProductPrice/@currency" />
				<xsl:variable name="sccurrencyToCurrencyName">
					<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'scCurrencyToWcCurency', $currencyToCurrencyName)" />
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="string-length(normalize-space($sccurrencyToCurrencyName)) &gt; 0">
						<xsl:value-of select="$sccurrencyToCurrencyName" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$currencyToCurrencyName" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			</PriceInfo>
			
			<OrderLines>
				<xsl:for-each select="$order/_ord:OrderItem">
					<xsl:variable name="wcShipNode">
					    <xsl:value-of select="_ord:FulfillmentCenter/_ord:FulfillmentCenterIdentifier/_wcf:Name" />
					</xsl:variable>
					<xsl:variable name="scShipNode">
					    <xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'wcShipNodeToscShipNode', $wcShipNode)" />    	
					</xsl:variable>
					<xsl:variable name="wcStore">
					    <xsl:value-of select="_ord:OrderItemShippingInfo/_ord:PhysicalStoreIdentifier/_wcf:ExternalIdentifier" />
					</xsl:variable>
					<xsl:variable name="scStore">
						<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'wcPhysicalStoreToscStore', $wcStore)" /> 
					</xsl:variable>
					<xsl:variable name="shipNode">
					    <xsl:choose>
						<xsl:when test="_ord:OrderItemShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:ShipModeCode = 'PickupInStore'">
						    <xsl:choose>
							    <xsl:when test="string-length(normalize-space($scStore)) &gt; 0">
								    <xsl:value-of select="$scStore" />
							    </xsl:when>
							    <xsl:otherwise>
								    <xsl:value-of select="$wcStore" />
							    </xsl:otherwise>
						    </xsl:choose>				   
						</xsl:when>
						<xsl:otherwise>
						    <xsl:choose>
							    <xsl:when test="string-length(normalize-space($scShipNode)) &gt; 0">
								    <xsl:value-of select="$scShipNode" />
							    </xsl:when>
							    <xsl:otherwise>
								    <xsl:value-of select="$wcShipNode" />
							    </xsl:otherwise>
						    </xsl:choose>							
						</xsl:otherwise>
					    </xsl:choose>
					</xsl:variable>
					<OrderLine>
						<xsl:choose>
							<xsl:when test="contains(_ord:OrderItemIdentifier/_wcf:UniqueID, '-')">
								<!-- FEP5 and FEP3 enhancement, remove PrimeLineNo -->
								<xsl:attribute name="SubLineNo">
									<xsl:value-of select="substring-after(_ord:OrderItemIdentifier/_wcf:UniqueID, '-')" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:attribute name="OrderedQty">
							<xsl:value-of select="_ord:Quantity" />
						</xsl:attribute>
						<xsl:attribute name="FillQuantity">
							<xsl:value-of select="_ord:Quantity" />
						</xsl:attribute>
						<xsl:attribute name="CarrierServiceCode">
						<!-- FEP5 and FEP3 enhancement -->
						<xsl:variable name="wcShipModeCode" select="_ord:OrderItemShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:ShipModeCode" />
						<xsl:variable name="tempShipModeCode">
							<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'carrierServiceCodeToShipModeCode', $wcShipModeCode)" />
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="string-length(normalize-space($tempShipModeCode)) &gt; 0">
								<xsl:value-of select="$tempShipModeCode" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$wcShipModeCode" />
							</xsl:otherwise>
						</xsl:choose>
						</xsl:attribute>

						<xsl:attribute name="SCAC">
							<xsl:variable name="wcCarrierCode" select="_ord:OrderItemShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:Carrier" />
							<xsl:variable name="tempCarrierCode"><xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'scacToCarrier', $wcCarrierCode)" /></xsl:variable>
							<xsl:choose>
								<xsl:when test="string-length(normalize-space($tempCarrierCode)) &gt; 0">
									<xsl:value-of select="$tempCarrierCode" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$wcCarrierCode" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>

						<!-- support multiple fulfillment center, remove ShipNode in OrderLine -->
						
						<xsl:attribute name="ReqShipDate">
							<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:RequestedShipDate" />
						</xsl:attribute>
						<xsl:attribute name="BOMXML">
							<xsl:value-of select="_ord:OrderItemConfiguration" />
						</xsl:attribute>
						
						<xsl:choose>
							<xsl:when
								test="_ord:OrderItemShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:ShipModeCode = 'PickupInStore'">
								<xsl:attribute name="DeliveryMethod">PICK</xsl:attribute>
								<xsl:attribute name="ShipNode"><xsl:value-of select="$shipNode" /></xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="DeliveryMethod">SHP</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						
						<!-- FEP5 and FEP3 enhancement -->
						<xsl:choose>
							<xsl:when test="contains(_ord:OrderItemIdentifier/_wcf:UniqueID, '-')">
								<References>
									<Reference>
										<xsl:attribute name="Name">WC_OrderLineID</xsl:attribute>
										<xsl:attribute name="Value">
											<xsl:value-of select="substring-before(_ord:OrderItemIdentifier/_wcf:UniqueID,'-')" />
										</xsl:attribute>
									</Reference>
								</References>
							</xsl:when>
							<xsl:otherwise>
								<References>
									<Reference>
										<xsl:attribute name="Name">WC_OrderLineID</xsl:attribute>
										<xsl:attribute name="Value">
											<xsl:value-of select="_ord:OrderItemIdentifier/_wcf:UniqueID" />
										</xsl:attribute>
									</Reference>
								</References>
							</xsl:otherwise>
						</xsl:choose>

						<!-- FEP5 and FEP3 enhancement -->
						<xsl:choose>
							<xsl:when test="normalize-space(_ord:OrderItemShippingInfo/_ord:ShippingInstruction)!=''">
								<Instructions>
									<Instruction>
										<xsl:attribute name="InstructionType">SHIP</xsl:attribute>
										<xsl:attribute name="InstructionText">
											<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingInstruction" />
										</xsl:attribute>
									</Instruction>
								</Instructions>
							</xsl:when>
							<xsl:otherwise>
							</xsl:otherwise>
						</xsl:choose>
						
						<OrderLineReservations>
						<xsl:variable name="ExpectedShipDate"><xsl:value-of select="_ord:OrderItemFulfillmentInfo/_ord:ExpectedShipDate" /></xsl:variable>
						
						<xsl:if test="_ord:FulfillmentCenter/_ord:FulfillmentCenterIdentifier">					
							<xsl:for-each select="_ord:OrderItemComponent">								
								<OrderLineReservation>
									<xsl:attribute name="ItemID">
										<xsl:value-of select="_ord:CatalogEntryIdentifier/_wcf:ExternalIdentifier/_wcf:PartNumber" />
									</xsl:attribute>
									<xsl:attribute name="Node">
										<xsl:value-of select="$shipNode" />
									</xsl:attribute>
									<xsl:attribute name="ReservationID">
										<xsl:text>WC_</xsl:text><xsl:value-of select="$order/_ord:OrderIdentifier/_wcf:UniqueID" />
									</xsl:attribute>
									<xsl:attribute name="Quantity">
										<xsl:value-of select="number(_ord:Quantity)*number(../_ord:Quantity)" />
									</xsl:attribute>
									<xsl:attribute name="UnitOfMeasure">
									
										<xsl:variable name="itemComponentLineReservationQuantityUOM" select="_ord:Quantity/@uom" />
										<xsl:variable name="scitemComponentLineReservationQuantityUOM">
											<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'wcUOMToscUOM', $itemComponentLineReservationQuantityUOM)" />
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="string-length(normalize-space($scitemComponentLineReservationQuantityUOM)) &gt; 0">
												<xsl:value-of select="$scitemComponentLineReservationQuantityUOM" />
											</xsl:when>
											<xsl:otherwise>EACH</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:if test="$ExpectedShipDate">
										<xsl:attribute name="RequestedReservationDate">
											<xsl:value-of select="mediationUtil:dateTimeToDate($ExpectedShipDate)"/>
										</xsl:attribute>
									</xsl:if>									
								</OrderLineReservation>								
							</xsl:for-each>									
							
							<xsl:if test="not(_ord:OrderItemComponent/_ord:CatalogEntryIdentifier)">				
							<OrderLineReservation>
								<xsl:attribute name="ItemID">
									<xsl:value-of select="_ord:CatalogEntryIdentifier/_wcf:ExternalIdentifier/_wcf:PartNumber" />
								</xsl:attribute>
								<xsl:attribute name="Node">
								    <xsl:value-of select="$shipNode" />
								</xsl:attribute>
								<xsl:attribute name="ReservationID">
									<xsl:text>WC_</xsl:text><xsl:value-of select="$order/_ord:OrderIdentifier/_wcf:UniqueID" />
								</xsl:attribute>
								<xsl:attribute name="Quantity">
									<xsl:value-of select="_ord:Quantity" />
								</xsl:attribute>
								<xsl:attribute name="UnitOfMeasure">
								
								<xsl:variable name="lineReservationQuantityUOM" select="_ord:Quantity/@uom" />
								<xsl:variable name="sclineReservationQuantityUOM">
									<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'wcUOMToscUOM', $lineReservationQuantityUOM)" />
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="string-length(normalize-space($sclineReservationQuantityUOM)) &gt; 0">
										<xsl:value-of select="$sclineReservationQuantityUOM" />
									</xsl:when>
									<xsl:otherwise>EACH</xsl:otherwise>
								</xsl:choose>
								</xsl:attribute>
								<xsl:if test="$ExpectedShipDate">
									<xsl:attribute name="RequestedReservationDate">
										<xsl:value-of select="mediationUtil:dateTimeToDate($ExpectedShipDate)"/>
									</xsl:attribute>
								</xsl:if>								
							</OrderLineReservation>	
							</xsl:if>
						</xsl:if>

							
						</OrderLineReservations>
										
						<Item>
							
							<xsl:attribute name="ItemID">
								<xsl:value-of select="_ord:CatalogEntryIdentifier/_wcf:ExternalIdentifier/_wcf:PartNumber" />
							</xsl:attribute>
							
							<xsl:attribute name="UnitOfMeasure">
							<!-- FEP5 and FEP3 enhancement -->
								<xsl:variable name="itemQuantityUOM" select="_ord:Quantity/@uom" />
								<xsl:variable name="scitemQuantityUOM">
									<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'wcUOMToscUOM', $itemQuantityUOM)" />
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="string-length(normalize-space($scitemQuantityUOM)) &gt; 0">
										<xsl:value-of select="$scitemQuantityUOM" />
									</xsl:when>
									<xsl:otherwise>EACH</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</Item>

						<xsl:choose>
							<xsl:when
								test="_ord:OrderItemShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:ShipModeCode != 'PickupInStore'">
								<PersonInfoShipTo>
									<xsl:attribute name="FirstName">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:ContactName/_wcf:FirstName" />
									</xsl:attribute>
									<xsl:attribute name="LastName">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:ContactName/_wcf:LastName" />
									</xsl:attribute>
									<xsl:attribute name="AddressLine1">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:AddressLine[1]" />
									</xsl:attribute>
									<xsl:attribute name="AddressLine2">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:AddressLine[2]" />
									</xsl:attribute>
									<xsl:attribute name="AddressLine3">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:AddressLine[3]" />
									</xsl:attribute>
									<xsl:attribute name="City">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:City" />
									</xsl:attribute>
									<xsl:attribute name="State">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:StateOrProvinceName" />
									</xsl:attribute>
									<xsl:attribute name="Country">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:Country" />
									</xsl:attribute>
									<xsl:attribute name="ZipCode">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:PostalCode" />
									</xsl:attribute>
									<xsl:attribute name="EMailID">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:EmailAddress1/_wcf:Value" />
									</xsl:attribute>
									<!-- FEP5 and FEP3 enhancement -->
									<xsl:attribute name="DayPhone">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Telephone1/_wcf:Value" />
									</xsl:attribute>
									<xsl:attribute name="EveningPhone">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Telephone2/_wcf:Value" />
									</xsl:attribute>
									<xsl:attribute name="AddressID">
										<xsl:value-of select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:ContactInfoIdentifier/_wcf:ExternalIdentifier/_wcf:ContactInfoNickName" />
									</xsl:attribute>							
								</PersonInfoShipTo>
							</xsl:when>							
						</xsl:choose>
						
						<LinePriceInfo>
							<xsl:attribute name="UnitPrice">
								<xsl:value-of select="_ord:OrderItemAmount/_wcf:UnitPrice/_wcf:Price" />
							</xsl:attribute>
							<xsl:attribute name="ListPrice">
								<xsl:value-of select="_ord:OrderItemAmount/_wcf:UnitPrice/_wcf:Price" />
							</xsl:attribute>
							<xsl:attribute name="RetailPrice">
								<xsl:value-of select="_ord:OrderItemAmount/_wcf:UnitPrice/_wcf:Price" />
							</xsl:attribute>
							<xsl:attribute name="IsLinePriceForInformationOnly">N</xsl:attribute>
							<xsl:attribute name="PricingQuantityStrategy">FIX</xsl:attribute>							
						</LinePriceInfo>
						<LineCharges>
							<xsl:for-each select="_ord:OrderItemAmount/_wcf:Adjustment">   
								<xsl:variable name="promotionType">
										<xsl:value-of select="_wcf:PromotionType"/>
									</xsl:variable>
									<xsl:variable name="mapKey">
										<xsl:value-of select="$promotionType"/>_<xsl:value-of select="_wcf:IsPromotionCodeRequired"/>
								</xsl:variable>
								 <xsl:variable name="ruleSetFieldName">
								 	<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'promotionTypeToRuleSetFiledName', $mapKey)" />
			                    </xsl:variable>
								<xsl:if test="string-length(normalize-space($ruleSetFieldName)) &gt; 0">
								    <LineCharge>
									    <xsl:attribute name="ChargeCategory"><xsl:value-of select="$ruleSetFieldName" /></xsl:attribute>
										<xsl:attribute name="ChargeName"><xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID" /></xsl:attribute>
										<xsl:attribute name="ChargePerLine"><xsl:value-of select="0-_wcf:Amount" /></xsl:attribute>
										<xsl:attribute name="IsManual">N</xsl:attribute>
									</LineCharge>
								</xsl:if>
							</xsl:for-each>
							<LineCharge>
								<xsl:attribute name="ChargeCategory">Shipping</xsl:attribute>
								<xsl:attribute name="ChargeName">Shipping Charge</xsl:attribute>
								<xsl:attribute name="ChargePerLine">
										<xsl:value-of select="_ord:OrderItemAmount/_wcf:ShippingCharge" />
								</xsl:attribute>
								<xsl:attribute name="IsManual">Y</xsl:attribute>
							</LineCharge>										
						</LineCharges>		
						<LineTaxes>
							<xsl:variable name="itemShippingAdjustmentTotal"><xsl:value-of select="format-number(sum(_ord:OrderItemAmount/_wcf:Adjustment/_wcf:Amount[../_wcf:Usage='Shipping Adjustment']), '#.00000')"/></xsl:variable>
							<LineTax>
								<xsl:attribute name="ChargeCategory">Price</xsl:attribute>
								<xsl:attribute name="Tax">
										<xsl:value-of select="_ord:OrderItemAmount/_wcf:SalesTax" />
								</xsl:attribute>
								<xsl:attribute name="TaxName">Sales Tax</xsl:attribute>
								<!-- FEP5 and FEP3 enhancement -->
								<xsl:variable name="itemSalesTax"><xsl:value-of select="_ord:OrderItemAmount/_wcf:SalesTax" /></xsl:variable>
								<xsl:variable name="itemTotal"><xsl:value-of select="_ord:OrderItemAmount/_wcf:OrderItemPrice" /></xsl:variable>
								<xsl:variable name="itemTotalAjustment"><xsl:value-of select="_ord:OrderItemAmount/_wcf:TotalAdjustment" /></xsl:variable>
								<xsl:variable name="itemDiscountAjustmentTotal"><xsl:value-of select="format-number($itemTotalAjustment - $itemShippingAdjustmentTotal, '#.00000')" /></xsl:variable>
								<xsl:attribute name="TaxPercentage">
										<xsl:choose>
											<xsl:when test="$itemSalesTax &gt; 0 and $itemTotal + $itemDiscountAjustmentTotal &gt; 0">
												<xsl:value-of select="format-number($itemSalesTax div ($itemTotal + $itemDiscountAjustmentTotal) * 100, '#.00000') " />
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
								</xsl:attribute>
							</LineTax>
							<LineTax>
								<xsl:attribute name="ChargeCategory">Shipping</xsl:attribute>
								<xsl:attribute name="ChargeName">Shipping Charge</xsl:attribute>
								<xsl:attribute name="Tax">
										<xsl:value-of select="_ord:OrderItemAmount/_wcf:ShippingTax" />
								</xsl:attribute>
								<xsl:attribute name="TaxName">Shipping Tax</xsl:attribute>
								<xsl:variable name="itemShippingTax"><xsl:value-of select="_ord:OrderItemAmount/_wcf:ShippingTax"/></xsl:variable>
								<xsl:variable name="itemShippingCharge"><xsl:value-of select="_ord:OrderItemAmount/_wcf:ShippingCharge"/></xsl:variable>
								<xsl:variable name="itemShippingCostWithPromotion"><xsl:value-of select="format-number($itemShippingCharge + $itemShippingAdjustmentTotal, '#.00000')" /></xsl:variable>
								<xsl:attribute name="TaxPercentage">
										<xsl:choose>
											<xsl:when test="$itemShippingTax &gt; 0 and $itemShippingCostWithPromotion &gt; 0">
												<xsl:value-of select="format-number($itemShippingTax div $itemShippingCostWithPromotion * 100, '#.00000') " />
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
								</xsl:attribute>
							</LineTax>
						</LineTaxes>
						
						<xsl:variable name="freeGift"><xsl:value-of select="_ord:OrderItemAmount/@freeGift"/></xsl:variable>						
					    <Awards>
						    <xsl:for-each select="_ord:OrderItemAmount/_wcf:Adjustment">
								<xsl:variable name="promotionType">
										<xsl:value-of select="_wcf:PromotionType"/>
									</xsl:variable>
									<xsl:variable name="mapKey">
										<xsl:value-of select="$promotionType"/>_<xsl:value-of select="_wcf:IsPromotionCodeRequired"/>
								</xsl:variable>
								 <xsl:variable name="ruleSetFieldName">
								 	<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'promotionTypeToRuleSetFiledName', $mapKey)" />
			                    </xsl:variable>
								<xsl:if test="string-length(normalize-space($ruleSetFieldName)) &gt; 0">
								    <Award> 
									    <xsl:if test="$freeGift='true'">
									        <xsl:attribute name="AwardType">FreeGift</xsl:attribute>
									    </xsl:if>
								        <xsl:attribute name="AwardAmount"><xsl:value-of select="_wcf:Amount" /></xsl:attribute>
									    <xsl:attribute name="ChargeCategory"><xsl:value-of select="$ruleSetFieldName" /></xsl:attribute>
										<xsl:attribute name="ChargeName"><xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID" /></xsl:attribute>
										<xsl:attribute name="AwardId"><xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID" /></xsl:attribute>
										
										<xsl:if test="_wcf:IsPromotionCodeRequired='true'">
											<xsl:variable name="calcodeId">
												<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>
											</xsl:variable>
											<xsl:variable name="promotionCodeObject" select="$order/_ord:PromotionCode[_ord:AssociatedPromotion/_wcf:PromotionIdentifier/_wcf:CalculationCodeIdentifier/_wcf:UniqueID =$calcodeId]"/>									
										    <xsl:attribute name="PromotionId">
										    	<xsl:choose>
										    		<xsl:when test="$promotionCodeObject">
										    			<xsl:value-of select="$promotionCodeObject/_ord:Code"/>
										    		</xsl:when>
										    		<xsl:otherwise>
										    			<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID" />
										    		</xsl:otherwise>
										    	</xsl:choose>										    	
										    </xsl:attribute>
										</xsl:if>
									    <xsl:attribute name="Description"><xsl:value-of select="_wcf:Description" /></xsl:attribute>
									</Award>
								</xsl:if>
							</xsl:for-each>
						</Awards>
					</OrderLine>
				</xsl:for-each>
			</OrderLines>
			<!-- If the shopper is a guest, we can get the mobile phone number from _ord:Order/_ord:OrderNotificationInfo-->
			
			
			<PersonInfoBillTo>
    				<xsl:attribute name="Title">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:ContactName/_wcf:PersonTitle" />
					</xsl:attribute>
					<xsl:attribute name="FirstName">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:ContactName/_wcf:FirstName" />
					</xsl:attribute>
					<xsl:attribute name="MiddleName">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:ContactName/_wcf:MiddleName" />
					</xsl:attribute>
					<xsl:attribute name="LastName">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:ContactName/_wcf:LastName" />
					</xsl:attribute>
					<xsl:attribute name="AddressLine1">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:Address/_wcf:AddressLine[1]" />
					</xsl:attribute>
					<xsl:attribute name="AddressLine2">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:Address/_wcf:AddressLine[2]" />
					</xsl:attribute>
					<xsl:attribute name="AddressLine3">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:Address/_wcf:AddressLine[3]" />
					</xsl:attribute>
					<xsl:attribute name="City">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:Address/_wcf:City" />
					</xsl:attribute>
					<xsl:attribute name="State">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:Address/_wcf:StateOrProvinceName" />
					</xsl:attribute>
					<xsl:attribute name="Country">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:Address/_wcf:Country" />
					</xsl:attribute>
					<xsl:attribute name="ZipCode">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:Address/_wcf:PostalCode" />
					</xsl:attribute>
					<xsl:attribute name="DayPhone">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:Telephone1/_wcf:Value" />
					</xsl:attribute>
					<xsl:attribute name="EveningPhone">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:Telephone2/_wcf:Value" />
					</xsl:attribute>
					<xsl:attribute name="EMailID">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:EmailAddress1/_wcf:Value" />
					</xsl:attribute>
					<xsl:attribute name="AlternateEmailID">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:EmailAddress2/_wcf:Value" />
					</xsl:attribute>
					<xsl:attribute name="DayFaxNo">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:Fax1/_wcf:Value" />
					</xsl:attribute>
					<xsl:attribute name="EveningFaxNo">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:Fax2/_wcf:Value" />
					</xsl:attribute>
					<!-- FEP5 and FEP3 enhancement -->
					<xsl:attribute name="AddressID">
						<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:ContactInfoIdentifier/_wcf:ExternalIdentifier/_wcf:ContactInfoNickName" />
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="string-length($order/_ord:BuyerBillInfo/_wcf:MobilePhone1/_wcf:Value) &gt; 0">
							<xsl:attribute name="MobilePhone">
								<xsl:value-of select="$order/_ord:BuyerBillInfo/_wcf:MobilePhone1/_wcf:Value"/>
							</xsl:attribute>
						</xsl:when>	
						<xsl:otherwise>
							<xsl:if test="$order/_ord:OrderNotificationInfo">
									<xsl:attribute name="MobilePhone">
										<xsl:value-of select="$order/_ord:OrderNotificationInfo/_ord:SMS[1]/_wcf:Value"/>
									</xsl:attribute>			
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
    	</PersonInfoBillTo>
		
			<PaymentMethods>
				<xsl:for-each select="$order/_ord:OrderPaymentInfo/_ord:PaymentInstruction">
					<PaymentMethod>
						<!-- FEP5 and FEP3 enhancement -->
						<xsl:variable name="paymentMethodToName" select="_ord:PaymentMethod/_ord:PaymentMethodName" />
							
						<xsl:if test="_ord:SequenceNumber">
							<xsl:attribute name="ChargeSequence">
								<xsl:value-of select="_ord:SequenceNumber" />
							</xsl:attribute>
						</xsl:if>
						<xsl:choose>
							<!-- Check -->
							<xsl:when test="_ord:PaymentMethod/_ord:PaymentMethodName='Check'">
								<xsl:attribute name="CheckNo">
									<xsl:value-of select="_ord:ProtocolData[@name='_token']" />
								</xsl:attribute>
								<xsl:attribute name="DisplayPaymentReference1">
									<xsl:value-of select="_ord:ProtocolData[@name='_display_value']" />
								</xsl:attribute>
								<xsl:attribute name="PaymentReference1">
									<xsl:value-of select="_ord:ProtocolData[@name='_token']" />
								</xsl:attribute>
								<xsl:attribute name="PaymentReference2">
									<xsl:value-of select="_ord:Amount" />
								</xsl:attribute>
							</xsl:when>
							<!-- Credit card payment methods -->
							<xsl:when test="_ord:ProtocolData[@name='cc_brand']">
								<xsl:attribute name="CreditCardExpDate">
									<xsl:value-of select="_ord:ProtocolData[@name='expire_month']" />/<xsl:value-of select="_ord:ProtocolData[@name='expire_year']" />
								</xsl:attribute>
								<xsl:attribute name="CreditCardNo">
									<xsl:value-of select="_ord:ProtocolData[@name='_token']" />
								</xsl:attribute>
								<!-- FEP5 and FEP3 enhancement -->
								<xsl:attribute name="CreditCardName">
									<xsl:value-of select="concat(_ord:BillingAddress/_wcf:ContactName/_wcf:FirstName,' ',_ord:BillingAddress/_wcf:ContactName/_wcf:MiddleName,' ',_ord:BillingAddress/_wcf:ContactName/_wcf:LastName)"/>
								</xsl:attribute>
								<xsl:attribute name="CreditCardType">
									<xsl:value-of select="_ord:ProtocolData[@name='cc_brand']" />
								</xsl:attribute>
								<xsl:attribute name="DisplayCreditCardNo">
									<xsl:value-of select="_ord:ProtocolData[@name='_display_value']" />
								</xsl:attribute>
								<xsl:attribute name="FirstName">
									<xsl:value-of select="_ord:BillingAddress/_wcf:ContactName/_wcf:FirstName" />
								</xsl:attribute>
								<xsl:attribute name="LastName">
									<xsl:value-of select="_ord:BillingAddress/_wcf:ContactName/_wcf:LastName" />
								</xsl:attribute>
								<xsl:attribute name="MiddleName">
									<xsl:value-of select="_ord:BillingAddress/_wcf:ContactName/_wcf:MiddleName" />
								</xsl:attribute>
							</xsl:when>
							<!-- Line of credit -->
							<xsl:when test="_ord:PaymentMethod/_ord:PaymentMethodName='LineOfCredit'">
								<xsl:attribute name="CustomerAccountNo">
									<xsl:value-of select="_ord:ProtocolData[@name='_token']" />
								</xsl:attribute>
								<xsl:attribute name="DisplayCustomerAccountNo">
									<xsl:value-of select="_ord:ProtocolData[@name='_display_value']" />
								</xsl:attribute>
							</xsl:when>
							<!-- Other payment methods -->
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when
							test="_ord:ProtocolData[@name='_token']">
										<xsl:attribute name="DisplayPaymentReference1">
											<xsl:value-of select="_ord:ProtocolData[@name='_display_value']" />
										</xsl:attribute>
										<xsl:attribute name="PaymentReference1">
											<xsl:value-of select="_ord:ProtocolData[@name='_token']" />
										</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="DisplayPaymentReference1">
											<xsl:value-of select="substring(_ord:UniqueID,string-length(_ord:UniqueID)-3,4)" />
										</xsl:attribute>
										<xsl:attribute name="PaymentReference1">
											<xsl:value-of select="_ord:UniqueID" />
										</xsl:attribute>										
									</xsl:otherwise>
								</xsl:choose>
								<!-- Assumption: SSFS payment type key == WC payment method name -->
							</xsl:otherwise>
						</xsl:choose>
						
						<!-- FEP5 and FEP3 enhancement -->
						<xsl:attribute name="PaymentType">
							<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'wcPaymentMethodToSCPaymentType', $paymentMethodToName)" />
							
						</xsl:attribute>
						
						<xsl:attribute name="MaxChargeLimit">
							<xsl:value-of select="_ord:Amount" />
						</xsl:attribute>
						<xsl:attribute name="UnlimitedCharges">N</xsl:attribute>
						<PaymentDetailsList>
							<!-- Financial transactions associated with the payment instruction -->
							<xsl:for-each select="$order/_ord:OrderPaymentInfo/_ord:FinancialTransaction[_ord:PaymentInstructionID=current()/_ord:UniqueID]">
								<PaymentDetails>
									<xsl:choose>
										<xsl:when test="_ord:TransactionType='Approve' or _ord:TransactionType='0'">
											<xsl:attribute name="AuthAvs">
												<xsl:value-of select="_ord:AvsCode" />
											</xsl:attribute>
											<xsl:attribute name="AuthCode">
												<xsl:value-of select="_ord:ReferenceNumber" />
											</xsl:attribute>
											<xsl:attribute name="AuthReturnCode">
												<xsl:value-of select="_ord:ResponseCode" />
											</xsl:attribute>
											<!-- Assumption: auth time == last update -->
											<xsl:attribute name="AuthTime">
												<xsl:value-of select="_ord:LastUpdate" />
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="_ord:ExpirationTime">
													<xsl:attribute name="AuthorizationExpirationDate">
														<xsl:value-of select="_ord:ExpirationTime" />
													</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="AuthorizationExpirationDate">
														<xsl:text>2500-01-01T00:00:00Z</xsl:text>
													</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="_ord:ReferenceNumber">
													<xsl:attribute name="AuthorizationID">
														<xsl:value-of select="_ord:ReferenceNumber" />
													</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="AuthorizationID">
														<xsl:value-of select="_ord:MerchantOrderNumber" />
													</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:attribute name="CVVAuthCode">
												<xsl:value-of select="_ord:TransactionExtensionData[@name='cc_cvc_response']" />
											</xsl:attribute>
											<xsl:attribute name="ChargeType">AUTHORIZATION</xsl:attribute>
										</xsl:when>
										<!-- Assumption: WC transaction type 'ApproveAndDeposit' is mapped to SSFS charge type 'CHARGE' -->
										<xsl:when test="_ord:TransactionType='Deposit' or _ord:TransactionType='1' or _ord:TransactionType='ApproveAndDeposit' or _ord:TransactionType='2'">
											<xsl:choose>
												<xsl:when test="_ord:ReferenceNumber">
													<xsl:attribute name="AuthorizationID">
														<xsl:value-of select="_ord:ReferenceNumber" />
													</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="AuthorizationID">
														<xsl:value-of select="_ord:MerchantOrderNumber" />
													</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:attribute name="ChargeType">CHARGE</xsl:attribute>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="_ord:Status='Success' or _ord:Status='2'">
											<xsl:attribute name="ProcessedAmount">
												<xsl:value-of select="_ord:RequestAmount" />
											</xsl:attribute>
											<xsl:attribute name="RequestProcessed">Y</xsl:attribute>
										</xsl:when>
										<xsl:when test="_ord:Status='Failed' or _ord:Status='3'">
											<xsl:attribute name="ProcessedAmount">0</xsl:attribute>
											<xsl:attribute name="RequestProcessed">Y</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="ProcessedAmount">0</xsl:attribute>
											<xsl:attribute name="RequestProcessed">N</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:attribute name="RequestAmount">
										<xsl:value-of select="_ord:RequestAmount" />
									</xsl:attribute>
									<xsl:attribute name="TranRequestTime">
										<xsl:value-of select="_ord:RequestTime" />
									</xsl:attribute>
									<xsl:attribute name="TranReturnCode">
										<xsl:value-of select="_ord:ResponseCode" />
									</xsl:attribute>
								</PaymentDetails>
							</xsl:for-each>
						</PaymentDetailsList>
						
							<PersonInfoBillTo>
								<xsl:attribute name="Title">
									<xsl:value-of select="_ord:BillingAddress/_wcf:ContactName/_wcf:PersonTitle" />
								</xsl:attribute>
								<xsl:attribute name="FirstName">
									<xsl:value-of select="_ord:BillingAddress/_wcf:ContactName/_wcf:FirstName" />
								</xsl:attribute>
								<xsl:attribute name="MiddleName">
									<xsl:value-of select="_ord:BillingAddress/_wcf:ContactName/_wcf:MiddleName" />
								</xsl:attribute>
								<xsl:attribute name="LastName">
									<xsl:value-of select="_ord:BillingAddress/_wcf:ContactName/_wcf:LastName" />
								</xsl:attribute>
								<xsl:attribute name="AddressLine1">
									<xsl:value-of select="_ord:BillingAddress/_wcf:Address/_wcf:AddressLine[1]" />
								</xsl:attribute>
								<xsl:attribute name="AddressLine2">
									<xsl:value-of select="_ord:BillingAddress/_wcf:Address/_wcf:AddressLine[2]" />
								</xsl:attribute>
								<xsl:attribute name="AddressLine3">
									<xsl:value-of select="_ord:BillingAddress/_wcf:Address/_wcf:AddressLine[3]" />
								</xsl:attribute>
								<xsl:attribute name="City">
									<xsl:value-of select="_ord:BillingAddress/_wcf:Address/_wcf:City" />
								</xsl:attribute>
								<xsl:attribute name="State">
									<xsl:value-of select="_ord:BillingAddress/_wcf:Address/_wcf:StateOrProvinceName" />
								</xsl:attribute>
								<xsl:attribute name="Country">
									<xsl:value-of select="_ord:BillingAddress/_wcf:Address/_wcf:Country" />
								</xsl:attribute>
								<xsl:attribute name="ZipCode">
									<xsl:value-of select="_ord:BillingAddress/_wcf:Address/_wcf:PostalCode" />
								</xsl:attribute>
								<xsl:attribute name="DayPhone">
									<xsl:value-of select="_ord:BillingAddress/_wcf:Telephone1/_wcf:Value" />
								</xsl:attribute>
								<xsl:attribute name="EveningPhone">
									<xsl:value-of select="_ord:BillingAddress/_wcf:Telephone2/_wcf:Value" />
								</xsl:attribute>
								<xsl:attribute name="EMailID">
									<xsl:value-of select="_ord:BillingAddress/_wcf:EmailAddress1/_wcf:Value" />
								</xsl:attribute>
								<xsl:attribute name="AlternateEmailID">
									<xsl:value-of select="_ord:BillingAddress/_wcf:EmailAddress2/_wcf:Value" />
								</xsl:attribute>
								<xsl:attribute name="DayFaxNo">
									<xsl:value-of select="_ord:BillingAddress/_wcf:Fax1/_wcf:Value" />
								</xsl:attribute>
								<xsl:attribute name="EveningFaxNo">
									<xsl:value-of select="_ord:BillingAddress/_wcf:Fax2/_wcf:Value" />
								</xsl:attribute>
								<!-- FEP5 and FEP3 enhancement -->
								<xsl:attribute name="AddressID">
									<xsl:value-of select="_ord:BillingAddress/_wcf:ContactInfoIdentifier/_wcf:ExternalIdentifier/_wcf:ContactInfoNickName" />
								</xsl:attribute>
							</PersonInfoBillTo>
						
					</PaymentMethod>
				</xsl:for-each>
			</PaymentMethods>
			<Promotions>
						    <xsl:for-each select="$order/_ord:OrderAmount/_wcf:Adjustment">
							    <xsl:if test="_wcf:IsPromotionCodeRequired='true'">
							        <Promotion>
								        <xsl:attribute name="PromotionId">
								        	<xsl:variable name="calcodeId">
												<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>
											</xsl:variable>
											<xsl:variable name="promotionCodeObject" select="$order/_ord:PromotionCode[_ord:AssociatedPromotion/_wcf:PromotionIdentifier/_wcf:CalculationCodeIdentifier/_wcf:UniqueID =$calcodeId]"/>
									    	<xsl:choose>
									    		<xsl:when test="$promotionCodeObject">
									    			<xsl:value-of select="$promotionCodeObject/_ord:Code"/>
									    		</xsl:when>
									    		<xsl:otherwise>
									    			<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID" />
									    		</xsl:otherwise>
									    	</xsl:choose>										    	
								        </xsl:attribute>
									    <xsl:attribute name="PromotionGroup">COUPON</xsl:attribute>
									    <xsl:attribute name="PromotionApplied">Y</xsl:attribute>
					                </Promotion>
								</xsl:if>
				            </xsl:for-each>
			</Promotions>
		</Order>
		
	</xsl:template>
	
</xsl:stylesheet>

