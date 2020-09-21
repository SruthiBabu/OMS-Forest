<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xslt" xmlns:_inv="http://www.ibm.com/xmlns/prod/commerce/9/inventory"
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:ra="http://WCToSSFSMediationModule/reserveAvailableInventory"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/" xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps" exclude-result-prefixes="xalan _inv _wcf _ord scwc xsd ra"
	version="1.0">

	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />

	<xsl:param name="scwc:ValueMapsData" />

	<xsl:template
		name="ProcessInventoryRequirementToApiInput_reserveAvailableInventory"
		match="/">
		<xsl:param name="ProcessInventoryRequirement" />
		<xsl:variable name="storeId">
			<xsl:value-of
				select="$ProcessInventoryRequirement/*[local-name()='ApplicationArea']/_wcf:BusinessContext/_wcf:ContextData[@name='storeId']/text()" />
		</xsl:variable>
		<xsl:variable name="OrganizationCode">
			<xsl:value-of
				select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $storeId)" />
		</xsl:variable>

		<xsl:variable name="order"
			select="$ProcessInventoryRequirement/_inv:DataArea/_inv:InventoryRequirement" />
		<Promise>
			<xsl:attribute name="OrganizationCode"><xsl:value-of select="$OrganizationCode" /></xsl:attribute>
			<ReservationParameters>
				<xsl:attribute name="ReservationID">
					<xsl:text>WC_</xsl:text>
					<xsl:value-of select="$order/_ord:OrderIdentifier/_wcf:UniqueID" />
				</xsl:attribute>
				<xsl:variable name="allowPartialReservation">
					<xsl:value-of select="$ProcessInventoryRequirement/_inv:DataArea/_inv:InventoryRequirement/_wcf:UserData/_wcf:UserDataField[@name='IBM_AllowPartialReservation']/text()" />   
				</xsl:variable>
				<xsl:attribute name="AllowPartialReservation">
					<xsl:choose>
						<xsl:when test="string-length(normalize-space($allowPartialReservation)) &gt; 0">
							<xsl:value-of select="$allowPartialReservation" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>N</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="AllowMultipleReservations">
					<xsl:text>Y</xsl:text>
				</xsl:attribute>
			</ReservationParameters>
			<PromiseLines>
				<xsl:for-each select="$order/_ord:OrderItem">
					<PromiseLine>	
						<xsl:if test="_ord:OrderItemShippingInfo/_ord:RequestedShipDate">
							<xsl:attribute name="ReqStartDate">
								<xsl:value-of
								select="_ord:OrderItemShippingInfo/_ord:RequestedShipDate" />
							</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="LineId">
							<xsl:text>WC_</xsl:text>
							<xsl:value-of select="_ord:OrderItemIdentifier/_wcf:UniqueID" />
						</xsl:attribute>
						<xsl:attribute name="ItemID">
							<xsl:value-of
							select="_ord:CatalogEntryIdentifier/_wcf:ExternalIdentifier/_wcf:PartNumber" />
						</xsl:attribute>
						<xsl:attribute name="RequiredQty">
							<xsl:value-of select="_ord:Quantity" />
						</xsl:attribute>
						<xsl:variable name="wcuom">
							<xsl:value-of select="_ord:Quantity/@uom" />
						</xsl:variable>
						<xsl:variable name="scuom">
							<xsl:choose>
								<xsl:when test="string-length(normalize-space($wcuom)) &gt; 0">
									<xsl:value-of
										select="ValueMaps:getMapValue($scwc:ValueMapsData, $OrganizationCode, 'wcUOMToscUOM', $wcuom)" />
								</xsl:when>
								<xsl:otherwise>
									EACH
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="uom">
							<xsl:choose>
								<xsl:when test="string-length(normalize-space($scuom)) &gt; 0">
									<xsl:value-of select="$scuom" />
								</xsl:when>
								<xsl:otherwise>
									EACH
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:attribute name="UnitOfMeasure">
							<xsl:value-of select="$uom" />
						</xsl:attribute>
						<xsl:attribute name="CarrierServiceCode">
							<xsl:variable name="wcShipModeCode"
							select="_ord:OrderItemShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:ShipModeCode" />
							<xsl:choose>
								<xsl:when
							test="string-length(normalize-space($wcShipModeCode)) &gt; 0">
									<xsl:variable name="scCarrierServiceCode">
										<xsl:value-of
							select="ValueMaps:getMapValue($scwc:ValueMapsData, $OrganizationCode, 'carrierServiceCodeToShipModeCode', $wcShipModeCode)" />
									</xsl:variable>
									<xsl:choose>
										<xsl:when
							test="string-length(normalize-space($scCarrierServiceCode)) &gt; 0">
											<xsl:value-of select="$scCarrierServiceCode" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$wcShipModeCode" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>Priority</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="ShipNode">
							<xsl:if
							test="_ord:OrderItemShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:ShipModeCode = 'PickupInStore' and normalize-space(_ord:OrderItemShippingInfo/_ord:PhysicalStoreIdentifier/_wcf:ExternalIdentifier) !=''">
								<xsl:variable name="wcShipNode"><xsl:value-of
							select="_ord:OrderItemShippingInfo/_ord:PhysicalStoreIdentifier/_wcf:ExternalIdentifier" /></xsl:variable>
								<xsl:variable name="scShipNode">
									<xsl:value-of
							select="ValueMaps:getMapValue($scwc:ValueMapsData, $OrganizationCode, 'wcShipNodeToscShipNode', $wcShipNode)" />
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="string-length(normalize-space($scShipNode)) &gt; 0">
										<xsl:value-of select="$scShipNode" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$wcShipNode" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</xsl:attribute>
						<ShipToAddress>
							<xsl:attribute name="AddressLine1">
								<xsl:value-of
								select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:AddressLine[1]" />
							</xsl:attribute>
							<xsl:attribute name="AddressLine2">
								<xsl:value-of
								select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:AddressLine[2]" />
							</xsl:attribute>
							<xsl:attribute name="AddressLine3">
								<xsl:value-of
								select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:AddressLine[3]" />
							</xsl:attribute>
							<xsl:attribute name="City">
								<xsl:value-of
								select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:City" />
							</xsl:attribute>
							<xsl:attribute name="State">
								<xsl:value-of
								select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:StateOrProvinceName" />
							</xsl:attribute>
							<xsl:attribute name="Country">
								<xsl:value-of
								select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:Country" />
							</xsl:attribute>
							<xsl:attribute name="ZipCode">
								<xsl:value-of
								select="_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:PostalCode" />
							</xsl:attribute>
						</ShipToAddress>
					</PromiseLine>
					<xsl:if test="_ord:ConfigurationID">
						<xsl:for-each select="_ord:OrderItemComponent">
							<PromiseLine>
								<xsl:attribute name="LineId">
									<xsl:text>WCC_</xsl:text>
									<xsl:value-of
									select="_ord:OrderItemComponentIdentifier/_ord:UniqueID" />
								</xsl:attribute>
								<xsl:attribute name="BundleParentLineId">
									<xsl:text>WC_</xsl:text>
									<xsl:value-of select="../_ord:OrderItemIdentifier/_wcf:UniqueID" />
								</xsl:attribute>
								<xsl:attribute name="ItemID">
									<xsl:value-of
									select="_ord:CatalogEntryIdentifier/_wcf:ExternalIdentifier/_wcf:PartNumber" />
								</xsl:attribute>
								<xsl:attribute name="KitQty">
									<xsl:value-of select="_ord:Quantity" />
								</xsl:attribute>
								<xsl:variable name="wcuom">
									<xsl:value-of select="_ord:Quantity/@uom" />
								</xsl:variable>
								<xsl:variable name="scuom">
									<xsl:choose>
										<xsl:when test="string-length(normalize-space($wcuom)) &gt; 0">
											<xsl:value-of
												select="ValueMaps:getMapValue($scwc:ValueMapsData, $OrganizationCode, 'wcUOMToscUOM', $wcuom)" />
										</xsl:when>
										<xsl:otherwise>
											EACH
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="uom">
									<xsl:choose>
										<xsl:when test="string-length(normalize-space($scuom)) &gt; 0">
											<xsl:value-of select="$scuom" />
										</xsl:when>
										<xsl:otherwise>
											EACH
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:attribute name="UnitOfMeasure">
									<xsl:value-of select="$uom" />
								</xsl:attribute>
								<xsl:attribute name="CarrierServiceCode">
									<xsl:variable name="wcShipModeCode1"
									select="_ord:OrderItemShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:ShipModeCode" />
									<xsl:choose>
										<xsl:when
									test="string-length(normalize-space($wcShipModeCode1)) &gt; 0">
											<xsl:variable name="scCarrierServiceCode1">
												<xsl:value-of
									select="ValueMaps:getMapValue($scwc:ValueMapsData, $OrganizationCode, 'carrierServiceCodeToShipModeCode', $wcShipModeCode1)" />
											</xsl:variable>
											<xsl:choose>
												<xsl:when
									test="string-length(normalize-space($scCarrierServiceCode1)) &gt; 0">
													<xsl:value-of select="$scCarrierServiceCode1" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$wcShipModeCode1" />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>Priority</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:attribute name="ShipNode">
									<xsl:if
									test="../_ord:OrderItemShippingInfo/_ord:ShippingMode/_ord:ShippingModeIdentifier/_ord:ExternalIdentifier/_ord:ShipModeCode = 'PickupInStore' and normalize-space(../_ord:OrderItemShippingInfo/_ord:PhysicalStoreIdentifier/_wcf:ExternalIdentifier) !=''">
										<xsl:variable name="wcShipNode">
											<xsl:value-of
									select="../_ord:OrderItemShippingInfo/_ord:PhysicalStoreIdentifier/_wcf:ExternalIdentifier" />
										</xsl:variable>
										<xsl:variable name="scShipNode">
											<xsl:value-of
									select="ValueMaps:getMapValue($scwc:ValueMapsData, $OrganizationCode, 'wcShipNodeToscShipNode', $wcShipNode)" />
										</xsl:variable>
										<xsl:choose>
											<xsl:when
									test="string-length(normalize-space($scShipNode)) &gt; 0">
												<xsl:value-of select="$scShipNode" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$wcShipNode" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:if>
								</xsl:attribute>
								<xsl:if test="_ord:OrderItemShippingInfo/_ord:RequestedShipDate">
									<xsl:attribute name="ReqStartDate">
										<xsl:value-of
										select="_ord:OrderItemShippingInfo/_ord:RequestedShipDate" />
									</xsl:attribute>
								</xsl:if>
								<ShipToAddress>
									<xsl:attribute name="AddressLine1">
										<xsl:value-of
										select="../_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:AddressLine[1]" />
									</xsl:attribute>
									<xsl:attribute name="AddressLine2">
										<xsl:value-of
										select="../_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:AddressLine[2]" />
									</xsl:attribute>
									<xsl:attribute name="AddressLine3">
										<xsl:value-of
										select="../_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:AddressLine[3]" />
									</xsl:attribute>
									<xsl:attribute name="City">
										<xsl:value-of
										select="../_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:City" />
									</xsl:attribute>
									<xsl:attribute name="State">
										<xsl:value-of
										select="../_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:StateOrProvinceName" />
									</xsl:attribute>
									<xsl:attribute name="Country">
										<xsl:value-of
										select="../_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:Country" />
									</xsl:attribute>
									<xsl:attribute name="ZipCode">
										<xsl:value-of
										select="../_ord:OrderItemShippingInfo/_ord:ShippingAddress/_wcf:Address/_wcf:PostalCode" />
									</xsl:attribute>
								</ShipToAddress>
							</PromiseLine>
						</xsl:for-each>
					</xsl:if>
				</xsl:for-each>
			</PromiseLines>
		</Promise>
	</xsl:template>
</xsl:stylesheet>