<?xml version = "1.0" encoding = "UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="Manifest | Print">
	<PrintDocuments>
			<xsl:attribute name="FlushToPrinter">
				<xsl:text>Y</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="PrintName">
				<xsl:text>pickupSummary</xsl:text>
			</xsl:attribute>
		<PrintDocument>
			<xsl:attribute name="BeforeChildrenPrintDocumentId">
				<xsl:text>UPS_PICKUP_SUMMARY</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="BeforeChildrenLabelFormatId">
				<xsl:text>xml:/Manifest/LabelFormat/@LabelFormatId</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="DataElementPath">
				<xsl:text>xml:/Manifest</xsl:text>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="name()=&quot;Print&quot;">
					<xsl:copy-of select="PrinterPreference"/>
					<xsl:copy-of select="LabelPreference"/>
				</xsl:when>
				<xsl:when test="name()=&quot;Manifest&quot;">
					<xsl:element name="PrinterPreference">
						<xsl:attribute name="UsergroupId"/>
						<xsl:attribute name="UserId"><xsl:text>xml:/Manifest/@Modifyuserid</xsl:text></xsl:attribute>
						<xsl:attribute name="WorkStationId"/>
						<xsl:attribute name="OrganizationCode"><xsl:text>xml:/Manifest/ShipNode/@NodeOrgCode</xsl:text></xsl:attribute>
					</xsl:element>
					<xsl:element name="LabelPreference">
						<xsl:attribute name="SCAC">
							<xsl:text>xml:/Manifest/@SCAC</xsl:text>
						</xsl:attribute>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
			<KeyAttributes>
				<KeyAttribute>
					<xsl:attribute name="Name"><xsl:text>ManifestKey</xsl:text></xsl:attribute>
				</KeyAttribute>
			</KeyAttributes>
			<InputData>
				<xsl:attribute name="FlowName">
					<xsl:text>GetManifestSummaryData</xsl:text>
				</xsl:attribute>
				<Manifest>
				<xsl:choose>
					<xsl:when test="name()=&quot;Print&quot;">
						<xsl:attribute name="ManifestKey">
							<xsl:value-of select="Manifest/@ManifestKey"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:when test="name()=&quot;Manifest&quot;">
						<xsl:attribute name="ManifestKey">
							<xsl:value-of select="@ManifestKey"/>
						</xsl:attribute>
					</xsl:when>
				</xsl:choose>
				</Manifest>
				<Template>
				<Api Name="getManifestDetails">
				  <Template>
				  <Manifest>
					 <ShipNode>
						  <ShipNodePersonInfo/> 
					  </ShipNode>
					<Carrier>
						<ScacExList>
							<ScacEx/>
						</ScacExList>
					</Carrier>
					<Shipments>
						<Shipment>
							<ScacAndService/>
							<SpecialServices>
								<SpecialService/>
							</SpecialServices>
							<ToAddress/>
							 <ShipNode>
								  <ShipNodePersonInfo/> 
							  </ShipNode>
							 <Containers>
								 <Container>
									<SpecialServices>
										<SpecialService/>
									</SpecialServices>
								     <ScacEx/>
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
									<Order>
										<OrderLines>
										<OrderLine>
												<Item/>
										</OrderLine>		
										</OrderLines>
									</Order>
								</ShipmentLine>
							</ShipmentLines>
						</Shipment>
					  </Shipments>
					 </Manifest> 
					</Template>
                   </Api>
				</Template>
			</InputData>
	</PrintDocument>
</PrintDocuments>
</xsl:template>
</xsl:stylesheet>