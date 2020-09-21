
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
(C) Copyright IBM Corp. 2005, 2015 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:SimpleDateFormat="java.text.SimpleDateFormat"	
	xmlns:Date="java.util.Date"	
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:ibmjda="http://www.sterlingcommerce.com/ibmjda/"
	xmlns:ValueMaps="xalan://com.yantra.ibmjda.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps" exclude-result-prefixes="xalan SimpleDateFormat Date ibmjda"
	xmlns:order="urn:gs1:ecom:order:xsd:3"
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
	version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:param name="ibmjda:ValueMapsData"/>	

   <xsl:template name="order:orderMessage" match="/">
   	<xsl:for-each select="//order" >	
      <xsl:element name="Order">		  
		  <xsl:variable name="lActionCode">
			  <xsl:value-of select="documentActionCode" />
		  </xsl:variable>
		  <xsl:attribute name="HostAction">
				<xsl:value-of select="$lActionCode"></xsl:value-of>
			 </xsl:attribute>
		  <xsl:if test="$lActionCode='ADD'">
			  <xsl:attribute name="HostAction">
				<xsl:text>ADD</xsl:text>
			 </xsl:attribute>
		  </xsl:if> 
          <xsl:if test="$lActionCode='CANCEL'">
			  <xsl:attribute name="HostAction">
				<xsl:text>CANCEL</xsl:text>
			 </xsl:attribute>
		  </xsl:if> 
		  <xsl:if test="$lActionCode='DELETE'">
			  <xsl:attribute name="HostAction">
				<xsl:text>CANCEL</xsl:text>
			 </xsl:attribute>
		  </xsl:if> 
		  <xsl:if test="$lActionCode='CHANGE_BY_REFRESH'">
			  <xsl:attribute name="HostAction">
				<xsl:text>CHANGE</xsl:text>
			 </xsl:attribute>
		  </xsl:if> 

    
			<!-- Create Transfer Order Request -->
            <xsl:if test="$lActionCode='ADD'  or $lActionCode='CHANGE_BY_REFRESH'">
            
               <xsl:attribute name="OrderDate">
                  <xsl:value-of select="creationDateTime" />
               </xsl:attribute>
               
              
               <xsl:attribute name="OrderNo">
                  <xsl:value-of select="orderIdentification/entityIdentification" />
               </xsl:attribute>

               <xsl:attribute name="OrderType">
                  <xsl:value-of select="concat(orderTypeCode,'_HOSTTO')"/>
               </xsl:attribute>
				
				<xsl:variable name="ExtEnterpriseCode">
					<xsl:value-of select="seller/additionalPartyIdentification" />
				</xsl:variable>
				
               <xsl:attribute name="EnterpriseCode">
                  <!-- <xsl:value-of select="seller/additionalPartyIdentification" /> -->
                  <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, 'DEFAULT', 'jdaToIBMOrganizationCode', $ExtEnterpriseCode)"/>                  
               </xsl:attribute>

               <xsl:attribute name="DocumentType">
                  <xsl:value-of select="'0006'" />
               </xsl:attribute>
			
				<xsl:variable name="ExtBuyerCode">
					<xsl:value-of select="buyer/additionalPartyIdentification" />
				</xsl:variable>
				
               <xsl:attribute name="BuyerOrganizationCode">
                 <!-- <xsl:value-of select="buyer/additionalPartyIdentification" />  -->
                 <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, 'DEFAULT', 'jdaToIBMOrganizationCode', $ExtBuyerCode)"/> 
               </xsl:attribute>

               <xsl:attribute name="PriorityNumber">
                  <xsl:value-of select="avpList/eComStringAttributeValuePairList[@attributeName='orderPriority']" />
               </xsl:attribute>
				
				<xsl:variable name="ExtShipNode">
					<xsl:value-of select="orderLogisticalInformation/shipFrom/additionalPartyIdentification" />
				</xsl:variable>
				
               <xsl:attribute name="ShipNode">
                  <!--  <xsl:value-of select="orderLogisticalInformation/shipFrom/additionalPartyIdentification" />  -->
                  <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtShipNode)"/> 
               </xsl:attribute>
				
				<xsl:variable name="ExtReceiveNode">
					 <xsl:value-of select="orderLogisticalInformation/shipTo/additionalPartyIdentification" />
				</xsl:variable>
				
               <xsl:attribute name="ReceivingNode">
                 <!--  <xsl:value-of select="orderLogisticalInformation/shipTo/additionalPartyIdentification" />  -->
                  <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtReceiveNode)"/> 
               </xsl:attribute>

               <xsl:attribute name="CarrierServiceCode">
                  <xsl:value-of select="orderLineItem/orderLineItemDetail/orderLogisticalInformation/shipmentTransportationInformation/transportServiceLevelCode" />
               </xsl:attribute>
               			   
               <xsl:attribute name="SCAC">
                  <xsl:value-of select="orderLineItem/orderLineItemDetail/orderLogisticalInformation/shipmentTransportationInformation/carrier/additionalPartyIdentification" />
               </xsl:attribute>
               
			   <xsl:variable name="omsdatetimepattern">yyyy-MM-dd'T'HH:mm:ss.SXXX</xsl:variable>               
			   <xsl:variable name="omsdatetimeformat" select="SimpleDateFormat:new($omsdatetimepattern)"/>
			   <xsl:variable name="datetimepattern">yyyy-MM-ddXXX'T'HH:mm:ss.S</xsl:variable>   
			   <xsl:variable name="datetimeformat" select="SimpleDateFormat:new($datetimepattern)"/>
			   
			   <xsl:variable name="orderdeliverydate" select="concat(orderLogisticalInformation/orderLogisticalDateInformation/requestedDeliveryDateRange/beginDate,'T',orderLogisticalInformation/orderLogisticalDateInformation/requestedDeliveryDateRange/beginTime)"/>
			   
			   	<xsl:variable name="reqorderdeliverydate" select="SimpleDateFormat:parse($datetimeformat,$orderdeliverydate)"/>
				
				<xsl:attribute name="ReqDeliveryDate">
				   <xsl:value-of select="SimpleDateFormat:format($omsdatetimeformat,$reqorderdeliverydate)" />
				</xsl:attribute>

				
				<xsl:variable name="ordershipdate" select="concat(orderLogisticalInformation/orderLogisticalDateInformation/requestedShipDateRange/beginDate,'T',orderLogisticalInformation/orderLogisticalDateInformation/requestedShipDateRange/beginTime)"/>
			   
				<xsl:variable name="reqordershipdate" select="SimpleDateFormat:parse($datetimeformat,$ordershipdate)"/>
				
				<xsl:attribute name="ReqShipDate">
				   <xsl:value-of select="SimpleDateFormat:format($omsdatetimeformat,$reqordershipdate)" />
				</xsl:attribute>		
				
				<xsl:element name="OrderDates">
					   <xsl:element name="OrderDate">
						   <xsl:attribute name="DateTypeId" >
								<xsl:text>JDA_LASTUPDATETIME_ORD</xsl:text> 
						   </xsl:attribute>
						   <xsl:attribute name="ActualDate" >
								<xsl:value-of select="lastUpdateDateTime" />
						   </xsl:attribute>
					   </xsl:element>
               </xsl:element>
				
               <xsl:element name="OrderLines">
                  <xsl:for-each select="orderLineItem">
                     <xsl:element name="OrderLine">
                        <xsl:attribute name="PrimeLineNo">
                           <xsl:value-of select="lineItemNumber" />
                        </xsl:attribute>

                        <xsl:attribute name="SubLineNo">
                           <xsl:value-of select="'1'" />
                        </xsl:attribute>

                        <xsl:attribute name="OrderedQty">
                           <xsl:value-of select="requestedQuantity" />
                        </xsl:attribute>

                        <xsl:attribute name="PackListType">
                           <xsl:value-of select="//eComStringAttributeValuePairList[@attributeName='commodityCode']" />
                        </xsl:attribute>

						
						<xsl:variable name="orderlinedeliverydate" select="concat(orderLineItemDetail/orderLogisticalInformation/orderLogisticalDateInformation/requestedDeliveryDateRange/beginDate,'T',orderLineItemDetail/orderLogisticalInformation/orderLogisticalDateInformation/requestedDeliveryDateRange/beginTime)"/>
			   
						<xsl:variable name="reqorderlinedeliverydate" select="SimpleDateFormat:parse($datetimeformat,$orderlinedeliverydate)"/>
				
						<xsl:attribute name="ReqDeliveryDate">
						   <xsl:value-of select="SimpleDateFormat:format($omsdatetimeformat,$reqorderlinedeliverydate)" />
						</xsl:attribute>

						
						<xsl:variable name="orderlineshipdate" select="concat(orderLineItemDetail/orderLogisticalInformation/orderLogisticalDateInformation/requestedShipDateRange/beginDate,'T',orderLineItemDetail/orderLogisticalInformation/orderLogisticalDateInformation/requestedShipDateRange/beginTime)"/>
			   
						<xsl:variable name="reqorderlineshipdate" select="SimpleDateFormat:parse($datetimeformat,$orderlineshipdate)"/>
						
						
						<xsl:attribute name="ReqShipDate">
						   <xsl:value-of select="SimpleDateFormat:format($omsdatetimeformat,$reqorderlineshipdate)" />
						</xsl:attribute>		
				
		
							
						<xsl:attribute name="NMFCClass">							
							 <xsl:value-of select="avpList/eComStringAttributeValuePairList[@attributeName='freightClassCode']"></xsl:value-of>
						 </xsl:attribute>
									 
                        <xsl:element name="Item">
						   <xsl:attribute name="ItemID">
							  <xsl:value-of select="transactionalTradeItem/additionalTradeItemIdentification" />
						   </xsl:attribute>

                           <xsl:attribute name="ItemWeight">
                              <xsl:value-of select="transactionalTradeItem/transactionalItemData/transactionalItemWeight/measurementValue" />
                           </xsl:attribute>

                           <xsl:variable name="ExtUOM">
								<xsl:value-of select="transactionalTradeItem/transactionalItemData/transactionalItemWeight/measurementValue/@measurementUnitCode" />
							</xsl:variable>
                           <xsl:attribute name="ItemWeightUOM">
							   <!-- <xsl:value-of select="$ExtUOM"></xsl:value-of> -->
                               <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMUOM', $ExtUOM)"/> 
                           </xsl:attribute>							
						             
							<!--
                           <xsl:attribute name="ProductClass">
                              <xsl:value-of select="'GOOD'" />
                           </xsl:attribute>
						   -->

                           <xsl:attribute name="UnitOfMeasure">
                              <xsl:value-of select="'EACH'" />
                           </xsl:attribute>
                        </xsl:element>
                     </xsl:element>
                  </xsl:for-each>
               </xsl:element>
 </xsl:if>

<xsl:if test="$lActionCode='CANCEL' or $lActionCode='DELETE'">
               <xsl:attribute name="Action">
                  <xsl:value-of select="'CANCEL'" />
               </xsl:attribute>

               <xsl:attribute name="OrderNo">
                  <xsl:value-of select="orderIdentification/entityIdentification" />
               </xsl:attribute>
				
				<xsl:variable name="ExtEnterpriseCode">
					<xsl:value-of select="seller/additionalPartyIdentification" />
				</xsl:variable>
				               
               <xsl:attribute name="EnterpriseCode">
                 <!--  <xsl:value-of select="seller/additionalPartyIdentification" /> -->
                   <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, 'DEFAULT', 'jdaToIBMOrganizationCode', $ExtEnterpriseCode)"/>
               </xsl:attribute>

               <xsl:attribute name="DocumentType">
                  <xsl:value-of select="'0006'" />
               </xsl:attribute>
</xsl:if>

      </xsl:element>
    </xsl:for-each>
   </xsl:template>
</xsl:stylesheet>

