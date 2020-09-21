<?xml version="1.0" encoding="UTF-8"?>
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
	<xsl:template name="GetCompleteOrderDetailsApiOutput" match="/">
		<xsl:variable name="enterpriseCode">
			<xsl:value-of select="/Order/@EnterpriseCode" />
		</xsl:variable>
		<xsl:variable name="storeId">
			<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'storeIdToOrganizationCode', $enterpriseCode)" />
		</xsl:variable>
		<Root>
			<Order>
				<xsl:attribute name="OrderHeaderKey">
					<xsl:value-of select="/Order/@OrderHeaderKey" />
				</xsl:attribute>
				<xsl:attribute name="EnterpriseCode"><xsl:value-of select="$storeId" /></xsl:attribute>
				<xsl:attribute name="SellerOrganizationCode"><xsl:value-of select="$storeId" /></xsl:attribute>			
				<PriceInfo>
					<xsl:variable name="scCurrency"
						select="/Order/PriceInfo/@Currency" />
					<xsl:variable name="wcCurrency">
						<xsl:value-of
							select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'scCurrencyToWcCurency', $scCurrency)" />
					</xsl:variable>
					<xsl:attribute name="Currency">
					<xsl:choose>
						<xsl:when
								test="string-length(normalize-space($wcCurrency)) &gt; 0">
							<xsl:value-of select="$wcCurrency" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$scCurrency" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
					<xsl:attribute name="TotalAmount">
					<xsl:value-of
							select="/Order/PriceInfo/@TotalAmount" />
				</xsl:attribute>
				</PriceInfo>
				<OrderLines>
					<xsl:variable name="orderLines"
						select="/Order/OrderLines" />
					<xsl:attribute name="TotalNumberOfRecords">
					<xsl:value-of
							select="$orderLines/@TotalNumberOfRecords" />
				 </xsl:attribute>
				</OrderLines>
			</Order>
		</Root>
	</xsl:template>
</xsl:stylesheet>