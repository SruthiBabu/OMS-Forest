<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->

<!--
    Document    getShipmentBOLData_Carrier.xsl
    Created on  October 22, 2003
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
		<xsl:if test="Shipment/LoadShipments/LoadShipment/Load/@MultipleLoadStop = &quot;Y&quot;">
            <xsl:attribute name="BolInstruction">Master Bill Of Lading Number:<xsl:value-of select="Shipment/LoadShipments/LoadShipment/Load/@BolNo"/></xsl:attribute>    
	    </xsl:if>  
        <xsl:for-each select="Shipment/@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
        <xsl:copy-of select="Shipment/ToAddress"/>  
        <xsl:copy-of select="Shipment/ShipNode"/>                
        <xsl:copy-of select="Shipment/ShipmentLines"/>         
        <xsl:copy-of select="Shipment/Containers"/> 
        <xsl:copy-of select="Shipment/Carrier"/>  
		<xsl:copy-of select="Shipment/Instructions"/>  
		<xsl:copy-of select="Shipment/MarkForAddress"/>  
		<xsl:copy-of select="Shipment/BillingInformation"/>  		
		<xsl:copy-of select="Shipment/LoadShipments"/> 
      <VICSBOLData>
        <xsl:copy-of select="Shipment/VICSBOLData/@*"/>
        <xsl:copy-of select="Shipment/VICSBOLData/CustomerOrderInfoList"/>
	<xsl:copy-of select="Shipment/VICSBOLData/ThirdPartyBillTo"/>
       <CommodityList>  
        <xsl:variable name="unique-NMFCCode" select="/Shipment/Containers/Container[not(ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=preceding-sibling::Shipment/Containers/Container/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode)]"/>
       <xsl:for-each select="$unique-NMFCCode">
             <xsl:variable name="CurrentNMFCCode">
                <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode"/>
            </xsl:variable>          
            <xsl:variable name="first-pallet"
                select="//Container[(@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;)) and @ContainerType='Pallet' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and not(@IsHazmat='Y')][1]"/>
	     <xsl:variable name="first-hazard-pallet"
                select="//Container[(@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;)) and @ContainerType='Pallet' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and (@IsHazmat='Y')][1]"/>
            <xsl:variable name="Total-Pallet-Crtns"
                select="sum(//Container[(@ParentContainerKey=&quot;&quot;  and @ContainerType='Pallet' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode)]/@TotalCrtns)"/>
            <xsl:variable name="first-case"
                select="//Container[(@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;)) and @ContainerType='Case' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and not(@IsHazmat='Y')][1]"/>		 
	     <xsl:variable name="first-hazard-case"
                select="//Container[(@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;)) and @ContainerType='Case' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and (@IsHazmat='Y')][1]"/>		 
	   
            <xsl:variable name="Total-Case-Crtns"
                select="sum(//Container[(@ParentContainerKey=&quot;&quot;  and @ContainerType='Case' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode)]/@TotalCrtns)"/>
            <xsl:variable name="CurrentContainerKey">
                <xsl:value-of select="@ShipmentContainerKey"/>
            </xsl:variable>
             <xsl:choose>
                <xsl:when test="generate-id(.) = generate-id($first-pallet)">
                <Commodity>
                    <xsl:attribute name="NMFCCode">
                        <xsl:value-of select="ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode"/>
                    </xsl:attribute>                 
                    <xsl:attribute name="NMFCClass">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCClass"/>
                    </xsl:attribute>
		    <xsl:choose>
			<xsl:when test="ContainerDetails/ContainerDetail/ShipmentLine/@IsHazmat = 'Y'">
				<xsl:attribute name="HazardousMaterial">
					<xsl:text>X</xsl:text>
                                </xsl:attribute>
				<xsl:attribute name="NMFCDescription">
					<xsl:text>See attached Hazmat sheet</xsl:text>
				</xsl:attribute> 
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:attribute name="NMFCDescription">
		                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCDescription"/>
				</xsl:attribute> 
			</xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="UnitQty">
                         <xsl:value-of select="count(//Container[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Pallet&quot; and not(@IsHazmat='Y')])"/>
                    </xsl:attribute>
                    <xsl:attribute name="UnitType">
                         <xsl:text>plts</xsl:text>
                    </xsl:attribute>              
                    <xsl:attribute name="Packages">
                         <xsl:value-of select="$Total-Pallet-Crtns"/>
                    </xsl:attribute>					
<!--                    <xsl:attribute name="Packages">
                         <xsl:value-of select="count(//Container[@ParentContainerKey=$CurrentContainerKey and @ContainerType=&quot;Case&quot;])"/>
                    </xsl:attribute>-->
                    <xsl:attribute name="PackageType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute>   
		    <xsl:attribute name="Weight">
			<xsl:value-of select="sum(//Container[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Pallet&quot;and not(@IsHazmat=&quot;Y&quot;)]/@ActualWeight)"/>
		    </xsl:attribute>
		    <xsl:attribute name="WeightUOM">
                         <xsl:value-of select="@ActualWeightUOM"/>
                    </xsl:attribute>                      
                  </Commodity>      
                </xsl:when>
                 <xsl:when test="generate-id(.) = generate-id($first-hazard-pallet)">
                <Commodity>
                    <xsl:attribute name="NMFCCode">
                        <xsl:value-of select="ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode"/>
                    </xsl:attribute>                 
                    <xsl:attribute name="NMFCClass">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCClass"/>
                    </xsl:attribute>
		    <xsl:choose>
			<xsl:when test="ContainerDetails/ContainerDetail/ShipmentLine/@IsHazmat = 'Y'">
				<xsl:attribute name="HazardousMaterial">
					<xsl:text>X</xsl:text>
                                </xsl:attribute>
				<xsl:attribute name="NMFCDescription">
					<xsl:text>See attached Hazmat sheet</xsl:text>
				</xsl:attribute> 
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:attribute name="NMFCDescription">
		                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCDescription"/>
				</xsl:attribute> 
			</xsl:otherwise>
                    </xsl:choose>
                    <xsl:attribute name="UnitQty">
                         <xsl:value-of select="count(//Container[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Pallet&quot; and @IsHazmat=&quot;Y&quot;])"/>
                    </xsl:attribute>
                    <xsl:attribute name="UnitType">
                         <xsl:text>plts</xsl:text>
                    </xsl:attribute>              
                    <xsl:attribute name="Packages">
                         <xsl:value-of select="$Total-Pallet-Crtns"/>
                    </xsl:attribute>					
