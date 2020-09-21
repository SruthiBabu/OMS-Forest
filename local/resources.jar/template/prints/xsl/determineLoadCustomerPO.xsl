<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    determineLoadCustomerPO.xsl
    Created on  October 22, 2003
    Author      vinayb
    Description
        Purpose of transformation follows.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
       xmlns:nodeset="org.apache.xalan.xslt.extensions.Nodeset"
    extension-element-prefixes="nodeset"
    exclude-result-prefixes="nodeset">
    <xsl:output indent="yes"/>
	<!-- Obtaining CustomerPONo by recursively traversing the child containers -->
    <xsl:template name="getCustomerPO">
        <xsl:param name="containerList"/>
        <xsl:param name="containerKey"/>    
        <xsl:variable name="childContainerList" select="$containerList[@ParentContainerKey=$containerKey]"/>
        <xsl:choose>
            <xsl:when test="$containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo != &quot;&quot;">
                <xsl:value-of select="$containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$childContainerList">
                    <xsl:variable name="currentContainerKey" select="@ShipmentContainerKey"/>
                    <xsl:choose>
                      <xsl:when test="$childContainerList[@ShipmentContainerKey=$currentContainerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo != &quot;&quot;">
                        <xsl:value-of select="$childContainerList[@ShipmentContainerKey=$currentContainerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/@CustomerPONo"/>
                      </xsl:when>
                      <xsl:otherwise>
                            <xsl:variable name="childCustomerPO">
                                <xsl:call-template name="getCustomerPO">
                                    <xsl:with-param name="containerList" select="//LoadContainer[@ParentContainerKey=$currentContainerKey or @ShipmentContainerKey=$currentContainerKey]"/>
                                    <xsl:with-param name="containerKey" select="$currentContainerKey"/>
                                </xsl:call-template>
                             </xsl:variable>
                              <xsl:value-of select="$childCustomerPO"/>   
                      </xsl:otherwise>
                   </xsl:choose>          
                </xsl:for-each>
              </xsl:otherwise>  
            </xsl:choose>
    </xsl:template>
	<!-- Obtaining NMFCCode by recursively traversing the child containers -->
    <xsl:template name="getNMFC">
        <xsl:param name="containerList"/>
        <xsl:param name="containerKey"/>    
        <xsl:variable name="childContainerList" select="$containerList[@ParentContainerKey=$containerKey]"/>
        <xsl:choose>
            <xsl:when test="$containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode != &quot;&quot;">
                <xsl:value-of select="concat($containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode,'|',$containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCClass,'|',$containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCDescription,';')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$childContainerList">
                    <xsl:variable name="currentContainerKey" select="@ShipmentContainerKey"/>
                    <xsl:choose>
                      <xsl:when test="$childContainerList[@ShipmentContainerKey=$currentContainerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode = &quot;&quot;">
                        <xsl:value-of select="concat($childContainerList[@ShipmentContainerKey=$currentContainerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCCode,'|',$childContainerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCClass,'|',$childContainerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/OrderLine/Item/@NMFCDescription)"/>
                      </xsl:when>
                      <xsl:otherwise>
                            <xsl:variable name="childNMFC">
                                <xsl:call-template name="getNMFC">
                                    <xsl:with-param name="containerList" select="//LoadContainer[@ParentContainerKey=$currentContainerKey or @ShipmentContainerKey=$currentContainerKey]"/>
                                    <xsl:with-param name="containerKey" select="$currentContainerKey"/>
                                </xsl:call-template>
                             </xsl:variable>
                              <xsl:value-of select="$childNMFC"/>
                      </xsl:otherwise>
                   </xsl:choose>          
                </xsl:for-each>
              </xsl:otherwise>  
            </xsl:choose>
    </xsl:template>    
    <!-- template rule matching source root element -->
    <xsl:template match="/Load">
      <Load>
        <xsl:for-each select="@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
        <xsl:copy-of select="OriginAddress"/>  
        <xsl:copy-of select="DestinationAddress"/>   
        <xsl:copy-of select="Carrier"/>                  
		<xsl:copy-of select="Instructions"/>
		<xsl:copy-of select="LoadShipments"/>
        <xsl:copy-of select="LoadContainers"/>
        <xsl:copy-of select="LoadStops"/> 
        <AllLoadContainers>      
            <xsl:for-each select="AllLoadContainers/LoadContainer">
            <xsl:variable name="currentContainerKey" select="@ShipmentContainerKey"/>
            <xsl:variable name="customerPONo">
                <xsl:call-template name="getCustomerPO">
                    <xsl:with-param name="containerList" select="//LoadContainer[@ParentContainerKey=$currentContainerKey or @ShipmentContainerKey=$currentContainerKey]"/>
                    <xsl:with-param name="containerKey" select="$currentContainerKey"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="nmfc">
                <xsl:call-template name="getNMFC">
                    <xsl:with-param name="containerList" select="//LoadContainer[@ParentContainerKey=$currentContainerKey or @ShipmentContainerKey=$currentContainerKey]"/>
                    <xsl:with-param name="containerKey" select="$currentContainerKey"/>
                </xsl:call-template>
            </xsl:variable>            
			<!-- Obtaining the individual attributes by invoking substring functions appropriately -->
            <xsl:variable name="nmfccode"><xsl:value-of select="substring-before($nmfc,'|')"/></xsl:variable>             
            <xsl:variable name="nmfcclass"><xsl:value-of select="substring-before(substring-after($nmfc,'|'),'|')"/></xsl:variable>            
           <xsl:variable name="nmfcdesc"><xsl:value-of select="substring-before(substring-after(substring-after($nmfc,'|'),'|'),';')"/></xsl:variable>  
            <LoadContainer>
                <xsl:variable name="CurrentContainerKey">
                    <xsl:value-of select="@ShipmentContainerKey"/>
                </xsl:variable>
               <xsl:for-each select="@*">
                    <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
               </xsl:for-each>                
                   <ContainerDetails>
                        <xsl:for-each select="ContainerDetails/ContainerDetail">
                               <ContainerDetail>                          
                                   <xsl:for-each select="@*">
                                       <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                                   </xsl:for-each>    
                                   <ShipmentLine>
                                        <xsl:copy-of select="ShipmentLine/@*"/>
                                        <xsl:copy-of select="ShipmentLine/Order"/>
                                        <OrderLine>
                                            <xsl:if test="ShipmentLine/OrderLine/@CustomerPONo=&quot;&quot;">
                                                     <xsl:attribute name="CustomerPONo"><xsl:value-of select="$customerPONo"/></xsl:attribute>    
                                            </xsl:if>
                                            <xsl:if test="ShipmentLine/OrderLine/@CustomerPONo!=&quot;&quot;">
                                                     <xsl:attribute name="CustomerPONo"><xsl:value-of select="ShipmentLine/OrderLine/@CustomerPONo"/></xsl:attribute>    
                                            </xsl:if>
                                            <xsl:for-each select="ShipmentLine/OrderLine/@*">    
                                               <xsl:if test="not(name()='CustomerPONo')"> 
                                                 <xsl:copy-of select="."/>
                                               </xsl:if> 
                                            </xsl:for-each>    
                                          <Item>
                                            <xsl:if test="ShipmentLine/OrderLine/Item/@NMFCCode=&quot;&quot;">
                                                <xsl:attribute name="NMFCCode"><xsl:value-of select="$nmfccode"/></xsl:attribute>
                                                <xsl:attribute name="NMFCClass"><xsl:value-of select="$nmfcclass"/></xsl:attribute>                                                
                                                <xsl:attribute name="NMFCDescription"><xsl:value-of select="$nmfcdesc"/></xsl:attribute>                                                
                                            </xsl:if>
                                            <xsl:if test="ShipmentLine/OrderLine/Item/@NMFCCode!=&quot;&quot;">
                                                <xsl:attribute name="NMFCCode"><xsl:value-of select="ShipmentLine/OrderLine/Item/@NMFCCode"/></xsl:attribute>
                                                <xsl:attribute name="NMFCClass"><xsl:value-of select="ShipmentLine/OrderLine/Item/@NMFCClass"/></xsl:attribute>                                                
                                                <xsl:attribute name="NMFCDescription"><xsl:value-of select="ShipmentLine/OrderLine/Item/@NMFCDescription"/></xsl:attribute>                                                                                                
                                            </xsl:if>
                                            <xsl:for-each select="ShipmentLine/OrderLine/Item/@*">    
                                               <xsl:if test="not(name()='NMFCCode' or name()='NMFCClass' or name()='NMFCDescription')"> 
                                                 <xsl:copy-of select="."/>
                                               </xsl:if> 
                                            </xsl:for-each> 
                                            <xsl:copy-of select="ShipmentLine/OrderLine/Item/ClassificationCodes"/>
                                         </Item> 
                                         </OrderLine>
                                       </ShipmentLine>    
                                   </ContainerDetail>
                         </xsl:for-each>
                           <xsl:if test="not(ContainerDetails/ContainerDetail)">
                               <ContainerDetail> 
                                    <ShipmentLine>
                                       <OrderLine>
                                            <xsl:attribute name="CustomerPONo"><xsl:value-of select="$customerPONo"/></xsl:attribute>    
                                            <Item>
                                                <xsl:attribute name="NMFCCode"><xsl:value-of select="$nmfccode"/></xsl:attribute>
                                                <xsl:attribute name="NMFCClass"><xsl:value-of select="$nmfcclass"/></xsl:attribute>                                                
                                                <xsl:attribute name="NMFCDescription"><xsl:value-of select="$nmfcdesc"/></xsl:attribute>                                                                                                                                                   
                                            </Item> 
                                      </OrderLine>
                                    </ShipmentLine>             
                               </ContainerDetail>
                           </xsl:if>   
                     </ContainerDetails>
                 </LoadContainer>    
            </xsl:for-each>
           </AllLoadContainers> 
        </Load>
    </xsl:template>
</xsl:stylesheet> 


