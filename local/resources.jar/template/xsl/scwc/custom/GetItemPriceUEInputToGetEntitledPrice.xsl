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
    xmlns:datetime="http://exslt.org/dates-and-times"
    xmlns:udt="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
    xmlns:yfc="http://www.sterlingcommerce.com/documentation/YPM/getItemPriceUE/input"
    xmlns:oa="http://www.openapplications.org/oagis/9"
    xmlns:mm="http://WCToSSFSMediationModule"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
    xmlns:_prc="http://www.ibm.com/xmlns/prod/commerce/9/price"
    xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
    xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps"
	exclude-result-prefixes="datetime mm scwc udt yfc java"
    version="1.0">
	<xsl:param name="scwc:ValueMapsData" />
	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" 
  cdata-section-elements="oa:Expression" indent="no" />
	<xsl:strip-space elements="*" />

	<xsl:template name="ItemPriceToGetEntitledPrice">
		<xsl:param name="ItemPrice"/>
		<xsl:variable name="OrganizationCode">
			<xsl:value-of select="$ItemPrice/@OrganizationCode" />
		</xsl:variable>
		<xsl:variable name="storeId">
			<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'storeIdToOrganizationCode', $OrganizationCode)" />
		</xsl:variable>
		<_prc:GetEntitledPrice>
			<oa:ApplicationArea xsi:type="_wcf:ApplicationAreaType">
				<oa:CreationDateTime xsi:type="udt:DateTimeType">
		            <xsl:variable name="datePattern">yyyy-MM-dd'T'HH:mm:ss'Z'</xsl:variable>
			    <xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new($datePattern), java:java.util.Date.new())" />
				</oa:CreationDateTime>
				<oa:BODID>ae596a20-ce17-11e0-971f-82b64e5493aa</oa:BODID>
				<_wcf:BusinessContext>
					<_wcf:ContextData name="storeId">
						<xsl:value-of select="$storeId" />
					</_wcf:ContextData>
					<xsl:choose>
						<xsl:when test="normalize-space($ItemPrice/@BuyerUserId)!=''">
							<_wcf:ContextData name="forUser">
								<xsl:value-of select="$ItemPrice/@BuyerUserId" />
							</_wcf:ContextData>
						</xsl:when>
						<xsl:otherwise>
							<_wcf:ContextData name="forUserId">
								<xsl:value-of select="'-1002'" />
							</_wcf:ContextData>
						</xsl:otherwise>
					</xsl:choose>
				</_wcf:BusinessContext>
			</oa:ApplicationArea>
			<_prc:DataArea>
				<oa:Get>
					<xsl:variable name="expression">
						<xsl:choose>
							<xsl:when test="normalize-space($ItemPrice/@IsQuantityTierRequested)='Y'">
								<xsl:value-of select="'{_wcf.ap=IBM_Store_EntitledPrice_RangePrice_All}/EntitledPrice['" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'{_wcf.ap=IBM_Store_EntitledPrice_All}/EntitledPrice['" />
							</xsl:otherwise>
						</xsl:choose>

						<xsl:for-each select="$ItemPrice/LineItems/LineItem">
							<xsl:variable name="uomOfSC">
								<xsl:value-of select="@UnitOfMeasure" />
							</xsl:variable>
							<xsl:variable name="uomOfWC">
								<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'wcUOMToscUOM', $uomOfSC)" />
							</xsl:variable>
							<xsl:if test="position() &gt; 1">
								<xsl:text> or </xsl:text>
							</xsl:if>
							<xsl:value-of select="concat('(CatalogEntryIdentifier[ExternalIdentifier[PartNumber=&quot;',@ItemID, '&quot;]]')"/>
							<xsl:if test="normalize-space($ItemPrice/@PricingDate)!=''">
								<xsl:variable name="pricingDate">
									<xsl:choose>
										<xsl:when test="contains($ItemPrice/@PricingDate, 'T')">
											<xsl:value-of select="$ItemPrice/@PricingDate"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat($ItemPrice/@PricingDate, 'T00:00:00Z')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="concat(' and PricingDate=&quot;', $pricingDate, '&quot;')"/>
							</xsl:if>
							<xsl:value-of select="concat(' and UnitPrice[Price[@currency=&quot;', $ItemPrice/@Currency, '&quot;]')"/>

							<xsl:value-of select="concat(' and (Quantity=&quot;', @Quantity, '&quot; and Quantity[@uom=&quot;',$uomOfWC ,'&quot;])')"/>

							<xsl:value-of select="'])'"/>
						</xsl:for-each>
						<xsl:value-of select="']'" />
					</xsl:variable>
					<oa:Expression expressionLanguage="_wcf:XPath">
						<xsl:value-of select="$expression"/>
					</oa:Expression>
				</oa:Get>
			</_prc:DataArea>
		</_prc:GetEntitledPrice>	
	</xsl:template>
</xsl:stylesheet>