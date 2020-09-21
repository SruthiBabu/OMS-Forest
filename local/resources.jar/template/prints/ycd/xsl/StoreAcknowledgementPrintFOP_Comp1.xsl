<?xml version="1.0" encoding="UTF-8" ?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Call Center and Store
(C) Copyright IBM Corp. 2008, 2011 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
	<!--
	Document   : StoreAcknowledgementPrintJasper_Comp1.xsl
	Author     : lbramhanandamurthy
	Description: This xsl is used to format the input xml to facilitate call to multiApi.
	-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:output indent="yes"/>
	<xsl:template match="/">
		<MultiApi>
			
						
			<xsl:apply-templates select="ShipmentList/Shipment"/>
			

			<API>
				<xsl:attribute name="Name">
					<xsl:text>getCurrencyList</xsl:text>
				</xsl:attribute>
				<Input>
					<Currency>
						<xsl:attribute name="Currency">
							<xsl:value-of select="ShipmentList/Shipment/@Currency"/>
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
					<xsl:text>getUserHierarchy</xsl:text>
				</xsl:attribute>
				<Input>
					<User>
						<xsl:attribute name="Loginid">
							<xsl:value-of select="ShipmentList/Shipment/@Loginid"/>
						</xsl:attribute>
					</User>
				</Input>
				<Template>
					<User Localecode="" Username=""/> 
				</Template>
			</API>
			
			<API>
				<xsl:attribute name="Name">
					<xsl:text>getItemUOMMasterList</xsl:text>
				</xsl:attribute>
				<Input>
					<ItemUOMMaster>
						<xsl:attribute name="CallingOrganizationCode">
							<xsl:value-of select="ShipmentList/Shipment/@ShipNode"/>
						</xsl:attribute>
					</ItemUOMMaster>
				</Input>
				<Template>
					<ItemUOMMasterList>
						<ItemUOMMaster UnitOfMeasure="" Description=""/> 
					</ItemUOMMasterList>
				</Template>
			</API>
		</MultiApi>
	</xsl:template>


	<xsl:template match="ShipmentList/Shipment" > 
		<API>
				<xsl:attribute name="Name">
					<xsl:text>getSortedShipmentDetails</xsl:text>
				</xsl:attribute>
				<Input>
					<Shipment>
						<xsl:attribute name="ShipmentKey">
							<xsl:value-of select="@ShipmentKey"/>
						</xsl:attribute>
					</Shipment>
				</Input>
				<Template>
					<Shipment Currency="" ShipmentKey="" OrderNo="" ShipmentNo="" ShipNode="" ActualShipmentDate="" ExpectedShipmentDate=""  RequestedShipmentDate="" >
						<ToAddress LastName="" FirstName=""/>
						<FromAddress AddressLine1="" AddressLine2="" AddressLine3="" City="" State="" ZipCode=""/>
						<ShipmentLines TotalNumberOfRecords="">
							<ShipmentLine OrderNo="" ItemDesc="" ItemID="" ProductClass="" ActualQuantity="" UnitOfMeasure=""  Quantity="" >
								<OrderLine ItemID="" GiftFlag="" >
									<LinePriceInfo UnitPrice="" PricingUOM="" />
									<Instructions>
										<Instruction InstructionType="" InstructionText="" />
									</Instructions>									
								</OrderLine>
							</ShipmentLine>
						</ShipmentLines>
						 <ShipNode Description="" ShipNode="">
						   <ShipNodePersonInfo AddressLine1=""
							AddressLine2="" AddressLine3="" AddressLine4=""
							AddressLine5="" AddressLine6="" AlternateEmailID=""
							Beeper="" City="Boston" Company="Matrix Retail" Country="US"
							DayFaxNo="" DayPhone="" Department="" EMailID="" ErrorTxt=""
							EveningFaxNo="" EveningPhone="" FirstName="John" HttpUrl=""
							JobTitle="" LastName="Roberts" MiddleName="" MobilePhone=""
							OtherPhone="" PersonID=""
							PersonInfoKey="" PreferredShipAddress=""
							State="MA" Suffix="" Title="" UseCount="0"
							VerificationStatus="" ZipCode=""/>
						</ShipNode>
					</Shipment>
				</Template>
			</API>
		</xsl:template>
</xsl:stylesheet>
