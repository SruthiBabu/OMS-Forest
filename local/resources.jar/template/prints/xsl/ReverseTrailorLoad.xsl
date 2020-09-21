<?xml version = "1.0" encoding = "UTF-8"?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Selling and Fulfillment Suite
(C) Copyright IBM Corp. 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="Print | Load">
	<PrintDocuments FlushToPrinter="Y" PrintName="ReverseTrailorLoad">
		<PrintDocument>
			<xsl:attribute name="BeforeChildrenPrintDocumentId">
				<xsl:text>REVERSE_TRAILOR_LOAD</xsl:text>
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
					<xsl:attribute name="FlowName">
						<xsl:text>getSortedLoadDetails</xsl:text>
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
					<Load BuyerOrganizationCode="" EnterpriseCode="" LoadKey="" LoadNo="" OriginNode="" >
						<LoadShipments TotalNumberOfRecords="">
							<LoadShipment LoadKey="" ShipNode="" ShipmentKey="" ShipmentNo="">
								<DropoffStop StopSequenceNo="" />
								<Shipment BuyerOrganizationCode="" CarrierServiceCode="" EnterpriseCode="" RequestedShipmentDate="" SCAC="" ScacAndService="" SellerOrganizationCode="" ShipDate="" ShipNode="" ShipToCustomerId="" ShipmentKey="" ShipmentNo="" Status="" >
									<ShipmentLines>
										<ShipmentLine WaveNo="" />
									</ShipmentLines>
								</Shipment>
							</LoadShipment>
						</LoadShipments>
						<Manifest ShipperAccountNo="" />
					</Load>
				</Template>
				</InputData>
		</PrintDocument>
</PrintDocuments>
</xsl:template>
</xsl:stylesheet>
