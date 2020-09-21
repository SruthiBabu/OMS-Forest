<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!-- GetLoadBOLCopy -->
  <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
      <xsl:template match="/Load">
        <LoadList>
	  <Load>
		<xsl:copy-of select="@*"/>
			<xsl:attribute name="Copy">
				 <xsl:text>Consignee Copy</xsl:text>
			</xsl:attribute>
			 <xsl:copy-of select="OriginAddress"/>
			 <xsl:copy-of select="DestinationAddress"/>
			 <xsl:copy-of select="LoadShipments"/>
			 <xsl:copy-of select="LoadStops"/>
			 <xsl:copy-of select="Containers"/>
			 <xsl:copy-of select="Carrier"/>
			 <xsl:copy-of select="Instructions"/>
			 <xsl:copy-of select="LabelFormat"/>
			 <xsl:copy-of select="VICSBOLData"/>			 
	  </Load>
	   <Load>
		<xsl:copy-of select="@*"/>
			<xsl:attribute name="Copy">
				 <xsl:text>Shipper Copy</xsl:text>
			</xsl:attribute>
			 <xsl:copy-of select="OriginAddress"/>
			 <xsl:copy-of select="DestinationAddress"/>
			 <xsl:copy-of select="LoadShipments"/>
			 <xsl:copy-of select="LoadStops"/>
			 <xsl:copy-of select="Containers"/>
			 <xsl:copy-of select="Carrier"/>
			 <xsl:copy-of select="Instructions"/>
			 <xsl:copy-of select="LabelFormat"/>
			 <xsl:copy-of select="VICSBOLData"/>
	  </Load>
	   <Load>
		<xsl:copy-of select="@*"/>
			<xsl:attribute name="Copy">
				 <xsl:text>Carrier Copy</xsl:text>
			</xsl:attribute>
			 <xsl:copy-of select="OriginAddress"/>
			 <xsl:copy-of select="DestinationAddress"/>
			 <xsl:copy-of select="LoadShipments"/>
			 <xsl:copy-of select="LoadStops"/>
			 <xsl:copy-of select="Containers"/>
			 <xsl:copy-of select="Carrier"/>
			 <xsl:copy-of select="Instructions"/>
			 <xsl:copy-of select="LabelFormat"/>
			 <xsl:copy-of select="VICSBOLData"/>
	  </Load>
	 </LoadList>
	 </xsl:template>
</xsl:stylesheet>