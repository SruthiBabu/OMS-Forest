<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    sortShipmentNMFCode.xsl
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
        <xsl:for-each select="Shipment/@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
        <xsl:copy-of select="Shipment/ToAddress"/>  
        <xsl:copy-of select="Shipment/ShipNode"/>                
        <xsl:copy-of select="Shipment/ShipmentLines"/>  
        <xsl:copy-of select="Shipment/VICSBOLData"/>    
        <xsl:copy-of select="Shipment/Carrier"/>   
		<xsl:copy-of select="Shipment/BillingInformation"/>  
		<xsl:copy-of select="Shipment/MarkForAddress"/>  
		<xsl:copy-of select="Shipment/Instructions"/>
		<xsl:copy-of select="Shipment/LoadShipments"/> 
        <Containers>      
            <xsl:for-each select="//Container">
            <Container>
                <xsl:variable name="CurrentContainerKey">
                    <xsl:value-of select="@ShipmentContainerKey"/>
                </xsl:variable>
               <xsl:for-each select="@*">
                    <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
               </xsl:for-each>  
                <xsl:attribute name="TotalCrtns"><xsl:value-of select="count(//Container[@ParentContainerKey=$CurrentContainerKey or (@ShipmentContainerKey=$CurrentContainerKey and @ContainerType=&quot;Case&quot;)])"/></xsl:attribute>                			   
                   <ContainerDetails>
                        <xsl:for-each select="ContainerDetails/ContainerDetail">
                               <xsl:sort select="ShipmentLine/OrderLine/Item/@NMFCCode" order="descending" data-type="text" />
                               <ContainerDetail>                          
                                   <xsl:for-each select="@*">
                                       <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                                   </xsl:for-each>    
                                   <ShipmentLine>
                                        <xsl:copy-of select="ShipmentLine/@*"/>
                                        <xsl:copy-of select="ShipmentLine/Order"/>
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
                 </Container>    
            </xsl:for-each>
           </Containers> 
        </Shipment>
    </xsl:template>

</xsl:stylesheet> 
