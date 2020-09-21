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
		<xsl:variable name="ShipNode">
			<xsl:value-of select="/OrderRelease/@ShipNode"/>
		</xsl:variable>
		<xsl:variable name="ExtShipNode">
			<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMShipNode', $ShipNode)"/>
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
						<xsl:value-of select="concat('LOC.',$ExtShipNode)"/>						
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
							<xsl:text>OrderRelease 1.0.0</xsl:text>
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
						<xsl:attribute name="attributeName">
							<xsl:text>referenceOrderNumber</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="/OrderRelease/Order/@OrderNo"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="orderIdentification">
					<xsl:element name="entityIdentification">	
						<xsl:value-of select="/OrderRelease/@OrderReleaseKey"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="orderTypeCode">
					<xsl:text>173</xsl:text>
				</xsl:element>
				<xsl:element name="buyer">
					<xsl:element name="additionalPartyIdentification">
						<!-- Hardcoded value required by xsd verification-->
						<xsl:attribute name="additionalPartyIdentificationTypeCode">
							<xsl:text>UNKNOWN</xsl:text>
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="normalize-space(/OrderRelease/@BillToID) !=''">
								<xsl:value-of select="/OrderRelease/@BillToID"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>&#160;</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
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
				<xsl:variable name="personInfoBillToHasAttrWvalue">
					<xsl:value-of select="count(/OrderRelease/Order/PersonInfoBillTo/@*[normalize-space(string(.))])" />
				</xsl:variable>
				<xsl:if test="normalize-space(/OrderRelease/Order/@CustomerContactID) !='' or $personInfoBillToHasAttrWvalue != 0">
					<xsl:element name="billTo">
						<xsl:if test="normalize-space(/OrderRelease/Order/@CustomerContactID) !=''">
							<xsl:element name="additionalPartyIdentification">
								<!-- Hardcoded value required by xsd verification-->
								<xsl:attribute name="additionalPartyIdentificationTypeCode">
									<xsl:text>UNKNOWN</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="/OrderRelease/Order/@CustomerContactID"/>
							</xsl:element>
						</xsl:if>
						<xsl:variable name="billToaddressHasAttrWvalue">
							<xsl:value-of select="count(/OrderRelease/Order/PersonInfoBillTo/@*[name()!='JobTitle' and name()!='DayPhone' and name()!='EMailID' and name()!='DayFaxNo'][normalize-space(string(.))])" />
						</xsl:variable>
						<xsl:if test="$billToaddressHasAttrWvalue !=0">
							<xsl:element name="address">
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@City) !=''">
									<xsl:element name="city">
										<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@City"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@Country) !=''">
									<xsl:element name="countryCode">
										<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@Country"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@FirstName) !='' or normalize-space(/OrderRelease/Order/PersonInfoBillTo/@LastName) !=''">
									<xsl:element name="name">
										<xsl:value-of select="concat(/OrderRelease/Order/PersonInfoBillTo/@FirstName,' ',/OrderRelease/Order/PersonInfoBillTo/@LastName)"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@ZipCode) !=''">
									<xsl:element name="postalCode">
										<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@ZipCode"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@State) !=''">
									<xsl:element name="state">
										<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@State"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@AddressLine1) !=''">
									<xsl:element name="streetAddressOne">
										<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@AddressLine1"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@AddressLine2) !=''">
									<xsl:element name="streetAddressTwo">
										<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@AddressLine2"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@AddressLine3) !=''">
									<xsl:element name="streetAddressThree">
										<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@AddressLine3"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@Latitude) !='' or normalize-space(/OrderRelease/Order/PersonInfoBillTo/@Longitude) !=''">
									<xsl:element name="geographicalCoordinates">
										<xsl:element name="latitude">
											<xsl:choose>
												<xsl:when test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@Latitude) !=''">
													<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@Latitude"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>&#160;</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:element>
										<xsl:element name="longitude">
											<xsl:choose>
												<xsl:when test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@Longitude) !=''">
													<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@Longitude"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>&#160;</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:element>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<xsl:variable name="billTocontactHasAttrWvalue">
							<xsl:value-of select="count(/OrderRelease/Order/PersonInfoBillTo/@*[name()='JobTitle' or name()='DayPhone' or name()='EMailID' or name()='DayFaxNo'][normalize-space(string(.))])" />
						</xsl:variable>
						<xsl:if test="$billTocontactHasAttrWvalue !=0">
							<xsl:element name="contact">
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@JobTitle) !=''">
									<xsl:element name="jobTitle">
										<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@JobTitle"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@DayPhone) !=''">
									<xsl:element name="communicationChannel">
										<xsl:element name="communicationChannelCode">
											<xsl:text>TELEPHONE</xsl:text>
										</xsl:element>
										<xsl:element name="communicationValue">
											<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@DayPhone"/>
										</xsl:element>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@EMailID) !=''">
									<xsl:element name="communicationChannel">
										<xsl:element name="communicationChannelCode">
											<xsl:text>EMAIL</xsl:text>
										</xsl:element>
										<xsl:element name="communicationValue">
											<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@EMailID"/>
										</xsl:element>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/Order/PersonInfoBillTo/@DayFaxNo) !=''">
									<xsl:element name="communicationChannel">
										<xsl:element name="communicationChannelCode">
											<xsl:text>TELEFAX</xsl:text>
										</xsl:element>
										<xsl:element name="communicationValue">
											<xsl:value-of select="/OrderRelease/Order/PersonInfoBillTo/@DayFaxNo"/>
										</xsl:element>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
					</xsl:element>	
				</xsl:if>
				<xsl:element name="orderLogisticalInformation">
					<xsl:element name="shipFrom">
						<xsl:element name="additionalPartyIdentification">
							<!-- Hardcoded value required by xsd verification-->
							<xsl:attribute name="additionalPartyIdentificationTypeCode">
								<xsl:text>UNKNOWN</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="$ExtShipNode"/>
						</xsl:element>
					</xsl:element>
					<xsl:element name="shipTo">
						<xsl:if test="normalize-space(/OrderRelease/@ReceivingNode) !=''">
							<xsl:element name="additionalPartyIdentification">
								<!-- Hardcoded value required by xsd verification-->
								<xsl:attribute name="additionalPartyIdentificationTypeCode">
									<xsl:text>UNKNOWN</xsl:text>
								</xsl:attribute>
								<xsl:value-of select="/OrderRelease/@ReceivingNode"/>
							</xsl:element>
						</xsl:if>
						<xsl:variable name="shipToaddressHasAttrWvalue">
							<xsl:value-of select="count(/OrderRelease/PersonInfoShipTo/@*[name()!='JobTitle' and name()!='DayPhone' and name()!='EMailID' and name()!='DayFaxNo'][normalize-space(string(.))])" />
						</xsl:variable>
						<xsl:if test="$shipToaddressHasAttrWvalue !=0">
							<xsl:element name="address">
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@City) !=''">
									<xsl:element name="city">
										<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@City"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@Country) !=''">
									<xsl:element name="countryCode">
										<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@Country"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@FirstName) !='' or normalize-space(/OrderRelease/PersonInfoShipTo/@LastName) !=''">
									<xsl:element name="name">
										<xsl:value-of select="concat(/OrderRelease/PersonInfoShipTo/@FirstName,' ',/OrderRelease/PersonInfoShipTo/@LastName)"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@ZipCode) !=''">
									<xsl:element name="postalCode">
										<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@ZipCode"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@State) !=''">
									<xsl:element name="state">
										<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@State"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@AddressLine1) !=''">
									<xsl:element name="streetAddressOne">
										<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@AddressLine1"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@AddressLine2) !=''">
									<xsl:element name="streetAddressTwo">
										<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@AddressLine2"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@AddressLine3) !=''">
									<xsl:element name="streetAddressThree">
										<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@AddressLine3"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@Latitude) !='' or normalize-space(/OrderRelease/PersonInfoShipTo/@Longitude) !=''">
									<xsl:element name="geographicalCoordinates">
										<xsl:element name="latitude">
											<xsl:choose>
												<xsl:when test="normalize-space(/OrderRelease/PersonInfoShipTo/@Latitude) !=''">
													<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@Latitude"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>&#160;</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:element>
										<xsl:element name="longitude">
											<xsl:choose>
												<xsl:when test="normalize-space(/OrderRelease/PersonInfoShipTo/@Longitude) !=''">
													<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@Longitude"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>&#160;</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:element>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						<xsl:variable name="shipTocontactHasAttrWvalue">
							<xsl:value-of select="count(/OrderRelease/PersonInfoShipTo/@*[name()='JobTitle' or name()='DayPhone' or name()='EMailID' or name()='DayFaxNo'][normalize-space(string(.))])" />
						</xsl:variable>
						<xsl:if test="$shipTocontactHasAttrWvalue !=0">
							<xsl:element name="contact">
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@JobTitle) !=''">
									<xsl:element name="jobTitle">
										<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@JobTitle"/>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@DayPhone) !=''">
									<xsl:element name="communicationChannel">
										<xsl:element name="communicationChannelCode">
											<xsl:text>TELEPHONE</xsl:text>
										</xsl:element>
										<xsl:element name="communicationValue">
											<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@DayPhone"/>
										</xsl:element>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@EMailID) !=''">
									<xsl:element name="communicationChannel">
										<xsl:element name="communicationChannelCode">
											<xsl:text>EMAIL</xsl:text>
										</xsl:element>
										<xsl:element name="communicationValue">
											<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@EMailID"/>
										</xsl:element>
									</xsl:element>
								</xsl:if>
								<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@DayFaxNo) !=''">
									<xsl:element name="communicationChannel">
										<xsl:element name="communicationChannelCode">
											<xsl:text>TELEFAX</xsl:text>
										</xsl:element>
										<xsl:element name="communicationValue">
											<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@DayFaxNo"/>
										</xsl:element>
									</xsl:element>
								</xsl:if>
							</xsl:element>
						</xsl:if>
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
					<xsl:variable name="OrderCarrierServiceCode">
						<xsl:choose>
							<xsl:when test="normalize-space(/OrderRelease/@CarrierServiceCode)!=''">								
								<xsl:value-of select="/OrderRelease/@CarrierServiceCode"/>							
							</xsl:when>
							<xsl:otherwise>								
								<xsl:value-of select="/OrderRelease/Order/@CarrierServiceCode"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="ReleaseCarrier">
						<xsl:choose>
							<xsl:when test="normalize-space(/OrderRelease/@SCAC)!=''">								
								<xsl:value-of select="/OrderRelease/@SCAC"/>							
							</xsl:when>
							<xsl:otherwise>								
								<xsl:value-of select="/OrderRelease/Order/@SCAC"/>
							</xsl:otherwise>
						</xsl:choose>						
					</xsl:variable>
					<xsl:element name="shipmentTransportationInformation">
						<xsl:element name="transportServiceCategoryType">
						<xsl:choose>
							<xsl:when test="normalize-space(/OrderRelease/@CarrierType)!='PARCEL'">								
								<xsl:text>30</xsl:text>						
							</xsl:when>
							<xsl:otherwise>								
								<xsl:text>100</xsl:text>			
							</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<xsl:if test="normalize-space($OrderCarrierServiceCode) !=''">
							<xsl:element name="transportServiceLevelCode">
								<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMCarrierServiceCode', $OrderCarrierServiceCode)"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="normalize-space($ReleaseCarrier) !=''">
							<xsl:element name="carrier">
								<xsl:element name="additionalPartyIdentification">
									<!-- Hardcoded value required by xsd verification-->
									<xsl:attribute name="additionalPartyIdentificationTypeCode">
										<xsl:text>SCAC</xsl:text>
									</xsl:attribute>
									<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, '', 'jdaToIBMCarrier', $ReleaseCarrier)"/>
								</xsl:element>
							</xsl:element>
						</xsl:if>
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
								<xsl:value-of select="Item/@ItemID"/>
							</xsl:element>
						</xsl:element>
						<xsl:element name="orderLineItemDetail">
							<xsl:element name="requestedQuantity">
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
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</order:orderMessage>
	</xsl:template>
</xsl:stylesheet>