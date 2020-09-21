<?xml version = "1.0" encoding = "UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:output indent="yes"/>
	<xsl:template match="/Shipment">
		<Shipment>
			<xsl:choose>
				<xsl:when test="not(@ActualShipmentDate) or (@ActualShipmentDate=&quot;&quot;)">
					<xsl:attribute name="ActualShipmentDate"><xsl:value-of select="@ExpectedShipmentDate"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="ActualShipmentDate"><xsl:value-of select="@ActualShipmentDate"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:for-each select="@*">
				<xsl:if test="not(name()= &quot;ActualShipmentDate&quot;)">
					 <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
				</xsl:if>
			</xsl:for-each>
			<xsl:copy-of select="SellerOrganization"/>
			<xsl:copy-of select="Carrier"/>
			<xsl:copy-of select="ShipNode"/>
			<xsl:copy-of select="ToAddress"/>
			<xsl:copy-of select="MarkForAddress"/>
			<xsl:copy-of select="BillingInformation"/>
			<xsl:copy-of select="Instructions"/>
			<xsl:copy-of select="Containers"/>
		        <xsl:copy-of select="BatchLocations"/> 
			<ShipmentLines>
				<xsl:for-each select="ShipmentLines/ShipmentLine[@ShipmentSubLineNo='0']">
					<ShipmentLine>
						<xsl:variable name="qty" select="sum(OrderLine/OrderStatuses/OrderStatus[@OrderLineKey=current()/@OrderLineKey and substring(@Status,1,4)='1300']/@StatusQty)"/> 
						<xsl:attribute name="OrderedQty">
							<xsl:value-of select="sum(OrderLine/OrderStatuses/OrderStatus[@OrderLineKey=current()/@OrderLineKey and not(substring(@Status,1,4)='1400')]/@StatusQty)"/> 
						</xsl:attribute>
						<xsl:attribute name="BackOrderedQty">
								<xsl:value-of select="$qty"/>
							</xsl:attribute>
						<xsl:copy-of select="@*"/>
						<xsl:copy-of select="Order"/>
						<xsl:copy-of select="OrderLine"/>
					</ShipmentLine>
				</xsl:for-each>
			</ShipmentLines>
		</Shipment>
	</xsl:template>
</xsl:stylesheet>