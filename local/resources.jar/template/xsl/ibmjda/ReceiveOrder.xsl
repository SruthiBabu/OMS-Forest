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
	xmlns:receiving_advice="urn:gs1:ecom:receiving_advice:xsd:3" 
	version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:param name="ibmjda:ValueMapsData"/>
	<xsl:template name="receiveOrder" match="/">
		<xsl:element name="Receipt">
			<xsl:attribute name="DocumentType">
				<xsl:text>0003</xsl:text>
			</xsl:attribute>
			<xsl:variable name="ExtReceivingNode">
			<xsl:value-of select="/receiving_advice:receivingAdviceMessage/receivingAdvice/shipTo/additionalPartyIdentification"/>
		</xsl:variable>
			<xsl:attribute name="ReceivingNode">
				<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtReceivingNode)"/>
			</xsl:attribute>			
			<xsl:attribute name="ReceiptDate">
				<xsl:value-of select="/receiving_advice:receivingAdviceMessage/receivingAdvice/receivingDateTime"/>
			</xsl:attribute>
			<xsl:element name="Shipment">
						<xsl:attribute name="OrderReleaseKey">
				<xsl:value-of select="/receiving_advice:receivingAdviceMessage/receivingAdvice/receivingAdviceIdentification/entityIdentification"/>
			</xsl:attribute>
			</xsl:element>	
			<xsl:element name="ReceiptLines">
			<xsl:for-each select="/receiving_advice:receivingAdviceMessage/receivingAdvice/receivingAdviceLogisticUnit/receivingAdviceLineItem">
				<xsl:variable name="primeLineNo">
					<xsl:value-of select="lineItemNumber"/>
				</xsl:variable>
				<xsl:variable name="ExtDispositionCode">
					<xsl:value-of select="avpList/eComStringAttributeValuePairList[@attributeName = 'inventoryStatusType' and @qualifierCodeList='InventoryStatusCode' ]" />
				</xsl:variable>
				<xsl:variable name="itemID">
					<xsl:value-of select="transactionalTradeItem/additionalTradeItemIdentification"/>
				</xsl:variable>
				<xsl:for-each select="receivingConditionInformation">
					<xsl:element name="ReceiptLine">					    
						<xsl:attribute name="DispositionCode">
						   <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMDispositionCode', $ExtDispositionCode)"/>
						</xsl:attribute>
						<xsl:attribute name="Quantity">
						   <xsl:value-of select="receivingConditionQuantity"/>
						</xsl:attribute>
						<xsl:attribute name="SubLineNo">
						   <xsl:text>1</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="PrimeLineNo">
							 <xsl:value-of select="$primeLineNo"/>
						</xsl:attribute>
						<xsl:attribute name="ItemID">
						   <xsl:value-of select="$itemID"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:for-each>
			</xsl:for-each>
	   </xsl:element>	
		</xsl:element>
		</xsl:template>
 </xsl:stylesheet>