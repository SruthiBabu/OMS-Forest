<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
 <xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps"
	exclude-result-prefixes="xalan"
	version="1.0">
	<xsl:param name="scwc:ValueMapsData" />
	<xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:template name="GetOrderLineDetailsApiOutput" match="/">
		<OrderLine>
			<xsl:attribute name="OrderHeaderKey">
				<xsl:value-of select="/OrderLine/@OrderHeaderKey" />
			</xsl:attribute>
			<xsl:attribute name="OrderLineKey">
				<xsl:value-of select="/OrderLine/@OrderLineKey" />
			</xsl:attribute>
			<xsl:attribute name="BOMXML">
				<xsl:value-of select="/OrderLine/@BOMXML" />
			</xsl:attribute>
		</OrderLine>
	</xsl:template>
</xsl:stylesheet>