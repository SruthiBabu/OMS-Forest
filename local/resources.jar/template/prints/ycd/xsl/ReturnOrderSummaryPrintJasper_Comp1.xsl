<?xml version="1.0" encoding="UTF-8" ?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Call Center and Store
(C) Copyright IBM Corp. 2006, 2011 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->

<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">

<xsl:output indent="yes"/>
			    
<xsl:template match="Order">
			    
<MultiApi>
				    
	<API>
		<xsl:attribute name="Name">
		<xsl:text>getCompleteOrderDetails</xsl:text>
		</xsl:attribute>
					
		<Input>   
				
		<Order>
						    
		<xsl:attribute name="OrderHeaderKey">
		<xsl:value-of select="/Order/@OrderHeaderKey"/>
		</xsl:attribute>
		<xsl:attribute name="SortingType">
		<xsl:text>ITEM</xsl:text>
		</xsl:attribute>
								       
		</Order>
		</Input>
		<Template>
			<Order  OrderDate="" OrderHeaderKey="" OrderName="" OrderNo="" >
				<ReturnOrders>
					<ReturnOrder OrderDate="" OrderHeaderKey="" OrderName="" OrderNo="" >
						<OrderLines>
						<OrderLine OrderedQty="" OrigOrderLineKey="" OriginalOrderedQty="" OtherCharges="" PrimeLineNo="" ReturnReasonLongDesc="" ReturnReasonShortDesc="" >
						<Item CostCurrency="" CountryOfOrigin="" CustomerItem="" CustomerItemDesc="" ECCNNo="" HarmonizedCode="" ISBN="" ItemDesc="" ItemID="" ItemShortDesc="" ItemWeight="" ItemWeightUOM=""  UnitOfMeasure=""/>
						<LinePriceInfo  LineTotal=""  UnitPrice="" TaxableFlag=""/>
						<LineOverallTotals  ExtendedPrice="" UnitPrice=""/>
						</OrderLine>
						</OrderLines>
						<PersonInfoBillTo AddressLine1="" AddressLine2="" AddressLine3="" AddressLine4="" AddressLine5="" AddressLine6="" AlternateEmailID="" Beeper="" City="" Company="" Country="" DayFaxNo="" DayPhone="" Department="" EMailID="" EveningFaxNo="" EveningPhone="" FirstName="" JobTitle="" LastName="" MiddleName="" MobilePhone="" OtherPhone="" PersonID="" PersonInfoKey="" State="" Suffix="" Title="" ZipCode=""/>
						<OverallTotals GrandCharges="" GrandDiscount="" GrandTax="" GrandTotal="" HdrCharges="" HdrDiscount="" HdrTax="" HdrTotal="" LineSubTotal=""/>
					</ReturnOrder>
				</ReturnOrders>
				</Order>
		</Template>

	</API>
	
	<API>
		   
		<xsl:attribute name="Name">
		<xsl:text>getCompleteOrderDetails</xsl:text>
		</xsl:attribute>
					
		<Input>   
				
		<Order>
						    
		<xsl:attribute name="OrderHeaderKey">
		<xsl:value-of select="/Order/@ReturnOrderHeaderKey"/>
		</xsl:attribute>
		<xsl:attribute name="SortingType">
		<xsl:text>ITEM</xsl:text>
		</xsl:attribute>							       
		</Order>
		</Input>
		<Template>
			<Order  OrderDate="" OrderHeaderKey="" OrderName="" OrderNo="" >
				
			</Order>
		</Template>

	</API>
	<API>
	<xsl:attribute name="Name">
	<xsl:text>getShipNodeList</xsl:text>
	</xsl:attribute>

	<Input>

	<ShipNode>

	<xsl:attribute name="NodeOrgCode">
	<xsl:value-of select="/Order/@ShipNode"/>
	</xsl:attribute>
	
	</ShipNode>
	</Input>
		<Template>
		<ShipNodeList>
		<ShipNode  Description="" ShipNode="" >
		<ShipNodePersonInfo AddressLine1="" AddressLine2="" AddressLine3="" AddressLine4="" AddressLine5="" AddressLine6="" AlternateEmailID="" Beeper="" City="" Company="" Country="" DayFaxNo="" DayPhone="" Department="" EMailID="" ErrorTxt="" EveningFaxNo="" EveningPhone="" FirstName="" HttpUrl="" JobTitle="" LastName="" Latitude="" Longitude="" MiddleName="" MobilePhone="" OtherPhone="" PersonID="" PersonInfoKey="" PreferredShipAddress="" State="" Suffix="" Title="" UseCount="" VerificationStatus="" ZipCode="" />
		</ShipNode>
		</ShipNodeList>
		</Template>
	</API>

	<API>
		<xsl:attribute name="Name">
		<xsl:text>getPrinter</xsl:text>
		</xsl:attribute>
		<Input>
			<GetPrinter>
				<xsl:attribute name="PrintDocumentId">
				<xsl:text>PRINT_ORDER_SUMMARY</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="User">
				<xsl:value-of select="/Order/@Loginid"/>
				</xsl:attribute>
			<PrinterPreference>
			<xsl:attribute name="OrganizationCode">
			<xsl:value-of select="/Order/@ShipNode"/>
			</xsl:attribute>
			</PrinterPreference>
			</GetPrinter>
		</Input>
	</API>
	
	<API>
		<xsl:attribute name="Name">
		<xsl:text>getUserHierarchy</xsl:text>
		</xsl:attribute>
		<Input>
		<User>
			<xsl:attribute name="Loginid">
			<xsl:value-of select="/Order/@Loginid"/>
			</xsl:attribute>
		</User>
		</Input>
		<Template>
		<User   Localecode=""  Username=""  /> 
		</Template>
	</API>
	<API>
		<xsl:attribute name="Name">
		<xsl:text>getCurrencyList</xsl:text>
		</xsl:attribute>
		<Input>
		<Currency>
			<xsl:attribute name="Currency">
			<xsl:value-of select="/Order/@Currency"/>
			</xsl:attribute>
		</Currency>
		
		</Input>
		<Template>
		<CurrencyList>
		<Currency PostfixSymbol="" PrefixSymbol=""  /> 
		</CurrencyList>
		</Template>
	</API>
	<API>
		<xsl:attribute name="Name">
		<xsl:text>getItemUOMMasterList</xsl:text>
		</xsl:attribute>
		<Input>
		<ItemUOMMaster>
			<xsl:attribute name="CallingOrganizationCode">
			<xsl:value-of select="/Order/@CallingOrganizationCode"/>
			</xsl:attribute>
		</ItemUOMMaster>
		</Input>
		<Template>
		<ItemUOMMasterList>
		<ItemUOMMaster UnitOfMeasure="" Description="" /> 
		</ItemUOMMasterList>
		</Template>
	</API>

</MultiApi>
</xsl:template>
</xsl:stylesheet>
