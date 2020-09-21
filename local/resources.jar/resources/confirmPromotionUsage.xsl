<?xml version="1.0" ?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Selling and Fulfillment Suite
(C) Copyright IBM Corp. 2001, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <PromotionUsage>
            <xsl:attribute name="OrganizationCode">
                <xsl:value-of select="/Order/PromotionAwards/@OrganizationCode" />
            </xsl:attribute>
            <xsl:attribute name="SellerOrganizationCode">
                <xsl:value-of select="/Order/PromotionAwards/@SellerOrganizationCode" />
            </xsl:attribute>
            <xsl:attribute name="OrderReference">
                <xsl:value-of select="/Order/PromotionAwards/@OrderHeaderKey" />
            </xsl:attribute>
            <xsl:attribute name="CustomerID">
                <xsl:value-of select="/Order/PromotionAwards/@CustomerID" />
            </xsl:attribute>
            <xsl:attribute name="CustomerContactID">
                <xsl:value-of select="/Order/PromotionAwards/@CustomerContactID" />
            </xsl:attribute>
        
            <xsl:for-each select="/Order/PromotionAwards/PromotionAward">
                <xsl:choose>
                    <xsl:when test="PromotionReferences/PromotionReference">
                        <xsl:for-each select="PromotionReferences/PromotionReference[@IsUnique='Y']">
	                        <Promotion>
			                    <xsl:attribute name="Action">
			                        <xsl:value-of select="../../@Action" />
			                    </xsl:attribute>
			                    <xsl:attribute name="PromotionID">
			                        <xsl:value-of select="../../@AwardId" />
			                    </xsl:attribute>
			                    <xsl:attribute name="PromotionReference">
			                        <xsl:value-of select="@ReferenceId" />
			                    </xsl:attribute>
		                	</Promotion>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
	                    <Promotion>
		                    <xsl:attribute name="Action">
		                        <xsl:value-of select="@Action" />
		                    </xsl:attribute>
		                    <xsl:attribute name="PromotionID">
		                        <xsl:value-of select="@AwardId" />
		                    </xsl:attribute>
	                	</Promotion>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </PromotionUsage>
    </xsl:template>
</xsl:stylesheet>

