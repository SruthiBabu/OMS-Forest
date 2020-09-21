<?xml version = "1.0" encoding = "UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
<xsl:output indent="yes"/>
	<xsl:template match="/">
	       <xsl:if test="not(ContainerList)">
			<xsl:message terminate="yes">ContainerList Information is Mandatory
			</xsl:message>
		</xsl:if>
		<PrintDocuments>
			<PrintDocument>
			<xsl:attribute name="BeforeChildrenPrintDocumentId">
				<xsl:text>CONTAINER_LABEL</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="BeforeChildrenLabelFormatId">
				<xsl:text>xml:/Container/@LabelFormatId</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="PrintName">
				<xsl:text>ShipmentContainers</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="DataElementPath">
				<xsl:text>xml:/Container</xsl:text>
			</xsl:attribute>
			<PrinterPreference>
				<xsl:attribute name="UsergroupId"/>
				<xsl:attribute name="UserId"><xsl:text>xml:/Container/@Modifyuserid</xsl:text></xsl:attribute>
				<xsl:choose>
					<xsl:when test="ContainerList/Container/PackLocation/@StationId and not (ContainerList/Container/PackLocation/@StationId = &quot;&quot;)">
					<xsl:attribute name="WorkStationId"><xsl:value-of select="ContainerList/Container/PackLocation/@StationId"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>	
						<xsl:attribute name="WorkStationId"><xsl:text>xml:/Container/@ContainerEquipment</xsl:text></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:attribute name="OrganizationCode"><xsl:text>xml:/Container/Shipment/ShipNode/@NodeOrgCode</xsl:text></xsl:attribute>
			</PrinterPreference>
			<LabelPreference>
				<xsl:attribute name="BuyerOrganizationCode">
					<xsl:text>xml:/Container/Shipment/@BuyerOrganizationCode</xsl:text>
				</xsl:attribute>
				<xsl:if test="ContainerList/Container/PackLocation/@StationType and not (ContainerList/Container/PackLocation/@StationType = &quot;&quot;)">
					<xsl:attribute name="EquipmentType">
						<xsl:value-of select="ContainerList/Container/PackLocation/@StationType"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="Node">
					<xsl:value-of select="ContainerList/Container/PackLocation/@Node"/>
				</xsl:attribute>
			</LabelPreference>
			<KeyAttributes>
				<KeyAttribute>
					<xsl:attribute name="Name"><xsl:text>ShipmentContainerKey</xsl:text></xsl:attribute>
				</KeyAttribute>	
			</KeyAttributes>
				<InputData>
					<xsl:copy-of select="ContainerList"/>
					<InputData>
					<xsl:attribute name="FlowName">
						<xsl:text>GetShippingLabelData</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ParentDataElement">
						<xsl:text>Container</xsl:text>
					</xsl:attribute>
					<Container>
					   <xsl:attribute name="GenerateContainerScm">Y</xsl:attribute>
					   <xsl:attribute name="ShipmentContainerKey">@ShipmentContainerKey</xsl:attribute>
					</Container>
					<Template>
						<Api Name="getShipmentContainerDetails">
						<Template>	
							<Container  ContainerEquipment="" ContainerNo="" ContainerScm="" ContainerType=""  ShipmentContainerKey="" ShipmentKey=""  TrackingNo=""  Zone="" >
								<BatchLocation BatchNo="" CartLocationId="" SlotNumber="" />
								<ContainerDetails TotalNumberOfRecords="">
									<ContainerDetail ItemID="" Quantity="">
										<ShipmentLine CustomerPoNo="" DepartmentCode="" ShipmentLineKey="" MarkForKey="">
                                                                                        <OrderLine OrderLineKey="">
                                                                                            <Item ItemID="" CustomerItem=""/>
                                                                                        </OrderLine>
											<MarkForAddress  Department=""/>
										</ShipmentLine>
									</ContainerDetail>
								</ContainerDetails>	
								<Shipment BuyerOrganizationCode="" ShipmentNo="" SCAC="" ProNo="" BolNo="" TrailerNo="">
									<ScacAndService CarrierType=""/>
									<ToAddress AddressLine1="" AddressLine2="" FirstName="" MiddleName="" LastName="" City="" State="" Country="" ZipCode="" />
									<FromAddress AddressLine1="" AddressLine2="" FirstName="" MiddleName="" LastName="" City="" State="" Country="" ZipCode="" />
									<MarkForAddress Department="" />
									<ShipNode ShipNode="" NodeOrgCode=""/>
								</Shipment>	
							</Container>
						  </Template>	
						</Api>
					</Template>
			</InputData>
		</InputData>
	</PrintDocument>
</PrintDocuments>
</xsl:template>
</xsl:stylesheet>