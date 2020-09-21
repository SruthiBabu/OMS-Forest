<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:mm="http://WCToSSFSMediationModule"
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order"
	xmlns="http://www.sterlingcommerce.com/documentation/YFS/createOrder/input"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
    xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps" 
	exclude-result-prefixes="xalan mm _wcf _ord"
	version="1.0">
	
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="no" />
	<xsl:strip-space elements="*" />
	<xsl:param name="scwc:ValueMapsData"/>
	
  <xsl:template name="ChangeOrderToOrder" match="/">
    <xsl:param name="ChangeOrder"/>
    <xsl:variable name="order" select="/_ord:ChangeOrder/_ord:DataArea/_ord:Order" />
		
		<xsl:variable name="storeId"><xsl:value-of select="$order/_ord:StoreIdentifier/_wcf:UniqueID/text()" /></xsl:variable>
		<xsl:variable name="OrganizationCode">
			<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $storeId)" />
		</xsl:variable>
		
		<Order>
			<xsl:attribute name="OrderNo">
				<xsl:text>WC_</xsl:text><xsl:value-of select="$order/_ord:OrderIdentifier/_wcf:UniqueID" />
			</xsl:attribute>
			<xsl:attribute name="EnterpriseCode"><xsl:value-of select="$OrganizationCode" /></xsl:attribute>	
			<xsl:attribute name="BuyerUserId"><xsl:value-of select="$order/_ord:BuyerIdentifier/_wcf:ExternalIdentifier/_wcf:Identifier" /></xsl:attribute>		
		</Order>
		
	</xsl:template>
	
</xsl:stylesheet>