<?xml version="1.0" encoding="UTF-8" ?>

<!-- 
Licensed Materials - Property of IBM
IBM Sterling Selling and fulfillment Suite
(C) Copyright IBM Corp. 2008,2011 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->

<!--
    Document    determineCustomerPO.xsl
    Created on  October 20, 2003
    Author      vinayb
    Description
        To determine CustomerPONo and NMFCCode for all the containers in the Shipment.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <xsl:template name="getCustomerPO">
        <xsl:param name="containerList"/>
        <xsl:param name="containerKey"/>    
        <xsl:variable name="childContainerList" select="$containerList[@ParentContainerKey=$containerKey]"/>
        <xsl:choose>
            <xsl:when test="$containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/@CustomerPoNo != &quot;&quot;">
                <xsl:value-of select="$containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/@CustomerPoNo"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$childContainerList">
                    <xsl:variable name="currentContainerKey" select="@ShipmentContainerKey"/>
                    <xsl:choose>
                      <xsl:when test="$childContainerList[@ShipmentContainerKey=$currentContainerKey]/ContainerDetails/ContainerDetail/ShipmentLine/@CustomerPoNo != &quot;&quot;">
                        <xsl:value-of select="$childContainerList[@ShipmentContainerKey=$currentContainerKey]/ContainerDetails/ContainerDetail/ShipmentLine/@CustomerPoNo"/>
                      </xsl:when>
                      <xsl:otherwise>
                            <xsl:variable name="childCustomerPO">
                                <xsl:call-template name="getCustomerPO">
                                    <xsl:with-param name="containerList" select="//Container[@ParentContainerKey=$currentContainerKey or @ShipmentContainerKey=$currentContainerKey]"/>
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
    <xsl:template name="getNMFC">
        <xsl:param name="containerList"/>
        <xsl:param name="containerKey"/>    
        <xsl:variable name="childContainerList" select="$containerList[@ParentContainerKey=$containerKey]"/>
        <xsl:choose>
            <xsl:when test="$containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/Item/ClassificationCodes/@NMFCCode != &quot;&quot;">
<xsl:value-of select="concat($containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/Item/ClassificationCodes/@NMFCCode,'|',$containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/Item/ClassificationCodes/@NMFCClass,'|',$containerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/Item/ClassificationCodes/@NMFCDescription,';')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$childContainerList">
                    <xsl:variable name="currentContainerKey" select="@ShipmentContainerKey"/>
                    <xsl:choose>
                      <xsl:when test="$childContainerList[@ShipmentContainerKey=$currentContainerKey]/ContainerDetails/ContainerDetail/ShipmentLine/Item/ClassificationCodes/@NMFCCode = &quot;&quot;">
                        <xsl:value-of select="concat($childContainerList[@ShipmentContainerKey=$currentContainerKey]/ContainerDetails/ContainerDetail/ShipmentLine/Item/ClassificationCodes/@NMFCCode,'|',$childContainerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/Item/ClassificationCodes/@NMFCClass,'|',$childContainerList[@ShipmentContainerKey=$containerKey]/ContainerDetails/ContainerDetail/ShipmentLine/Item/ClassificationCodes/@NMFCDescription)"/>
			</xsl:when>
                      <xsl:otherwise>
                            <xsl:variable name="childNMFC">
                                <xsl:call-template name="getNMFC">
                                    <xsl:with-param name="containerList" select="//Container[@ParentContainerKey=$currentContainerKey or @ShipmentContainerKey=$currentContainerKey]"/>
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
    <xsl:template match="/">
      <Shipment>
        <xsl:for-each select="Shipment/@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>
        <xsl:copy-of select="Shipment/ToAddress"/>  
        <xsl:copy-of select="Shipment/ShipNode"/>        
        <xsl:copy-of select="Shipment/Carrier"/>       		
        <xsl:copy-of select="Shipment/ShipmentLines"/>  
		<xsl:copy-of select="Shipment/BillingInformation"/>    
		<xsl:copy-of select="Shipment/MarkForAddress"/>  	
		<xsl:copy-of select="Shipment/Instructions"/>
		<xsl:copy-of select="Shipment/LoadShipments"/> 
        <Containers>      
            <xsl:for-each select="//Container">
            <Container>
                <xsl:variable name="currentContainerKey">
                    <xsl:value-of select="@ShipmentContainerKey"/>
                </xsl:variable>

            <xsl:variable name="customerPONo">
	     <xsl:if test="@HasMultiCustomerPONo=&quot;N&quot;">
                <xsl:call-template name="getCustomerPO">
                    <xsl:with-param name="containerList" select="//Container[@ParentContainerKey=$currentContainerKey or @ShipmentContainerKey=$currentContainerKey]"/>
                    <xsl:with-param name="containerKey" select="$currentContainerKey"/>
                </xsl:call-template>
               </xsl:if>
            </xsl:variable>
            <xsl:variable name="nmfc">
                <xsl:call-template name="getNMFC">
                    <xsl:with-param name="containerList" select="//Container[@ParentContainerKey=$currentContainerKey or @ShipmentContainerKey=$currentContainerKey]"/>
                    <xsl:with-param name="containerKey" select="$currentContainerKey"/>
                </xsl:call-template>
            </xsl:variable> 
            <xsl:variable name="nmfccode"><xsl:value-of select="substring-before($nmfc,'|')"/></xsl:variable>             
            <xsl:variable name="nmfcclass"><xsl:value-of select="substring-before(substring-after($nmfc,'|'),'|')"/></xsl:variable>            
