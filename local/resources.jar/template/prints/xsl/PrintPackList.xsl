<?xml version = "1.0" encoding = "UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:output indent="yes"/>
	<xsl:template match="Print | Shipment">
	<xsl:variable name="hasShipmentChanged">
            <xsl:value-of select="@ShipmentQuantityChanged"/>
        </xsl:variable>  
	<PrintDocuments>
		<xsl:attribute name="PrintName">
			<xsl:text>packList</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="FlushToPrinter">
			<xsl:text>Y</xsl:text>
		</xsl:attribute>
		<xsl:if test="($hasShipmentChanged)='Y'">
		<xsl:attribute name="PrintAfresh">
			<xsl:text>Y</xsl:text>
		</xsl:attribute>
		</xsl:if>
		<PrintDocument>
			<xsl:attribute name="Localecode">
				<xsl:text>xml:/Shipment/ShipNode/@Localecode</xsl:text>
			</xsl:attribute>
			<InputData>
				<xsl:attribute name="APIName">
					<xsl:text>getShipmentDetails</xsl:text>
				</xsl:attribute>
				<Shipment>
				<xsl:choose>
					<xsl:when test="name()=&quot;Print&quot;">
						<xsl:copy-of select="Shipment/@*" /> 
					</xsl:when>
					<xsl:when test="name()=&quot;Shipment&quot;">
						<xsl:copy-of select="@*" /> 
					</xsl:when>
				</xsl:choose>	
				</Shipment>
					<Template>	
						<Shipment>
							<ShipNode>
								<ShipNodePersonInfo/>
							</ShipNode>
						</Shipment>
				</Template>
			</InputData>
		</PrintDocument>
		<PrintDocument>
			<xsl:attribute name="BeforeChildrenPrintDocumentId">
				<xsl:text>PACKLIST</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="DataElementPath">
				<xsl:text>xml:/Shipment</xsl:text>
			</xsl:attribute>

			<xsl:choose>
				<xsl:when test="name()=&quot;Print&quot;">
					<xsl:copy-of select="PrinterPreference"/>
					<xsl:copy-of select="LabelPreference"/>
				</xsl:when>
				<xsl:when test="name()=&quot;Shipment&quot;">
					<PrinterPreference>
						<xsl:attribute name="PrinterId"/>
						<xsl:attribute name="UsergroupId"/>
						<xsl:attribute name="UserId"><xsl:text>xml:/Shipment/@Modifyuserid</xsl:text></xsl:attribute>
						<xsl:choose>
							<xsl:when test="@StationId and not (@StationId = &quot;&quot;)">
								<xsl:attribute name="WorkStationId"><xsl:value-of select="@StationId"/></xsl:attribute>
							</xsl:when>
							<xsl:otherwise>	
								<xsl:attribute name="WorkStationId"></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:attribute name="OrganizationCode"><xsl:text>xml:/Shipment/ShipNode/@NodeOrgCode</xsl:text></xsl:attribute>
					</PrinterPreference>
					<LabelPreference>
						<xsl:attribute name="EnterpriseCode">
							<xsl:text>xml:/Shipment/@EnterpriseCode</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="BuyerOrganizationCode">
							<xsl:text>xml:/Shipment/@BuyerOrganizationCode</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="SellerOrganizationCode">
							<xsl:text>xml:/Shipment/@SellerOrganizationCode</xsl:text>
						</xsl:attribute>
						<xsl:if test="@StationType and not (@StationType = &quot;&quot;)">
							<xsl:attribute name="EquipmentType">
								<xsl:value-of select="@StationType"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="Node">
							<xsl:value-of select="@ShipNode"/>
						</xsl:attribute>
					</LabelPreference>
				</xsl:when>
			</xsl:choose>
			<KeyAttributes>
				<KeyAttribute>
					<xsl:attribute name="Name"><xsl:text>ShipmentKey</xsl:text></xsl:attribute>
				</KeyAttribute>
			</KeyAttributes>
			<InputData>
				<xsl:attribute name="FlowName">
					<xsl:text>GetPackListData</xsl:text>
				</xsl:attribute>
				<Shipment>
				<xsl:choose>
					<xsl:when test="name()=&quot;Print&quot;">
						<xsl:copy-of select="Shipment/@*" /> 
					</xsl:when>
					<xsl:when test="name()=&quot;Shipment&quot;">
						<xsl:copy-of select="@*" /> 
					</xsl:when>
				</xsl:choose>	
				</Shipment>
				<Template>
					<Api Name="getShipmentDetails">
					<Template>	
						<Shipment ShipmentKey="" ShipmentNo="" ActualShipmentDate="" ExpectedShipmentDate="">
							<SellerOrganization OrganizationCode="">
								<CorporatePersonInfo AddressLine1="" AddressLine2="" FirstName="" MiddleName="" LastName="" City="" State="" Country="" ZipCode="" />
							</SellerOrganization>
							<Carrier Scac="" ScacDesc=""/>
							<MarkForAddress/>
							<BillingInformation ShipmentChargeType=""/>
							<Instructions>
								<Instruction InstructionType="" InstructionText=""/>
							</Instructions>
							<ToAddress/>
							<BatchLocations> 
							    <BatchLocation CartLocationId="">
							         <Batch BatchNo=""/>
                                                            </BatchLocation>
							</BatchLocations>
							<ShipmentLines>
								<ShipmentLine ActualQuantity="" ItemDesc="" ItemID="" OrderHeaderKey="" OrderLineKey="" OrderNo="" OrderReleaseKey="" PrimeLineNo=""  Quantity="" ReleaseNo="" ShipmentKey="" ShipmentLineKey="" ShipmentLineNo="" SubLineNo="" UnitOfMeasure="" BackOrderedQty="" ShipmentSubLineNo="" CustomerPoNo="" >
									<Order OrderHeaderKey="" OrderNo="">
										<PersonInfoBillTo AddressLine1="" AddressLine2="" FirstName="" MiddleName="" LastName="" City="" State="" Country="" ZipCode=""  />
									</Order>
									<OrderLine OrderLineKey="" OrderedQty="" OriginalOrderedQty=""   Status="" StatusQuantity="" SubLineNo="" >
										<Item CustomerItem=""/>
										<OrderStatuses>
											 <OrderStatus OrderLineKey="" OrderReleaseStatusKey=""  Status=""  StatusQty="" TotalQuantity=""/>
										  </OrderStatuses>
									</OrderLine>		
								</ShipmentLine>
							</ShipmentLines>
							<ShipNode NodeOrgCode="">
							     <ShipNodePersonInfo  AddressLine1="" AddressLine2="" FirstName="" MiddleName="" LastName="" City="" State="" Country="" ZipCode=""/>
							</ShipNode>  
						</Shipment>
					</Template>
				  </Api>	
				</Template>
			</InputData>
	</PrintDocument>
</PrintDocuments>
</xsl:template>
</xsl:stylesheet>