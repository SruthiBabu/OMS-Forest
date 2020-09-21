<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:xalan="http://xml.apache.org/xalan" xmlns:mm="http://WCToSSFSMediationModule"
	xmlns:oa="http://www.openapplications.org/oagis/9"
	xmlns:udt="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:_pro="http://www.ibm.com/xmlns/prod/commerce/9/promotion"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/" 
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	exclude-result-prefixes="xalan mm _wcf _pro scwc java"
	extension-element-prefixes="datetime ValueMaps" version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	
	<xsl:param name="scwc:ValueMapsData" />
  <xsl:template name="CouponToProcessPromoCode">
    <xsl:param name="Coupon"/>
    <xsl:variable name="OrganizationCode"><xsl:value-of select="$Coupon/@OrganizationCode" /></xsl:variable>
	<xsl:variable name="storeId">
		<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $OrganizationCode)" />
	</xsl:variable>				
	<_pro:ProcessPromoCode releaseID="">
			<_wcf:ApplicationArea>
				<oa:CreationDateTime xsi:type="udt:DateTimeType">
		            <xsl:variable name="datePattern">yyyy-MM-dd'T'HH:mm:ss'Z'</xsl:variable>
			    <xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new($datePattern), java:java.util.Date.new())" />
				</oa:CreationDateTime>
				<_wcf:BusinessContext>
					<_wcf:ContextData name="storeId"><xsl:value-of select="$storeId" /></_wcf:ContextData>
				</_wcf:BusinessContext>
			</_wcf:ApplicationArea>
		      <_pro:DataArea>
		        <oa:Process>
		          <oa:ActionCriteria>
		            <oa:ActionExpression actionCode="Validate" expressionLanguage="_wcf:XPath">/PromoCode[1]</oa:ActionExpression>
		          </oa:ActionCriteria>
		        </oa:Process>
		        <_pro:PromoCode>
		          <_pro:Code><xsl:value-of select="$Coupon/@CouponID" /></_pro:Code>
		          <_pro:BuyerIdentifier>
		            <_wcf:ExternalIdentifier>
		              <_wcf:Identifier><xsl:value-of select="$Coupon/@BuyerUserId" /></_wcf:Identifier>
		            </_wcf:ExternalIdentifier>
		          </_pro:BuyerIdentifier>
		          <xsl:if test="$Coupon/@PricingDate">
		          	<_pro:PricingDate><xsl:value-of select="$Coupon/@PricingDate" /></_pro:PricingDate>
		          </xsl:if>
		        </_pro:PromoCode>
		      </_pro:DataArea>
    </_pro:ProcessPromoCode>
    
  </xsl:template>
</xsl:stylesheet>