<!--                    <xsl:attribute name="Packages">
                         <xsl:value-of select="count(//Container[@ParentContainerKey=$CurrentContainerKey and @ContainerType=&quot;Case&quot;])"/>
                    </xsl:attribute>-->
                    <xsl:attribute name="PackageType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute>   
		    <xsl:attribute name="Weight">
			<xsl:value-of select="sum(//Container[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Pallet&quot;and (@IsHazmat=&quot;Y&quot;)]/@ActualWeight)"/>
		    </xsl:attribute>
		    <xsl:attribute name="WeightUOM">
                         <xsl:value-of select="@ActualWeightUOM"/>
                    </xsl:attribute>                      
                  </Commodity>      
                </xsl:when>

                <xsl:when test="generate-id(.) = generate-id($first-case)">
                <Commodity>
                    <xsl:attribute name="NMFCCode">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode"/>
                    </xsl:attribute>                 
                    <xsl:attribute name="NMFCClass">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCClass"/>
                    </xsl:attribute>                        
                    <xsl:choose>
			<xsl:when test="ContainerDetails/ContainerDetail/ShipmentLine/@IsHazmat = 'Y'">
				<xsl:attribute name="HazardousMaterial">
					<xsl:text>X</xsl:text>
                                </xsl:attribute>
				<xsl:attribute name="NMFCDescription">
					<xsl:text>See attached Hazmat sheet</xsl:text>
				</xsl:attribute> 
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:attribute name="NMFCDescription">
		                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCDescription"/>
				</xsl:attribute> 
			</xsl:otherwise>
                    </xsl:choose>
		    <xsl:attribute name="UnitQty">
                         <xsl:value-of select="count(/Shipment/Containers/Container[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and (@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;))and not(@IsHazmat='Y')])"/>
                    </xsl:attribute>
                    <xsl:attribute name="UnitType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute>                    
                    <xsl:attribute name="Packages">
                         <xsl:value-of select="count(/Shipment/Containers/Container[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and (@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;)) and not(@IsHazmat='Y')])"/>
                    </xsl:attribute>
                     <!--<xsl:attribute name="Packages">
                         <xsl:value-of select="$Total-Case-Crtns"/>
                    </xsl:attribute>-->
                    <xsl:attribute name="PackageType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute>                    
                    <xsl:attribute name="Weight">
                        <xsl:value-of select="sum(//Container[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and (@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;))and not(@IsHazmat=&quot;Y&quot;)]/@ActualWeight)"/>
                    </xsl:attribute>
                    <xsl:attribute name="WeightUOM">
                         <xsl:value-of select="@ActualWeightUOM"/>
                    </xsl:attribute>                      
                  </Commodity>  
                </xsl:when>
		<xsl:when test="generate-id(.) = generate-id($first-hazard-case)">
                <Commodity>
                    <xsl:attribute name="NMFCCode">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode"/>
                    </xsl:attribute>                 
                    <xsl:attribute name="NMFCClass">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCClass"/>
                    </xsl:attribute>                        
                    <xsl:choose>
			<xsl:when test="ContainerDetails/ContainerDetail/ShipmentLine/@IsHazmat = 'Y'">
				<xsl:attribute name="HazardousMaterial">
					<xsl:text>X</xsl:text>
                                </xsl:attribute>
				<xsl:attribute name="NMFCDescription">
					<xsl:text>See attached Hazmat sheet</xsl:text>
				</xsl:attribute> 
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:attribute name="NMFCDescription">
		                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCDescription"/>
				</xsl:attribute> 
			</xsl:otherwise>
                    </xsl:choose>
		    <xsl:attribute name="UnitQty">
                         <xsl:value-of select="count(/Shipment/Containers/Container[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and (@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;))and @IsHazmat=&quot;Y&quot;])"/>
                    </xsl:attribute>
                    <xsl:attribute name="UnitType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute>                    
                    <xsl:attribute name="Packages">
                         <xsl:value-of select="count(/Shipment/Containers/Container[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and (@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;)) and @IsHazmat=&quot;Y&quot;])"/>
                    </xsl:attribute>
                     <!--<xsl:attribute name="Packages">
                         <xsl:value-of select="$Total-Case-Crtns"/>
                    </xsl:attribute>-->
                    <xsl:attribute name="PackageType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute>                    
                    <xsl:attribute name="Weight">
                        <xsl:value-of select="sum(//Container[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and (@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;)) and(@IsHazmat=&quot;Y&quot;)]/@ActualWeight)"/>
                    </xsl:attribute>
                    <xsl:attribute name="WeightUOM">
                         <xsl:value-of select="@ActualWeightUOM"/>
                    </xsl:attribute>                      
                  </Commodity>  
                </xsl:when>
             </xsl:choose>   
        </xsl:for-each>
        </CommodityList> 
    </VICSBOLData>
  </Shipment>
 </xsl:template>
</xsl:stylesheet> 
    



