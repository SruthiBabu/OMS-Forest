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
	xmlns:despatch_advice="urn:gs1:ecom:receiveadvice:xsd:3"
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
	version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:param name="ibmjda:ValueMapsData"/>	
	
	<xsl:template name="receiveOrder" match="/">		  
	

		<xsl:element name="MultiApi" >
		
			<xsl:for-each select="//receivingAdvice" >
				
				<xsl:element name="API" >
					<xsl:attribute name="FlowName">
						<xsl:text>IBMJDA_TO_Push_ReceiveOrder_Internal</xsl:text>
					</xsl:attribute>
					<xsl:element name="Input" >		
	
							<xsl:variable name="ExtReceivingNode">
								<xsl:value-of select="shipTo/additionalPartyIdentification"/>
							</xsl:variable>		
							<xsl:variable name="ExtShipFromNode">
								<xsl:value-of select="shipFrom/additionalPartyIdentification"/>
							</xsl:variable>
							<xsl:variable name="ExtSeller">
								<xsl:value-of select="shipper/additionalPartyIdentification"/>
							</xsl:variable>		
							
													
							<xsl:element name="Receipt">								
								<xsl:attribute name="ReceivingNode">
									<!-- <xsl:value-of select="$ExtReceivingNode"/>   -->
									<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtReceivingNode)"/> 
								</xsl:attribute>							
								<xsl:attribute name="ReceiptDate">
									<xsl:value-of select="receivingDateTime"/>
								</xsl:attribute>		
								<xsl:attribute name="DocumentType">
									<xsl:text>0006</xsl:text>
								</xsl:attribute>									
								<xsl:element name="Shipment">
									<xsl:attribute name="ShipmentNo">
										<xsl:value-of select="purchaseOrder/entityIdentification"/>
									</xsl:attribute>
									<xsl:attribute name="ShipNode">
										<!-- <xsl:value-of select="$ExtShipFromNode"/>  -->
										<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtShipFromNode)"/>
									</xsl:attribute>
									<xsl:attribute name="SellerOrganizationCode">
										<!-- <xsl:value-of select="$ExtSeller"/>   -->
										<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtSeller)"/> 
									</xsl:attribute>
								</xsl:element>	
										
									<xsl:element name="ReceiptLines">
										<xsl:for-each select="receivingAdviceLogisticUnit/receivingAdviceLineItem">										
											<xsl:element name="ReceiptLine">																
												<xsl:attribute name="Quantity">
													<xsl:value-of select="quantityReceived"/>
												</xsl:attribute>	
												<xsl:attribute name="PrimeLineNo">
													<xsl:value-of select="lineItemNumber"/>
												</xsl:attribute>
												<xsl:attribute name="SubLineNo">
													<xsl:text>1</xsl:text>
												</xsl:attribute>
												<xsl:attribute name="ItemID">
													<xsl:value-of select="transactionalTradeItem/additionalTradeItemIdentification"/>
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