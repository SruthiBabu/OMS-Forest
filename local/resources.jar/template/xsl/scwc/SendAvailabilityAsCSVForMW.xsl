<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2016 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
	xmlns:yfc="http://www.sterlingcommerce.com/documentation/YFS/REALTIME_ATP_MONITOR/REALTIME_AVAILABILITY_CHANGE"
	xmlns:wrapper="http://www.ibm.com/xmlns/prod/websphere/j2ca/flatfile/inventoryavailabilitycsvtypewrapper"
	xmlns:mm="http://WCToSSFSMediationModule"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/" 
    xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="datetime mediationUtil ValueMaps"
	exclude-result-prefixes="xalan yfc"
	version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:param name="scwc:ValueMapsData" />
	<xsl:template name="AvailabilityChangeToContent" match="/">	
	
		<xsl:variable name="OrganizationCode"><xsl:value-of select="/InventoryItem/@InventoryOrganizationCode" /></xsl:variable>
		<xsl:variable name="ItemID"><xsl:value-of select="/InventoryItem/@ItemID" /></xsl:variable>
		<xsl:variable name="UOM"><xsl:value-of select="/InventoryItem/@UnitOfMeasure" /></xsl:variable>
		
		<xsl:variable name="storeId">
			<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'storeIdToInventoryOrganizationCode', $OrganizationCode)" />
		</xsl:variable>

		<wrapper:Content>
		<xsl:for-each select="/InventoryItem/AvailabilityChanges/AvailabilityChange">
		     <mm:InventoryAvailability>
			<mm:PartNumber><xsl:value-of select="$ItemID" /></mm:PartNumber>
			<xsl:choose>
				<xsl:when test="@IsDefaultDistributionGroup='Y' or normalize-space(@Node)=''">
					<mm:OnlineStoreUniqueID><xsl:value-of select="$storeId" /></mm:OnlineStoreUniqueID>
				</xsl:when>
				<xsl:otherwise>
					<mm:physicalStoreIdentifier>
						<xsl:variable name="scShipNode"><xsl:value-of select="@Node" /></xsl:variable>
						<xsl:variable name="wcShipNode">							
							<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'wcShipNodeToscShipNode', $scShipNode)" />
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="string-length(normalize-space($wcShipNode)) &gt; 0">
								<xsl:value-of select="$wcShipNode" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$scShipNode" />
							</xsl:otherwise>
						</xsl:choose>
					</mm:physicalStoreIdentifier>
				</xsl:otherwise>
			</xsl:choose>
					<mm:AvailableQuantity><xsl:value-of select="@OnhandAvailableQuantity" /></mm:AvailableQuantity>
					<mm:MonitorOption><xsl:value-of select="@MonitorOption" /></mm:MonitorOption>
					<mm:FutureAvailableQuantity><xsl:value-of select="@FutureAvailableQuantity" /></mm:FutureAvailableQuantity>
					<mm:FutureAvailableDate><xsl:value-of select="datetime:formatDate(@FutureAvailableDate, 'yyyy-MM-dd HH:mm:ss.SSS')" /></mm:FutureAvailableDate>
		     </mm:InventoryAvailability>
		     </xsl:for-each>
		</wrapper:Content>
	</xsl:template>
</xsl:stylesheet>
