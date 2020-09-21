<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
	Licensed Materials - Property of IBM
	IBM Sterling Order Management  (5725-D10)
	IBM Sterling Configure Price Quote (5725-D11)
	(C) Copyright IBM Corp. 2005, 2016 All Rights Reserved.
	US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:_mbr="http://www.ibm.com/xmlns/prod/commerce/9/member"
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
	<xsl:template name="CustomerDetailsToGetPerson" match="/">
		<xsl:variable name="OrganizationCode">
			<xsl:value-of select="/Customer/@StoreId" />
		</xsl:variable>
		<xsl:variable name="storeId">
			<xsl:value-of
				select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'storeIdToOrganizationCode', $OrganizationCode)" />
		</xsl:variable>
		<xsl:variable name="loginId">
			<xsl:value-of select="/Customer/@LoginId" />
		</xsl:variable>
		<xsl:variable name="emailId">
			<xsl:if test="normalize-space($loginId) =''">
				<xsl:value-of select="/Customer/@EmailId" />
			</xsl:if>
		</xsl:variable>		
		<_mbr:GetPerson>
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
			<_mbr:DataArea>
				<oa:Get>
					<oa:Expression expressionLanguage="_wcf:XPath">{_wcf.ap=IBM_Details}/Person[search(contains(Credential/LogonID, '<xsl:value-of select="$loginId"/>') or contains(ContactInfo/EmailAddress1/Value, '<xsl:value-of select="$emailId"/>'))]</oa:Expression>
				</oa:Get>
			</_mbr:DataArea>
		</_mbr:GetPerson>
	</xsl:template>
</xsl:stylesheet>