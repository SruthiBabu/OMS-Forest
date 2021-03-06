<?xml version = "1.0" encoding = "UTF-8"?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Selling and fulfillment Suite
(C) Copyright IBM Corp. 2008,2011 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="Print | Shipment">
	<PrintDocuments FlushToPrinter="Y" PrintName="ShipmentBOL">
		<xsl:variable name="IsHazmat">
			<xsl:choose>
				<xsl:when test="name()=&quot;Print&quot;">
					<xsl:value-of select="Shipment/@HazardousMaterialFlag"/>
				</xsl:when>
				<xsl:when test="name()=&quot;Shipment&quot;">
					<xsl:value-of select="@HazardousMaterialFlag"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<PrintDocument>			
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
				<xsl:text>VICS_BOL</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="BeforeChildrenLabelFormatId">
				<xsl:text>xml:/Shipment/LabelFormat/@LabelFormatId</xsl:text>
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
					<xsl:element name="PrinterPreference">
						<xsl:attribute name="UsergroupId"/>
						<xsl:attribute name="UserId"><xsl:text>xml:/Shipment/@Modifyuserid</xsl:text></xsl:attribute>
						<xsl:attribute name="WorkStationId"/>
						<xsl:attribute name="OrganizationCode"><xsl:text>xml:/Shipment/ShipNode/@NodeOrgCode</xsl:text></xsl:attribute>
					</xsl:element>
					<xsl:element name="LabelPreference">
						<xsl:attribute name="SCAC">
							<xsl:text>xml:/Shipment/@SCAC</xsl:text>
						</xsl:attribute>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
			<KeyAttributes>
				<KeyAttribute>
					<xsl:attribute name="Name"><xsl:text>ShipmentKey</xsl:text></xsl:attribute>
				</KeyAttribute>
			</KeyAttributes>
			<InputData>
				<xsl:attribute name="FlowName">
					<xsl:text>GetShipmentBOLData</xsl:text>
				</xsl:attribute>
				<Shipment>
					<xsl:attribute name="GenerateBolNo"><xsl:text>Y</xsl:text></xsl:attribute>
					<xsl:choose>
						<xsl:when test="name()=&quot;Print&quot;">
							<xsl:copy-of select="Shipment/@*"/>
						</xsl:when>
						<xsl:when test="name()=&quot;Shipment&quot;">
							<xsl:copy-of select="@*" /> 
						</xsl:when>
					</xsl:choose>	
				</Shipment>
				<Template>
				<Api Name="getShipmentDetails">
				  <Template>
					<Shipment>
					<LoadShipments>
						<LoadShipment LoadKey="" >
							<Load LoadKey="">
								<LoadStops>
									<LoadStop/>
								</LoadStops>
							</Load>
						</LoadShipment>
					</LoadShipments>
                       <Carrier/>
						<BillingInformation>
							<AlternateParty/>
						</BillingInformation>
						<ToAddress/>
						 <ShipNode>
							  <ShipNodePersonInfo/> 
						  </ShipNode>
						  <FromAddress/>
						  <MarkForAddress/>
							<Instructions>
								<Instruction/>
							</Instructions>
						 <Containers>
							 <Container>
								 <ContainerDetails>
									 <ContainerDetail>
									 <ShipmentTagSerials>
										<ShipmentTagSerial/> 
								     </ShipmentTagSerials>
									 <ShipmentLine>
									 	<Item>
											<PrimaryInformation IsHazmat="" />
											<ClassificationCodes/>
										</Item>
										  <ShipmentLineInvAttRequest/> 
											<OrderLine>
												<Item>
													<PrimaryInformation IsHazmat="" />
													<ClassificationCodes/>
												</Item>
											</OrderLine>		
									</ShipmentLine>
							 </ContainerDetail>
						 </ContainerDetails>
						</Container>
						</Containers>
							<ShipmentLines>
								<ShipmentLine>
									<Item>
										<PrimaryInformation IsHazmat="" />
										<ClassificationCodes/>
									</Item>
									<OrderLine>
										<Item>
											<PrimaryInformation IsHazmat="" />
											<ClassificationCodes/>
										</Item>
									</OrderLine>		
								</ShipmentLine>
							</ShipmentLines>
						</Shipment>
					</Template>
                   </Api>
				</Template>
				<InputData>
					<xsl:attribute name="ParentDataElement">
							<xsl:text>Shipment</xsl:text>
					</xsl:attribute>	
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
				<xsl:when test="name()=&quot;Shipment&quot;">
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
			<KeyAttributes>
				<KeyAttribute>
					<xsl:attribute name="Name"><xsl:text>ShipmentKey</xsl:text></xsl:attribute>
				</KeyAttribute>
			</KeyAttributes>
			<InputData>
				<xsl:attribute name="FlowName">
					<xsl:text>GetShipmentHazmatBOLData</xsl:text>
				</xsl:attribute>
				<Shipment>
					<xsl:choose>
						<xsl:when test="name()=&quot;Print&quot;">
							<xsl:copy-of select="Shipment/@*"/>
						</xsl:when>
						<xsl:when test="name()=&quot;Shipment&quot;">
							<xsl:copy-of select="@*" /> 
						</xsl:when>
					</xsl:choose>	
				</Shipment>
				<Template>
				<Api Name="getShipmentDetails">
				  <Template>
					<Shipment ActualShipmentDate="" BolNo="" BuyerOrganizationCode="" EnterpriseCode="" ParentShipmentKey="" ProNo="" SCAC="" ScacAndService="" SellerOrganizationCode="" ShipNode="" ShipmentKey="" ShipmentNo="" TotalWeight="" TotalWeightUOM="" TrailerNo="" >
						<Carrier/>
						<ToAddress/>
						<ShipNode>
							<ShipNodePersonInfo/> 
						</ShipNode>
						
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
				</Template>
		                </Api>
				</Template>
			</InputData>
		    	</PrintDocument>
		</xsl:if>

</PrintDocuments>
</xsl:template>
</xsl:stylesheet>
