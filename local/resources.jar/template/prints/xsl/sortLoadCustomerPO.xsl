<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    sortLoadCustomerPO.xsl
    Created on  October 22, 2003
    Author      vinayb
    Description
         Sorting the containers based on the CustomerPONo for the Commodities within the Load.
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
        <xsl:copy-of select="Carrier"/> 
		<xsl:copy-of select="Instructions"/> 
        <xsl:copy-of select="LoadStops"/>
        <AllLoadContainers>      
            <xsl:for-each select="AllLoadContainers/LoadContainer">
            <LoadContainer>
                <xsl:variable name="CurrentContainerKey">
                    <xsl:value-of select="@ShipmentContainerKey"/>
                </xsl:variable>
		<xsl:choose>
			<xsl:when test="not(@ActualWeight) or @ActualWeight = &quot;&quot; or number(@ActualWeight) = 0">
				<xsl:attribute name="ActualWeight"><xsl:value-of select="@ContainerGrossWeight"/></xsl:attribute>
				<xsl:attribute name="ActualWeightUOM"><xsl:value-of select="@ContainerGrossWeightUOM"/></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
					<xsl:attribute name="ActualWeight"><xsl:value-of select="@ActualWeight"/></xsl:attribute>
					<xsl:attribute name="ActualWeightUOM"><xsl:value-of select="@ActualWeightUOM"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
               <xsl:for-each select="@*">
			<xsl:if test="not(name() = &quot;ActualWeight&quot;)">	
	                    <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
			</xsl:if>
               </xsl:for-each>                
                   <ContainerDetails>
                        <xsl:for-each select="ContainerDetails/ContainerDetail">
		                       <xsl:sort select="ShipmentLine/OrderLine/@CustomerPONo" order="descending" data-type="text" />
                               <ContainerDetail>                          
                                   <xsl:for-each select="@*">
                                       <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                                   </xsl:for-each>    
                                   <ShipmentLine>
                                        <xsl:copy-of select="ShipmentLine/@*"/>
                                         <OrderLine>
						<xsl:if  test="not(ShipmentLine/OrderLine/@CustomerPONo)">
							<xsl:attribute name="CustomerPONo"/>
						</xsl:if>
					     <xsl:copy-of select="ShipmentLine/OrderLine/@*"/>
                                              <Item>
						<xsl:if  test="not(ShipmentLine/OrderLine/Item/@NMFCCode)">
							<xsl:attribute name="NMFCCode"/>
						</xsl:if>
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