<xsl:variable name="nmfcdesc"><xsl:value-of select="substring-before(substring-after(substring-after($nmfc,'|'),'|'),';')"/></xsl:variable>            
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
                                            <xsl:if test="ShipmentLine/@CustomerPoNo=&quot;&quot;">
                                                     <xsl:attribute name="CustomerPONo"><xsl:value-of select="$customerPONo"/></xsl:attribute>    
                                            </xsl:if>
                                            <xsl:if test="ShipmentLine/@CustomerPoNo!=&quot;&quot;">
                                                     <xsl:attribute name="CustomerPONo"><xsl:value-of select="ShipmentLine/@CustomerPoNo"/></xsl:attribute>    
                                            </xsl:if>
                                            <xsl:for-each select="ShipmentLine/OrderLine/@*">    
                                               <xsl:if test="not(name()='CustomerPONo')"> 
                                                 <xsl:copy-of select="."/>
                                               </xsl:if> 
                                            </xsl:for-each>    
                                          <Item>
 											<!-- Obtaining NMFCCode of one of the Child Containers if this Container had no NMFCCode-->
					<xsl:if test="ShipmentLine/Item/ClassificationCodes/@NMFCCode=&quot;&quot;">
                                                <xsl:attribute name="NMFCCode"><xsl:value-of select="$nmfccode"/></xsl:attribute>
                                                <xsl:attribute name="NMFCClass"><xsl:value-of select="$nmfcclass"/></xsl:attribute>                                                
                                                <xsl:attribute name="NMFCDescription"><xsl:value-of select="$nmfcdesc"/></xsl:attribute>                                                
                                            </xsl:if>
                                            <xsl:if test="ShipmentLine/Item/ClassificationCodes/@NMFCCode!=&quot;&quot;">
                                                <xsl:attribute name="NMFCCode"><xsl:value-of select="ShipmentLine/Item/ClassificationCodes/@NMFCCode"/></xsl:attribute>
                                                <xsl:attribute name="NMFCClass"><xsl:value-of select="ShipmentLine/Item/ClassificationCodes/@NMFCClass"/></xsl:attribute>                                                
                                                <xsl:attribute name="NMFCDescription"><xsl:value-of select="ShipmentLine/Item/ClassificationCodes/@NMFCDescription"/></xsl:attribute>                                                                                                
                                            </xsl:if>
                                            <xsl:for-each select="ShipmentLine/Item/ClassificationCodes/@*">    
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
                 </Container>    
            </xsl:for-each>
           </Containers> 
        </Shipment>
    </xsl:template>
</xsl:stylesheet>
