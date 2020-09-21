<?xml version="1.0" encoding="UTF-8" ?>
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
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:ibmjda="http://www.sterlingcommerce.com/ibmjda/"
	xmlns:SimpleDateFormat="java.text.SimpleDateFormat"	
	xmlns:ValueMaps="xalan://com.yantra.ibmjda.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps" exclude-result-prefixes="xalan SimpleDateFormat ibmjda"
	xmlns:despatch_advice="urn:gs1:ecom:transportInstruction:xsd:3"
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
	version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:param name="ibmjda:ValueMapsData"/>	
	
	<xsl:template name="createShipment" match="/">		
		   
	   	<xsl:for-each select="//transportInstruction" >	
	   	
		   <xsl:variable name="ExtLoadID">
				<xsl:value-of select="transportInstructionIdentification/entityIdentification"/>
			</xsl:variable>							
		   <xsl:element name="Load">		   
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
		  
			   <xsl:attribute name="ManifestNo">
					<xsl:value-of select="$ExtLoadID"></xsl:value-of>
				</xsl:attribute>   
			    <xsl:variable name="LastModifiedDateTime" >
				    <xsl:value-of select="lastUpdateDateTime" />
               </xsl:variable>
			   <xsl:element name="AdditionalDates">
					   <xsl:element name="AdditionalDate">
						   <xsl:attribute name="ActualDate" >
								<xsl:value-of select="$LastModifiedDateTime" ></xsl:value-of>
						   </xsl:attribute>
						   <xsl:attribute name="DateTypeId" >
								  <xsl:text>JDA_LASTUPDATETIME</xsl:text> 															
						   </xsl:attribute>
					   </xsl:element>
			   </xsl:element>
			<xsl:for-each select="//transportInstructionShipment" >		
							
							<xsl:variable name="ExtShipNode">
								<xsl:value-of select="shipFrom/additionalPartyIdentification"/>
							</xsl:variable>
							<xsl:variable name="ExtReceivingNode">
								<xsl:value-of select="shipTo/additionalPartyIdentification"/>
							</xsl:variable>
							<xsl:variable name="ExtEnterpriseCode">
									<xsl:value-of select="shipper/additionalPartyIdentification" /> 
							</xsl:variable>
							<xsl:variable name="omsdatetimepattern">yyyy-MM-dd'T'HH:mm:ss.SXXX</xsl:variable>               
							<xsl:variable name="omsdatetimeformat" select="SimpleDateFormat:new($omsdatetimepattern)"/>
							<xsl:variable name="datetimepattern">yyyy-MM-ddXXX'T'HH:mm:ss.S</xsl:variable>   
							<xsl:variable name="datetimeformat" select="SimpleDateFormat:new($datetimepattern)"/>
							<xsl:if test="$lActionCode='ADD'  or $lActionCode='CHANGE_BY_REFRESH'">								
									<xsl:element name="Shipment">										
										 <xsl:attribute name="ManifestNo">
												<xsl:value-of select="$ExtLoadID"></xsl:value-of>
										</xsl:attribute>
										<xsl:attribute name="EnterpriseCode">
											 <!--  <xsl:value-of select="$ExtEnterpriseCode"></xsl:value-of>  -->
											  <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMOrganizationCode', $ExtEnterpriseCode)"/> 
										 </xsl:attribute>
										 <xsl:attribute name="SellerOrganizationCode">
											  <!-- <xsl:value-of select="$ExtEnterpriseCode"></xsl:value-of> -->
											  <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMOrganizationCode', $ExtEnterpriseCode)"/> 
										 </xsl:attribute>
										<xsl:attribute name="ShipNode">
											 <!-- <xsl:value-of select="$ExtShipNode"/> -->
											 <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtShipNode)"/> 
										</xsl:attribute>
										<xsl:attribute name="ReceivingNode">
											  <!-- <xsl:value-of select="$ExtReceivingNode"/>  -->
											 <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtReceivingNode)"/> 
										</xsl:attribute>
										<xsl:attribute name="FindShipmentAndAdd">
											<xsl:text>N</xsl:text>
										</xsl:attribute>								
										<xsl:variable name="ExtCarrierServiceCode">
											<xsl:value-of select="transportInstructionTerms/transportServiceLevelCode"/>
										</xsl:variable>
										<xsl:attribute name="CarrierServiceCode">
											 <!-- <xsl:value-of select="$ExtCarrierServiceCode"/> -->
											<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMCarrierServiceCode', $ExtCarrierServiceCode)"/> 
										</xsl:attribute>
										<xsl:variable name="ExtCarrier">
												<xsl:value-of select="carrier/additionalPartyIdentification"/>
										</xsl:variable>
										<xsl:attribute name="SCAC">
											   <!-- <xsl:value-of select="$ExtCarrier"/> -->
												<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMCarrier', $ExtCarrier)"/>
										</xsl:attribute>			
										
										<xsl:variable name="orderdeliverydate" select="concat(plannedDelivery/logisticEventPeriod/endDate,'T',plannedDelivery/logisticEventPeriod/endTime)"/>
			   
										<xsl:variable name="expectedorderdeliverydate" select="SimpleDateFormat:parse($datetimeformat,$orderdeliverydate)"/>
										
										<xsl:attribute name="ExpectedDeliveryDate">										
											<xsl:value-of select="SimpleDateFormat:format($omsdatetimeformat,$expectedorderdeliverydate)" />
										</xsl:attribute>

										<xsl:variable name="ordershipmentdate" select="concat(plannedDespatch/logisticEventPeriod/endDate,'T',plannedDespatch/logisticEventPeriod/endTime)"/>
			   
										<xsl:variable name="expectedordershipmentdate" select="SimpleDateFormat:parse($datetimeformat,$ordershipmentdate)"/>
										
										<xsl:attribute name="ExpectedShipmentDate">										
											<xsl:value-of select="SimpleDateFormat:format($omsdatetimeformat,$expectedordershipmentdate)" />
										</xsl:attribute>								
													
										<xsl:attribute name="ShipmentNo">
											<xsl:value-of select="additionalShipmentIdentification"/>
										</xsl:attribute>									
										
										<xsl:variable  name="ExtOrderNo">
											<xsl:value-of select="transportReference/entityIdentification" />
										</xsl:variable>	
										 <xsl:element name="AdditionalDates">
												   <xsl:element name="AdditionalDate">
													   <xsl:attribute name="ActualDate" >
															<xsl:value-of select="$LastModifiedDateTime" ></xsl:value-of>
													   </xsl:attribute>
													   <xsl:attribute name="DateTypeId" >
															  <xsl:text>JDA_LASTUPDATETIME</xsl:text> 															
													   </xsl:attribute>
												   </xsl:element>
										   </xsl:element>		
											<xsl:element name="ShipmentLines">
												<xsl:for-each select="transportInstructionShipmentItem">										
													<xsl:element name="ShipmentLine">
														<xsl:attribute name="DocumentType">
															  <xsl:value-of select="'0006'" />
														 </xsl:attribute>
														 <xsl:attribute name="EnterpriseCode">
															  <!-- <xsl:value-of select="$ExtEnterpriseCode"></xsl:value-of> -->
															   <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMOrganizationCode', $ExtEnterpriseCode)"/> 
														 </xsl:attribute>
														<xsl:attribute name="OrderNo"> 
															<xsl:value-of select="$ExtOrderNo"/>
														</xsl:attribute>					
														<xsl:attribute name="Quantity">
															<xsl:value-of select="transactionalTradeItem/tradeItemQuantity"/>
														</xsl:attribute>	
														<xsl:attribute name="PrimeLineNo">
															<xsl:value-of select="lineItemNumber"/>
														</xsl:attribute>
														<xsl:attribute name="SubLineNo">
															<xsl:text>1</xsl:text>
														</xsl:attribute>
														<xsl:attribute name="ShipmentLineNo">
															<xsl:value-of select="lineItemNumber"/>
														</xsl:attribute>
													</xsl:element>										
											</xsl:for-each>
										</xsl:element>			
									</xsl:element>	<!-- shipment-->		
							</xsl:if>
							<xsl:if test="$lActionCode='CANCEL' or $lActionCode='DELETE'">
									<xsl:element name="Shipment">
										<xsl:attribute name="Action">
											<xsl:text>Delete</xsl:text>
										</xsl:attribute>
										 <xsl:attribute name="SellerOrganizationCode">
											   <!-- <xsl:value-of select="$ExtEnterpriseCode"></xsl:value-of>  -->
											  <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMOrganizationCode', $ExtEnterpriseCode)"/> 
										 </xsl:attribute>
										<xsl:attribute name="ShipNode">
											 <!-- <xsl:value-of select="$ExtShipNode"/>  -->
											 <xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ExtShipNode)"/> 
										</xsl:attribute>																			
										<xsl:attribute name="ShipmentNo">
											<xsl:value-of select="additionalShipmentIdentification"/>
										</xsl:attribute>
										<xsl:attribute name="CancelRemovedQuantity">
											<xsl:text>N</xsl:text>
										</xsl:attribute>	
										<xsl:attribute name="OverrideModificationRules">
											<xsl:text>Y</xsl:text>
										</xsl:attribute>										
									
									</xsl:element>	<!-- shipment-->
							
							</xsl:if>				
				</xsl:for-each>			
		</xsl:element>	
		</xsl:for-each>		
	</xsl:template>
</xsl:stylesheet>