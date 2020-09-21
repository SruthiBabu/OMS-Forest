<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:xalan="http://xml.apache.org/xslt"
     xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
     xmlns:_pro="http://www.ibm.com/xmlns/prod/commerce/9/promotion"
     xmlns:scwc="http://www.sterlingcommerce.com/scwc/" 
     xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	 extension-element-prefixes="ValueMaps"
     exclude-result-prefixes="xalan"
     version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>
  <xsl:strip-space elements="*"/>
<xsl:param name="scwc:ValueMapsData" />

  <xsl:template match="/ResponseData/Body/Errors">
	<xsl:copy-of select="/ResponseData/Body/Errors"/>
  </xsl:template>
	  
  <xsl:template name="AcknowledgePromoCodeToCoupon" match="/ResponseData/Body/_pro:AcknowledgePromoCode">
    <xsl:variable name="AcknowledgePromoCode" select="/ResponseData/Body/_pro:AcknowledgePromoCode"/>
   	<xsl:variable name="promoCode" select="$AcknowledgePromoCode/_pro:DataArea/_pro:PromoCode" />
   	<xsl:variable name="reasonCode" select="$promoCode/_pro:Reason/_wcf:ReasonCode" />

      <Coupon>
      	<xsl:attribute name="CouponID">
      	   <xsl:value-of select="$promoCode/_pro:Code"/>
      	</xsl:attribute>
      	<xsl:attribute name="CouponStatusMsgCode">
      	    <xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcPromoCodeReasonCodeToSCCouponStatus', $reasonCode)" />
      	</xsl:attribute>
      	<xsl:attribute name="Valid">
						<xsl:choose>
							<xsl:when test="$promoCode/_pro:Reason/_wcf:Valid='true'">
								<xsl:text>Y</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>N</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
      	</xsl:attribute>
      	<xsl:if test="$promoCode/_pro:AssociatedPromotion">
      		<PricingRules>
      			<xsl:for-each select="$promoCode/_pro:AssociatedPromotion">
      				<PricingRule>
      					<xsl:attribute name="PricingRuleKey">
      						<xsl:value-of select="_wcf:PromotionIdentifier/_wcf:CalculationCodeIdentifier/_wcf:UniqueID/text()" />
      					</xsl:attribute>
      					<xsl:attribute name="Description">
      						<xsl:value-of select="_wcf:Description/text()" />
      					</xsl:attribute>
      				</PricingRule>
      			</xsl:for-each>
      		</PricingRules>
      	</xsl:if>
      </Coupon>
  </xsl:template>
</xsl:stylesheet>