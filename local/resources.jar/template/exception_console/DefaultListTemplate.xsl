<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:lxslt="http://xml.apache.org/xslt"
                version="1.0">

<xsl:template match="/">

<HTML>
<xsl:comment>CONTENT_TYPE=text/html</xsl:comment>
<BODY>

<!-- 
	This is a sample xsl file which creates links for Order, Shipment and Load entities.  
	
	JS method openAlertLink is used to create a link to appropriate entity. Refer to Development Guide for details about this method.  

	JS method, openAlertLink can be used to form additional links to more Sterling entities.
	eg to create a link to delivery plan screen:
	<xsl:if ...> // some condition
		<xsl:element name="a">
			<xsl:attribute name="href">javascript:openAlertLink('deliveryplan.detail','Order','DeliveryPlanKey','<xsl:value-of select="$keyVariable"/>');</xsl:attribute>
			Delivery Plan
		</xsl:element>
	</xsl:if>
-->

<!-- 
	To create a link to outer system, form correct <A HREF="..." > HTML tag.
		eg to create a link to http://www.fedex.com/
		<xsl:if ..>	//	some condition
			<xsl:element name="a">
				<xsl:attribute name="href">http://www.fedex.com</xsl:attribute>
				<xsl:attribute name="target">_blank</xsl:attribute>
				Mylink
			</xsl:element>
		</xsl:if.>
-->


<xsl:variable name="OrderHeader" select="/Order/@OrderHeaderKey"/>
<xsl:if test="$OrderHeader &gt; '0'">
	<xsl:variable name="OrderDocument" select="/Order/@DocumentType"/>
	<xsl:variable name="linkPrefix">
		<!-- return order -->
		<xsl:if test="$OrderDocument = '0003'">
			<xsl:text>return.detail</xsl:text>
		</xsl:if>

		<!-- sales order -->
		<xsl:if test="$OrderDocument = '0001'">
			<xsl:text>order.detail</xsl:text>
		</xsl:if>

		<!-- inbound order -->
		<xsl:if test="$OrderDocument = '0005'">
			<xsl:text>po.detail</xsl:text>
		</xsl:if>
	</xsl:variable>

	<!-- form <a href="..."> -->
	<xsl:element name="a">
		<xsl:attribute name="href">javascript:openAlertLink('<xsl:value-of select="$linkPrefix"/>','Order','OrderHeaderKey','<xsl:value-of select="$OrderHeader"/>');</xsl:attribute>

		<xsl:if test="$OrderDocument = '0003'">
			<xsl:text>Return Order</xsl:text>
		</xsl:if>

		<!-- sales order -->
		<xsl:if test="$OrderDocument = '0001'">
			<xsl:text>Sales Order</xsl:text>
		</xsl:if>

		<!-- po order -->
		<xsl:if test="$OrderDocument = '0005'">
			<xsl:text>Inbound Order</xsl:text>
		</xsl:if>
	</xsl:element>
</xsl:if>

<xsl:variable name="ShipmentKey" select="/Shipment/@ShipmentKey"/>
<xsl:if test="$ShipmentKey &gt; '0'">
	<xsl:variable name="ShipmentDocument" select="/Shipment/@DocumentType"/>
	<xsl:variable name="linkPrefix">
		<!-- return shipment -->
		<xsl:if test="$ShipmentDocument = '0003'">
			<xsl:text>returnshipment.detail</xsl:text>
		</xsl:if>

		<!-- sales shipment -->
		<xsl:if test="$ShipmentDocument = '0001'">
			<xsl:text>shipment.detail</xsl:text>
		</xsl:if>

		<!-- inbound shipment-->
		<xsl:if test="$ShipmentDocument = '0005'">
			<xsl:text>poshipment.detail</xsl:text>
		</xsl:if>
	</xsl:variable>

	<xsl:element name="a">
		<xsl:attribute name="href">javascript:openAlertLink('<xsl:value-of select="$linkPrefix"/>','Shipment','ShipmentKey','<xsl:value-of select="$ShipmentKey"/>');</xsl:attribute>

		<!-- return shipment -->
		<xsl:if test="$ShipmentDocument = '0003'">
			<xsl:text>Return Shipment</xsl:text>
		</xsl:if>

		<!-- sales shipment -->
		<xsl:if test="$ShipmentDocument = '0001'">
			<xsl:text>Shipment</xsl:text>
		</xsl:if>

		<!-- inbound shipment-->
		<xsl:if test="$ShipmentDocument = '0005'">
			<xsl:text>Inbound Shipment</xsl:text>
		</xsl:if>
	</xsl:element>
</xsl:if>

<!-- Load -->
<xsl:variable name="LoadKey" select="/Load/@LoadKey" />
<xsl:if test="$LoadKey &gt; '0'">
	<xsl:element name="a">
		<xsl:attribute name="href">javascript:openAlertLink('load.detail','Load','LoadKey','<xsl:value-of select="$LoadKey"/>');</xsl:attribute>
		<xsl:text>Load</xsl:text>
	</xsl:element>
</xsl:if>

</BODY>
</HTML>
</xsl:template>

</xsl:stylesheet>
