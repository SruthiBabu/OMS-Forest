<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
(C) Copyright IBM Corp. 2005, 2015 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:ibmjda="http://www.sterlingcommerce.com/ibmjda/"
	xmlns:ValueMaps="xalan://com.yantra.ibmjda.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps" exclude-result-prefixes="xalan ibmjda"
	xmlns:despatch_advice="urn:gs1:ecom:transportInstruction:xsd:3"
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
	version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:param name="ibmjda:ValueMapsData"/>	
	
	<xsl:template name="createShipment" match="/">		
	    
		<xsl:element name="MultiApi" >
		
			<xsl:for-each select="//transportInstructionShipment" >
				
				<xsl:element name="API" >
					<xsl:attribute name="FlowName">
						<xsl:text>IBMJDA_TO_Push_CreateShipment_Internal</xsl:text>
					</xsl:attribute>
					<xsl:element name="Input" >
							
							<xsl:variable name="ExtShipNode">
								<xsl:value-of select="shipFrom/additionalPartyIdentification"/>
							</xsl:variable>
							<xsl:variable name="ExtReceivingNode">
								<xsl:value-of select="shipTo/additionalPartyIdentification"/>
							</xsl:variable>
							
							<xsl:element name="Shipment">
								<xsl:attribute name="Action">
									<xsl:text>Create</xsl:text>
								</xsl:attribute>
								<xsl:attribute name="ShipNode">
									<!-- <xsl:value-of select="$ExtShipNode"/>  -->
									 <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtShipNode)"/> 
								</xsl:attribute>
								<xsl:attribute name="ReceivingNode">
									<!-- <xsl:value-of select="$ExtReceivingNode"/>  -->
									 <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtReceivingNode)"/> 
								</xsl:attribute>
								<xsl:attribute name="FindShipmentAndAdd">
									<xsl:text>N</xsl:text>
								</xsl:attribute>								
								<xsl:variable name="ExtCarrierServiceCode">
									<xsl:value-of select="transportInstructionTerms/transportServiceLevelCode"/>
								</xsl:variable>
								<xsl:attribute name="CarrierServiceCode">
									 <!-- <xsl:value-of select="$ExtCarrierServiceCode"/> -->
									<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMCarrierServiceCode', $ExtCarrierServiceCode)"/> 
								</xsl:attribute>
								<xsl:variable name="ExtCarrier">
										<xsl:value-of select="carrier/additionalPartyIdentification"/>
								</xsl:variable>
								<xsl:attribute name="SCAC">
									 <!-- <xsl:value-of select="$ExtCarrier"/> -->
										<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMCarrier', $ExtCarrier)"/>
								</xsl:attribute>			
								<xsl:attribute name="ExpectedDeliveryDate">
									<xsl:value-of select="plannedDelivery/logisticEventPeriod/endDate"/>
								</xsl:attribute>		
								<xsl:attribute name="ExpectedShipmentDate">
									<xsl:value-of select="plannedDespatch/logisticEventPeriod/endDate"/>
								</xsl:attribute>	
											
								<xsl:attribute name="ShipmentNo">
									<xsl:value-of select="additionalShipmentIdentification"/>
								</xsl:attribute>	
								
								<xsl:variable  name="ExtOrderReleaseKey">
									<xsl:value-of select="additionalShipmentIdentification"/>
								</xsl:variable>				
									<xsl:element name="ShipmentLines">
										<xsl:for-each select="transportInstructionShipmentItem">										
											<xsl:element name="ShipmentLine">
												<xsl:attribute name="OrderReleaseKey"> 
													<xsl:value-of select="$ExtOrderReleaseKey"/>
												</xsl:attribute>					
												<xsl:attribute name="Quantity">
													<xsl:value-of select="transactionalTradeItem/tradeItemQuantity"/>
												</xsl:attribute>	
												<xsl:attribute name="PrimeLineNo">
													<xsl:value-of select="lineItemNumber"/>
												</xsl:attribute>
												<xsl:attribute name="SubLineNo">
													<xsl:text>1</xsl:text>
												</xsl:attribute>
												<xsl:attribute name="ShipmentLineNo">
													<xsl:value-of select="lineItemNumber"/>
												</xsl:attribute>
											</xsl:element>										
									</xsl:for-each>
								</xsl:element>			
								</xsl:element>
						</xsl:element> <!-- Input MultiAPI -->		
					</xsl:element> <!-- API -->		
				</xsl:for-each>		<!-- shipments-->	
		</xsl:element>		<!-- multiapi -->
	</xsl:template>
</xsl:stylesheet>