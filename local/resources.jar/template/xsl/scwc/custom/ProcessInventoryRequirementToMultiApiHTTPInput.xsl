<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2013 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:xalan="http://xml.apache.org/xslt"
     xmlns:oa="http://www.openapplications.org/oagis/9"
     xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
     xmlns:_inv="http://www.ibm.com/xmlns/prod/commerce/9/inventory"
     xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
     xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order"
     xmlns:xsd="http://www.w3.org/2001/XMLSchema"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	 xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	 xmlns:date="http://exslt.org/dates-and-times"
	 extension-element-prefixes="ValueMaps"
     exclude-result-prefixes="xalan oa _wcf _inv _ord"
     version="1.0">
  <xsl:param name="scwc:ValueMapsData" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>
  <xsl:strip-space elements="*"/>

  <xsl:template name="ProcessInventoryRequirementToApiInput_multiApi">
    
    	<xsl:param name="ProcessInventoryRequirement" />
		<xsl:variable name="storeId">
			<xsl:value-of select="$ProcessInventoryRequirement/*[local-name()='ApplicationArea']/_wcf:BusinessContext/_wcf:ContextData[@name='storeId']/text()" />
		</xsl:variable>
		<xsl:variable name="OrganizationCode">
			<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $storeId)" />
		</xsl:variable>
		<xsl:variable name="order" select="$ProcessInventoryRequirement/_inv:DataArea/_inv:InventoryRequirement" />
				<MultiApi>
					<xsl:for-each select="$order/_ord:OrderItem">
					    <xsl:variable name="inventoryStatus"><xsl:value-of select="_ord:OrderItemStatus/_ord:InventoryStatus" /></xsl:variable>
					    <xsl:if test="$inventoryStatus != 'Unallocated'">
						<xsl:choose>
							<xsl:when test="_ord:OrderItemComponent">
								<xsl:for-each select="_ord:OrderItemComponent">
									<API Name="cancelReservation">
										<Input>
											<CancelReservation>
												<xsl:attribute name="OrganizationCode"><xsl:value-of select="$OrganizationCode" /></xsl:attribute>
												<xsl:attribute name="ReservationID">
													<xsl:text>WC_</xsl:text><xsl:value-of select="$order/_ord:OrderIdentifier/_wcf:UniqueID" />
												</xsl:attribute>
												<xsl:attribute name="ItemID">
													<xsl:value-of select="_ord:CatalogEntryIdentifier/_wcf:ExternalIdentifier/_wcf:PartNumber" />
												</xsl:attribute>
												<xsl:attribute name="QtyToBeCancelled">
													<xsl:value-of select="number(_ord:Quantity)*number(../_ord:Quantity)" />
												</xsl:attribute>
												
												<xsl:variable name="wcuom">
													<xsl:value-of select="_ord:Quantity/@uom" />
												</xsl:variable>
												<xsl:variable name="scuom">
													<xsl:choose>
														<xsl:when test="string-length(normalize-space($wcuom)) &gt; 0">
															<!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='wcUOMToscUOM']/mm:Entry[@key=$wcuom]/text()"/> -->
															<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcUOMToscUOM', $wcuom)" />
														</xsl:when>
														<xsl:otherwise>EACH</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<xsl:variable name="uom">
													<xsl:choose>
														<xsl:when test="string-length(normalize-space($scuom)) &gt; 0">
															<xsl:value-of select="$scuom"/>
														</xsl:when>
														<xsl:otherwise>EACH</xsl:otherwise>
													</xsl:choose>				
												</xsl:variable>		
												<xsl:attribute name="UnitOfMeasure">
													<xsl:value-of select="$uom"/>
												</xsl:attribute>
												<xsl:variable name="wcShipNode"><xsl:value-of select="../_ord:FulfillmentCenter/_ord:FulfillmentCenterIdentifier/_wcf:Name" /></xsl:variable>
												<xsl:variable name="scShipNode">
													<!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='wcShipNodeToscShipNode']/mm:Entry[@key=$wcShipNode]/text()" /> -->
													<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcShipNodeToscShipNode', $wcShipNode)" />
												</xsl:variable>
												
												<xsl:attribute name="ShipNode">
													<xsl:choose>
														<xsl:when test="string-length(normalize-space($scShipNode)) &gt; 0">
															<xsl:value-of select="$scShipNode" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$wcShipNode" />
														</xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
												
												<xsl:variable name="shipDate">
													<xsl:value-of select="mediationUtil:dateTimeToDate(../_ord:OrderItemFulfillmentInfo/_ord:ExpectedShipDate)"/>
												</xsl:variable>
												
												<xsl:if test="string-length(normalize-space($shipDate)) &gt; 0">
													<xsl:attribute name="ShipDate">
														<xsl:value-of select="$shipDate"/>
													</xsl:attribute>	
												</xsl:if>
												
											</CancelReservation>
										</Input>
									</API>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<API Name="cancelReservation">
									<Input>
										<CancelReservation>
											<xsl:attribute name="OrganizationCode"><xsl:value-of select="$OrganizationCode" /></xsl:attribute>
											<xsl:attribute name="ReservationID">
												<xsl:text>WC_</xsl:text><xsl:value-of select="$order/_ord:OrderIdentifier/_wcf:UniqueID" />
											</xsl:attribute>
											<xsl:attribute name="ItemID">
												<xsl:value-of select="_ord:CatalogEntryIdentifier/_wcf:ExternalIdentifier/_wcf:PartNumber" />
											</xsl:attribute>
											<xsl:attribute name="QtyToBeCancelled">
												<xsl:value-of select="_ord:Quantity" />
											</xsl:attribute>
											<xsl:variable name="wcuom">
												<xsl:value-of select="_ord:Quantity/@uom" />
											</xsl:variable>
											<xsl:variable name="scuom">
												<xsl:choose>
													<xsl:when test="string-length(normalize-space($wcuom)) &gt; 0">
														<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcUOMToscUOM', $wcuom)"/>
													</xsl:when>
													<xsl:otherwise>EACH</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="uom">
												<xsl:choose>
													<xsl:when test="string-length(normalize-space($scuom)) &gt; 0">
														<xsl:value-of select="$scuom"/>
													</xsl:when>
													<xsl:otherwise>EACH</xsl:otherwise>
												</xsl:choose>				
											</xsl:variable>	
											<xsl:attribute name="UnitOfMeasure">
												<xsl:value-of select="$uom"/>
											</xsl:attribute>
								
											<xsl:variable name="wcShipNode">
												<xsl:value-of select="_ord:FulfillmentCenter/_ord:FulfillmentCenterIdentifier/_wcf:Name" />
											</xsl:variable>
											<xsl:variable name="scShipNode">
												<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcShipNodeToscShipNode', $wcShipNode)" />
											</xsl:variable>
											<xsl:attribute name="ShipNode">
													<xsl:choose>
														<xsl:when test="string-length(normalize-space($scShipNode)) &gt; 0">
															<xsl:value-of select="$scShipNode" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="$wcShipNode" />
														</xsl:otherwise>
													</xsl:choose>
											</xsl:attribute>
											
						
											
											<xsl:variable name="shipDate">
												<xsl:value-of select="mediationUtil:dateTimeToDate(_ord:OrderItemFulfillmentInfo/_ord:ExpectedShipDate)"/>
											</xsl:variable>
											
											<xsl:if test="string-length(normalize-space($shipDate)) &gt; 0">
												<xsl:attribute name="ShipDate">
													<xsl:value-of select="$shipDate"/>
												</xsl:attribute>	
											</xsl:if>
										</CancelReservation>
									</Input>
								</API>
							</xsl:otherwise>
						</xsl:choose>
					  </xsl:if>
					</xsl:for-each>
				</MultiApi>
  </xsl:template>
</xsl:stylesheet>