<?xml version = "1.0" encoding = "UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="Print | Container">
	<PrintDocuments>
			<xsl:attribute name="FlushToPrinter">
				<xsl:text>Y</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="PrintName">
				<xsl:text>carrierLabel</xsl:text>
			</xsl:attribute>
		<PrintDocument>
			<xsl:attribute name="BeforeChildrenPrintDocumentId">
				<xsl:text>UPS_CARRIER_LABEL</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="BeforeChildrenLabelFormatId">
				<xsl:text>xml:/Container/LabelFormat/@LabelFormatId</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="DataElementPath">
				<xsl:text>xml:/Container</xsl:text>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="name()=&quot;Print&quot;">
					<xsl:copy-of select="PrinterPreference"/>
					<LabelPreference>
						<xsl:copy-of select="LabelPreference/@*"/>
					</LabelPreference>
				</xsl:when>
				<xsl:when test="name()=&quot;Container&quot;">
					<xsl:element name="PrinterPreference">
						<xsl:attribute name="UsergroupId"/>
						<xsl:attribute name="UserId"><xsl:text>xml:/Container/@Modifyuserid</xsl:text></xsl:attribute>
						<xsl:attribute name="WorkStationId"/>
						<xsl:attribute name="OrganizationCode"><xsl:text>xml:/Container/Shipment/ShipNode/@ShipNode</xsl:text></xsl:attribute>
					</xsl:element>
					<xsl:element name="LabelPreference">
						<xsl:attribute name="SCAC">
							<xsl:text>xml:/Container/@SCAC</xsl:text>
						</xsl:attribute>
					</xsl:element>
				</xsl:when>
			 </xsl:choose>
			<KeyAttributes>
				<KeyAttribute>
					<xsl:attribute name="Name"><xsl:text>ShipmentContainerKey</xsl:text></xsl:attribute>
				</KeyAttribute>	
			</KeyAttributes>
			<InputData>
				<xsl:attribute name="FlowName">
					<xsl:text>GetUPSCarrierLabelData</xsl:text>
				</xsl:attribute>
				<Container>
					<xsl:choose>
						<xsl:when test="name()=&quot;Print&quot;">
							<xsl:copy-of select="Container/@*"/>
						</xsl:when>
						<xsl:when test="name()=&quot;Container&quot;">
							<xsl:copy-of select="@*"/>
						</xsl:when>
					</xsl:choose>
				</Container>
				<Template>
				<Api Name="getShipmentContainerDetails">
				  <Template>
					<Container>
						 <SpecialServices>
							  <SpecialService ReferenceKey="" ReferenceType="" SpecialServiceKey="" SpecialServiceRefKey="" SpecialServiceSurcharge="" SpecialServicesCode="" > 
								<SpecialServiceMaster SpecialServicesCode="" SpecialServicesDescription=""/>
							  </SpecialService>
						  </SpecialServices>
						  <ScacEx/>
					 <ContainerDetails>
						 <ContainerDetail ContainerDetailsKey="" ItemID="" ProductClass="" Quantity="" ShipmentContainerKey="" ShipmentKey="" ShipmentLineKey="" UnitOfMeasure="" isHistory="">
							 <ShipmentTagSerials>
								  <ShipmentTagSerial/> 
							  </ShipmentTagSerials>
							 <ShipmentLine>
								  <ShipmentLineInvAttRequest/> 
								  <OrderLine>
								    <Item/>
								  </OrderLine>	
							 </ShipmentLine>
						  </ContainerDetail>
					  </ContainerDetails>
					 <Shipment>
						 <SpecialServices>
							  <SpecialService ReferenceKey="" ReferenceType="" SpecialServiceKey="" SpecialServiceRefKey="" SpecialServiceSurcharge="" SpecialServicesCode="" > 
								<SpecialServiceMaster SpecialServicesCode="" SpecialServicesDescription=""/>
							  </SpecialService>
						  </SpecialServices>
						  <Order OrderNo="">
							 <SpecialServices>
								  <SpecialService ReferenceKey="" ReferenceType="" SpecialServiceKey="" SpecialServiceRefKey="" SpecialServiceSurcharge="" SpecialServicesCode="" > 
									<SpecialServiceMaster SpecialServicesCode="" SpecialServicesDescription=""/>
								  </SpecialService>
							  </SpecialServices>
						  </Order>
						 <ToAddress/> 
						 <ShipNode>
							  <ShipNodePersonInfo/> 
						 </ShipNode>
						 <BillingInformation>
							<AlternateParty/>
						 </BillingInformation>
						 <Containers>
							<Container/>
						 </Containers>
						 <Carrier/>
						 <ScacAndService CarrierServiceKey="" CarrierType="" DistancePerDay="" DistanceUOM="" ElectronicCode="" FixedTransitDays="" HostCode="" InternalReference1="" InternalReference2="" InternalReference3="" InternalReference4="" InternalReference5="" InternationalShipping="" ScacAndService="" ScacAndServiceDesc="" ScacAndServiceKey="" ScacKey="" ShipMode="" /> 
					 </Shipment>
					 <ParentContainer ActualFreightCharge="" ActualWeight="" ActualWeightUOM="" AppliedWeight="" AppliedWeightUOM="" AstraCode="" BarcodeDiscount="" BasicFreightCharge="" CarriageValue="" ContainerGrossWeight="" ContainerGrossWeightUOM="" ContainerGroup="" ContainerHeight="" ContainerHeightUOM="" ContainerLength="" ContainerLengthUOM="" ContainerNetWeight="" ContainerNetWeightUOM="" ContainerNo="" ContainerScm="" ContainerSeqNo="" ContainerType="" ContainerWidth="" ContainerWidthUOM="" CustomsValue="" DeclaredValue="" DimmedFlag="" DiscountAmount="" ExportLicenseExpDate="" ExportLicenseNo="" HasOtherContainers="" IncludedInInventoryPallet="" IsReceived="" LoadKey="" OversizedFlag="" ParentContainerGroup="" ParentContainerKey="" ParentContainerNo="" RoutingCode="" ShipmentContainerKey="" ShipmentKey="" SpecialServicesSurcharge="" TrackingNo="" Ucc128code="" Zone="" isHistory="">
						  <Status Description="" OwnerKey="" ProcessTypeKey="" RequiresCollaboration="" Status="" StatusKey="" StatusName="" StatusType="" /> 
					  </ParentContainer>
					 <ChildContainers TotalNumberOfRecords="">
							 <ChildContainer ActualFreightCharge="" ActualWeight="" ActualWeightUOM="" AppliedWeight="" AppliedWeightUOM="" AstraCode="" BarcodeDiscount="" BasicFreightCharge="" CarriageValue="" ContainerGrossWeight="" ContainerGrossWeightUOM="" ContainerGroup="" ContainerHeight="" ContainerHeightUOM="" ContainerLength="" ContainerLengthUOM="" ContainerNetWeight="" ContainerNetWeightUOM="" ContainerNo="" ContainerScm="" ContainerSeqNo="" ContainerType="" ContainerWidth="" ContainerWidthUOM="" CustomsValue="" DeclaredValue="" DimmedFlag="" DiscountAmount="" ExportLicenseExpDate="" ExportLicenseNo="" HasOtherContainers="" IncludedInInventoryPallet="" IsReceived="" LoadKey="" OversizedFlag="" ParentContainerGroup="" ParentContainerKey="" ParentContainerNo="" RoutingCode="" ShipmentContainerKey="" ShipmentKey="" SpecialServicesSurcharge="" TrackingNo="" Ucc128code="" Zone="" isHistory="">
							  <Status Description="" OwnerKey="" ProcessTypeKey="" RequiresCollaboration="" Status="" StatusKey="" StatusName="" StatusType="" /> 
					  </ChildContainer>
				  </ChildContainers>
			  </Container>
					</Template>
                   </Api>
				</Template>
			</InputData>
	</PrintDocument>
</PrintDocuments>
</xsl:template>
</xsl:stylesheet>