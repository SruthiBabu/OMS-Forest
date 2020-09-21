<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Selling and Fulfillment Suite
(C) Copyright IBM Corp. 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<!--
    Document    sortLoadDetails.xsl
    Created on  June 27 2013
    Author      GauravKM
    Description
        Sort the LoadShipments according to StopSequenceNo.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
    <xsl:template match="/">
        <Load>
            <xsl:for-each select="Load/@*">
                <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:copy-of select="Load/BuyerOrganizationCode"/>  
            <xsl:copy-of select="Load/EnterpriseCode"/>
	    <xsl:copy-of select="Load/LoadKey"/>
	    <xsl:copy-of select="Load/LoadNo"/>
	    <xsl:copy-of select="Load/OriginNode"/>
	    <LoadShipments>
		<xsl:for-each select="Load/LoadShipments/LoadShipment">
			<xsl:sort select="DropoffStop/@StopSequenceNo" order="ascending"/>
			<xsl:copy-of select="."/>
                </xsl:for-each>
            </LoadShipments>
	    <Manifest>
		    <xsl:for-each select="Load/Manifest/@*">
		    <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
		    </xsl:for-each>
		    <xsl:copy-of select="Load/Manifest/ShipperAccountNo" />
	    </Manifest>
        </Load>
    </xsl:template>
</xsl:stylesheet> 