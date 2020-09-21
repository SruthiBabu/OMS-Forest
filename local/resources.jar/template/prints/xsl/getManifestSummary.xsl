<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
<xsl:template match="/Manifest">
    
	<Manifest>
        <xsl:for-each select="@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
        <xsl:copy-of select="ShipNode"/>          
		<Shipments>
		<xsl:for-each select="Shipments/Shipment">
		     <Shipment>
				    <xsl:copy-of select="@*"/>  
			        <xsl:copy-of select="ToAddress"/>  
			        <xsl:copy-of select="ShipNode"/>                
			        <xsl:copy-of select="ShipmentLines"/>         
			        <xsl:copy-of select="Containers"/>		
			</Shipment>
		</xsl:for-each>
		</Shipments>
		<ManifestSummary>
		    <xsl:copy-of select="ManifestSummary/@*"/>  
<!--		<xsl:attribute name="TotalPackages"><xsl:value-of select="$totalPackages"/></xsl:attribute>		
		<xsl:attribute name="OneDayPackages"><xsl:value-of select="count(Shipments/Shipment/Containers/Container[@ParentContainerKey=&quot;&quot; and @CarrierServiceCode=&quot;UPSND&quot;])"/></xsl:attribute>		
		<xsl:attribute name="TwoDayPackages"><xsl:value-of select="count(Shipments/Shipment/Containers/Container[@ParentContainerKey=&quot;&quot; and @CarrierServiceCode=&quot;UPS2nd&quot;])"/></xsl:attribute>		
		<xsl:attribute name="ThreeDayPackages"><xsl:value-of select="count(Shipments/Shipment/Containers/Container[@ParentContainerKey=&quot;&quot; and @CarrierServiceCode=&quot;UPS3Day&quot;])"/></xsl:attribute>		
		<xsl:attribute name="InternationalPackages"><xsl:value-of select="count(Shipments/Shipment/Containers/Container[@ParentContainerKey=&quot;&quot; and @CarrierServiceCode=&quot;INTL&quot;])"/></xsl:attribute>		
		<xsl:attribute name="CODPackages"><xsl:value-of select="count(Shipments/Shipment/Containers/Container[@ParentContainerKey=&quot;&quot; and SpecialServices/SpecialService/@SpecialServiceCode =&quot;TAGLESSCOD&quot;])"/></xsl:attribute>		-->
        </ManifestSummary>        
    </Manifest>
    </xsl:template>

</xsl:stylesheet> 
    


