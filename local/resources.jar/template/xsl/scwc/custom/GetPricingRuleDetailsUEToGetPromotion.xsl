<?xml version="1.0" encoding="UTF-8"?>

<!--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce
  IBM Sterling Configure Price Quote (5725-D11)
  (C) Copyright IBM Corp. 2012,2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:xalan="http://xml.apache.org/xalan" xmlns:mm="http://WCToSSFSMediationModule"
	xmlns:oa="http://www.openapplications.org/oagis/9"
	xmlns:udt="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:_pro="http://www.ibm.com/xmlns/prod/commerce/9/promotion"
	xmlns="http://www.sterlingcommerce.com/documentation/YFS/getPricingRuleDetails/input"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/" xmlns:java="http://xml.apache.org/xslt/java" xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	exclude-result-prefixes="xalan mm _wcf _pro java"
	extension-element-prefixes="datetime ValueMaps" version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	
	<xsl:param name="scwc:ValueMapsData" />

	<xsl:template name="PricingRuleToGetPromotion">	
		<xsl:param name="PricingRule" />
		<xsl:variable name="OrganizationCode"><xsl:value-of select="$PricingRule/@OrganizationCode" /></xsl:variable>
		<xsl:variable name="storeId">
		<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $OrganizationCode)" /></xsl:variable>
		<xsl:variable name="DisplayLocalizedFieldInLocale"><xsl:value-of select="$PricingRule/@DisplayLocalizedFieldInLocale" /></xsl:variable>
		<xsl:variable name="locale">
		<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'scLocaleToWcLocale', $DisplayLocalizedFieldInLocale)" />
		</xsl:variable>
		
		<_pro:GetPromotion releaseID="" versionID="7.0.0.1">
		    <_wcf:ApplicationArea>
				<oa:CreationDateTime xsi:type="udt:DateTimeType">
		            <xsl:variable name="datePattern">yyyy-MM-dd'T'HH:mm:ss'Z'</xsl:variable>
			    <xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new($datePattern), java:java.util.Date.new())" />
				</oa:CreationDateTime>
				<_wcf:BusinessContext>
					<_wcf:ContextData name="storeId"><xsl:value-of select="$storeId" /></_wcf:ContextData>
					<_wcf:ContextData name="locale"><xsl:value-of select="$locale" /></_wcf:ContextData>
				</_wcf:BusinessContext>
			</_wcf:ApplicationArea>
			<_pro:DataArea>
			    <oa:Get>
					<xsl:variable name="calculationCodeID">
	    				<xsl:choose>
	    					<xsl:when test="$PricingRule/@PricingRuleName!=''">
	    						<xsl:value-of select="$PricingRule/@PricingRuleName" />
	    					</xsl:when>
	    					<xsl:otherwise>
	    						<xsl:value-of select="$PricingRule/Coupon/@CouponID" />
	    					</xsl:otherwise>
	    				</xsl:choose>
	    			</xsl:variable>
				    <oa:Expression expressionLanguage="_wcf:XPath">
					{_wcf.ap=IBM_Admin_Details}/Promotion[PromotionIdentifier[CalculationCodeIdentifier[(UniqueID=<xsl:value-of select="$calculationCodeID" />)]]]
					</oa:Expression>
				</oa:Get>
			</_pro:DataArea>
		</_pro:GetPromotion>
	</xsl:template>	
</xsl:stylesheet>
