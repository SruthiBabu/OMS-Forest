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
	<xsl:import href="template/xsl/scwc/custom/GetItemPriceUEInputToGetEntitledPrice.xsl" />
	<xsl:output
		method="xml"
		encoding="UTF-8"
		indent="no" />
	<xsl:template match="/">
		<xsl:variable
			name="ItemPrice"
			select="/ItemPrice" />
		<RequestData>
			<!-- no need to translate correlation data since it will be coming back unused -->
			<context>
				<correlation>
					<xsl:if test="$ItemPrice/@BuyerUserId">
						<xsl:attribute name="BuyerUserId">
							<xsl:value-of select="$ItemPrice/@BuyerUserId" />
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="$ItemPrice/@CustomerID">
						<xsl:attribute name="CustomerID">
							<xsl:value-of select="$ItemPrice/@CustomerID" />
						</xsl:attribute>
					</xsl:if>
					<!-- a simple data mapping: "@EnterpriseCode"(OrgCode) to "EnterpriseCode"(OrgCode) -->
					<xsl:if test="$ItemPrice/@EnterpriseCode">
						<xsl:attribute name="EnterpriseCode">
							<xsl:value-of select="$ItemPrice/@EnterpriseCode" />
						</xsl:attribute>
					</xsl:if>
					<!-- a simple data mapping: "@OrganizationCode"(OrgCode) to "OrganizationCode"(OrgCode) -->
					<xsl:attribute name="OrganizationCode">
						<xsl:value-of select="$ItemPrice/@OrganizationCode" />
					</xsl:attribute>
					<!-- a simple data mapping: "@PricingDate"(string) to "PricingDate"(string) -->
					<xsl:if test="$ItemPrice/@PricingDate">
						<xsl:attribute name="PricingDate">
							<xsl:value-of select="$ItemPrice/@PricingDate" />
						</xsl:attribute>
					</xsl:if>
					<LineItems>
						<xsl:for-each select="$ItemPrice/LineItems/LineItem">
							<LineItem>
								<xsl:attribute name="ItemID">
									<xsl:value-of select="@ItemID" />
								</xsl:attribute>
								<xsl:if test="@LineID">
									<xsl:attribute name="LineID">
										<xsl:value-of select="@LineID" />
									</xsl:attribute>
								</xsl:if>
							</LineItem>
						</xsl:for-each>
					</LineItems>
				</correlation>
			</context>
			<body>
				<xsl:call-template name="ItemPriceToGetEntitledPrice">
					<xsl:with-param
						name="ItemPrice"
						select="$ItemPrice" />
				</xsl:call-template>
			</body>
		</RequestData>
	</xsl:template>
</xsl:stylesheet>