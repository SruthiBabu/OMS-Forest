<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2016 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order"
	xmlns:oa="http://www.openapplications.org/oagis/9" xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:udt="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/" xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps" 
	exclude-result-prefixes="datetime xalan scwc ValueMaps java"  version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="scwc:ValueMapsData"/>
	<xsl:template name="OrderToProcessOrder" match="/">
	<xsl:variable name="Order" select="/Order"/>
	<xsl:variable name="OrganizationCode">
	    <xsl:value-of select="$Order/@EnterpriseCode"/>
	</xsl:variable>
	<xsl:variable name="storeId">
	    <xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $OrganizationCode)"/>
	</xsl:variable>
	<xsl:variable name="OrderNo">
	    <xsl:value-of select="$Order/@OrderNo"/>
	</xsl:variable>
	<xsl:variable name="ordHK">
	    <xsl:value-of select="$Order/@OrderHeaderKey"/>
	</xsl:variable>
	<_ord:ProcessOrder releaseID="">
	    <_wcf:ApplicationArea>
	        <oa:CreationDateTime xsi:type="udt:DateTimeType">
		            <xsl:variable name="datePattern">yyyy-MM-dd'T'HH:mm:ss'Z'</xsl:variable>
			    <xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new($datePattern), java:java.util.Date.new())" />
	        </oa:CreationDateTime>
	        <_wcf:BusinessContext>
	            <_wcf:ContextData name="storeId">
	                <xsl:value-of select="$storeId"/>
	            </_wcf:ContextData>
	        </_wcf:BusinessContext>
	    </_wcf:ApplicationArea>
	    <_ord:DataArea>
	        <oa:Process>
	            <oa:ActionCriteria>
	                <oa:ActionExpression actionCode="FinalizePromotionCalUsage" expressionLanguage="_wcf:XPath">/Order[1]</oa:ActionExpression>
	            </oa:ActionCriteria>
	        </oa:Process>
	        <_ord:Order>
	            <_ord:OrderIdentifier>
					<xsl:choose>
						<xsl:when test="normalize-space(/Order/@CartId) !=''">
							<_wcf:UniqueID>
								<xsl:value-of select="/Order/@CartId"/>
							</_wcf:UniqueID>
						</xsl:when>
						<xsl:when test="starts-with($OrderNo, 'WC_')">
							<_wcf:UniqueID>
								<xsl:value-of select="substring-after($OrderNo, 'WC_')"/>
							</_wcf:UniqueID>
						</xsl:when>
						<xsl:otherwise>
							<_wcf:ExternalOrderID>
								<xsl:value-of select="$ordHK"/>
							</_wcf:ExternalOrderID>
						</xsl:otherwise>
					</xsl:choose>
	            </_ord:OrderIdentifier>
		    <_ord:BuyerIdentifier>
			<_wcf:ExternalIdentifier>
				<_wcf:Identifier>
					<xsl:value-of select="/Order/@BuyerUserId" />
				</_wcf:Identifier>
			</_wcf:ExternalIdentifier>
		    </_ord:BuyerIdentifier>
	            <xsl:if test="string-length($storeId) &gt; 0">
	                <_ord:StoreIdentifier>
	                    <_wcf:UniqueID>
	                        <xsl:value-of select="$storeId"/>
	                    </_wcf:UniqueID>
	                </_ord:StoreIdentifier>
	            </xsl:if>
	        </_ord:Order>
	    </_ord:DataArea>
	</_ord:ProcessOrder>
	</xsl:template>
</xsl:stylesheet>
