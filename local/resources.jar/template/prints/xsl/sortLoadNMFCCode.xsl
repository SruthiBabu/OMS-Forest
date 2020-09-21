<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    sortLoadNMFCCode.xsl
    Created on  October 22, 2003
    Author      vinayb
    Description
        Sorting the containers based on the NMFCCodes for the Commodities within the Load.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
    <xsl:template match="/Load">
      <Load>
        <xsl:for-each select="@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
        <xsl:copy-of select="OriginAddress"/>  
        <xsl:copy-of select="DestinationAddress"/>          
        <xsl:copy-of select="LoadContainers"/>
        <xsl:copy-of select="LoadShipments"/> 
		<xsl:copy-of select="Instructions"/>
		<xsl:copy-of select="Carrier"/> 
        <xsl:copy-of select="VICSBOLData"/>         
        <xsl:copy-of select="LoadStops"/>
        <AllLoadContainers>      
            <xsl:for-each select="AllLoadContainers/LoadContainer">
            <LoadContainer>
                <xsl:variable name="CurrentContainerKey">
                    <xsl:value-of select="@ShipmentContainerKey"/>
                </xsl:variable>
               <xsl:for-each select="@*">
                    <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
               </xsl:for-each>  
                <xsl:attribute name="TotalCrtns"><xsl:value-of select="count(//LoadContainer[@ParentContainerKey=$CurrentContainerKey])"/></xsl:attribute>                
                   <ContainerDetails>
                        <xsl:for-each select="ContainerDetails/ContainerDetail">
                               <xsl:sort select="ShipmentLine/OrderLine/Item/@NMFCCode" order="descending" data-type="text" />
                               <ContainerDetail>                          
                                   <xsl:for-each select="@*">
                                       <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                                   </xsl:for-each>    
                                   <ShipmentLine>
                                        <xsl:copy-of select="ShipmentLine/@*"/>
                                         <OrderLine>
                                             <xsl:copy-of select="ShipmentLine/OrderLine/@*"/>
                                              <Item>
                                                 <xsl:copy-of select="ShipmentLine/OrderLine/Item/@*"/>
                                             </Item> 
                                         </OrderLine>
                                       </ShipmentLine>    
                                   </ContainerDetail>
                         </xsl:for-each>
                     </ContainerDetails>
                 </LoadContainer>    
            </xsl:for-each>
           </AllLoadContainers> 
        </Load>
    </xsl:template>
</xsl:stylesheet> 