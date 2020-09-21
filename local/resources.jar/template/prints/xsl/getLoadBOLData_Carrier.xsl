<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    getLoadBOLData_Carrier.xsl
    Created on  October 22, 2003
    Author      vinayb
    Description
        Obtaining Data required for Printing Load BOL, Carrier Information Section.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
    <xsl:template name="commodityList">
    <xsl:param name="uniqueNMFCCode"/>
     
       <xsl:for-each select="$uniqueNMFCCode">
            <xsl:variable name="CurrentNMFCCode">
                <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode"/>
            </xsl:variable>
            <xsl:variable name="Total-Pallet-Crtns"
                select="sum(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and (@ParentContainerKey=&quot;&quot;  and @ContainerType='Pallet')]/@TotalCrtns)"/>
            <xsl:variable name="first-pallet"
                select="/Load/AllLoadContainers/LoadContainer[(@ParentContainerKey=&quot;&quot; or (@LoadKey=&quot;&quot; and @ParentContainerGroup='INVENTORY')) and @ContainerType='Pallet' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and not(@IsHazmat='Y')][1]"/>
            <xsl:variable name="first-hazard-pallet"
                select="/Load/AllLoadContainers/LoadContainer[(@ParentContainerKey=&quot;&quot; or (@LoadKey=&quot;&quot; and @ParentContainerGroup='INVENTORY')) and @ContainerType='Pallet' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @IsHazmat='Y'][1]"/>

            <xsl:variable name="Total-Case-Crtns"
                select="sum(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and (@ParentContainerKey=&quot;&quot;  and @ContainerType='Case')]/@TotalCrtns)"/>
            <xsl:variable name="first-case"
                select="/Load/AllLoadContainers/LoadContainer[(@ParentContainerKey=&quot;&quot; or (@LoadKey=&quot;&quot; and @ParentContainerGroup='INVENTORY')) and @ContainerType='Case' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and not(@IsHazmat='Y')][1]"/>
            <xsl:variable name="first-hazard-case"
                select="/Load/AllLoadContainers/LoadContainer[(@ParentContainerKey=&quot;&quot; or (@LoadKey=&quot;&quot; and @ParentContainerGroup='INVENTORY')) and @ContainerType='Case' and ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @IsHazmat='Y'][1]"/>

            <xsl:variable name="CurrentContainerKey">
                <xsl:value-of select="@ShipmentContainerKey"/>
            </xsl:variable>
             <xsl:choose>
                <xsl:when test="generate-id(.) = generate-id($first-pallet)">
                <Commodity>
                    <xsl:attribute name="NMFCCode">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode"/>
                    </xsl:attribute>    
                    <xsl:attribute name="NMFCClass">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCClass"/>
                    </xsl:attribute>                        
                     <xsl:choose>
			<xsl:when test="@IsHazmat = 'Y'">
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
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Pallet&quot; and not(@IsHazmat='Y')])"/>
                    </xsl:attribute>
                    <xsl:attribute name="UnitType">
                         <xsl:text>plts</xsl:text>
                    </xsl:attribute>                    
                    <!--<xsl:attribute name="Packages">
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ParentContainerKey=$CurrentContainerKey and not(@IsHazmat=&quot;Y&quot;)])"/>
                    </xsl:attribute>-->
                    <xsl:attribute name="Packages">
                         <xsl:value-of select="$Total-Pallet-Crtns"/>
                    </xsl:attribute>
                    <xsl:attribute name="PackageType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute> 
		    <!--<xsl:attribute name="Weight">
                         <xsl:value-of select="sum(@ActualWeight)"/>
                    </xsl:attribute>-->
		    <xsl:attribute name="Weight">
			<xsl:value-of select="sum(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Pallet&quot; and not(@IsHazmat='Y')]/@ActualWeight)"/>
	            </xsl:attribute>
		    <xsl:attribute name="WeightUOM">
                         <xsl:value-of select="@ActualWeightUOM"/>
                    </xsl:attribute> 
                  </Commodity>      
                </xsl:when>
		</xsl:choose>
		<xsl:choose>
                <xsl:when test="generate-id(.) = generate-id($first-hazard-pallet)">
                <Commodity>
                    <xsl:attribute name="NMFCCode">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode"/>
                    </xsl:attribute>    
                    <xsl:attribute name="NMFCClass">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCClass"/>
                    </xsl:attribute>                        
                     <xsl:choose>
			<xsl:when test="@IsHazmat = 'Y'">
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
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Pallet&quot; and @IsHazmat='Y'])"/>
                    </xsl:attribute>
                    <xsl:attribute name="UnitType">
                         <xsl:text>plts</xsl:text>
                    </xsl:attribute>                    
                    <!--<xsl:attribute name="Packages">
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ParentContainerKey=$CurrentContainerKey and @IsHazmat='Y'])"/>
                    </xsl:attribute>-->
                    <xsl:attribute name="Packages">
                         <xsl:value-of select="$Total-Pallet-Crtns"/>
                    </xsl:attribute>
                    <xsl:attribute name="PackageType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute> 
		    <!--<xsl:attribute name="Weight">
                         <xsl:value-of select="sum(@ActualWeight)"/>
                    </xsl:attribute>-->
		    <xsl:attribute name="Weight">
			<xsl:value-of select="sum(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Pallet&quot; and @IsHazmat='Y']/@ActualWeight)"/>
	            </xsl:attribute>
		    <xsl:attribute name="WeightUOM">
                         <xsl:value-of select="@ActualWeightUOM"/>
                    </xsl:attribute> 
                  </Commodity>      
                </xsl:when>
		</xsl:choose>
		<xsl:choose>
		<xsl:when test="generate-id(.) = generate-id($first-case)">
                <Commodity>
                    <xsl:attribute name="NMFCCode">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode"/>
                    </xsl:attribute> 
                    <xsl:attribute name="NMFCClass">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCClass"/>
                    </xsl:attribute>  
                     <xsl:choose>
			<xsl:when test="@IsHazmat = 'Y'">
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
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and @ParentContainerKey=&quot;&quot; and not(@IsHazmat='Y')])"/>
                    </xsl:attribute>
                    <xsl:attribute name="UnitType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute>                    
                    <!--<xsl:attribute name="Packages">
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and ( @ParentContainerKey=&quot;&quot; or @ParentContainerKey=$CurrentContainerKey)])"/>
                    </xsl:attribute>-->
                     <xsl:attribute name="Packages">
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and @ParentContainerKey=&quot;&quot; and not(@IsHazmat=&quot;Y&quot;)])"/>
                    </xsl:attribute>
                    <xsl:attribute name="PackageType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute>                    
                    <xsl:attribute name="Weight">
                         <xsl:value-of select="sum(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and  @ParentContainerKey=&quot;&quot; and not(@IsHazmat=&quot;Y&quot;)]/@ActualWeight)"/>
                    </xsl:attribute>
                    <xsl:attribute name="WeightUOM">
                         <xsl:value-of select="@ActualWeightUOM"/>
                    </xsl:attribute> 
                  </Commodity>  
                </xsl:when>
             </xsl:choose>   
		<xsl:choose>
		<xsl:when test="generate-id(.) = generate-id($first-hazard-case)">
                <Commodity>
                    <xsl:attribute name="NMFCCode">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode"/>
                    </xsl:attribute> 
                    <xsl:attribute name="NMFCClass">
                        <xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCClass"/>
                    </xsl:attribute>  
                     <xsl:choose>
			<xsl:when test="@IsHazmat = 'Y'">
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
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and @ParentContainerKey=&quot;&quot; and @IsHazmat=&quot;Y&quot;])"/>
                    </xsl:attribute>
                    <xsl:attribute name="UnitType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute>                    
                    <!--<xsl:attribute name="Packages">
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and ( @ParentContainerKey=&quot;&quot; or @ParentContainerKey=$CurrentContainerKey)])"/>
                    </xsl:attribute>-->
                     <xsl:attribute name="Packages">
                         <xsl:value-of select="count(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and @ParentContainerKey=&quot;&quot; and @IsHazmat=&quot;Y&quot;])"/>
                    </xsl:attribute>
                    <xsl:attribute name="PackageType">
                         <xsl:text>ctns</xsl:text>
                    </xsl:attribute>                    
                    <xsl:attribute name="Weight">
                         <xsl:value-of select="sum(/Load/AllLoadContainers/LoadContainer[ContainerDetails/ContainerDetail[1]/ShipmentLine/OrderLine/Item/@NMFCCode=$CurrentNMFCCode and @ContainerType=&quot;Case&quot; and  @ParentContainerKey=&quot;&quot; and @IsHazmat=&quot;Y&quot;]/@ActualWeight)"/>
                    </xsl:attribute>
                    <xsl:attribute name="WeightUOM">
                         <xsl:value-of select="@ActualWeightUOM"/>
                    </xsl:attribute> 
                  </Commodity>  
                </xsl:when>
             </xsl:choose>   
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="/Load">
        <Load>
        <xsl:for-each select="@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
        <xsl:variable name="underlyingBOL">
            <xsl:text>Underlying Bill Of Lading Numbers :</xsl:text>
            <xsl:for-each select="LoadShipments/LoadShipment[not(Shipment/@BolNo=&quot;&quot;)]">
                <xsl:value-of select="Shipment/@BolNo"/>
                <xsl:if test="position()!=last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="@MultipleLoadStop='Y'">
             <xsl:attribute name="BolInstruction"><xsl:value-of select="$underlyingBOL"/></xsl:attribute>        
        </xsl:if> 
        <xsl:copy-of select="LoadContainers"/>
        <xsl:copy-of select="LoadShipments"/>   
        <xsl:copy-of select="LoadStops"/>
        <xsl:copy-of select="Carrier"/> 
        <xsl:copy-of select="OriginAddress"/>  
        <xsl:copy-of select="DestinationAddress"/> 
		<xsl:copy-of select="Instructions"/>
      <VICSBOLData>
        <xsl:if test="@MultipleLoadStop='Y'">		
            <xsl:attribute name="IsMasterBOL">X</xsl:attribute>
        </xsl:if> 
        <xsl:copy-of select="VICSBOLData/@*"/>
        <xsl:copy-of select="VICSBOLData/CustomerOrderInfoList"/>
	<xsl:copy-of select="VICSBOLData/ThirdPartyBillTo"/>
       <CommodityList>  

       <!--getting two LoadContainers with unique NMFCCode. One for Hazmat and other for Non-Hazmat-->
        <xsl:variable name="unique-NMFCCode" select="AllLoadContainers/LoadContainer[not(ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode=preceding-sibling::Load/AllLoadContainers/LoadContainer/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode)]"/>
	
       <xsl:call-template name="commodityList">
            <xsl:with-param name="uniqueNMFCCode" select="$unique-NMFCCode"/>
       </xsl:call-template>
        </CommodityList>        
    </VICSBOLData>
    </Load>
    </xsl:template>
</xsl:stylesheet> 
