<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
(C) Copyright IBM Corp. 2005, 2015 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:SimpleDateFormat="java.text.SimpleDateFormat"	
	xmlns:Date="java.util.Date"	
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
	<xsl:template name="ReleaseOrderOnCreationOrChange" match="/">
		<xsl:variable name="datetimepattern">yyyy-MM-dd'T'HH:mm:ssXXX</xsl:variable>
		<xsl:variable name="datetimeformat" select="SimpleDateFormat:new($datetimepattern)"/>
		<xsl:variable name="creationdatetimepattern">yyyy-MM-dd'T'HH:mm:ss.SXXX</xsl:variable>
		<xsl:variable name="creationdatetimeformat" select="SimpleDateFormat:new($creationdatetimepattern)"/>
		<xsl:variable name="OrganizationCode">
			<xsl:value-of select="/OrderRelease/@EnterpriseCode"/>
		</xsl:variable>	
		<xsl:variable name="ExtOrganizationCode">
			<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, 'DEFAULT', 'jdaToIBMOrganizationCode', $OrganizationCode)"/>
		</xsl:variable>	
		<xsl:variable name="SBDHReceiver">
			<xsl:value-of select="/OrderRelease/@ShipNode"/>
		</xsl:variable>
		<xsl:variable name="ExtSBDHReceiver">
			<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, 'DEFAULT', 'jdaToIBMShipNode', $SBDHReceiver)"/>
		</xsl:variable>

		<xsl:variable name="instanceIdentifierPattern">HHmmss</xsl:variable>
		<xsl:variable name="instanceIdentifierFormat" select="SimpleDateFormat:new($instanceIdentifierPattern)"/>
		<xsl:variable name="instanceIdentifierTimeValue" select="SimpleDateFormat:format($instanceIdentifierFormat,Date:new())"/>
		<xsl:variable name="orderReleaseKeyValue" select="/OrderRelease/@OrderReleaseKey"/>

		<order:orderMessage xsi:schemaLocation="urn:gs1:ecom:order:xsd:3 ../Schemas/gs1/ecom/Order.xsd">	   
			<xsl:element name="sh:StandardBusinessDocumentHeader">
				<xsl:element name="sh:HeaderVersion">
					<xsl:text>1.0</xsl:text>
				</xsl:element>
				<xsl:element name="sh:Sender">
					<xsl:element name="sh:Identifier">
						<xsl:attribute name="Authority">
							<xsl:text>ENTERPRISE</xsl:text>
						</xsl:attribute>
						<xsl:text>OMS.GLOBAL</xsl:text>
					</xsl:element>
				</xsl:element>
				<xsl:element name="sh:Receiver">
					<xsl:element name="sh:Identifier">
						<xsl:attribute name="Authority">
							<xsl:text>ENTERPRISE</xsl:text>
						</xsl:attribute>
						<xsl:text>LOC.</xsl:text><xsl:value-of select="$ExtSBDHReceiver"></xsl:value-of>
					</xsl:element>
				</xsl:element>
				<xsl:element name="sh:Receiver">
					<xsl:element name="sh:Identifier">
						<xsl:attribute name="Authority">
							<xsl:text>ENTERPRISE</xsl:text>
						</xsl:attribute>
						<xsl:text>TMS.GLOBAL</xsl:text>
					</xsl:element>
				</xsl:element>

				<xsl:element name="sh:DocumentIdentification">
					<xsl:element name="sh:Standard">
						<xsl:text>GS1</xsl:text>
					</xsl:element>
					<xsl:element name="sh:TypeVersion">
						<xsl:text>3.2</xsl:text>
					</xsl:element>
					<!-- To be Determined -->
					<xsl:element name="sh:InstanceIdentifier">
						<xsl:value-of select="concat($orderReleaseKeyValue,$instanceIdentifierTimeValue)"/>
					</xsl:element>
					<xsl:element name="sh:Type">
						<xsl:text>order</xsl:text>
					</xsl:element>
					<xsl:element name="sh:CreationDateAndTime">
						<xsl:value-of  select="SimpleDateFormat:format($creationdatetimeformat,Date:new())"/>
					</xsl:element>				
				</xsl:element>
				<xsl:element name="sh:BusinessScope">
					<xsl:element name="sh:Scope">
						<xsl:element name="sh:Type">
							<xsl:text>SCHEMA_GUIDE</xsl:text>
						</xsl:element>
						<xsl:element name="sh:InstanceIdentifier">
							<xsl:text>GS1 3.2,GS1_JDA 2016.1.0</xsl:text>
						</xsl:element>
						<xsl:element name="sh:Identifier">
							<xsl:text>TransferOrder 1.0.0</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>	
			<xsl:element name="order">	
				<xsl:element name="creationDateTime">	
					<xsl:value-of select="/OrderRelease/@Createts"/>
				</xsl:element>
				<xsl:element name="documentStatusCode">
					<xsl:text>ORIGINAL</xsl:text>
				</xsl:element>
				<xsl:element name="documentActionCode">
					<xsl:text>ADD</xsl:text>
				</xsl:element>

				<xsl:element name="avpList">						
					<xsl:element name="eComStringAttributeValuePairList">
						<xsl:attribute name="attributeName"><xsl:text>commodityCode</xsl:text></xsl:attribute>
						<xsl:value-of select="OrderRelease/OrderLine/@PackListType"/>			
					</xsl:element>	
					<xsl:element name="eComStringAttributeValuePairList">
						<xsl:attribute name="attributeName"><xsl:text>referenceOrderNumber</xsl:text></xsl:attribute>
						<xsl:value-of select="/OrderRelease/@SalesOrderNo"/>			
					</xsl:element>	
				</xsl:element>
				<xsl:element name="orderIdentification">
					<xsl:element name="entityIdentification">	
						<xsl:value-of select="/OrderRelease/@OrderReleaseKey"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="orderTypeCode">
					<xsl:text>150</xsl:text>
				</xsl:element>				
				<xsl:element name="buyer">
					<xsl:element name="additionalPartyIdentification">
						<!-- Hardcoded value required by xsd verification-->
						<xsl:attribute name="additionalPartyIdentificationTypeCode">
							<xsl:text>UNKNOWN</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="$ExtOrganizationCode"/>
					</xsl:element>
				</xsl:element>		
				<xsl:element name="seller">
					<xsl:element name="additionalPartyIdentification">
						<!-- Hardcoded value required by xsd verification-->
						<xsl:attribute name="additionalPartyIdentificationTypeCode">
							<xsl:text>UNKNOWN</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="$ExtOrganizationCode"/>
					</xsl:element>
				</xsl:element>

				<xsl:variable name="ShipNode">
					<xsl:value-of select="/OrderRelease/@ShipNode"/>
				</xsl:variable>
				<xsl:element name="orderLogisticalInformation">
					<xsl:element name="shipFrom">
						<xsl:element name="additionalPartyIdentification">
							<!-- Hardcoded value required by xsd verification-->
							<xsl:attribute name="additionalPartyIdentificationTypeCode">
								<xsl:text>UNKNOWN</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ShipNode)"/>
						</xsl:element>
					</xsl:element>

					<xsl:element name="shipTo">
						<xsl:element name="additionalPartyIdentification">
							<!-- Hardcoded value required by xsd verification-->
							<xsl:attribute name="additionalPartyIdentificationTypeCode">
								<xsl:text>UNKNOWN</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="/OrderRelease/@ShipToId"/>
						</xsl:element>						
					</xsl:element>

					<xsl:element name="orderLogisticalDateInformation">														
						<xsl:variable name="dateformat" select="SimpleDateFormat:new('yyyy-MM-ddXXX')"/>
						<xsl:variable name="timeformat" select="SimpleDateFormat:new('HH:mm:ss.S')"/>
						<xsl:variable name="maxReqDeliveryDate">
							<xsl:for-each select="//OrderStatus">
								<xsl:sort select="@ExpectedDeliveryDate" data-type="text" order="descending"></xsl:sort>
								<xsl:if test="position()=1">
									<xsl:value-of select="@ExpectedDeliveryDate"></xsl:value-of> 
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>															

						<xsl:variable name="minReqDeliveryDate">
							<xsl:for-each select="//OrderStatus">
								<xsl:sort select="@ExpectedDeliveryDate" data-type="text" order="ascending"></xsl:sort>
								<xsl:if test="position()=1">
									<xsl:value-of select="@ExpectedDeliveryDate"></xsl:value-of> 
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>

						<xsl:variable name="maxdeliverydatetime" select="SimpleDateFormat:parse($datetimeformat,$maxReqDeliveryDate)"/>
						<xsl:variable name="mindeliverydatetime" select="SimpleDateFormat:parse($datetimeformat,$minReqDeliveryDate)"/>
						<xsl:element name="requestedDeliveryDateRange">
							<xsl:element name="beginDate">
								<xsl:value-of select="SimpleDateFormat:format($dateformat,$mindeliverydatetime)"/>
							</xsl:element>
							<xsl:element name="beginTime">
								<xsl:value-of select="SimpleDateFormat:format($timeformat,$mindeliverydatetime)"/>
							</xsl:element>
							<xsl:element name="endDate">
								<xsl:value-of select="SimpleDateFormat:format($dateformat,$maxdeliverydatetime)"/>
							</xsl:element>
							<xsl:element name="endTime">
								<xsl:value-of select="SimpleDateFormat:format($timeformat,$maxdeliverydatetime)"/>
							</xsl:element>
						</xsl:element>

						<xsl:variable name="maxReqShipDate">
							<xsl:for-each select="//OrderStatus">
								<xsl:sort select="@ExpectedShipmentDate" data-type="text" order="descending"></xsl:sort>
								<xsl:if test="position()=1">
									<xsl:value-of select="@ExpectedShipmentDate"></xsl:value-of> 
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>															

						<xsl:variable name="minReqShipDate">
							<xsl:for-each select="//OrderStatus">
								<xsl:sort select="@ExpectedShipmentDate" data-type="text" order="ascending"></xsl:sort>
								<xsl:if test="position()=1">
									<xsl:value-of select="@ExpectedShipmentDate"></xsl:value-of> 
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>	

						<xsl:variable name="maxshipdatetime" select="SimpleDateFormat:parse($datetimeformat,$maxReqShipDate)"/>
						<xsl:variable name="minshipdatetime" select="SimpleDateFormat:parse($datetimeformat,$minReqShipDate)"/>

						<xsl:element name="requestedShipDateRange">
							<xsl:element name="beginDate">
								<xsl:value-of select="SimpleDateFormat:format($dateformat,$minshipdatetime)"/>
							</xsl:element>
							<xsl:element name="beginTime">
								<xsl:value-of select="SimpleDateFormat:format($timeformat,$minshipdatetime)"/>
							</xsl:element>
							<xsl:element name="endDate">
								<xsl:value-of select="SimpleDateFormat:format($dateformat,$maxshipdatetime)"/>
							</xsl:element>
							<xsl:element name="endTime">
								<xsl:value-of select="SimpleDateFormat:format($timeformat,$maxshipdatetime)"/>
							</xsl:element>
						</xsl:element>

					</xsl:element>									

				</xsl:element>
				<xsl:for-each select="/OrderRelease/OrderLine">
					<xsl:element name="orderLineItem">
						<xsl:element name="lineItemNumber">
							<xsl:value-of select="@PrimeLineNo"/>
						</xsl:element>						
						<xsl:element name="requestedQuantity">
							<xsl:value-of select="@StatusQuantity"/>
						</xsl:element>

						<xsl:variable name="WeightUOM">
							<xsl:value-of select="ItemDetails/PrimaryInformation/@UnitWeightUOM"/>
						</xsl:variable>
						<xsl:variable name="VolumeUOM">
							<xsl:value-of select="ItemDetails/PrimaryInformation/@UnitVolumeUOM"/>
						</xsl:variable>

						<xsl:element name="transactionalTradeItem">
							<xsl:element name="gtin">
								<!-- Hardcoded Value to pass xsd verification-->
								<xsl:text>00000000000000</xsl:text>
							</xsl:element>
							<xsl:element name="additionalTradeItemIdentification">
								<xsl:attribute name="additionalTradeItemIdentificationTypeCode">
									<xsl:text>BUYER_ASSIGNED</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="Item/@ItemID"/>
							</xsl:element>
							<xsl:element name="transactionalItemData">
								<xsl:element name="transactionalItemWeight">
									<xsl:element name="measurementType">
										<xsl:text>UNIT_NET_WEIGHT</xsl:text>
									</xsl:element>
									<xsl:element name="measurementValue">
										<xsl:attribute name="measurementUnitCode">
											<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMUOM', $WeightUOM)"/>
										</xsl:attribute>
										<xsl:value-of select="ItemDetails/PrimaryInformation/@UnitWeight" />										
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>

						<xsl:variable name="OrderCarrierServiceCode">
							<xsl:value-of select="/OrderRelease/Order/@CarrierServiceCode"/>
						</xsl:variable>
						<xsl:variable name="ReleaseCarrier">
							<xsl:value-of select="/OrderRelease/@SCAC"/>
						</xsl:variable>
						<xsl:element name="shipmentTransportationInformation">											
							<xsl:choose>
								<xsl:when test="normalize-space(/OrderRelease/Order/@CarrierServiceCode) !=''">
									<xsl:element name="transportServiceLevelCode">
										<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMCarrierServiceCode', $OrderCarrierServiceCode)"/>
									</xsl:element>
								</xsl:when>
							</xsl:choose>

							<xsl:choose>
								<xsl:when test="normalize-space(/OrderRelease/@SCAC) !=''">
									<xsl:element name="carrier">
										<xsl:element name="additionalPartyIdentification">
											<!-- Hardcoded value required by xsd verification-->
											<xsl:attribute name="additionalPartyIdentificationTypeCode">
												<xsl:text>SCAC</xsl:text>
											</xsl:attribute>
											<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMCarrier', $ReleaseCarrier)"/>
										</xsl:element>
									</xsl:element>
								</xsl:when>
							</xsl:choose>													
						</xsl:element>

						<xsl:element name="orderLineItemDetail">
							<xsl:element name="requestedQuantity">
								<!-- passing line level quantity here for Value to pass xsd verification-->
								<xsl:value-of select="@StatusQuantity"/>
							</xsl:element>

							<xsl:element name="orderLogisticalInformation">
								<xsl:element name="orderLogisticalDateInformation">										
									<xsl:variable name="dateformat" select="SimpleDateFormat:new('yyyy-MM-ddXXX')"/>
									<xsl:variable name="timeformat" select="SimpleDateFormat:new('HH:mm:ss.S')"/>
									<xsl:variable name="reqDeliveryDate">
										<xsl:value-of select="OrderStatuses/OrderStatus/@ExpectedDeliveryDate"/>
									</xsl:variable>	
									<xsl:if test="normalize-space($reqDeliveryDate) !=''">									
										<xsl:variable name="deliverydatetime" select="SimpleDateFormat:parse($datetimeformat,$reqDeliveryDate)"/>					
										<xsl:element name="requestedDeliveryDateRange">
											<xsl:if test="normalize-space(SimpleDateFormat:format($dateformat,$deliverydatetime)) !=''">
												<xsl:element name="beginDate">
													<xsl:value-of select="SimpleDateFormat:format($dateformat,$deliverydatetime)" />							
												</xsl:element>
											</xsl:if>
											<xsl:if test="normalize-space(SimpleDateFormat:format($timeformat,$deliverydatetime)) !=''">
												<xsl:element name="beginTime">								
													<xsl:value-of select="SimpleDateFormat:format($timeformat,$deliverydatetime)" />								
												</xsl:element>
											</xsl:if>
											<xsl:if test="normalize-space(SimpleDateFormat:format($dateformat,$deliverydatetime)) !=''">
												<xsl:element name="endDate">
													<xsl:value-of select="SimpleDateFormat:format($dateformat,$deliverydatetime)" />							
												</xsl:element>
											</xsl:if>
											<xsl:if test="normalize-space(SimpleDateFormat:format($timeformat,$deliverydatetime)) !=''">
												<xsl:element name="endTime">								
													<xsl:value-of select="SimpleDateFormat:format($timeformat,$deliverydatetime)" />								
												</xsl:element>
											</xsl:if>
										</xsl:element>
									</xsl:if>
									<xsl:variable name="reqShipDate">										
										<xsl:value-of select="OrderStatuses/OrderStatus/@ExpectedShipmentDate"></xsl:value-of>											
									</xsl:variable>	
									<xsl:if test="normalize-space($reqShipDate) !=''">												
										<xsl:variable name="shipdatetime" select="SimpleDateFormat:parse($datetimeformat,$reqShipDate)"/>					
										<xsl:element name="requestedShipDateRange">
											<xsl:if test="normalize-space(SimpleDateFormat:format($dateformat,$shipdatetime)) !=''">									
												<xsl:element name="beginDate">
													<xsl:value-of select="SimpleDateFormat:format($dateformat,$shipdatetime)" />							
												</xsl:element>
											</xsl:if>
											<xsl:if test="normalize-space(SimpleDateFormat:format($timeformat,$shipdatetime)) !=''">
												<xsl:element name="beginTime">								
													<xsl:value-of select="SimpleDateFormat:format($timeformat,$shipdatetime)" />								
												</xsl:element>
											</xsl:if>
											<xsl:if test="normalize-space(SimpleDateFormat:format($dateformat,$shipdatetime)) !=''">									
												<xsl:element name="endDate">
													<xsl:value-of select="SimpleDateFormat:format($dateformat,$shipdatetime)" />							
												</xsl:element>
											</xsl:if>
											<xsl:if test="normalize-space(SimpleDateFormat:format($timeformat,$shipdatetime)) !=''">
												<xsl:element name="endTime">								
													<xsl:value-of select="SimpleDateFormat:format($timeformat,$shipdatetime)" />								
												</xsl:element>
											</xsl:if>
										</xsl:element>
									</xsl:if>	
								</xsl:element>

							</xsl:element>							

						</xsl:element>

						<xsl:element name="avpList">						
							<xsl:element name="eComStringAttributeValuePairList">
								<xsl:attribute name="attributeName"><xsl:text>freightClassCode</xsl:text></xsl:attribute>
								<xsl:value-of select="ItemDetails/ClassificationCodes/@NMFCClass"/>			
							</xsl:element>																	
							<xsl:element name="eComStringAttributeValuePairList">						
								<xsl:attribute name="attributeName"><xsl:text>unitNetVolume</xsl:text></xsl:attribute>
								<xsl:attribute name="qualifierCodeName">
									<!-- <xsl:value-of select="ItemDetails/PrimaryInformation/@UnitVolumeUOM"/> -->
									<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMUOM', $VolumeUOM)"/>
								</xsl:attribute> 									
								<xsl:attribute name="qualifierCodeList">
									<xsl:text>MeasurementUnitCode</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="ItemDetails/PrimaryInformation/@UnitVolume"/>													
							</xsl:element>							
						</xsl:element>	

					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</order:orderMessage>
	</xsl:template>
</xsl:stylesheet>