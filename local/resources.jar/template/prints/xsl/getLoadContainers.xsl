<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    getLoadContainers.xsl
    Created on  October 18, 2003
    Author      vinayb
    Description
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >


    <!-- template rule matching source root element -->
    <xsl:output indent="yes"/>
    <xsl:template match="/Load">
       <Load>
        <xsl:for-each select="@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
        <xsl:copy-of select="LoadContainers"/>
        <xsl:copy-of select="LoadShipments"/>   
       <xsl:copy-of select="OriginAddress"/>
        <xsl:copy-of select="DestinationAddress"/>
        <xsl:copy-of select="Carrier"/>   
		<xsl:copy-of select="Instructions"/>
        <xsl:copy-of select="LoadStops"/>
      <AllLoadContainers>
        <xsl:for-each select="LoadContainers/Container">
            <LoadContainer>
                <xsl:for-each select="@*">
                    <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                </xsl:for-each>     
                <xsl:copy-of select="ContainerDetails"/>                
            </LoadContainer>    
        </xsl:for-each>
        <xsl:for-each select="LoadShipments/LoadShipment/Shipment">
			<xsl:for-each select="Containers/Container">
	            <LoadContainer>
		            <xsl:for-each select="@*">
			            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
				    </xsl:for-each>     
					<xsl:copy-of select="ContainerDetails"/>                
	            </LoadContainer>  
			</xsl:for-each>
        </xsl:for-each>        
      </AllLoadContainers>
      </Load>
    </xsl:template>

</xsl:stylesheet> 
