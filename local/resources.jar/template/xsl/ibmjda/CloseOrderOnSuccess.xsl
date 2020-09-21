<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
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
	<xsl:template name="CloseOrderOnSuccess" match="/">
		<xsl:variable name="datetimepattern">yyyy-MM-dd'T'HH:mm:ssXXX</xsl:variable>
		<xsl:variable name="dateformat" select="SimpleDateFormat:new('yyyy-MM-ddXXX')"/>
		<xsl:variable name="timeformat" select="SimpleDateFormat:new('HH:mm:ss.S')"/>
		<xsl:variable name="datetimeformat" select="SimpleDateFormat:new($datetimepattern)"/>
		<xsl:variable name="creationdatetimepattern">yyyy-MM-dd'T'HH:mm:ss.SXXX</xsl:variable>
		<xsl:variable name="creationdatetimeformat" select="SimpleDateFormat:new($creationdatetimepattern)"/>
		<xsl:variable name="OrganizationCode">
			<xsl:value-of select="/Order/@SellerOrganizationCode"/>
		</xsl:variable>
		<xsl:variable name="ExtOrganizationCode">
			<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, 'DEFAULT', 'jdaToIBMOrganizationCode', $OrganizationCode)"/>
		</xsl:variable>
		<xsl:variable name="instanceIdentifierPattern">HHmmss</xsl:variable>
		<xsl:variable name="instanceIdentifierFormat" select="SimpleDateFormat:new($instanceIdentifierPattern)"/>
		<xsl:variable name="instanceIdentifierTimeValue" select="SimpleDateFormat:format($instanceIdentifierFormat,Date:new())"/>
		<xsl:variable name="orderHeaderKeyValue" select="/Order/@OrderHeaderKey"/>
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
						<xsl:text>DMD.GLOBAL</xsl:text>
					</xsl:element>
				</xsl:element>
				<xsl:element name="sh:Receiver">
					<xsl:element name="sh:Identifier">
						<xsl:attribute name="Authority">
							<xsl:text>ENTERPRISE</xsl:text>
						</xsl:attribute>
						<xsl:text>WFMR.GLOBAL</xsl:text>
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
						<xsl:value-of select="concat($orderHeaderKeyValue,$instanceIdentifierTimeValue)"/>
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
							<xsl:text>OrderClose 1.0.0</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>	
			<xsl:element name="order">	
				<xsl:element name="creationDateTime">	
					<xsl:value-of select="/Order/@Createts"/>
				</xsl:element>
				<xsl:element name="documentStatusCode">
					<!-- Hardcoded value required by xsd verification-->
					<xsl:text>ORIGINAL</xsl:text>
				</xsl:element>
				<xsl:element name="documentActionCode">
					<xsl:text>ADD</xsl:text>
				</xsl:element>
				<xsl:variable name="EntryType">
					<xsl:value-of select="/Order/@EntryType" />
				</xsl:variable>
				<xsl:element name="avpList">
					<xsl:element name="eComStringAttributeValuePairList">
						<xsl:attribute name="attributeName">
							<xsl:text>orderEntryCode</xsl:text>						
						</xsl:attribute>
						<xsl:attribute name="qualifierCodeList">
							<xsl:text>OrderEntryTypeCode</xsl:text>						
						</xsl:attribute>
						<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMEntryType', $EntryType)"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="orderIdentification">
					<xsl:element name="entityIdentification">	
						<xsl:value-of select="/Order/@OrderHeaderKey"/>
					</xsl:element>
				</xsl:element>
				<xsl:variable name="docType">
					<xsl:value-of select="/Order/@DocumentType" />
				</xsl:variable>
				<xsl:variable name="orderType">
					<xsl:value-of select="/Order/@OrderType" />
				</xsl:variable>
				<xsl:element name="orderTypeCode">
					<xsl:choose>
						<xsl:when test="$docType = '0001' ">
							<xsl:text>10002</xsl:text>
						</xsl:when>
						<xsl:when test="$docType = '0003' ">
							<xsl:text>10003</xsl:text>
						</xsl:when>
						<xsl:when test="$docType = '0006' and $orderType != '150_HOSTTO'">
							<xsl:text>10004</xsl:text>
						</xsl:when>
						<xsl:when test="$docType = '0006' and $orderType='150_HOSTTO'">
							<xsl:text>10005</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:element>
				<!--<xsl:element name="orderTypeCode">
					<xsl:text>220</xsl:text>
				</xsl:element>-->
				<xsl:element name="buyer">
					<xsl:if test="normalize-space(/Order/@BillToID) !=''">					
						<xsl:element name="additionalPartyIdentification">
							<!-- Hardcoded value required by xsd verification-->
							<xsl:attribute name="additionalPartyIdentificationTypeCode">
								<xsl:text>UNKNOWN</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="/Order/@BillToID"/>
						</xsl:element>
					</xsl:if>
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
				<xsl:variable name="personInfoBillToHasAttrWvalue">
					<xsl:value-of select="count(/Order/PersonInfoBillTo/@*[normalize-space(string(.))])" />
				</xsl:variable>
				<xsl:if test="normalize-space(/Order/@CustomerContactID) !='' or $personInfoBillToHasAttrWvalue != 0">
					<xsl:element name="billTo">
						<xsl:if test="normalize-space(/Order/@CustomerContactID) !=''">
							<xsl:element name="additionalPartyIdentification">
								<!-- Hardcoded value required by xsd verification-->
								<xsl:attribute name="additionalPartyIdentificationTypeCode">
									<xsl:text>UNKNOWN</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="/Order/@CustomerContactID"/>
							</xsl:element>
						</xsl:if>
						<xsl:variable name="billToaddressHasAttrWvalue">
							<xsl:value-of select="count(/Order/PersonInfoBillTo/@*[name()!='JobTitle' and name()!='DayPhone' and name()!='EMailID' and name()!='DayFaxNo'][normalize-space(string(.))])" />
						</xsl:variable>
						<xsl:if test="$billToaddressHasAttrWvalue !=0">
							<xsl:element name="address">
								<xsl:if test="normalize-space(/Order/PersonInfoBillTo/@City) != ''">
									<xsl:element name="city">
										<xsl:value-of select="/Order/PersonInfoBillTo/@City"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/Order/PersonInfoBillTo/@Country) != ''">
									<xsl:element name="countryCode">
										<xsl:value-of select="/Order/PersonInfoBillTo/@Country"/>
									</xsl:element>
								</xsl:if>
								<xsl:variable name="firstLastName">
									<xsl:value-of select="normalize-space(concat(/Order/PersonInfoBillTo/@FirstName,' ',/Order/PersonInfoBillTo/@LastName))"/>
								</xsl:variable>
								<xsl:if test="$firstLastName != ''">
									<xsl:element name="name">
										<xsl:value-of select="$firstLastName"/>
									</xsl:element>
								</xsl:if>							
								<xsl:if test="normalize-space(/Order/PersonInfoBillTo/@ZipCode) != ''">
									<xsl:element name="postalCode">
										<xsl:value-of select="/Order/PersonInfoBillTo/@ZipCode"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/Order/PersonInfoBillTo/@State) != ''">
									<xsl:element name="state">
										<xsl:value-of select="/Order/PersonInfoBillTo/@State"/>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:if>
				<xsl:element name="orderLogisticalInformation">
					<xsl:variable name="ShipNode">
						<xsl:value-of select="/Order/@ShipNode"/>
					</xsl:variable>
					<xsl:element name="shipFrom">
						<xsl:if test="normalize-space($ShipNode) != ''">
							<xsl:element name="additionalPartyIdentification">
								<!-- Hardcoded value required by xsd verification-->
								<xsl:attribute name="additionalPartyIdentificationTypeCode">
									<xsl:text>UNKNOWN</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ShipNode)"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
					<xsl:element name="shipTo">								
						<xsl:variable name="shipToaddressHasAttrWvalue">
							<xsl:value-of select="count(/Order/PersonInfoShipTo/@*[name()!='JobTitle' and name()!='DayPhone' and name()!='EMailID' and name()!='DayFaxNo'][normalize-space(string(.))])" />
						</xsl:variable>
						<xsl:if test="$shipToaddressHasAttrWvalue !=0">
							<xsl:element name="address">
								<xsl:if test="normalize-space(/Order/PersonInfoShipTo/@City) != ''">
									<xsl:element name="city">
										<xsl:value-of select="/Order/PersonInfoShipTo/@City"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/Order/PersonInfoShipTo/@Country) != ''">
									<xsl:element name="countryCode">
										<xsl:value-of select="/Order/PersonInfoShipTo/@Country"/>
									</xsl:element>
								</xsl:if>
								<xsl:variable name="firstLastName">
									<xsl:value-of select="normalize-space(concat(/Order/PersonInfoShipTo/@FirstName,' ',/Order/PersonInfoShipTo/@LastName))"/>
								</xsl:variable>
								<xsl:if test="$firstLastName != ''">
									<xsl:element name="name">
										<xsl:value-of select="$firstLastName"/>
									</xsl:element>
								</xsl:if>							
								<xsl:if test="normalize-space(/Order/PersonInfoShipTo/@ZipCode) != ''">
									<xsl:element name="postalCode">
										<xsl:value-of select="/Order/PersonInfoShipTo/@ZipCode"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/Order/PersonInfoShipTo/@State) != ''">
									<xsl:element name="state">
										<xsl:value-of select="/Order/PersonInfoShipTo/@State"/>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
					</xsl:element>	
				</xsl:element>
				<xsl:for-each select="/Order/OrderLines/OrderLine">
					<xsl:variable name="PersonInfoShipTo" select="PersonInfoShipTo"/>
					<xsl:variable name="DeliveryMethod">
						<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMDeliveryMethodCode', @DeliveryMethod)"/>
					</xsl:variable>
					<xsl:variable name="ItemDetails" select="ItemDetails"/>
					<xsl:element name="orderLineItem">
						<xsl:element name="lineItemNumber">
							<xsl:value-of select="@PrimeLineNo"/>
						</xsl:element>						
						<xsl:element name="requestedQuantity">
							<xsl:value-of select="@OriginalOrderedQty"/>
						</xsl:element>
						<xsl:element name="transactionalTradeItem">
							<xsl:element name="gtin">
								<!-- Hardcoded Value to pass xsd verification-->
								<xsl:text>00000000000000</xsl:text>
							</xsl:element>
							<xsl:element name="additionalTradeItemIdentification">
								<!-- Hardcoded value required by xsd verification-->
								<xsl:attribute name="additionalTradeItemIdentificationTypeCode">
									<xsl:text>BUYER_ASSIGNED</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="ItemDetails/@ItemID"/>
							</xsl:element>
						</xsl:element>
						<xsl:for-each select="Schedules/Schedule">
							<xsl:variable name="scheduleQuantity">
								<xsl:value-of select="@Quantity"/>
							</xsl:variable>
							<xsl:if test="$scheduleQuantity &gt; 0">
								<xsl:variable name="reqDeliveryDate">
									<xsl:value-of select="@ExpectedDeliveryDate"/>
								</xsl:variable>
								<xsl:variable name="reqShipDate">
									<xsl:value-of select="@ExpectedShipmentDate"/>
								</xsl:variable>
								<xsl:element name="orderLineItemDetail">
									<xsl:element name="requestedQuantity">									
										<xsl:value-of select="$scheduleQuantity"/>
									</xsl:element>
									<xsl:element name="orderLogisticalInformation">
										<xsl:variable name="ShipNode">
											<xsl:value-of select="@ShipNode"/>
										</xsl:variable>
										<xsl:element name="shipFrom">
											<xsl:if test="normalize-space($ShipNode) != ''">
												<xsl:element name="additionalPartyIdentification">
													<!-- Hardcoded value required by xsd verification-->
													<xsl:attribute name="additionalPartyIdentificationTypeCode">
														<xsl:text>UNKNOWN</xsl:text>
													</xsl:attribute>
													<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ShipNode)"/>
												</xsl:element>
											</xsl:if>											
										</xsl:element>
										<xsl:element name="shipTo">							
											<xsl:variable name="shipToaddressHasAttrWvalue">
												<xsl:value-of select="count($PersonInfoShipTo/@*[name()!='JobTitle' and name()!='DayPhone' and name()!='EMailID' and name()!='DayFaxNo'][normalize-space(string(.))])" />
											</xsl:variable>
											<xsl:if test="$shipToaddressHasAttrWvalue !=0">
												<xsl:element name="address">
													<xsl:if test="normalize-space($PersonInfoShipTo/@City) != ''">
														<xsl:element name="city">
															<xsl:value-of select="$PersonInfoShipTo/@City"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="normalize-space($PersonInfoShipTo/@Country) != ''">
														<xsl:element name="countryCode">
															<xsl:value-of select="$PersonInfoShipTo/@Country"/>
														</xsl:element>
													</xsl:if>
													<xsl:variable name="firstLastName">
														<xsl:value-of select="normalize-space(concat($PersonInfoShipTo/@FirstName,' ',$PersonInfoShipTo/@LastName))"/>
													</xsl:variable>
													<xsl:if test="$firstLastName != ''">
														<xsl:element name="name">
															<xsl:value-of select="$firstLastName"/>
														</xsl:element>
													</xsl:if>							
													<xsl:if test="normalize-space($PersonInfoShipTo/@ZipCode) != ''">
														<xsl:element name="postalCode">
															<xsl:value-of select="$PersonInfoShipTo/@ZipCode"/>
														</xsl:element>
													</xsl:if>
													<xsl:if test="normalize-space($PersonInfoShipTo/@State) != ''">
														<xsl:element name="state">
															<xsl:value-of select="$PersonInfoShipTo/@State"/>
														</xsl:element>
													</xsl:if>
												</xsl:element>
											</xsl:if>											
										</xsl:element>					
										<xsl:element name="orderLogisticalDateInformation">
											<xsl:if test="normalize-space($reqDeliveryDate) !=''">														
												<xsl:variable name="deliverydatetime" select="SimpleDateFormat:parse($datetimeformat,$reqDeliveryDate)"/>
												<xsl:element name="requestedDeliveryDateTime">
													<xsl:if test="normalize-space(SimpleDateFormat:format($dateformat,$deliverydatetime)) !=''">
														<xsl:element name="date">
															<xsl:value-of select="SimpleDateFormat:format($dateformat,$deliverydatetime)" />							
														</xsl:element>
													</xsl:if>
													<xsl:if test="normalize-space(SimpleDateFormat:format($timeformat,$deliverydatetime)) !=''">
														<xsl:element name="time">								
															<xsl:value-of select="SimpleDateFormat:format($timeformat,$deliverydatetime)" />								
														</xsl:element>
													</xsl:if>
												</xsl:element>
											</xsl:if>
											<xsl:if test="normalize-space($reqShipDate) !=''">							
												<xsl:variable name="shipdatetime" select="SimpleDateFormat:parse($datetimeformat,$reqShipDate)"/>					
												<xsl:element name="requestedShipDateTime">	
													<xsl:if test="normalize-space(SimpleDateFormat:format($dateformat,$shipdatetime)) !=''">													
														<xsl:element name="date">
															<xsl:value-of select="SimpleDateFormat:format($dateformat,$shipdatetime)" />							
														</xsl:element>
													</xsl:if>
													<xsl:if test="normalize-space(SimpleDateFormat:format($timeformat,$shipdatetime)) !=''">
														<xsl:element name="time">								
															<xsl:value-of select="SimpleDateFormat:format($timeformat,$shipdatetime)" />								
														</xsl:element>
													</xsl:if>
												</xsl:element>
											</xsl:if>
										</xsl:element>
									</xsl:element>
									<xsl:element name="avpList">
										<xsl:element name="eComStringAttributeValuePairList">
											<xsl:attribute name="attributeName">
												<xsl:text>deliveryMethodCode</xsl:text>						
											</xsl:attribute>
											<xsl:attribute name="qualifierCodeList">									
												<xsl:text>DeliveryMethodTypeCode</xsl:text>		
											</xsl:attribute>	
											<xsl:value-of select="$DeliveryMethod" />											
										</xsl:element>
										<xsl:variable name="orderLineScheduleKey_Schedule">
											<xsl:value-of select="@OrderLineScheduleKey"/>
										</xsl:variable>	
										<xsl:for-each select="/Order/OrderLines/OrderLine/OrderStatuses/OrderStatus">
											<xsl:if test="$orderLineScheduleKey_Schedule=@OrderLineScheduleKey and @Status!= '9000'">
												<xsl:element name="eComStringAttributeValuePairList">
													<xsl:attribute name="attributeName">
														<xsl:text>actualExecutionDateTime</xsl:text>						
													</xsl:attribute>	
													<xsl:value-of select="@StatusDate" />											
												</xsl:element>
												<xsl:element name="eComStringAttributeValuePairList">
													<xsl:attribute name="attributeName">
														<xsl:text>actualQuantity</xsl:text>						
													</xsl:attribute>	
													<xsl:value-of select="@StatusQty" />											
												</xsl:element>
												<xsl:element name="eComStringAttributeValuePairList">
													<xsl:attribute name="attributeName">
														<xsl:text>orderReleaseKey</xsl:text>						
													</xsl:attribute>	
													<xsl:value-of select="@OrderReleaseKey" />											
												</xsl:element>
											</xsl:if>
										</xsl:for-each>		
									</xsl:element>
								</xsl:element>							
							</xsl:if>
						</xsl:for-each>
					</xsl:element>					
				</xsl:for-each>
			</xsl:element>
		</order:orderMessage>
	</xsl:template>
</xsl:stylesheet>