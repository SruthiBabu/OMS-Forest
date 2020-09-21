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
	exclude-result-prefixes="xalan"
	version="1.0">
	<!-- imports -->
	<xsl:import href="template/xsl/scwc/custom/GetPricingRuleDetailsUEToGetPromotion.xsl" />
	<xsl:output
		method="xml"
		encoding="UTF-8"
		indent="no" />
	<xsl:template match="/">
		<xsl:variable
			name="PricingRule"
			select="/PricingRule" />
		<RequestData>
			<!-- no need to translate correlation data since it will be coming back unused -->
			<context>
				<correlation>
					<xsl:if test="$PricingRule/@PricingRuleKey">
						<xsl:attribute name="PricingRuleKey">
							<xsl:value-of select="$PricingRule/@PricingRuleKey" />
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="$PricingRule/@DisplayLocalizedFieldInLocale">
						<xsl:attribute name="DisplayLocalizedFieldInLocale">
							<xsl:value-of select="$PricingRule/@DisplayLocalizedFieldInLocale" />
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="$PricingRule/@OrganizationCode">
						<xsl:attribute name="OrganizationCode">
							<xsl:value-of select="$PricingRule/@OrganizationCode" />
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="$PricingRule/@PricingRuleName">
						<xsl:attribute name="PricingRuleName">
							<xsl:value-of select="$PricingRule/@PricingRuleName" />
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="$PricingRule/@SellerOrganizationCode">
						<xsl:attribute name="SellerOrganizationCode">
							<xsl:value-of select="$PricingRule/@SellerOrganizationCode" />
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="$PricingRule/Coupon">
						<Coupon>
							<xsl:if test="$PricingRule/Coupon/@CouponKey">
								<xsl:attribute name="CouponKey">
									<xsl:value-of select="$PricingRule/Coupon/@CouponKey" />
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="$PricingRule/Coupon/@CouponID">
								<xsl:attribute name="CouponID">
									<xsl:value-of select="$PricingRule/Coupon/@CouponID" />
								</xsl:attribute>
							</xsl:if>
						</Coupon>
					</xsl:if>
					<PricingRuleLocaleList>
						<xsl:for-each select="$PricingRule/PricingRuleLocaleList/PricingRuleLocale">
							<PricingRuleLocale>
								<xsl:if test="@Country">
									<xsl:attribute name="Country">
										<xsl:value-of select="@Country" />
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="@Description">
									<xsl:attribute name="Description">
										<xsl:value-of select="@Description" />
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="@Language">
									<xsl:attribute name="Language">
										<xsl:value-of select="@Language" />
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="@PricingRuleKey">
									<xsl:attribute name="PricingRuleKey">
										<xsl:value-of select="@PricingRuleKey" />
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="@PricingRuleLocaleKey">
									<xsl:attribute name="PricingRuleLocaleKey">
										<xsl:value-of select="@PricingRuleLocaleKey" />
									</xsl:attribute>
								</xsl:if>
								<xsl:if test="@Variant">
									<xsl:attribute name="Variant">
										<xsl:value-of select="@Variant" />
									</xsl:attribute>
								</xsl:if>
							</PricingRuleLocale>
						</xsl:for-each>
					</PricingRuleLocaleList>
				</correlation>
			</context>
			<body>
				<xsl:call-template name="PricingRuleToGetPromotion">
					<xsl:with-param
						name="PricingRule"
						select="$PricingRule" />
				</xsl:call-template>
			</body>
		</RequestData>
	</xsl:template>
</xsl:stylesheet>