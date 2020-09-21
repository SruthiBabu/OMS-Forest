<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
(C) Copyright IBM Corp. 2005, 2015 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SimpleDateFormat="java.text.SimpleDateFormat" xmlns:Date="java.util.Date" xmlns:ibmjda="http://www.sterlingcommerce.com/ibmjda/" xmlns:ValueMaps="xalan://com.yantra.ibmjda.impl.ValueMapsData" extension-element-prefixes="ValueMaps" exclude-result-prefixes="xalan SimpleDateFormat Date ibmjda" xmlns:labor_capacity="urn:gs1:ecom:labor_capacity:xsd:3" xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="ibmjda:ValueMapsData"/>
	<xsl:variable name="locationValue">
		<xsl:value-of select="labor_capacity:laborCapacityMessage/laborCapacity/location"/>
	</xsl:variable>
	<xsl:variable name="enterpriseValue">
		<xsl:value-of select="labor_capacity:laborCapacityMessage/laborCapacity/enterprise"/>
	</xsl:variable>
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="labor_capacity:laborCapacityMessage/laborCapacity/enterprise">
		<enterprise>
			 <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMOrganizationCode', $enterpriseValue)"/> 
		</enterprise>
	</xsl:template>
	<xsl:template match="labor_capacity:laborCapacityMessage/laborCapacity/location">
		<location>
			 <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $locationValue)"/> 
		</location>
	</xsl:template>
</xsl:stylesheet>
