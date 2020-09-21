<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    PrintLTLManifest.xsl
    Created on  March 4, 2005
    Author      Sudheer
    Description
        This XSL transforms the manifest details XML into PrintDocumentSet api input.
-->

<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<!--<xsl:output indent="yes"/> -->
	<xsl:template match="Print | Manifest">
		<xsl:variable name="IsHazmat">
			<xsl:choose>
				<xsl:when test="name()=&quot;Print&quot;">
					<xsl:value-of select="Manifest/@IsHazmat"/>
				</xsl:when>
				<xsl:when test="name()=&quot;Manifest&quot;">
					<xsl:value-of select="@IsHazmat"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<PrintDocuments>
			<xsl:attribute name="FlushToPrinter">
				<xsl:text>Y</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="PrintName">
				<xsl:text>LTLManifest</xsl:text>
			</xsl:attribute>
			<PrintDocument>
			<xsl:attribute name="Localecode">
				<xsl:text>xml:/Manifest/ShipNode/@Localecode</xsl:text>
			</xsl:attribute>
			<InputData>
				<xsl:attribute name="APIName">
					<xsl:text>getManifestDetails</xsl:text>
				</xsl:attribute>
				<Manifest>
                                    <xsl:choose>
					<xsl:when test="name()=&quot;Print&quot;">
						<xsl:copy-of select="Manifest/@*" /> 
					</xsl:when>
					<xsl:when test="name()=&quot;Manifest&quot;">
						<xsl:copy-of select="@*" /> 
					</xsl:when>
                                    </xsl:choose>	
				</Manifest>
				<Template>
					<Manifest  ManifestKey="" ManifestNo="" ><ShipNode Localecode="" /></Manifest>
				</Template>
			</InputData>

		</PrintDocument>
		<PrintDocument>
			<xsl:attribute name="BeforeChildrenPrintDocumentId">
				<xsl:text>LTL_MANIFEST</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="BeforeChildrenLabelFormatId">
				<xsl:text>xml:/Manifest/@LabelFormatId</xsl:text>
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
					<PrinterPreference>
						<xsl:attribute name="UsergroupId"/>
						<xsl:attribute name="UserId"><xsl:text>xml:/Manifest/@Modifyuserid</xsl:text></xsl:attribute>
						<xsl:attribute name="OrganizationCode"><xsl:text>xml:/Manifest/@ShipNode</xsl:text></xsl:attribute>
					</PrinterPreference>
					<LabelPreference>
						<xsl:attribute name="Node">
							<xsl:text>xml:/Manifest/@ShipNode</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="SCAC">
							<xsl:text>xml:/Manifest/@Scac</xsl:text>
						</xsl:attribute>
					</LabelPreference>
				</xsl:when>
			</xsl:choose>
			<KeyAttributes>
				<KeyAttribute>
					<xsl:attribute name="Name"><xsl:text>ManifestKey</xsl:text></xsl:attribute>
				</KeyAttribute>	
			</KeyAttributes>
			<InputData>
				<xsl:attribute name="FlowName">
                                    <xsl:text>GetLTLManifestData</xsl:text>
				</xsl:attribute>
				<Manifest>
					<xsl:choose>
                                            <xsl:when test="name()=&quot;Print&quot;">
						<xsl:copy-of select="Manifest/@*" /> 
                                            </xsl:when>
                                            <xsl:when test="name()=&quot;Manifest&quot;">
                                                <xsl:copy-of select="@*" /> 
                                            </xsl:when>    
                                        </xsl:choose>	
				</Manifest>
				<Template>
				    <Api Name="getManifestDetails">
					<Template>
					<Manifest IsParcel="" Modifyuserid="" ShipNode="" ManifestDate="" ManifestKey="" ManifestNo="" Scac="" TrailerNo=""><Carrier ScacDesc=""/> <ShipNode> <ShipNodePersonInfo AddressLine1="" AddressLine2="" AddressLine3="" Country="" City="" State="" ZipCode=""/> </ShipNode> <Loads TotalNumberOfRecords="" TotalNumberOfCases="" TotalNumberOfPallets="" TotalWeight="" TotalWeightUOM=""> <Load BolNo="" NumberOfCases="" NumberOfPallets="" ProNo="" TotalWeight="" TotalWeightUOM=""> <DestinationAddress AddressLine1="" AddressLine2="" AddressLine3="" Company="" Country="" City="" State="" ZipCode=""/> </Load> </Loads> </Manifest>
					</Template>
				    </Api>
				</Template>
			</InputData>                        
		</PrintDocument>

		<xsl:if test="$IsHazmat = 'Y'">
			<PrintDocument>
				<xsl:attribute name="BeforeChildrenPrintDocumentId">
					<xsl:text>SHIPPERS_DECLARATION</xsl:text>
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
						<PrinterPreference>
							<xsl:attribute name="UsergroupId"/>
							<xsl:attribute name="UserId"><xsl:text>xml:/Manifest/@Modifyuserid</xsl:text></xsl:attribute>
							<xsl:attribute name="OrganizationCode"><xsl:text>xml:/Manifest/@ShipNode</xsl:text></xsl:attribute>
						</PrinterPreference>
						<LabelPreference>
							<xsl:attribute name="Node">
								<xsl:text>xml:/Manifest/@ShipNode</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="SCAC">
								<xsl:text>xml:/Manifest/@Scac</xsl:text>
							</xsl:attribute>
						</LabelPreference>
					</xsl:when>
				</xsl:choose>
				<KeyAttributes>
					<KeyAttribute>
						<xsl:attribute name="Name"><xsl:text>ManifestKey</xsl:text></xsl:attribute>
					</KeyAttribute>	
				</KeyAttributes>
               			<InputData>
					<xsl:attribute name="FlowName">
						<xsl:text>GetShippersDeclarationData</xsl:text>
					</xsl:attribute>
                                        <Manifest>
					<xsl:choose>
						<xsl:when test="name()=&quot;Print&quot;">
							<xsl:copy-of select="Manifest/@*" /> 
						</xsl:when>
						<xsl:when test="name()=&quot;Manifest&quot;">
							<xsl:copy-of select="@*" /> 	
						</xsl:when>    
					</xsl:choose> 
                                        </Manifest>
					<Template>
						<Api Name="getManifestDetails">
							<Template>
								<Manifest>
									<ShipNode>
										<ShipNodePersonInfo AddressLine1="" AddressLine2="" AddressLine3="" AddressLine4="" AddressLine5="" AddressLine6="" AlternateEmailID="" Beeper="" City="" Company="" Country="" DayFaxNo="" DayPhone="" Department="" EMailID="" ErrorTxt="" EveningFaxNo="" EveningPhone="" FirstName="" HttpUrl="" JobTitle="" LastName="" MiddleName="" MobilePhone="" OtherPhone="" PersonID="" PersonInfoKey="" PreferredShipAddress="" State="" Suffix="" Title="" UseCount="" VerificationStatus="" ZipCode="" />
									</ShipNode>
									<Shipments>
                                                                            <Shipment ShipmentKey="" ShipmentNo="" ProNo="" >
										<ToAddress />
										<ShipmentLines>
											<ShipmentLine>
												<Item>
													<HazmatInformation Symbols=" " ProperShippingName=" " HazardClass=" " UNNumber=" " PackingGroup=" " Label=" " SpecialProvisions=" " Exception=" " QtyNonBulk=" " QtyBulk=" " PassengerAir=" " CargoAir=" " Vessel=" " VesselSP=" " SortOrder=" "/>
												</Item>
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
		</xsl:if>
	</PrintDocuments>
</xsl:template>
</xsl:stylesheet>
