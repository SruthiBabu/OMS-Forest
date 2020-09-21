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
	xmlns:despatch_advice="urn:gs1:ecom:despatch_advice:xsd:3"
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
	version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:param name="ibmjda:ValueMapsData"/>
	<xsl:key name="UniqueShipmentLineId" match="despatchAdviceLineItem" use="lineItemNumber" />
	<xsl:template name="changeShipment" match="/">
		<xsl:element name="MultiApi">
			<xsl:for-each select="/despatch_advice:despatchAdviceMessage/despatchAdvice">
				<xsl:variable name="ExtOrganizationCode">
					<xsl:value-of select="seller/additionalPartyIdentification"/>
				</xsl:variable>		
				<xsl:variable name="ExtShipNode">
					<xsl:value-of select="shipFrom/additionalPartyIdentification"/>
				</xsl:variable>
				<xsl:variable name="orderreleasekey">
					<xsl:value-of select="purchaseOrder/entityIdentification"/>
				</xsl:variable>
				<xsl:element name="API" >
					<xsl:attribute name="Name">
						<xsl:text>createShipment</xsl:text>
					</xsl:attribute>
					<xsl:element name="Input" >					
						<xsl:element name="Shipment">
							<xsl:attribute name="ShipNode">
								<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtShipNode)"/>
							</xsl:attribute>
							<xsl:attribute name="ConfirmShip">
								<xsl:text>Y</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="ExpectedShipmentDate">
								<xsl:value-of select="despatchInformation/despatchDateTime"/>
							</xsl:attribute>	
							<xsl:attribute name="ActualShipmentDate">
								<xsl:value-of select="despatchInformation/actualShipDateTime"/>
							</xsl:attribute>
							<xsl:attribute name="ShipmentNo">
								<xsl:value-of select="despatchAdviceIdentification/entityIdentification"/>
							</xsl:attribute>
							<xsl:attribute name="EnterpriseCode">
								<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, 'DEFAULT', 'jdaToIBMOrganizationCode', $ExtOrganizationCode)"/>
							</xsl:attribute>			
							<xsl:element name="ShipmentLines">
								<xsl:for-each select="//despatchAdviceLineItem[count(. | key('UniqueShipmentLineId', lineItemNumber)[1])= 1]">				
									<xsl:variable name="lineItemNo">
										<xsl:value-of select="lineItemNumber"/>
									</xsl:variable>
									<xsl:variable name="totalquantity">
										<xsl:value-of select="sum(//despatchAdvice[purchaseOrder/entityIdentification=$orderreleasekey]/despatchAdviceLogisticUnit/despatchAdviceLineItem[lineItemNumber=$lineItemNo]/despatchedQuantity)"/>
									</xsl:variable>
									<xsl:if test="$totalquantity != 0">
										<xsl:element name="ShipmentLine">
											<xsl:attribute name="OrderReleaseKey">
												<xsl:value-of select="$orderreleasekey"/>
											</xsl:attribute>					
											<xsl:attribute name="Quantity">
												<xsl:value-of select="$totalquantity"/>
											</xsl:attribute>	
											<xsl:attribute name="PrimeLineNo">
												<xsl:value-of select="purchaseOrder/lineItemNumber"/>
											</xsl:attribute>
											<xsl:attribute name="SubLineNo">
												<xsl:text>1</xsl:text>
											</xsl:attribute>
											<xsl:attribute name="ShipmentLineNo">
												<xsl:value-of select="lineItemNumber"/>
											</xsl:attribute>
										</xsl:element>
									</xsl:if>
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Containers">
								<xsl:for-each select="despatchAdviceLogisticUnit">
									<xsl:element name="Container">
										<xsl:attribute name="ContainerNo">
											<xsl:value-of select="logisticUnitIdentification/additionalLogisticUnitIdentification"/>
										</xsl:attribute>
										<xsl:attribute name="TrackingNo">
											<xsl:value-of select="carrierTrackAndTraceInformation/packageTrackingNumber"/>
										</xsl:attribute>
										<xsl:element name="ContainerDetails">
											<xsl:element name="ContainerDetail">
												<xsl:attribute name="Quantity">
													<xsl:value-of select="despatchAdviceLineItem/despatchedQuantity"/>
												</xsl:attribute>
												<xsl:element name="ShipmentLine">
													<xsl:attribute name="ShipmentLineNo">
														<xsl:value-of select="despatchAdviceLineItem/lineItemNumber"/>
													</xsl:attribute>
												</xsl:element>
											</xsl:element>
										</xsl:element>
									</xsl:element>				
								</xsl:for-each>	
							</xsl:element>					
						</xsl:element>	
					</xsl:element>	
				</xsl:element>			
			</xsl:for-each>	
		</xsl:element>	
	</xsl:template>
</xsl:stylesheet>