<?xml version="1.0" ?>
<!-- Licensed Materials - Property of IBM IBM Sterling Selling and Fulfillment 
	Suite (C) Copyright IBM Corp. 2001, 2014 All Rights Reserved. US Government 
	Users Restricted Rights - Use, duplication or disclosure restricted by GSA 
	ADP Schedule Contract with IBM Corp. -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<PricingRule>
		    <xsl:attribute name="OrganizationCode">
                <xsl:value-of select="/PricingRule/@OrganizationCode" />
            </xsl:attribute>
            <xsl:attribute name="PricingRuleName">
                <xsl:value-of select="/PricingRule/@PricingRuleName" />
            </xsl:attribute>
            <xsl:attribute name="PricingRuleKey">
                <xsl:value-of select="/PricingRule/@PricingRuleKey" />
            </xsl:attribute>
            <xsl:attribute name="PricingStatus">INACTIVE</xsl:attribute>
		</PricingRule>
	</xsl:template>
</xsl:stylesheet>