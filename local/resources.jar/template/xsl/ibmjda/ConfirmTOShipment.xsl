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
	xmlns:ValueMaps="xalan://com.yantra.ibmjda.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps" exclude-result-prefixes="xalan ibmjda"
	xmlns:despatch_advice="urn:gs1:ecom:despatch_advice:xsd:3"
	xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" 
	version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"
		xalan:indent-amount="2" />
	<xsl:strip-space elements="*" />
	<xsl:param name="ibmjda:ValueMapsData"/>	
	
	<xsl:template name="despatch_advice:despatchAdviceMessage" match="/">		
	    
		<xsl:element name="MultiApi" ><!-- Outer MultiApi Begin -->
			<xsl:for-each select="//despatchAdvice" > <!--Dispatch Advice ForLoop Begin -->
				<xsl:element name="API" > <!-- Outer API Begin -->
					<xsl:attribute name="FlowName">
						<xsl:text>IBMJDA_TO_UpdateConfirmShipment_Internal</xsl:text>
					</xsl:attribute>
					<xsl:element name="Input" > <!-- outer Input Begin -->
						<!-- Value map Variables Begin -->
						<xsl:variable name="SellerOrg">  
							<xsl:value-of select="shipper/additionalPartyIdentification"/>
						</xsl:variable>
