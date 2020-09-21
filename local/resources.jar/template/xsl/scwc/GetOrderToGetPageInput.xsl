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
	xmlns:oa="http://www.openapplications.org/oagis/9"
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps"
	exclude-result-prefixes="xalan _ord _wcf oa"
	version="1.0">
	<xsl:param name="scwc:ValueMapsData" />
	<xsl:output
		method="xml"
		encoding="UTF-8"
		indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:template
		name="GetOrderToApiInput_getPage"
		match="/">
		<xsl:variable
			name="GetOrder"
			select="/_ord:GetOrder" />
		<RequestData>
			<body>
				<xsl:variable name="Expression">
					<xsl:value-of select="$GetOrder/_ord:DataArea/oa:Get/oa:Expression" />
				</xsl:variable>
				<xsl:variable
					name="selectionCriteria"
					select="mediationUtil:selectionCriteria($Expression)" />
				<xsl:variable name="storeId">
					<xsl:value-of select="mediationUtil:getXPathParameterValue($selectionCriteria, 'UniqueID.2')" />
				</xsl:variable>
				<xsl:variable name="OrganizationCode">
					<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $storeId)" />
				</xsl:variable>
				<xsl:variable name="buyerUserId">
					<xsl:value-of select="mediationUtil:getXPathParameterValue($selectionCriteria, 'LogOnID.1')" />
				</xsl:variable>
				<xsl:variable name="lastOHKey">
					<xsl:value-of select="mediationUtil:getXPathParameterValue($selectionCriteria, 'ExternalOrderID.1')" />
				</xsl:variable>
				<xsl:variable name="wcOrderNo">
					<xsl:value-of select="mediationUtil:getXPathParameterValue($selectionCriteria, 'UniqueID.1')" />
				</xsl:variable>
				<Page>
					<xsl:attribute name="PageSize"><xsl:value-of select="$GetOrder/_ord:DataArea/oa:Get/@maxItems" /></xsl:attribute>
					<xsl:attribute name="PaginationStrategy">NEXTPAGE</xsl:attribute>
					<API>
						<xsl:attribute name="Name">getOrderList</xsl:attribute>
						<Input>
							<Order>
								<xsl:attribute name="EnterpriseCode"><xsl:value-of select="$OrganizationCode" /></xsl:attribute>
								<xsl:attribute name="SellerOrganizationCode"><xsl:value-of select="$OrganizationCode" /></xsl:attribute>
								<xsl:attribute name="BuyerUserId"><xsl:value-of select="$buyerUserId" /></xsl:attribute>
								<xsl:attribute name="BuyerUserIdQryType">EQ</xsl:attribute>
								<xsl:attribute name="DocumentType">0001</xsl:attribute>
								<xsl:attribute name="ReadFromHistory">B</xsl:attribute>
								<xsl:attribute name="DraftOrderFlag">N</xsl:attribute>
								<UserOverride>
									<Order_Header>
										<xsl:attribute name="EnterpriseCode"><xsl:value-of select="$OrganizationCode" /></xsl:attribute>
										<xsl:attribute name="BuyerUserId"><xsl:value-of select="$buyerUserId" /></xsl:attribute>
									</Order_Header>
								</UserOverride>
								<xsl:if test="string-length(normalize-space($wcOrderNo)) &gt; 0">
									<ComplexQuery>
										<xsl:attribute name="Operator">AND</xsl:attribute>
										<Or>
											<xsl:for-each select="mediationUtil:getMultipleValuedXpathParameterValues($selectionCriteria, 'UniqueID.1', ',')">
												<Exp>
													<xsl:attribute name="Name">OrderNo</xsl:attribute>
													<xsl:attribute name="QryType">EQ</xsl:attribute>
													<xsl:attribute name="Value"><xsl:text>WC_</xsl:text><xsl:value-of select="." /></xsl:attribute>
												</Exp>
											</xsl:for-each>
										</Or>
									</ComplexQuery>
								</xsl:if>
								<OrderBy>
									<Attribute>
										<xsl:attribute name="Desc">Y</xsl:attribute>
										<xsl:attribute name="Name">OrderHeaderKey</xsl:attribute>
									</Attribute>
								</OrderBy>
							</Order>
						</Input>
					</API>
					<PreviousPage>
						<xsl:if test="string-length(normalize-space($lastOHKey)) &gt; 0">
							<Order>
								<xsl:attribute name="OrderHeaderKey">
									<xsl:value-of select="$lastOHKey" />
								</xsl:attribute>
							</Order>
						</xsl:if>
					</PreviousPage>
				</Page>
			</body>
		</RequestData>
	</xsl:template>
</xsl:stylesheet>