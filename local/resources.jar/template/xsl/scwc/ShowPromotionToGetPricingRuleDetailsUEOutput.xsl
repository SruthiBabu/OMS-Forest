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
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:mm="http://WCToSSFSMediationModule"
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:_pro="http://www.ibm.com/xmlns/prod/commerce/9/promotion"
	xmlns="http://www.sterlingcommerce.com/documentation/YFS/getPricingRuleDetails/output"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/" 
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	exclude-result-prefixes="mm _wcf _pro"
	extension-element-prefixes="ValueMaps"
	version="1.0">
	
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="no" />
	<xsl:strip-space elements="*" />
	
	<xsl:param name="scwc:ValueMapsData" />
	
	<xsl:template match="/ResponseData/Body/Errors">
		<xsl:copy-of select="/ResponseData/Body/Errors"/>
	</xsl:template>
	
	<xsl:template name="ShowPromotionToPricingRule" match="/ResponseData/Body/_pro:ShowPromotion">
		<xsl:variable	name="ShowPromotion"	select="/ResponseData/Body/_pro:ShowPromotion" />
		<xsl:variable name="promotion" select="$ShowPromotion/_pro:DataArea/_pro:Promotion" />
		<xsl:variable name="description" select="$promotion/_pro:Description[1]" />		
		
		<xsl:variable name="storeId">
		    <xsl:value-of select="$promotion/_pro:PromotionIdentifier/_wcf:ExternalIdentifier/_wcf:StoreIdentifier/_wcf:UniqueID/text()" /></xsl:variable>
		<xsl:variable name="OrganizationCode">
		    <!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='storeIdToOrganizationCode']/mm:Entry[@key=$storeId]/text()" /> -->
		    <xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $storeId)" />
		</xsl:variable>
		
		
		<PricingRule>
			<xsl:attribute name="Description">
				<xsl:choose>
					<xsl:when test="$description/_pro:LongDescription">
					  <xsl:value-of select="$description/_pro:LongDescription" />
					</xsl:when>
					<xsl:otherwise>
					  <xsl:value-of select="$description/_pro:ShortDescription" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="EndDateActive"><xsl:value-of select="$promotion/_pro:Schedule/_pro:EndDate" /></xsl:attribute>
			<xsl:attribute name="IsCouponRule">
				<xsl:choose>
					<xsl:when test="$promotion/_pro:PromotionCodeRequired='false'">
						<xsl:text>N</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Y</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
      		</xsl:attribute>	
			<xsl:attribute name="OrganizationCode"><xsl:value-of select="$OrganizationCode" /></xsl:attribute>
			<xsl:attribute name="PricingRuleName"><xsl:value-of select="$promotion/_pro:AdministrativeName" /></xsl:attribute>
			<xsl:attribute name="PricingStatus"><xsl:value-of select="$promotion/_pro:Status" /></xsl:attribute>
			<xsl:attribute name="RuleType"><xsl:value-of select="$promotion/_pro:PromotionType" /></xsl:attribute>
			<xsl:attribute name="StartDateActive"><xsl:value-of select="$promotion/_pro:Schedule/_pro:StartDate" /></xsl:attribute>
			<xsl:choose>
				<xsl:when test="$promotion/_pro:PromotionCode">
				  <Coupon>
				    <xsl:attribute name="CouponID"><xsl:value-of select="$promotion/_pro:PromotionCode/text()" /></xsl:attribute>				
				  </Coupon>
				</xsl:when>
			</xsl:choose>	
		</PricingRule>
		
	</xsl:template>	
</xsl:stylesheet>
