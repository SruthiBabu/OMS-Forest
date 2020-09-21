<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    getShipmentBOLData.xsl
    Created on  October 8, 2003
	Author      vinayb
    Description
        Purpose of transformation follows.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
    <xsl:template match="/">
        <Shipment>
        <xsl:for-each select="Shipment/@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
        <xsl:copy-of select="Shipment/ToAddress"/>  
        <xsl:copy-of select="Shipment/ShipNode"/>                
        <xsl:copy-of select="Shipment/ShipmentLines"/> 
		<xsl:copy-of select="Shipment/LoadShipments"/> 
        <xsl:copy-of select="Shipment/Containers"/>  
        <xsl:copy-of select="Shipment/Carrier"/>  
		<xsl:copy-of select="Shipment/Instructions"/>  
		<xsl:copy-of select="Shipment/MarkForAddress"/>  
		<xsl:copy-of select="Shipment/BillingInformation"/>  
      <VICSBOLData>
	     <xsl:choose>
		    <xsl:when test="Shipment/BillingInformation/@ShipmentChargeType='PREPAID'">
			    <xsl:attribute name="Prepaid"><xsl:text>X</xsl:text></xsl:attribute>
	        </xsl:when>
		    <xsl:when test="Shipment/BillingInformation/@ShipmentChargeType='COLLECT'">
			    <xsl:attribute name="Collect"><xsl:text>X</xsl:text></xsl:attribute>
	        </xsl:when>
		  </xsl:choose>
		<xsl:attribute name="TrailerLoadedByShipper"><xsl:text>X</xsl:text></xsl:attribute>
        <xsl:attribute name="FreightCountedByPallets"/>
        <xsl:attribute name="FreightCountedByPieces"><xsl:text>X</xsl:text></xsl:attribute>       
        <!-- This code has to be modified to obtain FreighTerms from getShipmentDetails -->
        <xsl:choose>
            <xsl:when test="Shipment/BillingInformation/@ChargesPaidBy='SHIPPER'">
                <xsl:attribute name="FromFOB"/>
                <xsl:attribute name="ToFOB"><xsl:text>X</xsl:text></xsl:attribute>
            </xsl:when>
            <xsl:when test="Shipment/BillingInformation/@ChargesPaidBy='BUYER'">
                <xsl:attribute name="FromFOB"><xsl:text>X</xsl:text></xsl:attribute>
                <xsl:attribute name="ToFOB"/>
            </xsl:when>
        </xsl:choose>
       <xsl:if test="//Container[@ParentContainerKey=&quot;&quot; and @ContainerType=&quot;Pallet&quot;]">
            <xsl:attribute name="FreightCountedByPallets"><xsl:text>X</xsl:text></xsl:attribute>
            <xsl:attribute name="FreightCountedByPieces"/>
       </xsl:if>
        <xsl:if test="Shipment/BillingInformation/@ShipmentChargeType=&quot;THIRDPARTY&quot;">
            <xsl:attribute name="ThirdParty"><xsl:text>X</xsl:text></xsl:attribute>
            <ThirdPartyBillTo>
                <xsl:attribute name="BillToName"><xsl:value-of select="concat(Shipment/BillingInformation/AlternateParty/@FirstName ,' ',substring(Shipment/BillingInformation/AlternateParty/@MiddleName,1,1),' ',Shipment/BillingInformation/AlternateParty/@LastName)"/></xsl:attribute>  
                <xsl:attribute name="Company"><xsl:value-of select="Shipment/BillingInformation/AlternateParty/@Company"/></xsl:attribute>    
                <xsl:attribute name="AddressLine1"><xsl:value-of select="Shipment/BillingInformation/AlternateParty/@AddressLine1"/></xsl:attribute>    
                <xsl:attribute name="City"><xsl:value-of select="Shipment/BillingInformation/AlternateParty/@City"/></xsl:attribute>
                <xsl:attribute name="State"><xsl:value-of select="Shipment/BillingInformation/AlternateParty/@State"/></xsl:attribute>                                                                                        
                <xsl:attribute name="ZipCode"><xsl:value-of select="Shipment/BillingInformation/AlternateParty/@ZipCode"/></xsl:attribute>                                                    
            </ThirdPartyBillTo>    
       </xsl:if>        
       <xsl:variable name="unique-CustomerPO" select="//Container[not(@ShipmentContainerKey=preceding-sibling::Shipment/Containers/Container/@ShipmentContainerKey) and not(ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo=preceding-sibling::Shipment/Containers/Container/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo)]"/>
       <CustomerOrderInfoList>  
       <xsl:for-each select="$unique-CustomerPO">
           <xsl:variable name="CurrentCustomerPONo">
                <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo"/>
            </xsl:variable> 
            <xsl:variable name="first-case"
                  select="//Container[(@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;)) and @ContainerType='Case' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo=$CurrentCustomerPONo][1]"/>
             <xsl:variable name="CurrentContainerKey">
                <xsl:value-of select="@ShipmentContainerKey"/>
            </xsl:variable>
           <xsl:variable name="CurrentContainerNo">
                <xsl:value-of select="@ContainerNo"/>
            </xsl:variable>            
             <xsl:choose>
                <xsl:when test="(@ParentContainerKey=&quot;&quot; or not( @ParentContainerGroup=&quot;SHIPMENT&quot;)) and @ContainerType = &quot;Pallet&quot;">
                  <CustomerOrderInfo>  
                    <xsl:attribute name="CustomerPONo">
                        <xsl:value-of select="$CurrentCustomerPONo"/> 
                    </xsl:attribute> 
                    <xsl:attribute name="Packages">
                         <xsl:value-of select="count(/Shipment/Containers/Container[@ParentContainerKey=$CurrentContainerKey and @ContainerType=&quot;Case&quot;])"/>
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
                         <xsl:value-of select="count(//Container[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/@CustomerPONo=$CurrentCustomerPONo and @ContainerType=&quot;Case&quot; and (@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;))])"/>
                    </xsl:attribute>
                    <xsl:attribute name="Pallet">
                        <xsl:text>N</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="AdditionalInfo"/>
                    <xsl:attribute name="Weight">
                         <xsl:value-of select="sum(//Container[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/@CustomerPONo=$CurrentCustomerPONo  and @ContainerType=&quot;Case&quot; and (@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;))]/@ActualWeight)"/>
                    </xsl:attribute>                
                    <xsl:attribute name="WeightUOM">
                         <xsl:value-of select="@ActualWeightUOM"/>
                    </xsl:attribute>                     
                  </CustomerOrderInfo>    
                </xsl:when>
             </xsl:choose> 
        </xsl:for-each>
        </CustomerOrderInfoList>
    </VICSBOLData>
    </Shipment>
    </xsl:template>

</xsl:stylesheet> 
    


