<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xalan="http://xml.apache.org/xalan" 
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation" 
	xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order" 
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/" 
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData" extension-element-prefixes="ValueMaps" exclude-result-prefixes="xalan _wcf _ord" version="1.0">
	<xsl:param name="scwc:ValueMapsData"/>
  <xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>
  <xsl:strip-space elements="*"/>

	<xsl:template match="/ResponseData/Body/Errors">
		<xsl:copy-of select="/ResponseData/Body/Errors"/>
  	</xsl:template>
  
  <xsl:template name="AcknowledgeOrderToOrder" match="/ResponseData/Body/_ord:AcknowledgeOrder">
    <!-- xsl:param name="AcknowledgeOrder"/>
    <xsl:param name="OrderInfoCorrelation"/>  -->
    	<xsl:variable name="AcknowledgeOrder" select="/ResponseData/Body/_ord:AcknowledgeOrder"/>
        <xsl:variable name="OrderInfoCorrelation" select="/ResponseData/context/correlation/OrderInfo"/>
        
    	<xsl:variable name="order" select="$AcknowledgeOrder/_ord:DataArea/_ord:Order"/>
    	<xsl:variable name="storeId"><xsl:value-of select="$order/_ord:StoreIdentifier/_wcf:UniqueID/text()"/></xsl:variable>
		<xsl:variable name="OrganizationCode">
			<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $storeId)"/>
		</xsl:variable>
		<xsl:variable name="shipmodeCode">
			<xsl:value-of select="$order/_ord:OrderShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:ShipModeCode"/>
		</xsl:variable>
		<xsl:if test="shipmodeCode">
			<xsl:variable name="carrierServiceCode"><!-- <xsl:value-of select="document('../../ValueMaps.xml')/ValueMaps/Map[@name='carrierServiceCodeToShipModeCode']/Entry[@key=$shipmodeCode]/text()" /> -->
			<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'carrierServiceCodeToShipModeCode', $shipmodeCode)"/></xsl:variable>	
		</xsl:if>
		
		<xsl:variable name="wcCurrency">
			<xsl:value-of select="$order/_ord:OrderAmount/_wcf:TotalProductPrice/@currency"/>
		</xsl:variable>
		
		<xsl:variable name="scCurrency">
			<!-- <xsl:value-of select="document('../../ValueMaps.xml')/ValueMaps/Map[@name='scCurrencyToWcCurency']/Entry[text()=$wcCurrency]/@key" /> -->
			<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'scCurrencyToWcCurency', $wcCurrency)"/>
		</xsl:variable>
		<Order>
			<xsl:attribute name="Currency">
				<xsl:choose>
					<xsl:when test="string-length($scCurrency) &gt; 0">
						<xsl:value-of select="$scCurrency"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$wcCurrency"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="BuyerUserId">
				<xsl:value-of select="$OrderInfoCorrelation/@BuyerUserId"/>
			</xsl:attribute>
			<xsl:attribute name="CustomerID">
				<xsl:value-of select="$OrderInfoCorrelation/@CustomerID"/>
			</xsl:attribute>
			<xsl:attribute name="EnterpriseCode">
				<xsl:value-of select="$OrderInfoCorrelation/@EnterpriseCode"/>
			</xsl:attribute>
			
			<xsl:if test="string-length($OrderInfoCorrelation/@PricingDate) &gt; 0">
				<xsl:attribute name="PricingDate">
					<xsl:value-of select="$OrderInfoCorrelation/@PricingDate"/>
				</xsl:attribute>
			</xsl:if>
			
			<xsl:attribute name="OrderReference">
				<xsl:value-of select="$OrderInfoCorrelation/@OrderReference"/>
			</xsl:attribute>
			<xsl:attribute name="OrganizationCode">
				<xsl:value-of select="$OrderInfoCorrelation/@OrganizationCode"/>
			</xsl:attribute>
			<xsl:attribute name="RunCatalogOnlyRules">
				<xsl:value-of select="$OrderInfoCorrelation/@RunCatalogOnlyRules"/>
			</xsl:attribute>
			<xsl:attribute name="SuggestManualRuleAdjustments">
				<xsl:value-of select="$OrderInfoCorrelation/@SuggestManualRuleAdjustments"/>
			</xsl:attribute>
			<xsl:attribute name="SuppressRuleExecution">
				<xsl:value-of select="$OrderInfoCorrelation/@SuppressRuleExecution"/>
			</xsl:attribute>
			<xsl:attribute name="SuppressShipping">
				<xsl:value-of select="$OrderInfoCorrelation/@SuppressShipping"/>
			</xsl:attribute>			
			
			<xsl:variable name="sumDiscountAdjustment">
				<xsl:value-of select="format-number(sum($order/_ord:OrderAmount/_wcf:Adjustment/_wcf:Amount[../_wcf:Usage='Discount']), '#.00')"/>
			</xsl:variable>
			
			<xsl:variable name="sumItemLevelDiscountAdjustment">
				<xsl:value-of select="format-number(sum($order/_ord:OrderAmount/_wcf:Adjustment/_wcf:Amount[../_wcf:Usage='Discount'  and  ../_wcf:DisplayLevel='OrderItem']), '#.00')"/>
			</xsl:variable>
			
			<xsl:variable name="sumShippingChargeAdjustment">
				<xsl:value-of select="format-number(sum($order/_ord:OrderAmount/_wcf:Adjustment/_wcf:Amount[. &lt;=0  and ../_wcf:Usage='Shipping Adjustment']),'#.00')"/>
			</xsl:variable>
			<xsl:variable name="sumShippingSurcharge">
				<xsl:value-of select="format-number(sum($order/_ord:OrderAmount/_wcf:Adjustment/_wcf:Amount[. &gt;=0  and ../_wcf:Usage='Shipping Adjustment']),'#.00')"/>
			</xsl:variable>
			
			<xsl:variable name="sumShippingAdjustment">
				<xsl:value-of select="format-number($sumShippingChargeAdjustment + $sumShippingSurcharge, '#.00')"/>
			</xsl:variable>
		
			<xsl:variable name="priceTotal">
				<xsl:value-of select="$order/_ord:OrderAmount/_wcf:TotalProductPrice"/>
			</xsl:variable>
			<xsl:attribute name="OrderAdjustment">
				<xsl:value-of select="format-number(0, '#.00')"/>
			</xsl:attribute>
			
			<xsl:attribute name="LinePriceTotal">
				<xsl:value-of select="format-number($priceTotal + $sumItemLevelDiscountAdjustment , '#.00')"/>
			</xsl:attribute>
			
			<xsl:attribute name="Subtotal">
				<xsl:value-of select="format-number($priceTotal + $sumDiscountAdjustment,'#.00')"/>
			</xsl:attribute>
			
			<xsl:variable name="shippingCharge">
				<xsl:value-of select="$order/_ord:OrderAmount/_wcf:TotalShippingCharge"/>
			</xsl:variable>
			
			<xsl:attribute name="OrderTotal">
				<xsl:value-of select="format-number($priceTotal + $sumDiscountAdjustment + $shippingCharge + $sumShippingAdjustment, '#.00')"/>
			</xsl:attribute>
			
			<!-- Coupon /promotion code mapping -->
			<Coupons>
				<xsl:for-each select="$order/_ord:PromotionCode">
					<Coupon>
						<xsl:attribute name="CouponID">
							<xsl:value-of select="_ord:Code"/>
						</xsl:attribute>
						<xsl:variable name="reasonCode" select="_ord:Reason/_wcf:ReasonCode"/>
						<xsl:attribute name="CouponStatusMsgCode">
							<!-- <xsl:value-of select="document('../../ValueMaps.xml')/ValueMaps/Map[@name='wcPromoCodeReasonCodeToSCCouponStatus']/Entry[@key=$reasonCode]/text()" /> -->
							<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcPromoCodeReasonCodeToSCCouponStatus', $reasonCode)"/>
						</xsl:attribute>
						<xsl:attribute name="Valid">
							<xsl:choose>
								<xsl:when test="_ord:Reason/_wcf:Valid='true' ">
									<xsl:text>Y</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>N</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</Coupon>
				</xsl:for-each>
			</Coupons>
			
			<!-- Order item mapping -->
			<OrderLines>
				<xsl:for-each select="$order/_ord:OrderItem">
					<xsl:variable name="lineID" select="_ord:OrderItemIdentifier/_wcf:ExternalOrderItemID"/>
					<OrderLine>
						<!-- attribute mapping -->
						<xsl:attribute name="AbsoluteAdjustment">0</xsl:attribute>
						<xsl:attribute name="DeliveryMethod">
							<xsl:value-of select="$OrderInfoCorrelation/OrderLines/OrderLine[@LineID=$lineID]/@DeliveryMethod"/>
						</xsl:attribute>
						<xsl:attribute name="EligibleForShippingDiscount">
							<xsl:value-of select="$OrderInfoCorrelation/OrderLines/OrderLine[@LineID=$lineID]/@EligibleForShippingDiscount"/>
						</xsl:attribute>
						<xsl:variable name="lineQuantity">
							<xsl:value-of select="_ord:Quantity"/>
						</xsl:variable>
						<xsl:variable name="extendedPrice">
							<xsl:value-of select="format-number(_ord:OrderItemAmount/_wcf:UnitPrice/_wcf:Price * $lineQuantity, '#.00')"/>
						</xsl:variable>
						<!-- add isPriceForInformationOnly logic here -->
						<xsl:variable name="IsLinePriceForInformationOnly">
							<xsl:choose>
								<xsl:when test="_ord:OrderItemAmount/@isPriceForInformationOnly = 'true'">
									<xsl:text>Y</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>N</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:attribute name="ExtendedPrice">
							<xsl:value-of select="$extendedPrice"/>
						</xsl:attribute>
						<xsl:attribute name="IsLinePriceForInformationOnly">
							<xsl:value-of select="$IsLinePriceForInformationOnly"/>
						</xsl:attribute>
						<xsl:attribute name="IsPriceLocked">
							<xsl:choose>
								<xsl:when test="_ord:OrderItemAmount[@priceOverride='true']">
									<xsl:text>Y</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>N</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="ItemID">
							<xsl:value-of select="_ord:CatalogEntryIdentifier/_wcf:ExternalIdentifier/_wcf:PartNumber"/>
						</xsl:attribute>
						
						<xsl:variable name="lineDiscountAdjustment">
							<xsl:value-of select="format-number(sum(_ord:OrderItemAmount/_wcf:Adjustment/_wcf:Amount[../_wcf:Usage='Discount' and ../_wcf:DisplayLevel='OrderItem']),'#.00')"/>
						</xsl:variable>
						<xsl:variable name="lineShippingChargeAdjustment">
							<xsl:value-of select="format-number(sum(_ord:OrderItemAmount/_wcf:Adjustment/_wcf:Amount[. &lt;=0 and ../_wcf:Usage='Shipping Adjustment']),'#.00')"/>
						</xsl:variable>
						<xsl:variable name="lineShippingSurcharge">
							<xsl:value-of select="format-number(sum(_ord:OrderItemAmount/_wcf:Adjustment/_wcf:Amount[. &gt;=0 and ../_wcf:Usage='Shipping Adjustment']),'#.00')"/>
						</xsl:variable>
						<xsl:variable name="orderDiscountAdjustment">
							<xsl:value-of select="format-number(sum(_ord:OrderItemAmount/_wcf:Adjustment/_wcf:Amount[../_wcf:Usage='Discount' and ../_wcf:DisplayLevel='Order']),'#.00')"/>
						</xsl:variable>
						<xsl:attribute name="LineAdjustment">
							<xsl:value-of select="$lineDiscountAdjustment"/>
						</xsl:attribute>
						
						<xsl:attribute name="LineID">
							<xsl:value-of select="_ord:OrderItemIdentifier/_wcf:ExternalOrderItemID"/>
						</xsl:attribute>
						<xsl:attribute name="LinePrice">
							<xsl:value-of select="format-number($extendedPrice + $lineDiscountAdjustment , '#.00')"/>
						</xsl:attribute>
						<xsl:attribute name="LineTotal">
							<xsl:value-of select="format-number($extendedPrice + $lineDiscountAdjustment + $orderDiscountAdjustment + $lineShippingChargeAdjustment + $lineShippingSurcharge , '#.00')"/>
						</xsl:attribute>
						<xsl:attribute name="ListPrice">
							<xsl:value-of select="_ord:OrderItemAmount/_wcf:UnitPrice/_wcf:Price"/>
						</xsl:attribute>
						<xsl:attribute name="OrderAdjustment">
							<xsl:value-of select="$orderDiscountAdjustment"/>
						</xsl:attribute>
						<xsl:attribute name="PercentAdjustment">0</xsl:attribute>
						<xsl:attribute name="Quantity">
							<xsl:value-of select="_ord:Quantity"/>
						</xsl:attribute>
						<xsl:attribute name="ShippingAdjustment">
							<xsl:value-of select="format-number($lineShippingChargeAdjustment + $lineShippingSurcharge , '#.00')"/>
						</xsl:attribute>
						<xsl:attribute name="ShippingChargeAdjustment">
							<xsl:value-of select="$lineShippingChargeAdjustment"/>
						</xsl:attribute>
						<xsl:attribute name="ShippingSurcharge">
							<xsl:value-of select="$lineShippingSurcharge"/>
						</xsl:attribute>
						<xsl:attribute name="UnitOfMeasure">
							<xsl:choose>
								<xsl:when test="$OrderInfoCorrelation/OrderLines/OrderLine[@LineID=$lineID]">
									<xsl:value-of select="$OrderInfoCorrelation/OrderLines/OrderLine[@LineID=$lineID]/@UnitOfMeasure"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="uomOfWC" select="_ord:Quantity/@uom"/>
									<!-- <xsl:variable name="uomOfSC" select="document('../../ValueMaps.xml')/ValueMaps/Map[@name='wcUOMToscUOM']/Entry[@key=$uomOfWC]/text()" /> -->
									<xsl:variable name="uomOfSC" select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcUOMToscUOM', $uomOfWC)"/>
									<xsl:value-of select="$uomOfSC"/>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:attribute>
						<xsl:variable name="unitprice">
							<xsl:value-of select="_ord:OrderItemAmount/_wcf:UnitPrice/_wcf:Price"/>
						</xsl:variable>
						<xsl:attribute name="UnitPrice">
							<xsl:value-of select="$unitprice"/>
						</xsl:attribute>
						
						<!-- Line Adjustment mapping -->
						<LineAdjustments>
							<xsl:for-each select="_ord:OrderItemAmount/_wcf:Adjustment[_wcf:Usage='Discount' and _wcf:DisplayLevel='OrderItem']">
								<Adjustment>
									<xsl:attribute name="AdjustmentApplied">
										<xsl:value-of select="_wcf:Amount"/>
									</xsl:attribute>
									<xsl:attribute name="AdjustmentAvailable">
										<xsl:value-of select="_wcf:Amount"/>
									</xsl:attribute>
									<xsl:variable name="generateID">
										<xsl:value-of select="generate-id(_wcf:CalculationCodeID)"/>
									</xsl:variable>
									<xsl:attribute name="AdjustmentID">
										<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>_<xsl:value-of select="$generateID"/>
									</xsl:attribute>
									<xsl:attribute name="AdjustmentPerLine">
										<xsl:value-of select="_wcf:Amount"/>
									</xsl:attribute>								
									<xsl:attribute name="Currency">
										<xsl:value-of select="_wcf:Amount/@currency"/>
									</xsl:attribute>
									<xsl:attribute name="Description">
										<xsl:value-of select="_wcf:Description"/>
									</xsl:attribute>
									<xsl:attribute name="DistributeAdjustment">N</xsl:attribute>
									<xsl:attribute name="IsCouponRule">
										<xsl:choose>
											<xsl:when test="_wcf:IsPromotionCodeRequired">
												<xsl:choose>
													<xsl:when test="_wcf:IsPromotionCodeRequired = 'false'">
														<xsl:text>N</xsl:text>
													</xsl:when>
													<xsl:when test="_wcf:IsPromotionCodeRequired = 'true'">
														<xsl:text>Y</xsl:text>
													</xsl:when>
													<xsl:otherwise>N</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>N</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:attribute name="IsItemRule">Y</xsl:attribute>
									<xsl:attribute name="IsManualAdjustment">
										<xsl:choose>
											<xsl:when test="_wcf:CalculationCodeID/_wcf:UniqueID=-10">
												<xsl:text>Y</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>N</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:attribute name="IsManualRule">N</xsl:attribute>
									<xsl:attribute name="PricingRuleName">
										<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>
									</xsl:attribute>
									
									<xsl:variable name="isFreeGiftLine">
										<xsl:choose>
											<xsl:when test="../@freeGift = 'true'">
												<xsl:text>true</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>false</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									
									<xsl:variable name="isAdjustmentEqualPrice">
										<xsl:choose>
											<xsl:when test="ceiling(format-number (_wcf:Amount div $unitprice, '#.00') ) =floor(format-number(_wcf:Amount div $unitprice , '#.00') )">
												<xsl:text>true</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>false</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:attribute name="RuleCategory">
										<xsl:if test="$isFreeGiftLine = 'true' and $isAdjustmentEqualPrice = 'true'">
											<xsl:text>FreeGift</xsl:text>
										</xsl:if>										
									</xsl:attribute>
									
									<AdjustmentAction>
										<xsl:attribute name="ChargeCategory">
											<xsl:variable name="promotionType">
												<xsl:value-of select="_wcf:PromotionType"/>
											</xsl:variable>
											<xsl:variable name="mapKey">
												<xsl:value-of select="$promotionType"/>_<xsl:value-of select="_wcf:IsPromotionCodeRequired"/>
											</xsl:variable>
											<xsl:variable name="ruleSetFieldName">
												<!-- <xsl:value-of select="document('../../ValueMaps.xml')/ValueMaps/Map[@name='promotionTypeToRuleSetFiledName']/Entry[@key=$mapKey]/text()" /> -->
												<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'promotionTypeToRuleSetFiledName', $mapKey)"/>
											</xsl:variable>
											<xsl:value-of select="$ruleSetFieldName"/>
										</xsl:attribute>
										<xsl:attribute name="ChargeName">
											<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>
										</xsl:attribute>
										
									</AdjustmentAction>
									<xsl:if test="_wcf:IsPromotionCodeRequired">
										<xsl:if test="_wcf:IsPromotionCodeRequired = 'true'">
											<xsl:variable name="calcodeId">
												<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>
											</xsl:variable>
											<xsl:variable name="promotionCodeObject" select="$order/_ord:PromotionCode[_ord:AssociatedPromotion/_wcf:PromotionIdentifier/_wcf:CalculationCodeIdentifier/_wcf:UniqueID =$calcodeId]"/>
											
											<xsl:if test="$promotionCodeObject">
												<Coupon>
													<xsl:attribute name="CouponID">
														<xsl:value-of select="$promotionCodeObject/_ord:Code"/>
													</xsl:attribute>													
												</Coupon>
											</xsl:if>
										</xsl:if>
									</xsl:if>	
								</Adjustment>
							</xsl:for-each>
						</LineAdjustments>
						<!-- Shipping adjustments mapping -->
						<ShippingAdjustments>
							<xsl:for-each select="_ord:OrderItemAmount/_wcf:Adjustment[_wcf:Usage='Shipping Adjustment']">
								<Adjustment>
									<xsl:attribute name="AdjustmentApplied">
										<xsl:value-of select="_wcf:Amount"/>
									</xsl:attribute>
									<xsl:attribute name="AdjustmentAvailable">
										<xsl:value-of select="_wcf:Amount"/>
									</xsl:attribute>
									<xsl:variable name="generateID">
										<xsl:value-of select="generate-id(_wcf:CalculationCodeID)"/>
									</xsl:variable>
									<xsl:attribute name="AdjustmentID">
										<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>_<xsl:value-of select="$generateID"/>
									</xsl:attribute>
									<xsl:attribute name="AdjustmentPerLine">
										<xsl:value-of select="_wcf:Amount"/>
									</xsl:attribute>					
									<xsl:attribute name="Currency">
										<xsl:value-of select="_wcf:Amount/@currency"/>
									</xsl:attribute>
									<xsl:attribute name="Description">
										<xsl:value-of select="_wcf:Description"/>
									</xsl:attribute>
									<xsl:attribute name="DistributeAdjustment">Y</xsl:attribute>
									<xsl:attribute name="IsManualAdjustment">
										<xsl:choose>
											<xsl:when test="_wcf:CalculationCodeID/_wcf:UniqueID=-12">
												<xsl:text>Y</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>N</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:attribute name="PricingRuleName">
										<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>
									</xsl:attribute>
									<AdjustmentAction>
										<xsl:attribute name="ChargeCategory">
											<xsl:variable name="promotionType">
												<xsl:value-of select="_wcf:PromotionType"/>
											</xsl:variable>
											<xsl:variable name="mapKey">
												<xsl:value-of select="$promotionType"/>_<xsl:value-of select="_wcf:IsPromotionCodeRequired"/>
											</xsl:variable>
											<xsl:variable name="ruleSetFieldName">
												<!-- <xsl:value-of select="document('../../ValueMaps.xml')/ValueMaps/Map[@name='promotionTypeToRuleSetFiledName']/Entry[@key=$mapKey]/text()" /> -->
												<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'promotionTypeToRuleSetFiledName', $mapKey)"/>
											</xsl:variable>
											<xsl:value-of select="$ruleSetFieldName"/>
										</xsl:attribute>
										<xsl:attribute name="ChargeName">
											<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>
										</xsl:attribute>
									</AdjustmentAction>
									<xsl:if test="_wcf:IsPromotionCodeRequired">
										<xsl:if test="_wcf:IsPromotionCodeRequired = 'true'">
											<xsl:variable name="calcodeId">
												<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>
											</xsl:variable>
											<xsl:variable name="promotionCodeObject" select="$order/_ord:PromotionCode[_ord:AssociatedPromotion/_wcf:PromotionIdentifier/_wcf:CalculationCodeIdentifier/_wcf:UniqueID =$calcodeId]"/>
											
											<xsl:if test="$promotionCodeObject">
												<Coupon>
													<xsl:attribute name="CouponID">
														<xsl:value-of select="$promotionCodeObject/_ord:Code"/>
													</xsl:attribute>
												</Coupon>
											</xsl:if>
										</xsl:if>
									</xsl:if>	

								</Adjustment>
							</xsl:for-each>
						</ShippingAdjustments>
						
						<!-- Order Adjustments mapping -->
						<OrderAdjustments>
							<xsl:for-each select="_ord:OrderItemAmount/_wcf:Adjustment[_wcf:Usage='Discount'  and _wcf:DisplayLevel='Order']">
								<Adjustment>
									<xsl:attribute name="AdjustmentApplied">
										<xsl:value-of select="_wcf:Amount"/>
									</xsl:attribute>
									<xsl:attribute name="AdjustmentAvailable">
										<xsl:value-of select="_wcf:Amount"/>
									</xsl:attribute>
									<xsl:variable name="generateID">
										<xsl:value-of select="generate-id(_wcf:CalculationCodeID)"/>
									</xsl:variable>
									<xsl:attribute name="AdjustmentID">
										<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>_<xsl:value-of select="$generateID"/>
									</xsl:attribute>
									<xsl:attribute name="CarrierServiceCode"/>
									<xsl:attribute name="Currency">
										<xsl:value-of select="_wcf:Amount/@currency"/>
									</xsl:attribute>
									<xsl:attribute name="Description">
										<xsl:value-of select="_wcf:Description"/>
									</xsl:attribute>
									<xsl:attribute name="DistributeAdjustment">Y</xsl:attribute>
									<xsl:attribute name="IsCouponRule">
										<xsl:choose>
											<xsl:when test="_wcf:IsPromotionCodeRequired">
												<xsl:choose>
													<xsl:when test="_wcf:IsPromotionCodeRequired = 'false'">
														<xsl:text>N</xsl:text>
													</xsl:when>
													<xsl:when test="_wcf:IsPromotionCodeRequired = 'true'">
														<xsl:text>Y</xsl:text>
													</xsl:when>
													<xsl:otherwise>N</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>N</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:attribute name="IsManualAdjustment">
										<xsl:choose>
											<xsl:when test="_wcf:CalculationCodeID/_wcf:UniqueID=-11">
												<xsl:text>Y</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>N</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:attribute name="PricingRuleName">
										<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>
									</xsl:attribute>
									<xsl:variable name="isFreeGiftLine">
										<xsl:choose>
											<xsl:when test="../@freeGift = 'true'">
												<xsl:text>true</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>false</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									
									<xsl:variable name="isAdjustmentEqualPrice">
										<xsl:choose>
											<xsl:when test="ceiling(format-number(_wcf:Amount div $unitprice, '#.00') ) =floor(format-number(_wcf:Amount div $unitprice, '#.00') )">
												<xsl:text>true</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>false</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:attribute name="RuleCategory">
										<xsl:if test="$isFreeGiftLine = 'true' and $isAdjustmentEqualPrice = 'true'">
											<xsl:text>FreeGift</xsl:text>
										</xsl:if>										
									</xsl:attribute>
									<AdjustmentAction>
										<xsl:attribute name="ChargeCategory">
											<xsl:variable name="promotionType">
												<xsl:value-of select="_wcf:PromotionType"/>
											</xsl:variable>
											<xsl:variable name="mapKey">
												<xsl:value-of select="$promotionType"/>_<xsl:value-of select="_wcf:IsPromotionCodeRequired"/>
											</xsl:variable>
											<xsl:variable name="ruleSetFieldName">
												<!-- <xsl:value-of select="document('../../ValueMaps.xml')/ValueMaps/Map[@name='promotionTypeToRuleSetFiledName']/Entry[@key=$mapKey]/text()" /> -->
												<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'promotionTypeToRuleSetFiledName', $mapKey)"/>
											</xsl:variable>
											<xsl:value-of select="$ruleSetFieldName"/>
										</xsl:attribute>
										<xsl:attribute name="ChargeName">
											<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>
										</xsl:attribute>
									</AdjustmentAction>
									<xsl:if test="_wcf:IsPromotionCodeRequired">
										<xsl:if test="_wcf:IsPromotionCodeRequired = 'true'">
											<xsl:variable name="calcodeId">
												<xsl:value-of select="_wcf:CalculationCodeID/_wcf:UniqueID"/>
											</xsl:variable>
											<xsl:variable name="promotionCodeObject" select="$order/_ord:PromotionCode[_ord:AssociatedPromotion/_wcf:PromotionIdentifier/_wcf:CalculationCodeIdentifier/_wcf:UniqueID =$calcodeId]"/>
											
											<xsl:if test="$promotionCodeObject">
												<Coupon>
													<xsl:attribute name="CouponID">
														<xsl:value-of select="$promotionCodeObject/_ord:Code"/>
													</xsl:attribute>
												</Coupon>
											</xsl:if>
										</xsl:if>
									</xsl:if>
								</Adjustment>
							</xsl:for-each>
						</OrderAdjustments>
					</OrderLine>
				</xsl:for-each>
				<!-- add order lines back from correlation context with quantity=0 in cancel cases -->
				<xsl:for-each select="$OrderInfoCorrelation/OrderLines/OrderLine">
					<xsl:if test="string-length(@Quantity) &gt; 0 and @Quantity = 0">
						<OrderLine>
						<!-- attribute mapping -->
						<xsl:attribute name="DeliveryMethod">
							<xsl:value-of select="@DeliveryMethod"/>
						</xsl:attribute>
						<xsl:attribute name="EligibleForShippingDiscount">
							<xsl:value-of select="@EligibleForShippingDiscount"/>
						</xsl:attribute>
						<xsl:attribute name="IsLinePriceForInformationOnly">
							<xsl:value-of select="@IsLinePriceForInformationOnly"/>
						</xsl:attribute>
						<xsl:attribute name="IsPriceLocked">
							<xsl:value-of select="@IsPriceLocked"/>
						</xsl:attribute>
						<xsl:attribute name="ItemID">
							<xsl:value-of select="@ItemID"/>
						</xsl:attribute>
						<xsl:attribute name="LineID">
							<xsl:value-of select="@LineID"/>
						</xsl:attribute>
						<xsl:attribute name="Quantity">0</xsl:attribute>
						<xsl:attribute name="UnitOfMeasure">
							<xsl:value-of select="@UnitOfMeasure"/>
						</xsl:attribute>
						<xsl:attribute name="UnitPrice">
							<xsl:value-of select="@UnitPrice"/>
						</xsl:attribute>
						</OrderLine>
					</xsl:if>
				</xsl:for-each>
				
				<!-- Kit pricing support -->
				<xsl:for-each select="$OrderInfoCorrelation/OrderLines/OrderLine">
					<xsl:variable name="parentLineID">
						<xsl:value-of select="@ParentLineID"/>
					</xsl:variable>
					<xsl:if test="string-length(normalize-space($parentLineID)) &gt; 0">
						<OrderLine>
						<!-- attribute mapping -->
						<xsl:attribute name="DeliveryMethod">
							<xsl:value-of select="@DeliveryMethod"/>
						</xsl:attribute>
						<xsl:attribute name="EligibleForShippingDiscount">
							<xsl:value-of select="@EligibleForShippingDiscount"/>
						</xsl:attribute>
						<xsl:attribute name="IsLinePriceForInformationOnly">
							<xsl:value-of select="@IsLinePriceForInformationOnly"/>
						</xsl:attribute>
						<xsl:attribute name="IsPriceLocked">
							<xsl:value-of select="@IsPriceLocked"/>
						</xsl:attribute>
						<xsl:attribute name="ItemID">
							<xsl:value-of select="@ItemID"/>
						</xsl:attribute>
						<!--  
						<xsl:attribute name="ParentLineID">
							<xsl:value-of select="@ParentLineID"/>
						</xsl:attribute>
						-->
						<xsl:attribute name="LineID">
							<xsl:value-of select="@LineID"/>
						</xsl:attribute>
						<xsl:attribute name="Quantity">
							<xsl:value-of select="@Quantity"/>
						</xsl:attribute>
						<xsl:attribute name="UnitOfMeasure">
							<xsl:value-of select="@UnitOfMeasure"/>
						</xsl:attribute>
						<xsl:attribute name="UnitPrice">
							<xsl:choose>
								<xsl:when test="@IsPriceLocked = 'Y'">
									<xsl:value-of select="@UnitPrice"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>0</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						</OrderLine>
					</xsl:if>
				</xsl:for-each>
			</OrderLines>
			<Shipping>
				<xsl:attribute name="AdjustedShippingTotal">
					<xsl:value-of select="format-number($shippingCharge + $sumShippingAdjustment , '#.00')"/>
				</xsl:attribute>
				<xsl:attribute name="CarrierServiceCode">
					<xsl:value-of select="$OrderInfoCorrelation/Shipping/@CarrierServiceCode"/>
				</xsl:attribute>
				<xsl:attribute name="Carrier">
					<xsl:value-of select="$OrderInfoCorrelation/Shipping/@Carrier"/>
				</xsl:attribute>
				<xsl:attribute name="MinimizeNumberOfShipments">
					<xsl:value-of select="$OrderInfoCorrelation/Shipping/@MinimizeNumberOfShipments"/>
				</xsl:attribute>
				<xsl:attribute name="ShippingAdjustment">
					<xsl:value-of select="$sumShippingAdjustment"/>
				</xsl:attribute>
				<xsl:attribute name="ShippingCharge">
					<xsl:value-of select="$shippingCharge"/>
				</xsl:attribute>
				<xsl:attribute name="ShippingChargeAdjustment">
					<xsl:value-of select="$sumShippingChargeAdjustment"/>
				</xsl:attribute>
				<xsl:attribute name="ShippingSurcharge">
					<xsl:value-of select="$sumShippingSurcharge"/>
				</xsl:attribute>
			</Shipping>
			
		</Order>
			
  </xsl:template>
</xsl:stylesheet>