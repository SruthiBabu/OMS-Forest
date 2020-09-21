<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    getLoadBOLData.xsl
    Created on  October 17, 2003
    Author      vinayb
    Description
        Consolidates the Containers in the Load .
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
    <xsl:template name="customerPOList">
        <xsl:param name="uniqueCustomerPO"/>
        <xsl:for-each select="$uniqueCustomerPO">
           <xsl:variable name="CurrentCustomerPONo">
                <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo"/>
            </xsl:variable>       
        <xsl:variable name="first-case" select="/Load/AllLoadContainers/LoadContainer[(@ParentContainerKey=&quot;&quot; or (@LoadKey=&quot;&quot; and @ParentContainerGroup='INVENTORY') ) and @ContainerType='Case' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo=$CurrentCustomerPONo][1]"/>
           <xsl:variable name="CurrentContainerKey">
                <xsl:value-of select="@ShipmentContainerKey"/>
            </xsl:variable>
             <xsl:choose>
                <xsl:when test="(@ParentContainerKey=&quot;&quot; or (@LoadKey=&quot;&quot; and @ParentContainerGroup='INVENTORY')) and @ContainerType = &quot;Pallet&quot;">
                  <CustomerOrderInfo>  
                    <xsl:attribute name="CustomerPONo">
                        <xsl:value-of select="$CurrentCustomerPONo"/> 
                    </xsl:attribute> 
                    <xsl:attribute name="Packages">
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[@ParentContainerKey=$CurrentContainerKey ])"/>
                    </xsl:attribute>
                    <xsl:attribute name="Pallet">
                        <xsl:text>Y</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="PalletId">
                        <xsl:value-of select="@ContainerScm"/>
                    </xsl:attribute>  
                    <xsl:attribute name="AdditionalInfo">
                        <xsl:value-of select="@ContainerScm"/>
                    </xsl:attribute>  						
                    <xsl:attribute name="Weight">
                         <xsl:value-of select="sum(@ActualWeight)"/>
                    </xsl:attribute>
                    <xsl:attribute name="WeightUOM">
                         <xsl:value-of select="@ActualWeightUOM"/>
                    </xsl:attribute> 
                 </CustomerOrderInfo>       
                </xsl:when>
            <xsl:when test="generate-id(.) = generate-id($first-case)">
              <CustomerOrderInfo>  
                   <xsl:attribute name="CustomerPONo">
                        <xsl:value-of select="$CurrentCustomerPONo"/> 
                    </xsl:attribute> 
                    <xsl:attribute name="Packages">
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[@ContainerType=&quot;Case&quot; and @ParentContainerKey=&quot;&quot;  and ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/@CustomerPONo=$CurrentCustomerPONo])"/>
                    </xsl:attribute>
                    <xsl:attribute name="Pallet">
                        <xsl:text>N</xsl:text>
                    </xsl:attribute>
					<xsl:attribute name="AdditionalInfo"/>
                    <xsl:attribute name="Weight">
                         <xsl:value-of select="sum(/Load/AllLoadContainers/LoadContainer[@ContainerType=&quot;Case&quot; and @ParentContainerKey=&quot;&quot; and ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/@CustomerPONo=$CurrentCustomerPONo]/@ActualWeight)"/>
                    </xsl:attribute>  
                    <xsl:attribute name="WeightUOM">
                         <xsl:value-of select="@ActualWeightUOM"/>
                    </xsl:attribute> 					
                  </CustomerOrderInfo>    
                </xsl:when>
             </xsl:choose> 
        </xsl:for-each>        
    </xsl:template>
    <xsl:template match="/Load">
        <Load>
        <xsl:for-each select="@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
        <xsl:copy-of select="LoadContainers"/>
        <xsl:copy-of select="LoadShipments"/>   
        <xsl:copy-of select="LoadStops"/>
        <xsl:copy-of select="Carrier"/> 
        <xsl:copy-of select="OriginAddress"/>  
        <xsl:copy-of select="DestinationAddress"/>  		
        <xsl:copy-of select="AllLoadContainers"/>     
		<xsl:copy-of select="Instructions"/>
      <VICSBOLData>
       <xsl:choose>
        <xsl:when test="LoadShipments/LoadShipment/Shipment/BillingInformation/@ShipmentChargeType=&quot;PREPAID&quot;">
            <xsl:attribute name="Prepaid"><xsl:text>X</xsl:text></xsl:attribute>
        </xsl:when>
        <xsl:when test="LoadShipments/LoadShipment/Shipment/BillingInformation/@ShipmentChargeType='COLLECT'">
            <xsl:attribute name="Collect"><xsl:text>X</xsl:text></xsl:attribute>
        </xsl:when>
       </xsl:choose>
        <xsl:choose>
            <xsl:when test="LoadShipments/LoadShipment/Shipment/BillingInformation/@ChargesPaidBy='SHIPPER'">
                <xsl:attribute name="FromFOB"/>
                <xsl:attribute name="ToFOB"><xsl:text>X</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test="LoadShipments/LoadShipment/Shipment/BillingInformation/@ChargesPaidBy='BUYER'">
                <xsl:attribute name="FromFOB"><xsl:text>X</xsl:text></xsl:attribute>
                <xsl:attribute name="ToFOB"/>
            </xsl:when>
        </xsl:choose>
       <xsl:attribute name="TrailerLoadedByShipper"><xsl:text>X</xsl:text></xsl:attribute>
        <xsl:attribute name="FreightCountedByPallets"/>
        <xsl:attribute name="FreightCountedByPieces"><xsl:text>X</xsl:text></xsl:attribute>       
        <xsl:if test="LoadShipments/LoadShipment/Shipment/BillingInformation/@ShipmentChargeType='THIRDPARTY'">
            <xsl:attribute name="ThirdParty"><xsl:text>X</xsl:text></xsl:attribute>
            <ThirdPartyBillTo>
	           <xsl:attribute name="BillToName"><xsl:value-of select="concat(LoadShipments/LoadShipment/Shipment/BillingInformation/AlternateParty/@FirstName ,' ',substring(LoadShipments/LoadShipment/Shipment/BillingInformation/AlternateParty/@MiddleName,1,1),' ',LoadShipments/LoadShipment/Shipment/BillingInformation/AlternateParty/@LastName)"/></xsl:attribute>  
               <xsl:attribute name="Company"><xsl:value-of select="LoadShipments/LoadShipment/Shipment/BillingInformation/AlternateParty/@Company"/></xsl:attribute>
               <xsl:attribute name="AddressLine1"><xsl:value-of select="LoadShipments/LoadShipment/Shipment/BillingInformation/AlternateParty/@AddressLine1"/></xsl:attribute>    
               <xsl:attribute name="City"><xsl:value-of select="LoadShipments/LoadShipment/Shipment/BillingInformation/AlternateParty/@City"/></xsl:attribute>
               <xsl:attribute name="State"><xsl:value-of select="LoadShipments/LoadShipment/Shipment/BillingInformation/AlternateParty/@State"/></xsl:attribute>                                                                                        
               <xsl:attribute name="ZipCode"><xsl:value-of select="LoadShipments/LoadShipment/Shipment/BillingInformation/AlternateParty/@ZipCode"/></xsl:attribute>                                                    
            </ThirdPartyBillTo>    
       </xsl:if>        
       <CustomerOrderInfoList>         
       <xsl:variable name="unique-Load-CustomerPO" select="AllLoadContainers/LoadContainer[not(ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo=preceding-sibling::Load/AllLoadContainers/LoadContainer/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo)]"/>
       <xsl:call-template name="customerPOList">
            <xsl:with-param name="uniqueCustomerPO" select="$unique-Load-CustomerPO"/>
       </xsl:call-template>     
        </CustomerOrderInfoList>
    </VICSBOLData>
    </Load>
    </xsl:template>

</xsl:stylesheet> 
