<?xml version="1.0" encoding="UTF-8"?>
<!-- ================================================================= Licensed 
	Materials - Property of IBM WebSphere Commerce (C) Copyright IBM Corp. 2010 ,2016
	All Rights Reserved. US Government Users Restricted Rights - Use, duplication 
	or disclosure restricted by GSA ADP Schedule Contract with IBM Corp. ================================================================= -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
	xmlns:oa="http://www.openapplications.org/oagis/9"
	xmlns:udt="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:_inv="http://www.ibm.com/xmlns/prod/commerce/9/inventory"
	xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order"
	xmlns="http://www.sterlingcommerce.com/documentation/YFS/reserveAvailableInventory/output"
	xmlns:mm="http://WCToSSFSMediationModule" xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="datetime mediationUtil ValueMaps"
	exclude-result-prefixes="xalan java" version="1.0">
	<xsl:param name="scwc:ValueMapsData" />
	<xsl:output method="xml" encoding="UTF-8"
		omit-xml-declaration="yes" indent="no" />
	<xsl:strip-space elements="*" />
	<xsl:template name="RootToAcknowledgeInventoryRequirement" match="/">
		<xsl:param name="Root" />
		<xsl:variable name="PromiseHeader" select="$Root/PromiseHeader"/>
		<xsl:variable name="currentdatetime" select="datetime:date-time()" />
		<xsl:variable name="today" select="datetime:date($currentdatetime)" />
	
		<_inv:AcknowledgeInventoryRequirement releaseID="">
			<_wcf:ApplicationArea>
				<oa:CreationDateTime xsi:type="udt:DateTimeType">
		            <xsl:variable name="datePattern">yyyy-MM-dd'T'HH:mm:ss'Z'</xsl:variable>
			    <xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new($datePattern), java:java.util.Date.new())" />
				</oa:CreationDateTime>
			</_wcf:ApplicationArea>
			<_inv:DataArea>
				<_inv:InventoryRequirement>
					<_ord:OrderIdentifier>
						<_wcf:UniqueID>
							<xsl:value-of
								select="substring-after($PromiseHeader/PromiseLines/PromiseLine/Reservations/Reservation/@ReservationID[1], 'WC_')" />
						</_wcf:UniqueID>
					</_ord:OrderIdentifier>
					<xsl:for-each
						select="$PromiseHeader/PromiseLines/PromiseLine[starts-with(@LineId, 'WC_') and not(@BundleParentLineId and not(@BundleParentLineId=''))]">
						<xsl:variable name="orderItemId">
							<xsl:value-of select="substring-after(@LineId, 'WC_')" />
						</xsl:variable>
						<!-- check whether Reservations/Reservation exist, if not, that means unallocated -->
						<xsl:choose>
							<xsl:when test="count(Reservations/Reservation) &lt;= 0">
								<_ord:OrderItem>
									<_ord:OrderItemIdentifier>
										<_wcf:UniqueID>
											<xsl:value-of select="$orderItemId" />
										</_wcf:UniqueID>
									</_ord:OrderItemIdentifier>
									<_ord:OrderItemStatus>
										<_ord:InventoryStatus xsi:type="_ord:InventoryStatusEnumerationType">Unallocated</_ord:InventoryStatus>
									</_ord:OrderItemStatus>
								</_ord:OrderItem>
							</xsl:when>
							<xsl:otherwise>
							<!-- check whether partial reservation exist, if yes, create an orderitem for the unallocated inventories. -->
							<xsl:for-each select="Reservations">
								<xsl:if test="@TotalReservedQty != @QtyToBeReserved">
								  <_ord:OrderItem>
									<_ord:CorrelationGroup>
													<xsl:value-of select="$orderItemId"/>
									</_ord:CorrelationGroup>
									<_ord:OrderItemStatus>
										<_ord:InventoryStatus xsi:type="_ord:InventoryStatusEnumerationType">Unallocated</_ord:InventoryStatus>
									</_ord:OrderItemStatus>
									
									<xsl:variable name="uomOfSC"><xsl:value-of select="@UnitOfMeasure" /></xsl:variable>
				    				<xsl:variable name="uomOfWC">
				    					<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'wcUOMToscUOM', $uomOfSC)" />
				    				</xsl:variable>
									<_ord:Quantity>
											<xsl:attribute name="uom">
												<xsl:value-of select="$uomOfWC"/>
											</xsl:attribute>
											<xsl:value-of select="@QtyToBeReserved - @TotalReservedQty"/>
										</_ord:Quantity>
								</_ord:OrderItem>
								</xsl:if>	
							</xsl:for-each>
							
								<xsl:for-each select="Reservations/Reservation">
									<_ord:OrderItem>
										<xsl:choose>
											<xsl:when test="position() &lt;= 1">
												<_ord:OrderItemIdentifier>
													<_wcf:UniqueID>
														<xsl:value-of select="$orderItemId" />
													</_wcf:UniqueID>
												</_ord:OrderItemIdentifier>
											</xsl:when>
											<xsl:otherwise>
												<_ord:CorrelationGroup>
													<xsl:value-of select="$orderItemId"/>
												</_ord:CorrelationGroup>
											</xsl:otherwise>
										</xsl:choose>
										<!-- set orderitem's quantity, that is the reserved quantity from different reservation -->
										<xsl:variable name="uomOfSC"><xsl:value-of select="@UnitOfMeasure" /></xsl:variable>
				    					<xsl:variable name="uomOfWC">
						    					<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, '', 'wcUOMToscUOM', $uomOfSC)" />
				    					</xsl:variable>
										<_ord:Quantity>
											<xsl:attribute name="uom">
												<xsl:value-of select="$uomOfWC"/>
											</xsl:attribute>
											<xsl:value-of select="@ReservedQty"/>
										</_ord:Quantity>
										<_ord:OrderItemStatus>
											<xsl:choose>
												<xsl:when test="@ProductAvailabilityDate and mediationUtil:dateTimeCompare($today, @ProductAvailabilityDate[1]) &gt;= 0">
													<_ord:InventoryStatus xsi:type="_ord:InventoryStatusEnumerationType">Allocated</_ord:InventoryStatus>
												</xsl:when>
												<xsl:when test="@ReservationID">
													<_ord:InventoryStatus xsi:type="_ord:InventoryStatusEnumerationType">Backordered</_ord:InventoryStatus>
												</xsl:when>
												<xsl:otherwise>
													<_ord:InventoryStatus xsi:type="_ord:InventoryStatusEnumerationType">Unallocated</_ord:InventoryStatus>
												</xsl:otherwise>
											</xsl:choose>
										</_ord:OrderItemStatus>
										<_ord:OrderItemFulfillmentInfo>
											<xsl:if test="@ProductAvailabilityDate">
												<_ord:AvailableDate>
													<xsl:value-of select="mediationUtil:dateToDateTime(@ProductAvailabilityDate[1])" />
												</_ord:AvailableDate>
											</xsl:if>
											<xsl:if test="@ShipDate">
												<_ord:ExpectedShipDate>
													<xsl:value-of select="mediationUtil:dateToDateTime(@ShipDate[1])" />
												</_ord:ExpectedShipDate>
											</xsl:if>
										</_ord:OrderItemFulfillmentInfo>
										<xsl:if test="@ShipNode">
											<_ord:FulfillmentCenter>
												<_ord:FulfillmentCenterIdentifier>
													<_wcf:Name>
														<xsl:variable name="scShipNode"><xsl:value-of select="@ShipNode" /></xsl:variable>
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
													</_wcf:Name>
												</_ord:FulfillmentCenterIdentifier>
											</_ord:FulfillmentCenter>
										</xsl:if>
									</_ord:OrderItem>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</_inv:InventoryRequirement>
			</_inv:DataArea>
		</_inv:AcknowledgeInventoryRequirement>
	</xsl:template>
</xsl:stylesheet>
