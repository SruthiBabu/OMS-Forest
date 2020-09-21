<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2016 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
 <xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps"
	exclude-result-prefixes="xalan"
	version="1.0">
	<xsl:param name="scwc:ValueMapsData" />
	<xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:template name="GetCompleteOrderDetailsApiOutput" match="/">
		<xsl:variable name="enterpriseCode">
			<xsl:value-of select="/Order/@EnterpriseCode" />
		</xsl:variable>
		<xsl:variable name="storeCode">
			<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'storeIdToOrganizationCode', $enterpriseCode)" />
		</xsl:variable>
		<Root>
		<Order>
			<xsl:attribute name="AuthorizedClient">
				<xsl:value-of select="/Order/@AuthorizedClient" />
			</xsl:attribute>
			<xsl:attribute name="EntryType">
			<xsl:value-of select="/Order/@EntryType" />
			</xsl:attribute>
			<xsl:attribute name="EnterpriseCode"><xsl:value-of select="$storeCode" /></xsl:attribute>
			<xsl:attribute name="SellerOrganizationCode"><xsl:value-of select="$storeCode" /></xsl:attribute>			
			<xsl:attribute name="OrderNo">
				<xsl:value-of select="/Order/@OrderNo" />
			</xsl:attribute>
			<xsl:attribute name="OrderDate">
				<xsl:value-of select="/Order/@OrderDate" />
			</xsl:attribute>
			<xsl:attribute name="OrderHeaderKey">
				<xsl:value-of select="/Order/@OrderHeaderKey" />
			</xsl:attribute>
			<xsl:attribute name="DocumentType">
				<xsl:value-of select="/Order/@DocumentType" />
			</xsl:attribute>
			<xsl:attribute name="OverallStatus">
				<xsl:value-of select="/Order/@OverallStatus" />
			</xsl:attribute>
			<xsl:attribute name="ScacAndService">
				<xsl:value-of select="/Order/@ScacAndService" />
			</xsl:attribute>
			<xsl:attribute name="IsShipComplete">
			<xsl:choose>
				<xsl:when test="normalize-space(/Order/@IsShipComplete)!=''">
					<xsl:value-of select="/Order/@IsShipComplete" />
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="CarrierServiceCode">
				<xsl:variable name="scCarrierServiceCode" select="/Order/@CarrierServiceCode" />
				<xsl:variable name="tempShipModeCode"><xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'carrierServiceCodeToShipModeCode', $scCarrierServiceCode)" /></xsl:variable>
				<xsl:choose>
					<xsl:when test="string-length(normalize-space($tempShipModeCode)) &gt; 0">
						<xsl:value-of select="$tempShipModeCode" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$scCarrierServiceCode" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="SCAC">
				<xsl:variable name="scSCAC" select="/Order/@SCAC" />
				<xsl:variable name="tempCarrier"><xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'scacToCarrier', $scSCAC)" /></xsl:variable>
				<xsl:choose>
					<xsl:when test="string-length(normalize-space($tempCarrier)) &gt; 0">
						<xsl:value-of select="$tempCarrier" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$scSCAC" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<PriceInfo>
				<xsl:variable name="scCurrency" select="/Order/PriceInfo/@Currency" />
				<xsl:variable name="wcCurrency">
					<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'scCurrencyToWcCurency', $scCurrency)" />
				</xsl:variable>
				<xsl:attribute name="Currency">
					<xsl:choose>
						<xsl:when test="string-length(normalize-space($wcCurrency)) &gt; 0">
							<xsl:value-of select="$wcCurrency" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$scCurrency" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="EnterpriseCurrency">
					<xsl:choose>
						<xsl:when test="string-length(normalize-space($wcCurrency)) &gt; 0">
							<xsl:value-of select="$wcCurrency" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$scCurrency" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="ReportingConversionDate">
					<xsl:value-of select="/Order/PriceInfo/@ReportingConversionDate" />
				</xsl:attribute>
				<xsl:attribute name="ReportingConversionRate">
					<xsl:value-of select="/Order/PriceInfo/@ReportingConversionRate" />
				</xsl:attribute>
				<xsl:attribute name="TotalAmount">
					<xsl:value-of select="/Order/PriceInfo/@TotalAmount" />
				</xsl:attribute>
			</PriceInfo>
			<OverallTotals>
				<xsl:copy-of select="/Order/OverallTotals/@*" />
			</OverallTotals>
			<OrderLines>
				<xsl:variable name="orderLines" select="/Order/OrderLines" />
				<xsl:for-each select="$orderLines/OrderLine">
				    <xsl:variable name="scShipNode">
				    	<xsl:value-of select="@ShipNode" /></xsl:variable>
				    <xsl:variable name="wcShipNode">
				    	<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'wcShipNodeToscShipNode', $scShipNode)" />				    	
				    </xsl:variable>
				    <xsl:variable name="shipNode">
					    <xsl:choose>
						    <xsl:when test="string-length(normalize-space($wcShipNode)) &gt; 0">
							    <xsl:value-of select="$wcShipNode" />
						    </xsl:when>
						    <xsl:otherwise>
							    <xsl:value-of select="$scShipNode" />
						    </xsl:otherwise>
					    </xsl:choose>
				    </xsl:variable>							
					<OrderLine>
						<xsl:for-each select="@*">
					    	<xsl:if test="(name() != 'CarrierServiceCode' or name() != 'SCAC' or name() != 'ShipNode' or name() != 'MaxLineStatus') or name() != 'MinLineStatus'">
					       		<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
					      	</xsl:if> 
					    </xsl:for-each>
					    <xsl:attribute name="ShipNode"><xsl:value-of select="$shipNode" /></xsl:attribute>
						 <xsl:choose>
							<xsl:when test="@DeliveryMethod = 'PICK'">
								<xsl:attribute name="CarrierServiceCode"></xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="CarrierServiceCode">
									<xsl:variable name="scCarrierServiceCode" select="@CarrierServiceCode" />
									<xsl:variable name="tempShipModeCode"><xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'carrierServiceCodeToShipModeCode', $scCarrierServiceCode)" /></xsl:variable>
									<xsl:choose>
										<xsl:when test="string-length(normalize-space($tempShipModeCode)) &gt; 0">
											<xsl:value-of select="$tempShipModeCode" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$scCarrierServiceCode" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>						
						<xsl:attribute name="SCAC">
							<xsl:variable name="scSCAC" select="@SCAC" />
							<xsl:variable name="tempCarrier"><xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'scacToCarrier', $scSCAC)" /></xsl:variable>
							<xsl:choose>
								<xsl:when test="string-length(normalize-space($tempCarrier)) &gt; 0">
									<xsl:value-of select="$tempCarrier" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$scSCAC" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:variable name="scMaxLineStatus"><xsl:value-of select="@MaxLineStatus" /></xsl:variable>
						<xsl:variable name="wcMaxLineStatus">
							<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'scStatusToWcStatus', $scMaxLineStatus)" />
						</xsl:variable>
						<xsl:attribute name="MaxLineStatus">
							<xsl:value-of select="$wcMaxLineStatus" />
						</xsl:attribute>
						<xsl:variable name="scMinLineStatus"><xsl:value-of select="@MinLineStatus" /></xsl:variable>
						<xsl:variable name="wcMinLineStatus">
							<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'scStatusToWcStatus', $scMinLineStatus)" />
						</xsl:variable>
						<xsl:attribute name="MinLineStatus">
							<xsl:value-of select="$wcMinLineStatus" />
						</xsl:attribute>
						<Item>
							<xsl:attribute name="ItemID">
								<xsl:value-of select="Item/@ItemID" />
							</xsl:attribute>
							<xsl:attribute name="UnitOfMeasure">
								<xsl:variable name="itemQuantityUOM" select="Item/@UnitOfMeasure" />
								<xsl:variable name="wcitemQuantityUOM">
									<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'wcUOMToscUOM', $itemQuantityUOM)" />
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="string-length(normalize-space($wcitemQuantityUOM)) &gt; 0">
										<xsl:value-of select="$wcitemQuantityUOM" />
									</xsl:when>
									<xsl:otherwise>C62</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</Item>
						<xsl:if test="PersonInfoShipTo">
							<PersonInfoShipTo>
								 <xsl:copy-of select="PersonInfoShipTo/@*" />							
							</PersonInfoShipTo>
						</xsl:if>
						<LinePriceInfo>
							<xsl:copy-of select="LinePriceInfo/@*" />
						</LinePriceInfo>
						<xsl:if test="LineCharges">
							<LineCharges>
								<xsl:for-each select="LineCharges/LineCharge">   
									<LineCharge>
										<xsl:copy-of select="@*" />
									</LineCharge>
								</xsl:for-each>										
							</LineCharges>
						</xsl:if>
						<xsl:if test="LineTaxes">
							<LineTaxes>
								<xsl:for-each select="LineTaxes/LineTax">   
									<LineTax>
										<xsl:copy-of select="@*" />
									</LineTax>
								</xsl:for-each>	
								<xsl:for-each select="LineTaxes/TaxSummary">   
									<TaxSummary>
										<xsl:for-each select="TaxSummaryDetail">
											<TaxSummaryDetail>
												<xsl:copy-of select="@*" />
											</TaxSummaryDetail> 
										</xsl:for-each>
									</TaxSummary>
								</xsl:for-each>									
							</LineTaxes>
						</xsl:if>
						<xsl:if test="Instructions">
						<Instructions>
								<xsl:attribute name="NumberOfInstructions">
									<xsl:value-of select="Instructions/@NumberOfInstructions" />
								</xsl:attribute>
								<xsl:for-each select="Instructions/Instruction">
									<Instruction>
										<xsl:copy-of select="@*" />
									</Instruction> 
								</xsl:for-each>
						</Instructions>
						</xsl:if>
						<xsl:if test="ComputedPrice">
						<ComputedPrice>
							<xsl:copy-of select="ComputedPrice/@*" />
						</ComputedPrice>
						</xsl:if>
						<xsl:if test="Awards">
						<Awards>
								<xsl:for-each select="Awards/Award">
									<Award>
										<xsl:copy-of select="@*" />
									</Award> 
								</xsl:for-each>
						</Awards>
						</xsl:if>
						<xsl:if test="ProductItems">
						<ProductItems>
								<xsl:for-each select="ProductItems/ProductItem">
									<ProductItem>
										<xsl:copy-of select="@*" />
									</ProductItem> 
								</xsl:for-each>
						</ProductItems>
						</xsl:if>
						<xsl:if test="References">
						<References>
								<xsl:for-each select="References/Reference">
									<Reference>
										<xsl:copy-of select="@*" />
									</Reference> 
								</xsl:for-each>
						</References>
						</xsl:if>
						<xsl:if test="ShipmentLines">
						<ShipmentLines>
								<xsl:for-each select="ShipmentLines/ShipmentLine">
									<Reference>
										<xsl:copy-of select="@*" />
									</Reference> 
								</xsl:for-each>
						</ShipmentLines>
						</xsl:if>	
						<xsl:if test="BundleParentLine">
						<BundleParentLine>
							<xsl:copy-of select="BundleParentLine/@*" />
						</BundleParentLine>
						</xsl:if>
						<xsl:if test="KitLines">
						<KitLines>
								<xsl:copy-of select="KitLines/@*" />
								<xsl:for-each select="KitLines/KitLine">
									<KitLine>
										<xsl:copy-of select="@*" />
										<KitLineTranQuantity>
											<xsl:copy-of select="KitLineTranQuantity/@*" />
										</KitLineTranQuantity>
									</KitLine> 
								</xsl:for-each>
						</KitLines>
						</xsl:if>	
						<xsl:if test="OrderLineReservations">
						<OrderLineReservations>
						    <xsl:for-each select="OrderLineReservations/OrderLineReservation">
							<OrderLineReservation>
								<xsl:variable name="scShipNode">
							    	<xsl:value-of select="@Node" /></xsl:variable>
							    <xsl:variable name="wcShipNode">
							    	<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'wcShipNodeToscShipNode', $scShipNode)" />				    	
							    </xsl:variable>
								<xsl:attribute name="Node">
					    		    <xsl:choose>
									    <xsl:when test="string-length(normalize-space($wcShipNode)) &gt; 0">
										    <xsl:value-of select="$wcShipNode" />
									    </xsl:when>
									    <xsl:otherwise>
										    <xsl:value-of select="$scShipNode" />
									    </xsl:otherwise>
								    </xsl:choose>
								</xsl:attribute>
							</OrderLineReservation>
							</xsl:for-each>
						</OrderLineReservations>	
						</xsl:if>
						<xsl:if test="OrderStatuses">
						<OrderStatuses>
								<xsl:for-each select="OrderStatuses/OrderStatus">
									<OrderStatus>
										<xsl:copy-of select="@*" />
										<Details>
											<xsl:copy-of select="Details/@*" />
										</Details>
									</OrderStatus> 
								</xsl:for-each>
						</OrderStatuses>
						</xsl:if>
					</OrderLine>
				</xsl:for-each>
			</OrderLines>
			<!-- If the shopper is a guest, we can get the mobile phone number from _ord:Order/_ord:OrderNotificationInfo-->
					<xsl:if test="/Order/PersonInfoShipTo">
						<PersonInfoShipTo>
								<xsl:copy-of select="/Order/PersonInfoShipTo/@*" />
						</PersonInfoShipTo>
					</xsl:if>
					<xsl:if test="/Order/PersonInfoBillTo">
						<PersonInfoBillTo>
								<xsl:copy-of select="/Order/PersonInfoBillTo/@*" />
						</PersonInfoBillTo>
					</xsl:if>
						<xsl:if test="/Order/HeaderCharges">
							<HeaderCharges>
								<xsl:for-each select="HeaderCharges/HeaderCharge"> 
									<HeaderCharge>
										<xsl:copy-of select="@*" />
									</HeaderCharge>
								</xsl:for-each>										
							</HeaderCharges>
						</xsl:if>
						<xsl:if test="/Order/HeaderTaxes">
							<HeaderTaxes>
								<xsl:for-each select="HeaderTaxes/HeaderTax">  
									<HeaderTax>
										<xsl:copy-of select="@*" />
									</HeaderTax>
								</xsl:for-each>	
								<xsl:for-each select="HeaderTaxes/TaxSummary">   
									<TaxSummary>
										<xsl:for-each select="TaxSummaryDetail">
											<TaxSummaryDetail>
												<xsl:copy-of select="@*" />
											</TaxSummaryDetail> 
										</xsl:for-each>
									</TaxSummary>
								</xsl:for-each>									
							</HeaderTaxes>
						</xsl:if>
						<xsl:if test="/Order/Awards">
						<Awards>
								<xsl:for-each select="Awards/Award">
									<Award>
										<xsl:copy-of select="@*" />
									</Award> 
								</xsl:for-each>
						</Awards>
						</xsl:if>
						<xsl:if test="/Order/PaymentMethods">
						<PaymentMethods>
								<xsl:for-each select="/Order/PaymentMethods/PaymentMethod">
										<PaymentMethod>
											<xsl:for-each select="@*">
										    	<xsl:if test="name() != 'PaymentType'">
										       		<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
										      	</xsl:if> 
										    </xsl:for-each>
										     <xsl:attribute name="PaymentType">
										    	<xsl:variable name="paymentType">
													<xsl:value-of select="@PaymentType"/>
												</xsl:variable>
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
												<xsl:choose>
													<xsl:when test="$paymentType = 'CREDIT_CARD'">CREDIT_CARD</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="$wcPaymentMethodValue"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:attribute>
											<xsl:if test="PersonInfoBillTo">											
												<PersonInfoBillTo>
													<xsl:copy-of select="PersonInfoBillTo/@*" />
												</PersonInfoBillTo> 
											</xsl:if>
									</PaymentMethod>
								</xsl:for-each>
							</PaymentMethods>
						</xsl:if>
						<xsl:if test="/Order/OrderStatuses">
						<OrderStatuses>
								<xsl:for-each select="/Order/OrderStatuses/OrderStatus">
									<OrderStatus>
										<xsl:copy-of select="@*" />
										<Details>
											<xsl:copy-of select="Details/@*" />
										</Details>
									</OrderStatus> 
								</xsl:for-each>
						</OrderStatuses>
						</xsl:if>
			     <xsl:if test="/Order/Modifications/Modification/@ModificationType">
				<Modifications>
					<Modification>
						<xsl:attribute name="ModificationType">
						<xsl:value-of select="/Order/Modifications/Modification/@ModificationType" />
						</xsl:attribute>
						<xsl:attribute name="ModificationAllowed">
						<xsl:value-of select="/Order/Modifications/Modification/@ModificationAllowed" />
						</xsl:attribute>
					</Modification >
				</Modifications>
			     </xsl:if>
												
		</Order>

		</Root>
	</xsl:template>
</xsl:stylesheet>
