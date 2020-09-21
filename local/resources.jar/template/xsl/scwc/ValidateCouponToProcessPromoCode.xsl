<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:xalan="http://xml.apache.org/xalan" xmlns:mm="http://WCToSSFSMediationModule"
	exclude-result-prefixes="xalan"
    version="1.0">

  <!-- imports  -->
  <xsl:import href="template/xsl/scwc/custom/ValidateCouponToProcessPromoCode.xsl"/>
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <xsl:template match="/"  >
    <RequestData>
      <xsl:apply-templates select="context" mode="localContextToContext_735084136"/>
      <body>
        <xsl:variable name="Coupon" select="/Coupon"/>
        <xsl:call-template name="CouponToProcessPromoCode">
          <xsl:with-param name="Coupon" select="$Coupon"/>
        </xsl:call-template>
      </body>
	</RequestData>
  </xsl:template>

  <xsl:template match="context"  mode="localContextToContext_735084136">
    <context>
      <xsl:if test="correlation">
        <xsl:copy-of select="correlation"/>
      </xsl:if>
    </context>
  </xsl:template>
  
  <!-- *****************    Utility Templates    ******************  -->
  <xsl:template name="copyNamespaceDeclarations">
    <xsl:param name="root"/>
    <xsl:for-each select="$root/namespace::*">
      <xsl:copy/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

