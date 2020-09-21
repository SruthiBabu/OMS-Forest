<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
	Licensed Materials - Property of IBM
	IBM Sterling Order Management  (5725-D10)
	IBM Sterling Configure Price Quote (5725-D11)
	(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
	US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps" exclude-result-prefixes="xalan"
	version="1.0">
	<xsl:param name="scwc:ValueMapsData" />
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:template name="GetOrderLineDetailsApiInput" match="/">
		<xsl:variable name="OrderLineDetail" select="/OrderLineDetail" />
		<xsl:variable name="storeId">
			<xsl:value-of select="$OrderLineDetail/UserOverride/Order_Header/@EnterpriseCode" />
		</xsl:variable>
		<xsl:variable name="EnterpriseCode">
			<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'storeIdToOrganizationCode', $storeId)" />
		</xsl:variable>
		<OrderLineDetail>
			<xsl:attribute name="OrderLineKey">
				<xsl:value-of select="$OrderLineDetail/@OrderLineKey" />
			</xsl:attribute>
		    <UserOverride>
		      <Order_Header>
				<xsl:if test="$OrderLineDetail/UserOverride/Order_Header/@BuyerUserId">
				<xsl:attribute name="BuyerUserId">
						<xsl:value-of select="$OrderLineDetail/UserOverride/Order_Header/@BuyerUserId" />
					</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="EnterpriseCode">
						<xsl:value-of select="$EnterpriseCode" />
					</xsl:attribute>
		      </Order_Header>
		    </UserOverride>
		  </OrderLineDetail>
	</xsl:template>
</xsl:stylesheet>