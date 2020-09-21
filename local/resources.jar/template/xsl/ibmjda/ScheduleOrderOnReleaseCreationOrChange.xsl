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
	<xsl:template name="ScheduleOnReleaseCreationOrChange" match="/">
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
							<xsl:text>ReturnOrder 1.0.0</xsl:text>
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
						<xsl:value-of select="/OrderRelease/OrderLine/@DerivedFromOrderHeaderKey"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="orderIdentification">
					<xsl:element name="entityIdentification">	
						<xsl:value-of select="/OrderRelease/@OrderReleaseKey"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="orderTypeCode">
					<xsl:text>10001</xsl:text>
				</xsl:element>
				<xsl:element name="buyer">
					<xsl:element name="additionalPartyIdentification">
						<!-- Hardcoded value required by xsd verification-->
						<xsl:attribute name="additionalPartyIdentificationTypeCode">
							<xsl:text>UNKNOWN</xsl:text>
						</xsl:attribute>
						<xsl:text>&#160;</xsl:text>
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
				<xsl:element name="orderLogisticalInformation">
					<!--xsl:variable name="ReleaseCarrier">
						<xsl:value-of select="/OrderRelease/@SCAC"/>
					</xsl:variable-->
					<xsl:variable name="personInfoShipToHasAttrWValue">
						<xsl:value-of select="count(/OrderRelease/PersonInfoShipTo/@*[normalize-space(string(.))])" />
					</xsl:variable>
					<xsl:if test="normalize-space(/OrderRelease/@ShipToId) != '' or $personInfoShipToHasAttrWValue != 0">
						<xsl:element name="shipFrom">
							<xsl:if test="normalize-space(/OrderRelease/@ShipToId) != ''">
								<xsl:element name="additionalPartyIdentification">
									<!-- Hardcoded value required by xsd verification-->
									<xsl:attribute name="additionalPartyIdentificationTypeCode">
										<xsl:text>UNKNOWN</xsl:text>
									</xsl:attribute>
									<xsl:value-of select="/OrderRelease/@ShipToId"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="$personInfoShipToHasAttrWValue != 0">
								<xsl:element name="address">
									<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@City) != ''">
										<xsl:element name="city">
											<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@City"/>
										</xsl:element>
									</xsl:if>
									<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@Country) != ''">
										<xsl:element name="countryCode">
											<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@Country"/>
										</xsl:element>
									</xsl:if>
									<xsl:variable name="firstLastName">
										<xsl:value-of select="normalize-space(concat(/OrderRelease/PersonInfoShipTo/@FirstName,' ',/OrderRelease/PersonInfoShipTo/@LastName))"/>
									</xsl:variable>
									<xsl:if test="$firstLastName != ''">
										<xsl:element name="name">
											<xsl:value-of select="$firstLastName" />
										</xsl:element>
									</xsl:if>
									<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@ZipCode) != ''">
										<xsl:element name="postalCode">
											<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@ZipCode"/>
										</xsl:element>		
									</xsl:if>
									<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@State) != ''">			
										<xsl:element name="state">
											<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@State"/>
										</xsl:element>
									</xsl:if>
									<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@AddressLine1) != ''">
										<xsl:element name="streetAddressOne">
											<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@AddressLine1"/>
										</xsl:element>
									</xsl:if>
									<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@AddressLine2) != ''">
										<xsl:element name="streetAddressTwo">
											<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@AddressLine2"/>
										</xsl:element>
									</xsl:if>
									<xsl:if test="normalize-space(/OrderRelease/PersonInfoShipTo/@AddressLine3) != ''">
										<xsl:element name="streetAddressThree">
											<xsl:value-of select="/OrderRelease/PersonInfoShipTo/@AddressLine3"/>
										</xsl:element>
									</xsl:if>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:if>
					<xsl:element name="shipTo">
						<xsl:element name="additionalPartyIdentification">
							<!-- Hardcoded value required by xsd verification-->
							<xsl:attribute name="additionalPartyIdentificationTypeCode">
								<xsl:text>UNKNOWN</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="$ExtShipNode"/>
						</xsl:element>
					</xsl:element>
					<!-- xsl:element name="orderLogisticalDateInformation">							
						<xsl:variable name="dateformat" select="SimpleDateFormat:new('yyyy-MM-dd')"/>
						<xsl:variable name="timeformat" select="SimpleDateFormat:new('HH:mm:ss.SXXX')"/>
						<xsl:variable name="reqDeliveryDate">
							<xsl:value-of select="/OrderRelease/@ReqDeliveryDate"/>
						</xsl:variable>					
						<xsl:variable name="deliverydatetime" select="SimpleDateFormat:parse($datetimeformat,$reqDeliveryDate)"/>					
						<xsl:element name="requestedDeliveryDateTime">
							<xsl:element name="date">
								<xsl:value-of select="SimpleDateFormat:format($dateformat,$deliverydatetime)" />							
							</xsl:element>
							<xsl:element name="time">								
								<xsl:value-of select="SimpleDateFormat:format($timeformat,$deliverydatetime)" />								
							</xsl:element>
						</xsl:element>
					</xsl:element -->
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
						<xsl:variable name="ReturnReasonCode">
							<xsl:value-of select="@ReturnReason"/>
						</xsl:variable>
						<xsl:if test="normalize-space($ReturnReasonCode) != ''">
							<xsl:element name="orderLineItemDetail">
								<xsl:element name="requestedQuantity">
									<xsl:value-of select="@StatusQuantity"/>
								</xsl:element>
								<xsl:element name="orderLogisticalInformation"/>
								<xsl:element name="avpList">
									<xsl:element name="eComStringAttributeValuePairList">
										<xsl:attribute name="attributeName"><xsl:text>returnReasonCode</xsl:text></xsl:attribute>
										<xsl:value-of select="ValueMaps:getValueForMapKey($ibmjda:ValueMapsData, $ReturnReasonCode, 'jdaToIBMReturnReasonCode', $ReturnReasonCode)"/>		
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:if>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</order:orderMessage>
	</xsl:template>
</xsl:stylesheet>