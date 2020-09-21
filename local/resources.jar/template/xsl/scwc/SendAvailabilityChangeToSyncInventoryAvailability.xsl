<?xml version="1.0" encoding="UTF-8"?>

<!--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2011,2014 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
-->
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:mm="http://WCToSSFSMediationModule"
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
	xmlns:oa="http://www.openapplications.org/oagis/9"
	xmlns:udt="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:_inv="http://www.ibm.com/xmlns/prod/commerce/9/inventory"
	xmlns:yfc="http://www.sterlingcommerce.com/documentation/YFS/REALTIME_ATP_MONITOR/REALTIME_AVAILABILITY_CHANGE"
	xmlns:_cor="http://WCToSSFSMediationModule/correlation"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	xmlns:java="http://xml.apache.org/xslt/java"
    xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="datetime mediationUtil ValueMaps" 
	exclude-result-prefixes="java"
	version="1.0">
	
	<xsl:param name="scwc:ValueMapsData"/>

	<xsl:output method="xml" encoding="UTF-8"
		omit-xml-declaration="yes" indent="no" />
	<xsl:strip-space elements="*" />
	
	<xsl:template name="AvailabilityChangeToSyncInventoryAvailability" match="/">
		<xsl:variable name="OrganizationCode"><xsl:value-of select="/InventoryItem/@InventoryOrganizationCode" /></xsl:variable>
		<xsl:variable name="storeId"><xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'storeIdToInventoryOrganizationCode', $OrganizationCode)" /></xsl:variable>
		<xsl:variable name="ItemID"><xsl:value-of select="/InventoryItem/@ItemID" /></xsl:variable>
		<xsl:variable name="UOM"><xsl:value-of select="/InventoryItem/@UnitOfMeasure" /></xsl:variable>
				<_inv:SyncInventoryAvailability releaseID="">
					<_wcf:ApplicationArea>
						<oa:CreationDateTime xsi:type="udt:DateTimeType">
		            <xsl:variable name="datePattern">yyyy-MM-dd'T'HH:mm:ss'Z'</xsl:variable>
			    <xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new($datePattern), java:java.util.Date.new())" />
						</oa:CreationDateTime>
						<_wcf:BusinessContext>
							<_wcf:ContextData name="storeId"><xsl:value-of select="$storeId" /></_wcf:ContextData>
						</_wcf:BusinessContext>
					</_wcf:ApplicationArea>
					<_inv:DataArea>
						<oa:Sync>
							<oa:ActionCriteria>
								<oa:ActionExpression actionCode="Change" expressionLanguage="_wcf:XPath">/InventoryAvailability[1]</oa:ActionExpression>
							</oa:ActionCriteria>
						</oa:Sync>
						<xsl:for-each select="/InventoryItem/AvailabilityChanges/AvailabilityChange">
						<_inv:InventoryAvailability>
							<_inv:InventoryAvailabilityIdentifier>
								<_wcf:ExternalIdentifier>
									<_wcf:CatalogEntryIdentifier>
										<_wcf:ExternalIdentifier>
											<_wcf:PartNumber><xsl:value-of select="$ItemID" /></_wcf:PartNumber>
										</_wcf:ExternalIdentifier>
									</_wcf:CatalogEntryIdentifier>
									<xsl:choose>
										<xsl:when test="@IsDefaultDistributionGroup='Y' or normalize-space(@Node)=''">
											<_wcf:OnlineStoreIdentifier>
												<_wcf:UniqueID><xsl:value-of select="$storeId" /></_wcf:UniqueID>
											</_wcf:OnlineStoreIdentifier>
										</xsl:when>
										<xsl:otherwise>
											<_wcf:PhysicalStoreIdentifier>
												<_wcf:ExternalIdentifier>
													<xsl:variable name="scShipNode"><xsl:value-of select="@Node" /></xsl:variable>
													<xsl:variable name="wcShipNode">
														<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'wcShipNodeToscShipNode', $scShipNode)" />
													</xsl:variable>
													<xsl:choose>
														<xsl:when test="string-length(normalize-space($wcShipNode)) &gt; 0">
															<xsl:value-of select="$wcShipNode" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$scShipNode" />
														</xsl:otherwise>
													</xsl:choose>
												</_wcf:ExternalIdentifier>
											</_wcf:PhysicalStoreIdentifier>
										</xsl:otherwise>
									</xsl:choose>
								</_wcf:ExternalIdentifier>
							</_inv:InventoryAvailabilityIdentifier>
							<xsl:choose>
								<xsl:when test="@OnhandAvailableQuantity &gt; 0">
									<_inv:InventoryStatus>Available</_inv:InventoryStatus>
									<_inv:AvailableQuantity>
										<xsl:attribute name="uom">
										<xsl:choose>
											<xsl:when test="normalize-space($UOM)!=''">
												<xsl:variable name="itemQuantityUOM" select="$UOM" />
												<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'wcUOMToscUOM', $itemQuantityUOM)" />
											</xsl:when>
											<xsl:otherwise>C62</xsl:otherwise>
										</xsl:choose>
										</xsl:attribute>
										<xsl:value-of select="@OnhandAvailableQuantity" />								
									</_inv:AvailableQuantity>
								</xsl:when>
								<xsl:when test="@FirstFutureAvailableDate != '' and @FirstFutureAvailableDate != '2500-01-01'">
									<_inv:InventoryStatus>Backorderable</_inv:InventoryStatus>
									<_inv:AvailabilityDateTime><xsl:value-of select="mediationUtil:dateToDateTime(@FirstFutureAvailableDate)" /></_inv:AvailabilityDateTime>
								</xsl:when>
								<xsl:otherwise>
									<_inv:InventoryStatus>Unavailable</_inv:InventoryStatus>
								</xsl:otherwise>
							</xsl:choose>
							<_inv:LastUpdateDateTime><xsl:value-of select="mediationUtil:dateToDateTime(@AlertRaisedOn)" /></_inv:LastUpdateDateTime>
						</_inv:InventoryAvailability>
						</xsl:for-each>
					</_inv:DataArea>
				</_inv:SyncInventoryAvailability>
	</xsl:template>
</xsl:stylesheet>
