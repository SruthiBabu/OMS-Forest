<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->

<!--
    Document    determineShipmentBOLFormat.xsl
    Created on  October 19, 2003
    Author      vinayb
    Description
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes"/>

    <!-- template rule matching source root element -->
    <xsl:template match="/Shipment">
        <Shipment>
                <!--<xsl:copy-of select="@*"/>-->
                <xsl:variable name="modifiedScac">
                    <xsl:choose>
                        <xsl:when test="string-length(@Scac) = 1">
                            <xsl:value-of select="concat(@Scac,'---')"/>  
                        </xsl:when>
                        <xsl:when test="string-length(@Scac) = 2">
                            <xsl:value-of select="concat(@Scac,'--')"/>  
                        </xsl:when>
                        <xsl:when test="string-length(@Scac) = 3">
                            <xsl:value-of select="concat(@Scac,'-')"/>  
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@Scac"/>  
                        </xsl:otherwise>                            
                    </xsl:choose>
                </xsl:variable>
                <xsl:for-each select="@*">
                    <xsl:if test="name() = &quot;Scac&quot;">
                        <xsl:attribute name="{name()}"><xsl:value-of select="$modifiedScac"/></xsl:attribute>
                    </xsl:if>    
                    <xsl:if test="not(name() = &quot;Scac&quot;)">
                        <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                    </xsl:if>    
                    <xsl:if test="not(name() = &quot;Scac&quot;)">
                        <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                    </xsl:if>                        
                </xsl:for-each>
                
                <xsl:copy-of select="ToAddress"/>
                <xsl:copy-of select="ShipNode"/>
                <xsl:copy-of select="ShipmentLines"/>
                <xsl:copy-of select="Containers"/>
                <xsl:copy-of select="Carrier"/>				
		<xsl:copy-of select="BillingInformation"/>  
		<xsl:copy-of select="MarkForAddress"/>
		<xsl:copy-of select="LoadShipments"/>

				<Instructions>
					<xsl:for-each select="Instructions/Instruction">
						<Instruction>						 
							<xsl:copy-of select="@*"/>						      
							<xsl:variable name="Instruction">
								<xsl:value-of select="@InstructionText"/>					
							</xsl:variable>	
							<xsl:variable name="Instruction1">
						<xsl:value-of select="normalize-space($Instruction)"/>
						</xsl:variable>
							<xsl:attribute name="InstructionText">
								<xsl:value-of select="$Instruction1"/>
							</xsl:attribute>
						</Instruction>					
					</xsl:for-each>
				</Instructions>

        <xsl:variable name="noOfOrders">
            <xsl:value-of select="count(VICSBOLData/CustomerOrderInfoList/CustomerOrderInfo)"/>
        </xsl:variable> 
        <xsl:variable name="noOfCommodity">
            <xsl:value-of select="count(VICSBOLData/CommodityList/Commodity)"/>
        </xsl:variable> 
        <LabelFormat>
        <xsl:attribute name="LabelFormatId">
            <xsl:if test="number($noOfOrders) &gt; 5 and number($noOfCommodity) &gt; 5">VICSBOL_SHIPMENT_SUPPLEMENT</xsl:if>    
            <xsl:if test="number($noOfOrders) &gt; 5 and number($noOfCommodity) &lt; 5">VICSBOL_SHIPMENT_CUSTOMER_SUPPLEMENT</xsl:if>    
            <xsl:if test="number($noOfOrders) &lt; 5 and number($noOfCommodity) &gt; 5">VICSBOL_SHIPMENT_CARRIER_SUPPLEMENT</xsl:if>            
            <xsl:if test="number($noOfOrders) &lt; 5 and number($noOfCommodity) &lt; 5">VICSBOL_SHIPMENT</xsl:if>      
          </xsl:attribute>   
        </LabelFormat>
        <VICSBOLData>
            <xsl:copy-of select="VICSBOLData/@*"/>
            <CustomerOrderInfoList>
                <xsl:attribute name="TotalPackages"><xsl:value-of select="sum(VICSBOLData/CustomerOrderInfoList/CustomerOrderInfo/@Packages)"/></xsl:attribute>
                <xsl:attribute name="TotalWeight"><xsl:value-of select="sum(VICSBOLData/CustomerOrderInfoList/CustomerOrderInfo/@Weight)"/></xsl:attribute>
                <xsl:for-each select="VICSBOLData/CustomerOrderInfoList/CustomerOrderInfo">
                    <CustomerOrderInfo>
                       <!-- <xsl:if test="@PalletId">
                            <xsl:attribute name="AdditionalInfo"><xsl:value-of select="@PalletId"/></xsl:attribute>
                        </xsl:if>-->                    
                        <xsl:copy-of select="@*"/>   
                    </CustomerOrderInfo>
                </xsl:for-each>
            </CustomerOrderInfoList>
            <CommodityList>
                <xsl:attribute name="TotalPackages"><xsl:value-of select="sum(VICSBOLData/CommodityList/Commodity/@Packages)"/></xsl:attribute>
                <xsl:attribute name="TotalWeight"><xsl:value-of select="sum(VICSBOLData/CommodityList/Commodity/@Weight)"/></xsl:attribute>
                <xsl:attribute name="TotalUnits"><xsl:value-of select="sum(VICSBOLData/CommodityList/Commodity/@UnitQty)"/></xsl:attribute>                
                <xsl:copy-of select="VICSBOLData/CommodityList/Commodity"/>   
           </CommodityList>     
	   <xsl:copy-of select="VICSBOLData/ThirdPartyBillTo"/>
        </VICSBOLData>
       </Shipment> 
    </xsl:template>
</xsl:stylesheet> 
