<?xml version="1.0" ?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Selling and Fulfillment Suite
(C) Copyright IBM Corp. 2001, 2013 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<CouponCodeList>
            <xsl:for-each select="/Coupon/CouponCodeList/CouponCode">
                <CouponCode>
                    <xsl:attribute name="CouponCode">
                        <xsl:value-of select="@CouponCode"/>
                    </xsl:attribute>
                </CouponCode>
            </xsl:for-each>
        </CouponCodeList>
    </xsl:template>
</xsl:stylesheet>

