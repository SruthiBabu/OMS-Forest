<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
	Licensed Materials - Property of IBM
	IBM Sterling Order Management  (5725-D10)
	IBM Sterling Configure Price Quote (5725-D11)
	(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
	US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order"
	xmlns:oa="http://www.openapplications.org/oagis/9"
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:udt="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	exclude-result-prefixes="datetime xalan scwc ValueMaps java"
	extension-element-prefixes="ValueMaps" version="1.0">

	<xsl:param name="scwc:ValueMapsData" />
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />

	<!-- The rule represents a custom mapping: "in2:Order" to "out5:ProcessOrder". -->
	<xsl:template name="LockCartToProcessOrder" match="/">
		<xsl:variable name="OrganizationCode">
			<xsl:value-of select="/Order/@StoreId" />
		</xsl:variable>
		<xsl:variable name="storeId">
			<xsl:value-of
				select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'storeIdToOrganizationCode', $OrganizationCode)" />
		</xsl:variable>
		<xsl:variable name="orderNo">
			<xsl:value-of select="/Order/@CartId" />
		</xsl:variable>
		<_ord:ProcessOrder releaseID="">
			<oa:ApplicationArea xsi:type="_wcf:ApplicationAreaType">
				<oa:CreationDateTime xsi:type="udt:DateTimeType">
		            <xsl:variable name="datePattern">yyyy-MM-dd'T'HH:mm:ss'Z'</xsl:variable>
			    <xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new($datePattern), java:java.util.Date.new())" />
				</oa:CreationDateTime>
				<_wcf:BusinessContext>
					<_wcf:ContextData name="storeId">
						<xsl:value-of select="$storeId" />
					</_wcf:ContextData>
				</_wcf:BusinessContext>
			</oa:ApplicationArea>
			<_ord:DataArea>
				<oa:Process>
					<oa:ActionCriteria>
						<oa:ActionExpression actionCode="Lock" expressionLanguage="_wcf:XPath">/Order</oa:ActionExpression>
					</oa:ActionCriteria>
				</oa:Process>
				<_ord:Order>
					<_ord:OrderIdentifier>
						<_wcf:UniqueID>
							<xsl:value-of select="$orderNo" />
						</_wcf:UniqueID>
					</_ord:OrderIdentifier>
				</_ord:Order>
			</_ord:DataArea>
		</_ord:ProcessOrder>
	</xsl:template>
</xsl:stylesheet>