<!-- 						<xsl:variable name="BuyerOrg">  
							<xsl:value-of select="receiver/additionalPartyIdentification"/>
						</xsl:variable> -->
						<xsl:variable name="ShpNode">  
							<xsl:value-of select="shipFrom/additionalPartyIdentification"/>
						</xsl:variable>
						<xsl:variable name="RecNode">  
							<xsl:value-of select="shipTo/additionalPartyIdentification"/>
						</xsl:variable>
						<xsl:variable name="SCACCode">  
							<xsl:value-of select="carrier/additionalPartyIdentification"/>
						</xsl:variable>
						<xsl:variable name="OrdRelKey">  
							<xsl:value-of select="purchaseOrder/entityIdentification"/>
						</xsl:variable>
						<!-- Value map Variables End -->
						<xsl:element name="MultiApi" ><!-- Inner MultiApi Begin -->
							<xsl:element name="API" > <!-- Inner changeShipment API Begin -->
								<xsl:attribute name="Name">
									<xsl:text>changeShipment</xsl:text>
								</xsl:attribute>
								<xsl:element name="Input" ><!-- Inner changeShipment Input Begin -->
									<xsl:element name="Shipment">
										<xsl:attribute name="Action">
											<xsl:text>Create-Modify</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="DocumentType">
											<xsl:text>0006</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="FindShipmentAndAdd">
											<xsl:text>N</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="OverrideModificationRules">
											<xsl:text>Y</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="SellerOrganizationCode">
											<!-- <xsl:value-of select="$SellerOrg"/>  -->
											<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMOrganizationCode', $SellerOrg)"/>
										</xsl:attribute>
										<!-- The Below is not needed
											<xsl:attribute name="BuyerOrganizationCode">
											<xsl:value-of select="$BuyerOrg"/>  OR
											<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMOrganizationCode', $BuyerOrg)"/> 
										</xsl:attribute> -->
										<!-- The Below is not needed
											<xsl:attribute name="EnterpriseCode">
											<xsl:value-of select="$SellerOrg"/>  OR
											<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMOrganizationCode', $SellerOrg)"/> 
										</xsl:attribute> -->
										<xsl:attribute name="ShipNode">
											<!-- <xsl:value-of select="$ShpNode"/> -->
											<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ShpNode)"/>
										</xsl:attribute>
										<xsl:attribute name="ReceivingNode">
											<!-- <xsl:value-of select="$RecNode"/>  -->
											<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $RecNode)"/>
										</xsl:attribute>
										<xsl:attribute name="SCAC">
											<!-- <xsl:value-of select="$SCACCode"/> -->
											<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMCarrier', $SCACCode)"/>
										</xsl:attribute>
										<xsl:if test="despatchInformation/actualShipDateTime != 'null'" >
											<xsl:attribute name="ActualShipmentDate">
												<xsl:value-of select="despatchInformation/actualShipDateTime"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:if test="despatchInformation/estimatedDeliveryDateTime != 'null'" >
											<xsl:attribute name="ExpectedDeliveryDate">
												<xsl:value-of select="despatchInformation/estimatedDeliveryDateTime"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="ShipmentNo">
											<xsl:value-of select="despatchAdviceIdentification/entityIdentification"/>
										</xsl:attribute>
										
										<xsl:variable name="mTrailerNo">
												<xsl:value-of select="despatchAdviceTransportInformation/transportMeansID"/>
										</xsl:variable>
										<xsl:choose>
											<xsl:when test="normalize-space($mTrailerNo) !=''">
												<xsl:attribute name="TrailerNo">
																<xsl:value-of select="$mTrailerNo"></xsl:value-of>
												</xsl:attribute>
											</xsl:when>
										</xsl:choose>	
										
										<xsl:element name="Containers"> <!-- Containers Begin -->
											<xsl:variable name="mLoadKey">
												<xsl:value-of select="despatchAdviceTransportInformation/routeID"/>
											</xsl:variable>
											<xsl:for-each select="despatchAdviceLogisticUnit">
													<xsl:variable name="levelIDExpected">3</xsl:variable>
													<xsl:if test="levelIdentification = $levelIDExpected">
													<xsl:variable name="Linewt">  
														<total_Weight>
															 <xsl:for-each select="despatchAdviceLineItem">
																 <item>
																	 <xsl:value-of select="despatchedQuantity * transactionalTradeItem/transactionalItemData/transactionalItemWeight/measurementValue"/>
																 </item>
															 </xsl:for-each>
														 </total_Weight>
													</xsl:variable>
													<xsl:variable name="CntNetWtUOM">  
														<xsl:value-of select="despatchAdviceLineItem/transactionalTradeItem/transactionalItemData/transactionalItemWeight/measurementValue/@measurementUnitCode"/>
													</xsl:variable>
													<xsl:element name="Container"><!-- Container Begin -->
														<xsl:attribute name="Action">
															<xsl:text>Create-Modify</xsl:text>
														</xsl:attribute>
														<xsl:attribute name="LoadKey">
															<xsl:value-of select="$mLoadKey"></xsl:value-of>
														</xsl:attribute>
														<xsl:attribute name="ShipmentContainerKey">
															<xsl:value-of select="logisticUnitIdentification/additionalLogisticUnitIdentification"/>
														</xsl:attribute>
														<xsl:attribute name="ContainerNo">
															<xsl:value-of select="logisticUnitIdentification/additionalLogisticUnitIdentification"/>
														</xsl:attribute>
														<xsl:attribute name="ContainerNetWeight">
															<xsl:variable name="NetWt" select="xalan:nodeset($Linewt)"/>
															<xsl:value-of select="sum($NetWt/total_Weight/item)" /> 
															<!-- <xsl:value-of select="despatchAdviceLineItem/transactionalTradeItem/transactionalItemData/transactionalItemWeight/measurementValue"/>-->
														</xsl:attribute>
														<xsl:attribute name="ContainerNetWeightUOM">
															<!-- <xsl:value-of select="$CntNetWtUOM"/> -->
															<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMUOM', $CntNetWtUOM)"/>
														</xsl:attribute>
														<xsl:element name="ContainerDetails"><!-- ContainerDetails Begin -->
															<xsl:element name="ContainerDetail"><!-- ContainerDetail Begin -->
																<xsl:attribute name="Action">
																	<xsl:text>Create-Modify</xsl:text>
																</xsl:attribute>
																<xsl:for-each select="despatchAdviceLineItem">
																	<xsl:variable name="ItmUOM">  
																			<xsl:value-of select="despatchedQuantity/@measurementUnitCode"/>
																		</xsl:variable>
																	<xsl:element name="ShipmentLine"><!-- ShipmentLine Begin -->
																		<xsl:attribute name="OrderReleaseKey">
																			<xsl:value-of select="$OrdRelKey"/>
																		</xsl:attribute>
																		<xsl:attribute name="PrimeLineNo">
																			<xsl:value-of select="purchaseOrder/lineItemNumber"/>
																		</xsl:attribute>
																		<xsl:attribute name="SubLineNo">
																			<xsl:text>1</xsl:text>
																		</xsl:attribute>
																		<xsl:attribute name="ShipmentLineNo">
																			<xsl:value-of select="lineItemNumber"/>
																		</xsl:attribute>
																		<xsl:attribute name="ShipmentSubLineNo">
																			<xsl:text>0</xsl:text>
																		</xsl:attribute>
																		<xsl:attribute name="ItemID">
																			<xsl:value-of select="transactionalTradeItem/additionalTradeItemIdentification"/>
																		</xsl:attribute>
																		<xsl:attribute name="Quantity">
																			<xsl:value-of select="despatchedQuantity"/>
																		</xsl:attribute>
																		<!-- <xsl:attribute name="UnitOfMeasure">
																			 <xsl:value-of select="$ItmUOM"/>  
																			<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMUOM', $ItmUOM)"/>
																		</xsl:attribute> -->
																	</xsl:element><!-- ShipmentLine End -->
																</xsl:for-each>	
															</xsl:element><!-- ContainerDetail End -->
														</xsl:element><!-- ContainerDetails End -->
													</xsl:element><!-- Container End -->
												</xsl:if>
											</xsl:for-each>
											
											
										</xsl:element><!-- Containers End -->
										<xsl:element name="ShipmentLines"> <!-- ShipmentLines Begin -->
											<xsl:for-each select="despatchAdviceLogisticUnit/despatchAdviceLineItem">
												<xsl:variable name="ItmUOM">  
													<xsl:value-of select="despatchedQuantity/@measurementUnitCode"/>
												</xsl:variable>
												<xsl:element name="ShipmentLine"> <!-- ShipmentLine Begin -->
													<xsl:attribute name="OrderReleaseKey">
														<xsl:value-of select="$OrdRelKey"/>
													</xsl:attribute>
													<xsl:attribute name="PrimeLineNo">
														<xsl:value-of select="purchaseOrder/lineItemNumber"/>
													</xsl:attribute>
													<xsl:attribute name="SubLineNo">
														<xsl:text>1</xsl:text>
													</xsl:attribute>
													<xsl:attribute name="ShipmentLineNo">
														<xsl:value-of select="lineItemNumber"/>
													</xsl:attribute>
													<xsl:attribute name="ShipmentSubLineNo">
														<xsl:text>0</xsl:text>
													</xsl:attribute>
													<xsl:attribute name="ItemID">
														<xsl:value-of select="transactionalTradeItem/additionalTradeItemIdentification"/>
													</xsl:attribute>
													<xsl:attribute name="Quantity">
														<xsl:value-of select="despatchedQuantity"/>
													</xsl:attribute>
													<!-- <xsl:attribute name="UnitOfMeasure">
														 <xsl:value-of select="$ItmUOM"/>  
														<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMUOM', $ItmUOM)"/>
													</xsl:attribute> -->
												</xsl:element> <!-- ShipmentLine End -->
											</xsl:for-each>
										</xsl:element><!-- ShipmentLines End -->
									</xsl:element>
								</xsl:element><!-- Inner changeShipment Input End -->
							</xsl:element><!-- Inner changeShipmentAPI End -->
							<xsl:element name="API" > <!-- Inner confirmShipment API Begin -->
								<xsl:attribute name="Name">
									<xsl:text>confirmShipment</xsl:text>
								</xsl:attribute>
								<xsl:element name="Input" ><!-- Inner confrimShipment Input Begin -->
									<xsl:element name="Shipment">
										<xsl:attribute name="DocumentType">
											<xsl:text>0006</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="FindShipmentAndAdd">
											<xsl:text>N</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="OverrideModificationRules">
											<xsl:text>Y</xsl:text>
										</xsl:attribute>
										<xsl:attribute name="SellerOrganizationCode">
											<!-- <xsl:value-of select="$SellerOrg"/> -->
											<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMOrganizationCode', $SellerOrg)"/>
										</xsl:attribute>
										<xsl:attribute name="ShipNode">
											<!-- <xsl:value-of select="$ShpNode"/> -->
											<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ShpNode)"/> 
										</xsl:attribute>
										<xsl:attribute name="ReceivingNode">
											<!-- <xsl:value-of select="$RecNode"/>  -->
											<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $RecNode)"/>
										</xsl:attribute>
										<xsl:attribute name="ShipmentNo">
											<xsl:value-of select="despatchAdviceIdentification/entityIdentification"/>
										</xsl:attribute>
										<xsl:element name="ShipmentLines"> <!-- ShipmentLines Begin -->
											<xsl:for-each select="despatchAdviceLogisticUnit/despatchAdviceLineItem">
												<xsl:variable name="ItmUOM">  
													<xsl:value-of select="despatchedQuantity/@measurementUnitCode"/>
												</xsl:variable>
												<xsl:element name="ShipmentLine"><!-- ShipmentLine Begin -->
													<xsl:attribute name="OrderReleaseKey">
														<xsl:value-of select="$OrdRelKey"/>
													</xsl:attribute>
													<xsl:attribute name="PrimeLineNo">
														<xsl:value-of select="purchaseOrder/lineItemNumber"/>
													</xsl:attribute>
													<xsl:attribute name="SubLineNo">
														<xsl:text>1</xsl:text>
													</xsl:attribute>
													<xsl:attribute name="ShipmentLineNo">
														<xsl:value-of select="lineItemNumber"/>
													</xsl:attribute>
													<xsl:attribute name="ShipmentSubLineNo">
														<xsl:text>0</xsl:text>
													</xsl:attribute>
													<xsl:attribute name="ItemID">
														<xsl:value-of select="transactionalTradeItem/additionalTradeItemIdentification"/>
													</xsl:attribute>
													<xsl:attribute name="Quantity">
														<xsl:value-of select="despatchedQuantity"/>
													</xsl:attribute>
													<!-- <xsl:attribute name="UnitOfMeasure">
														 <xsl:value-of select="$ItmUOM"/> 
														<xsl:value-of select="ValueMaps:getMapValue($ibmjda:ValueMapsData, '', 'jdaToIBMUOM', $ItmUOM)"/> 
													</xsl:attribute>  -->
											</xsl:element><!-- ShipmentLine End -->
										</xsl:for-each>
										</xsl:element><!-- ShipmentLines End -->
									</xsl:element>
								</xsl:element><!-- Inner confirmShipment Input End -->
							</xsl:element><!-- Inner confirmShipmentAPI End -->
						</xsl:element><!-- Inner MultiApi End -->
					</xsl:element> <!-- outer Input End-->
				</xsl:element> <!-- Outer API End -->
			</xsl:for-each>
		</xsl:element>		<!-- Outer MultiApi End -->
	</xsl:template>
</xsl:stylesheet>
