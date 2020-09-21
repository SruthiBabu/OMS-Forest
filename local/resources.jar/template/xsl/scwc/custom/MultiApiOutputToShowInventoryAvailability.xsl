<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2016 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
	xmlns:_inv="http://www.ibm.com/xmlns/prod/commerce/9/inventory"
	xmlns:oa="http://www.openapplications.org/oagis/9" xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:udt="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
	xmlns:_cor="http://WCToSSFSMediationModule/correlation"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
    xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
    xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java"
	extension-element-prefixes="datetime mediationUtil ValueMaps" version="1.0">
	<xsl:param name="scwc:ValueMapsData"/>
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />

	<!--
		The rule represents a custom mapping: "Root" to
		"out5:ShowInventoryAvailability".
	-->
	<xsl:template name="RootToShowInventoryAvailability">
		<xsl:param name="Root" />
		<xsl:param name="correlation" />
		<xsl:variable name="apisMonitorItemAvailability" select="$Root/MultiApi/API[@Name='monitorItemAvailability']" />
		<xsl:variable name="apisFindInventory" select="$Root/MultiApi/API[@Name='findInventory']" />
		<xsl:variable name="apiExtns" select="$correlation/GetInvAvlMultiApi/APIInputExtn" />

		<_inv:ShowInventoryAvailability>
			<_wcf:ApplicationArea>
				<oa:CreationDateTime xsi:type="udt:DateTimeType">
		            <xsl:variable name="datePattern">yyyy-MM-dd'T'HH:mm:ss'Z'</xsl:variable>
			    <xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new($datePattern), java:java.util.Date.new())" />
				</oa:CreationDateTime>
			</_wcf:ApplicationArea>
			<_inv:DataArea>
				<xsl:for-each select="$apiExtns">
					<xsl:variable name="index" select="position()" />
					<xsl:variable name="partNumber" select="@partNumber" />
					<xsl:variable name="uom" select="@uom" />
					<xsl:variable name="scUOM" select="@scUOM" />
					<xsl:variable name="onlineStoreIndex" select="number(@onlineStoreIndex)" />
					
					<xsl:variable name="onlineStoreIdentifier"
						select="@onlineStoreIdentifier" />
					<xsl:variable name="physicalStoreIdentifier"
						select="@physicalStoreIdentifier" />

					<xsl:choose>
						<!-- Online Store -->
						<xsl:when
							test="string-length(normalize-space($onlineStoreIdentifier)) &gt; 0">
							<_inv:InventoryAvailability>
								<_inv:InventoryAvailabilityIdentifier>
									<_wcf:ExternalIdentifier>
										<_wcf:CatalogEntryIdentifier>
											<_wcf:ExternalIdentifier>
												<_wcf:PartNumber>
							                        <xsl:value-of select="$partNumber" />
						                        </_wcf:PartNumber>
											</_wcf:ExternalIdentifier>
										</_wcf:CatalogEntryIdentifier>
										<_wcf:OnlineStoreIdentifier>
											<_wcf:ExternalIdentifier>
												<_wcf:NameIdentifier>
							                        <xsl:value-of select="$onlineStoreIdentifier" />
						                        </_wcf:NameIdentifier>
											</_wcf:ExternalIdentifier>
										</_wcf:OnlineStoreIdentifier>
									</_wcf:ExternalIdentifier>
								</_inv:InventoryAvailabilityIdentifier>
								<xsl:variable name="inventoryAlerts"
									select="$apisMonitorItemAvailability[$onlineStoreIndex]/Output/InventoryAlerts" />
								<xsl:choose>
									<xsl:when
										test="$inventoryAlerts/InventoryAlert/@OnhandAvailableQuantity &gt; 0">
										<_inv:InventoryStatus>Available</_inv:InventoryStatus>
										<_inv:AvailableQuantity>
											<xsl:attribute name="uom">
												<xsl:value-of select="$uom" />
											</xsl:attribute>
											<xsl:value-of
												select="$inventoryAlerts/InventoryAlert/@OnhandAvailableQuantity" />
										</_inv:AvailableQuantity>
									</xsl:when>
									<xsl:when
										test="normalize-space($inventoryAlerts/InventoryAlert/@FirstFutureAvailableDate) != '' and $inventoryAlerts/InventoryAlert/@FirstFutureAvailableDate != '2500-01-01'">
										<_inv:InventoryStatus>Backorderable</_inv:InventoryStatus>
										<_inv:AvailabilityDateTime>
											<xsl:value-of
												select="mediationUtil:dateToDateTime($inventoryAlerts/InventoryAlert/@FirstFutureAvailableDate)" />
										</_inv:AvailabilityDateTime>
									</xsl:when>
									<xsl:otherwise>
										<_inv:InventoryStatus>Unavailable</_inv:InventoryStatus>
										<_inv:AvailableQuantity>
												<xsl:attribute name="uom">C62</xsl:attribute>
												0
										</_inv:AvailableQuantity>
									</xsl:otherwise>
								</xsl:choose>
							</_inv:InventoryAvailability>
						</xsl:when>
						<!-- Physical store -->
						<xsl:when test="string-length(normalize-space($physicalStoreIdentifier)) &gt; 0">
							<_inv:InventoryAvailability>
								<_inv:InventoryAvailabilityIdentifier>
									<_wcf:ExternalIdentifier>
										<_wcf:CatalogEntryIdentifier>
											<_wcf:ExternalIdentifier>
												<_wcf:PartNumber>
												<xsl:value-of select="$partNumber" />
											</_wcf:PartNumber>
											</_wcf:ExternalIdentifier>
										</_wcf:CatalogEntryIdentifier>
										<_wcf:PhysicalStoreIdentifier>
											<_wcf:ExternalIdentifier>
											<xsl:value-of select="$physicalStoreIdentifier" />
										</_wcf:ExternalIdentifier>
										</_wcf:PhysicalStoreIdentifier>
									</_wcf:ExternalIdentifier>
								</_inv:InventoryAvailabilityIdentifier>
								<xsl:variable name="currentdatetime" select="datetime:date-time()" />
								<xsl:variable name="today" select="datetime:date($currentdatetime)" />
								<xsl:variable name="scShipNode">
									<xsl:variable name="tmpSCShipNode"
										select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'wcShipNodeToscShipNode', $physicalStoreIdentifier)"/>
									<xsl:choose>
										<xsl:when test="string-length(normalize-space($tmpSCShipNode)) &gt; 0">
											<xsl:value-of select="$tmpSCShipNode" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$physicalStoreIdentifier" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="promise" select="$apisFindInventory[1]/Output/Promise" />
								<xsl:variable name="promiseLine"
									select="$promise/SuggestedOption/Option/PromiseLines/PromiseLine[@ItemID=$partNumber and @ShipNode=$scShipNode and @UnitOfMeasure=$scUOM]" />
								<xsl:variable name="availableQuantity"
									select="sum($promiseLine/Assignments/Assignment[@ProductAvailDate and mediationUtil:dateTimeCompare($today, @ProductAvailDate) &gt;= 0]/@Quantity)" />
								<xsl:choose>
									<xsl:when test="$availableQuantity &gt; 0">
										<_inv:InventoryStatus>Available</_inv:InventoryStatus>
										<_inv:AvailableQuantity>
											<xsl:attribute name="uom">
												<xsl:value-of select="$uom" />
											</xsl:attribute>
											<xsl:value-of select="$availableQuantity" />
										</_inv:AvailableQuantity>
									</xsl:when>
									<xsl:when
										test="$promiseLine/Assignments/Assignment[@Quantity &gt; 0] and $promiseLine/Assignments/Assignment[@Quantity &gt; 0]/@ProductAvailDate != ''">
										<_inv:InventoryStatus>Backorderable</_inv:InventoryStatus>
										<_inv:AvailabilityDateTime>
											<xsl:value-of
												select="mediationUtil:dateToDateTime($promiseLine/Assignments/Assignment[@Quantity &gt; 0]/@ProductAvailDate)" />
										</_inv:AvailabilityDateTime>
									</xsl:when>
									<xsl:otherwise>
										<_inv:InventoryStatus>Unavailable</_inv:InventoryStatus>
									</xsl:otherwise>
								</xsl:choose>
							</_inv:InventoryAvailability>
						</xsl:when>
						<xsl:otherwise>
							<!-- Do Nothing -->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</_inv:DataArea>
		</_inv:ShowInventoryAvailability>
	</xsl:template>
</xsl:stylesheet>
