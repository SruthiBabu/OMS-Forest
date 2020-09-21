<?xml version = "1.0" encoding = "UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="Print | Load">
	<PrintDocuments FlushToPrinter="Y" PrintName="LoadBOL">
		<xsl:variable name="IsHazmat">
			<xsl:choose>
				<xsl:when test="name()=&quot;Print&quot;">
					<xsl:value-of select="Load/@HazardousMaterial"/>
				</xsl:when>
				<xsl:when test="name()=&quot;Load&quot;">
					<xsl:value-of select="@HazardousMaterial"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<PrintDocument>
			<xsl:attribute name="Localecode">
				<xsl:text>xml:/Load/LoadShipments/LoadShipment/Shipment/ShipNode/@Localecode</xsl:text>
			</xsl:attribute>
			<InputData>
				<xsl:attribute name="APIName">
					<xsl:text>getLoadDetails</xsl:text>
				</xsl:attribute>
				<Load>
				<xsl:choose>
					<xsl:when test="name()=&quot;Print&quot;">
						<xsl:copy-of select="Load/@*" /> 
					</xsl:when>
					<xsl:when test="name()=&quot;Load&quot;">
						<xsl:copy-of select="@*" /> 
					</xsl:when>
				</xsl:choose>	
				</Load>
					<Template>	
						<Load>
							<LoadShipments>
								<LoadShipment>
									<Shipment>
										<ShipNode/>
									</Shipment>
								</LoadShipment>
							</LoadShipments>
						</Load>
					</Template>
			</InputData>
		</PrintDocument>
		<PrintDocument>
			<xsl:attribute name="BeforeChildrenPrintDocumentId">
				<xsl:text>VICS_BOL</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="BeforeChildrenLabelFormatId">
				<xsl:text>xml:/Load/LabelFormat/@LabelFormatId</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="DataElementPath">
				<xsl:text>xml:/Load</xsl:text>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="name()=&quot;Print&quot;">
					<xsl:copy-of select="PrinterPreference"/>
					<xsl:copy-of select="LabelPreference"/>
				</xsl:when>
				<xsl:when test="name()=&quot;Load&quot;">
					<xsl:element name="PrinterPreference">
						<xsl:attribute name="UsergroupId"/>
						<xsl:attribute name="UserId"><xsl:text>xml:/Load/@Modifyuserid</xsl:text></xsl:attribute>
						<xsl:attribute name="WorkStationId"/>
						<xsl:attribute name="OrganizationCode"><xsl:text>xml:/Load/@OriginNode</xsl:text></xsl:attribute>
					</xsl:element>
					<xsl:element name="LabelPreference">
						<xsl:attribute name="SCAC">
							<xsl:text>xml:/Load/@SCAC</xsl:text>
						</xsl:attribute>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
			<xsl:element name="KeyAttributes">
				<xsl:element name="KeyAttribute">
					<xsl:attribute name="Name"><xsl:text>LoadKey</xsl:text></xsl:attribute>
				</xsl:element>
			</xsl:element>
			<InputData>
				<xsl:attribute name="APIName">
					<xsl:text>manageLoad</xsl:text>
				</xsl:attribute>
				<Loads>
					<Load>
						<xsl:attribute name="GenerateBolNo"><xsl:text>Y</xsl:text></xsl:attribute>
						<xsl:choose>
							<xsl:when test="name()=&quot;Print&quot;">
								<xsl:copy-of select="Load/@*" /> 
							</xsl:when>
							<xsl:when test="name()=&quot;Load&quot;">
								<xsl:copy-of select="@*" /> 
							</xsl:when>
						</xsl:choose>
					</Load>
			   </Loads>
				<Template>
					<Loads>
						 <Load>
							 <LoadShipments>
								 <LoadShipment ShipmentKey="">
									  <Shipment ShipmentNo="" ShipmentKey=""/> 
								 </LoadShipment>
							  </LoadShipments>
						  </Load>
					  </Loads>					
					</Template>
				<InputData>
					<xsl:attribute name="FlowName">
						<xsl:text>GetLoadBOLData</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ParentDataElement">
						<xsl:text>Load</xsl:text>
					</xsl:attribute>
					<Load>
						<xsl:choose>
							<xsl:when test="name()=&quot;Print&quot;">
								<xsl:copy-of select="Load/@*" /> 
							</xsl:when>
							<xsl:when test="name()=&quot;Load&quot;">
								<xsl:copy-of select="@*" /> 
							</xsl:when>
						</xsl:choose>	
					</Load>
				<Template>
					<Api Name="getLoadDetails">
					<Template>
					<Load DocumentType="" PickupFromShipmentOrigin="" DropAtShipmentDestination="" ActualArrivalDate=" " ActualDepartureDate=" " AppointmentNo=" " BolNo=" " CarrierServiceCode="" Currency=" " DeliveryPlanKey="" DestinationAddressKey=" " DestinationNode="" EnterpriseCode=" " ExpectedArrivalDate=" " ExpectedDepartureDate=" " HeldForConfirmation=" " LoadKey=" " LoadNo=" " LoadType=" " OriginAddressKey=" " OriginNode="" OwnerOrganizationCode=" " PodNo=" " ProNo=" " Scac="" ScacAndService="" ScacAndServiceKey="" SealNo=" " ShipMode=" " ShipVia=" " Status="" StatusDate="" TotalActualCharge=" " TotalEstimatedCharge=" " TotalVolume=" " TotalVolumeUOM=" " TotalWeight=" " TotalWeightUOM=" " TrailerNo=" " MultipleLoadStop="" BuyerOrganizationCode="">
						<OriginAddress/> 
					    <DestinationAddress/> 
						<Carrier/>
						<Instructions>
							<Instruction/>
						</Instructions>
						<LoadStops>
							<LoadStop/>
						</LoadStops>
						<LoadShipments>
							 <LoadShipment>
								  <PickupStop /> 
								  <DropoffStop/> 
								  <Shipment> 
									<Carrier/>
									<BillingInformation>
										<AlternateParty/>
									</BillingInformation>
									<ToAddress/>
									 <ShipNode>
										  <ShipNodePersonInfo/> 
									  </ShipNode>
									 <Containers>
										 <Container>
											 <ContainerDetails>
												 <ContainerDetail>
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
									</Container>
									</Containers>
										<ShipmentLines>
											<ShipmentLine>
												<OrderLine>
													<Item/>
												</OrderLine>
											</ShipmentLine>
										</ShipmentLines>
								  </Shipment>
						  </LoadShipment>
						 </LoadShipments>
						 <LoadContainers>
							 <Container>
								 <ContainerDetails>
									 <ContainerDetail>
									 <ShipmentTagSerials>
										<ShipmentTagSerial/> 
								     </ShipmentTagSerials>
									 <ShipmentLine>
											<ShipmentLineInvAttRequest /> 
                                        <OrderLine>
                                            <Item/>
                                        </OrderLine>
									</ShipmentLine>
							 </ContainerDetail>
						 </ContainerDetails>
						</Container>
						</LoadContainers>
						</Load>
					</Template>
					</Api>
				</Template>
				<InputData>
					<xsl:attribute name="ParentDataElement">
						<xsl:text>Load</xsl:text>
					</xsl:attribute>					
				</InputData>				
			</InputData>
		</InputData>
	</PrintDocument>
	<xsl:if test="$IsHazmat = 'Y'">
            <PrintDocument>
			<xsl:attribute name="BeforeChildrenPrintDocumentId">
				<xsl:text>HAZMAT_BOL</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="DataElementPath">
				<xsl:text>xml:/HazmatData</xsl:text>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="name()=&quot;Print&quot;">
					<xsl:copy-of select="PrinterPreference"/>
					<xsl:copy-of select="LabelPreference"/>
				</xsl:when>
				<xsl:when test="name()=&quot;Load&quot;">
					<xsl:element name="PrinterPreference">
						<xsl:attribute name="UsergroupId"/>
						<xsl:attribute name="UserId"><xsl:text>xml:/HazmatData/@Modifyuserid</xsl:text></xsl:attribute>
						<xsl:attribute name="WorkStationId"/>
						<xsl:attribute name="OrganizationCode"><xsl:text>xml:/HazmatData/@NodeOrgCode</xsl:text></xsl:attribute>
					</xsl:element>
					<xsl:element name="LabelPreference">
						<xsl:attribute name="SCAC">
							<xsl:text>xml:/HazmatData/@Scac</xsl:text>
						</xsl:attribute>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
			<xsl:element name="KeyAttributes">
				<xsl:element name="KeyAttribute">
					<xsl:attribute name="Name"><xsl:text>LoadKey</xsl:text></xsl:attribute>
				</xsl:element>
			</xsl:element>
			<InputData>
				<xsl:attribute name="FlowName">
					<xsl:text>GetLoadHazmatBOLData</xsl:text>
				</xsl:attribute>
				<Load>
					<xsl:choose>
						<xsl:when test="name()=&quot;Print&quot;">
							<xsl:copy-of select="Load/@*" /> 
						</xsl:when>
						<xsl:when test="name()=&quot;Load&quot;">
							<xsl:copy-of select="@*" /> 
						</xsl:when>
					</xsl:choose>
				</Load>
				   <Template>
					<Api Name="getLoadDetails">
						<Template>
						<Load DocumentType="" PickupFromShipmentOrigin="" DropAtShipmentDestination="" ActualArrivalDate=" " ActualDepartureDate=" " AppointmentNo=" " BolNo=" " CarrierServiceCode="" Currency=" " DeliveryPlanKey="" DestinationAddressKey=" " DestinationNode="" EnterpriseCode=" " ExpectedArrivalDate=" " ExpectedDepartureDate=" " HeldForConfirmation=" " LoadKey=" " LoadNo=" " LoadType=" " OriginAddressKey=" " OriginNode="" OwnerOrganizationCode=" " PodNo=" " ProNo=" " Scac="" ScacAndService="" ScacAndServiceKey="" SealNo=" " ShipMode=" " ShipVia=" " Status="" StatusDate="" TotalActualCharge=" " TotalEstimatedCharge=" " TotalVolume=" " TotalVolumeUOM=" " TotalWeight=" " TotalWeightUOM=" " TrailerNo=" " MultipleLoadStop="" Modifyuserid="">
						<OriginAddress/> 
						<DestinationAddress/> 
						<Carrier/>
						<LoadShipments>
							 <LoadShipment>
								  <Shipment> 
									<Carrier/>
									 <Containers>
										 <Container>
											 <ContainerDetails>
												<ContainerDetail>
												  <ShipmentLine>
													<Item>
														<PrimaryInformation IsHazmat="" />
														<ClassificationCodes HazmatClass="" />
														<HazmatInformation Symbols=" " ProperShippingName=" " HazardClass=" " UNNumber=" " PackingGroup=" " Label=" " SpecialProvisions=" " Exception=" " QtyNonBulk=" " QtyBulk=" " PassengerAir=" " CargoAir=" " Vessel=" " VesselSP=" " SortOrder=" "/>
													</Item>
												  </ShipmentLine>
												</ContainerDetail>
											</ContainerDetails>
										</Container>
									</Containers>
								</Shipment>
						  </LoadShipment>
						 </LoadShipments>
						 <LoadContainers>
							 <Container>
								<ContainerDetails>
									<ContainerDetail>
										<ShipmentLine>
											<Item>
												<PrimaryInformation IsHazmat="" />
												<ClassificationCodes HazmatClass="" />
												<HazmatInformation Symbols=" " ProperShippingName=" " HazardClass=" " UNNumber=" " PackingGroup=" " Label=" " SpecialProvisions=" " Exception=" " QtyNonBulk=" " QtyBulk=" " PassengerAir=" " CargoAir=" " Vessel=" " VesselSP=" " SortOrder=" "/>
											</Item>
										</ShipmentLine>
									</ContainerDetail>
								</ContainerDetails>
							</Container>
						</LoadContainers>
						</Load>
					</Template>
					</Api>
				</Template>
			</InputData>
            </PrintDocument>
        </xsl:if>
</PrintDocuments>
</xsl:template>
</xsl:stylesheet>
