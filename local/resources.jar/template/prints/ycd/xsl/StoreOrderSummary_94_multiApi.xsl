<?xml version="1.0" encoding="UTF-8"?>
<!-- Licensed Materials - Property of IBM IBM Sterling Selling and Fulfillment 
	Suite - Foundation (C) Copyright IBM Corp. 2007, 2016 All Rights Reserved. 
	US Government Users Restricted Rights - Use, duplication or disclosure restricted 
	by GSA ADP Schedule Contract with IBM Corp. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="Order">
		<MultiApi>
			<API Name="getShipNodeList">
				<Input>
					<Shipment>
						<xsl:attribute name="ShipNode">
							<xsl:value-of select="@ShipNode" />
						</xsl:attribute>
					</Shipment>
				</Input>
				<Template>
					<ShipNodeList>
						<ShipNode ShipNode="" Description="">
							<ShipNodePersonInfo AddressLine1="" AddressLine2="" AddressLine3="" AddressLine4="" AddressLine5="" AddressLine6="" Country="" City="" State="" ZipCode="" />
						</ShipNode>
					</ShipNodeList>
				</Template>
			</API>
			
			<API Name="getRuleDetails">
				<Input>
					<Rules>
						<xsl:attribute name="OrganizationCode">
							<xsl:value-of select="@OrganizationCode" />
						</xsl:attribute>
						<xsl:attribute name="RuleSetFieldName">
								<xsl:text>YCD_USE_TRANSACTIONAL_QUANTITY</xsl:text>
						</xsl:attribute>	
					</Rules>
				</Input>
				<Template>
					<Rules RuleSetFieldName="" RuleSetValue="">
					</Rules>
				</Template>
			</API>
			
			<API Name="getItemUOMMasterList">
				<Input>
					<ItemUOMMaster>
						<xsl:attribute name="CallingOrganizationCode">
							<xsl:value-of select="@OrganizationCode" />
						</xsl:attribute>
					</ItemUOMMaster>
				</Input>
				<Template>
					<ItemUOMMasterList>
						<ItemUOMMaster UnitOfMeasure="" Description="" />
					</ItemUOMMasterList>
				</Template>
			</API>


			<API Name="getCompleteOrderDetails">
				<Input>
					<Order>
						<xsl:attribute name="OrderHeaderKey">
							<xsl:value-of select="@OrderHeaderKey" />
						</xsl:attribute>
					</Order>
				</Input>
				<Template>
					<Order BillToID="" BuyerUserId="" CustomerContactID="" CustomerEMailID="" CustomerFirstName="" CustomerPhoneNo="" CustomerLastName="" CustomerZipCode="" DocumentType="" DraftOrderFlag="" EnterpriseCode="" EntryType="" MaxOrderStatusDesc="" OrderName="" OrderDate="" OrderHeaderKey="" OrderNo="" SellerOrganizationCode="" TaxExemptFlag="" TaxExemptionCertificate="" Status="">
						<PersonInfoShipTo AddressID="" AddressLine1="" AddressLine2="" City="" Company="" Country="" CountryDesc="" DayPhone="" Department="" EMailID="" EveningPhone="" FirstName="" IsAddressVerified="" IsCommercialAddress="" LastName="" MiddleName="" MobilePhone="" PersonID="" PersonInfoKey="" State="" Suffix="" Title="" TitleDesc="" ZipCode="" isHistory="" />
						<PriceInfo Currency="" TotalAmount="" />
						<OverallTotals AdjustedSubtotalWithoutTaxes="" GrandAdjustmentsWithoutTotalShipping="" GrandDeliveryCharges="" GrandRefundTotal="" GrandShippingTotal="" GrandTax="" GrandTotal="" GrandDiscount="" HdrShippingCharges="" HeaderAdjustmentWithoutShipping="" LineSubTotal="" OrderHeaderKey="" SubtotalWithoutTaxes="" />
						<Promotions>
							<Promotion DenialReason="" Description="" PromotionAmount="" PromotionApplied="" PromotionId="">
								<PricingRule Description="" />
							</Promotion>
						</Promotions>
						<OrderLines TotalNumberOfRecords="">
							<OrderLine DeliveryMethod="" GiftFlag="" GiftWrap="" OrderLineKey="" OrderedQty="" ReqShipDate="" EarliestShipDate="" Status="">
								<OrderLineTranQuantity OrderedQty="" TransactionalUOM="" />
								<LinePriceInfo DisplayUnitPrice="" IsPriceLocked="" ListPrice="" UnitPrice="" />
								<PersonInfoShipTo AddressID="" AddressLine1="" AddressLine2="" City="" Company="" Country="" CountryDesc="" DayPhone="" Department="" EMailID="" EveningPhone="" FirstName="" IsAddressVerified="" IsCommercialAddress="" LastName="" MiddleName="" MobilePhone="" PersonID="" PersonInfoKey="" State="" Suffix="" Title="" TitleDesc="" ZipCode="" isHistory="" />
								<Shipnode AcceptanceRequired="" ActivateFlag="" CanShipToAllNodes="" CanShipToOtherAddresses="" ContactAddressKey="" CurrentBolNumber="" DefaultDeclaredValue="" Description="" ExportLicenseExpDate="" ExportLicenseNo="" ExportTaxpayerId="" GenerateBolNumber="" IdentifiedByParentAs="" InterfaceSubType="" InterfaceType="" InventoryTracked="" Inventorytype="" IsItemBasedAllocationAllowed="" Latitude="" Localecode="" Longitude="" MaintainInventoryCost="" NodeType="" OwnerKey="" OwnerType="" PicklistType="" ReceivingNode="" RequiresChangeRequest="" ReturnCenterFlag="" ReturnsNode="" ShipNode="" ShipNodeAddressKey="" ShipNodeClass="" ShipnodeKey="" ShipnodeType="" ShippingNode="" SupplierKey="" ThreePlNode="" TimeDiff="">
									<ShipNodePersonInfo AddressLine1="" AddressLine2="" AddressLine3="" AddressLine4="" AddressLine5="" AddressLine6="" AlternateEmailID="" Beeper="" City="" Company="" Country="" DayFaxNo="" DayPhone="" Department="" EMailID="" ErrorTxt="" EveningFaxNo="" EveningPhone="" FirstName="" HttpUrl="" IsCommercialAddress="" JobTitle="" LastName="" MiddleName="" MobilePhone="" OtherPhone="" PersonID="" PersonInfoKey="" PreferredShipAddress="" State="" Suffix="" TaxGeoCode="" Title="" UseCount="" VerificationStatus="" ZipCode="" />
								</Shipnode>
								<ItemDetails ItemID="" ItemKey="" UnitOfMeasure="" IsPickupAllowed="" IsShippingAllowed="">
									<PrimaryInformation ExtendedDisplayDescription="" ImageID="" ImageLabel="" ImageLocation="" IsModelItem="" Department="" />
									<ClassificationCodes Model="" />
									<ItemAttributeGroupTypeList>
										<ItemAttributeGroupType ItemAttributeGroupType="DISTINCT_ATTRIBUTES">
											<ItemAttributeGroupList>
												<ItemAttributeGroup ItemAttributeGroupID="VARIATIONS">
													<ItemAttributeList>
														<ItemAttribute ItemAttributeName="" Value="" />
													</ItemAttributeList>
												</ItemAttributeGroup>
											</ItemAttributeGroupList>
										</ItemAttributeGroupType>
									</ItemAttributeGroupTypeList>
									<AttributeList />
								</ItemDetails>
								<LineOverallTotals DisplayUnitPrice="" />
								<OrderDates>
									<OrderDate ActualDate="" DateTypeId="YCD_FTC_FIRST_PROMISE_DATE" />
									<OrderDate CommittedDate="" DateTypeId="MIN_DELIVERY" />
									<OrderDate CommittedDate="" DateTypeId="MAX_DELIVERY" />
								</OrderDates>
							</OrderLine>
							<Order EnterpriseCode="" OrderHeaderKey="" SellerOrganizationCode="">
								<PriceInfo Currency="" />
							</Order>
						</OrderLines>
					</Order>
				</Template>
			</API>

			<API Name="getOrganizationHierarchy">
				<Input>
					<Organization>
						<xsl:attribute name="OrganizationCode">
							<xsl:value-of select="@ShipNode" />
						</xsl:attribute>
					</Organization>
				</Input>
				<Template>
					<Organization OrganizationCode="" OrganizationKey="" OrganizationName="" LocaleCode="">
					</Organization>
				</Template>
			</API>
			<API Name="getCurrencyList">
				<Input>
					<Currency>
						<xsl:attribute name="Currency">
							<xsl:value-of select="@Currency" />
						</xsl:attribute>
					</Currency>
				</Input>
				<Template>
					<CurrencyList>
						<Currency Currency="" PostfixSymbol="" PrefixSymbol="" CurrencyKey="" CurrencyDescription=""/>
					</CurrencyList>
				</Template>
			</API>
		</MultiApi>
	</xsl:template>
</xsl:stylesheet>
