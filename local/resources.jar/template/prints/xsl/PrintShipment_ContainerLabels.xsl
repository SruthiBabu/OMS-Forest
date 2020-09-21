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
			<xsl:choose>
				<xsl:when test="name()=&quot;Print&quot;">
					<xsl:copy-of select="PrinterPreference"/>
					<xsl:copy-of select="LabelPreference"/>
				</xsl:when>
				<xsl:when test="name()=&quot;Shipment&quot;">
					<PrinterPreference>
						<xsl:attribute name="UsergroupId"/>
						<xsl:attribute name="UserId"><xsl:text>xml:/Container/@Modifyuserid</xsl:text></xsl:attribute>
						<xsl:attribute name="WorkStationId"><xsl:text>xml:/Container/@ContainerEquipment</xsl:text></xsl:attribute>
						<xsl:attribute name="OrganizationCode"><xsl:text>xml:/Container/Shipment/ShipNode/@NodeOrgCode</xsl:text></xsl:attribute>
					</PrinterPreference>
					<LabelPreference>
						<xsl:attribute name="BuyerOrganizationCode">
							<xsl:text>xml:/Container/Shipment/@BuyerOrganizationCode</xsl:text>
						</xsl:attribute>
					</LabelPreference>
				</xsl:when>
			</xsl:choose>
			<KeyAttributes>
				<KeyAttribute>
					<xsl:attribute name="Name"><xsl:text>ShipmentContainerKey</xsl:text></xsl:attribute>
				</KeyAttribute>	
			</KeyAttributes>
				<InputData>
					<xsl:attribute name="APIName">
						<xsl:text>getShipmentContainerList</xsl:text>
					</xsl:attribute>
					<Container>
						<xsl:choose>
							<xsl:when test="name()=&quot;Print&quot;">
							<xsl:attribute name="ShipmentKey">
								<xsl:value-of select="Shipment/@ShipmentKey" />
							</xsl:attribute> 
							</xsl:when>
							<xsl:when test="name()=&quot;Shipment&quot;">
							<xsl:attribute name="ShipmentKey">
								<xsl:value-of select="@ShipmentKey" /> 
							</xsl:attribute> 
							</xsl:when>
						</xsl:choose>	
					</Container>
					<Template>
						 <Containers>
							<Container ShipmentContainerKey=""/>
						</Containers>	
					</Template>
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
							<Container  ContainerEquipment="" ContainerNo="" ContainerScm="" ContainerType=""  ShipmentContainerKey="" ShipmentKey=""  TrackingNo=""  Zone="" HasMultiDepartmentCodes="" HasMultiCustomerPONo="">
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
								<Corrugation ItemID=""/>
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