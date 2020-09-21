<?xml version="1.0" encoding="UTF-8"?>
<!--
	Licensed Materials - Property of IBM
	IBM Sterling Order Management (5725-D10)
	IBM Sterling Configure Price Quote (5725-D11)
	(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
	US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:in="http://www.openapplications.org/oagis/9" xmlns:in5="http://www.ibm.com/xmlns/prod/commerce/9/inventory" xmlns:in6="http://www.openapplications.org/oagis/9/currencycode/54217:2001" xmlns:in7="http://www.ibm.com/xmlns/prod/commerce/9/foundation" xmlns:in8="wsdl.http://www.ibm.com/xmlns/prod/commerce/9/inventory" xmlns:in2="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1" xmlns:in3="http://www.openapplications.org/oagis/9/languagecode/5639:1988" xmlns:in9="http://www.openapplications.org/oagis/9/unitcode/66411:2001" xmlns:in4="http://www.openapplications.org/oagis/9/IANAMIMEMediaTypes:2003" xmlns:out="http://www.sterlingcommerce.com/documentation/MasterOrder" xmlns:out2="http://www.sterlingcommerce.com/documentation/YFSError" xmlns:out3="http://www.sterlingcommerce.com/documentation/YFS/getOrderLineDetails/output" xmlns:out4="http://www.sterlingcommerce.com/documentation/YCP/multiApi/input" xmlns:out5="http://www.sterlingcommerce.com/documentation/YFS/cancelReservation/output" xmlns:out6="http://WCToSSFSMediationModule/multiApi" xmlns:io="http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0" xmlns:io2="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:out7="http://www.sterlingcommerce.com/documentation/YFS/reserveAvailableInventory/input" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:out8="http://WCToSSFSMediationModule/reserveAvailableInventory" xmlns:io3="http://www.w3.org/2003/05/soap-envelope" xmlns:io4="http://www.ibm.com/websphere/sibx/smo/v6.0.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:out9="wsdl.http://WCToSSFSMediationModule/SSFSInventoryHTTPInterface" xmlns:out10="http://WCToSSFSMediationModule/documentation/SterlingResponseRoot" xmlns:out11="http://WCToSSFSMediationModule/SSFSInventoryHTTPInterface" xmlns:out12="http://www.sterlingcommerce.com/documentation/YFS/reserveAvailableInventory/output" xmlns:io5="http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0" xmlns:out13="http://www.sterlingcommerce.com/documentation/YFS/monitorItemAvailability/output" xmlns:io6="http://www.w3.org/2005/08/addressing" xmlns:out14="http://www.sterlingcommerce.com/documentation/YCP/multiApi/output" xmlns:out15="http://www.sterlingcommerce.com/documentation/YCP/getPage/output" xmlns:io7="http://WCToSSFSMediationModule" xmlns:out16="http://www.sterlingcommerce.com/documentation/YFS/findInventory/output" exclude-result-prefixes="xalan" version="1.0">
  <!-- imports -->
  <xsl:import href="template/xsl/scwc/custom/GetInventoryAvailabilityToCorrelationContext.xsl"/>
  <xsl:import href="template/xsl/scwc/custom/GetInventoryAvailabilityToMultiApiHTTPInput.xsl"/>
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>
  <!-- root template -->
  <xsl:template match="/">
    <RequestData>
      <context>
        <correlation>
          <xsl:variable name="GetInventoryAvailability1" select="in5:GetInventoryAvailability"/>
          <xsl:call-template name="GetInventoryAvailabilityToCorrelation">
            <xsl:with-param name="GetInventoryAvailability1" select="$GetInventoryAvailability1"/>
          </xsl:call-template>
        </correlation>
        <!-- a structural mapping: "context/transient"(anyType) to "transient"(anyType) -->
        <xsl:if test="context/transient">
          <xsl:copy-of select="context/transient"/>
        </xsl:if>
        <!-- a structural mapping: "context/failInfo"(FailInfoType) to "failInfo"(FailInfoType) -->
        <xsl:if test="context/failInfo">
          <xsl:copy-of select="context/failInfo"/>
        </xsl:if>
        <!-- a structural mapping: "context/primitiveContext"(PrimitiveContextType) to "primitiveContext"(PrimitiveContextType) -->
        <xsl:if test="context/primitiveContext">
          <xsl:copy-of select="context/primitiveContext"/>
        </xsl:if>
        <!-- a structural mapping: "context/shared"(anyType) to "shared"(anyType) -->
        <xsl:if test="context/shared">
          <xsl:copy-of select="context/shared"/>
        </xsl:if>
        <!-- a structural mapping: "context/dynamicProperty"(DynamicPropertyContextType) to "dynamicProperty"(DynamicPropertyContextType) -->
        <xsl:if test="context/dynamicProperty">
          <xsl:copy-of select="context/dynamicProperty"/>
        </xsl:if>
        <!-- a structural mapping: "context/userContext"(UserContextType) to "userContext"(UserContextType) -->
        <xsl:if test="context/userContext">
          <xsl:copy-of select="context/userContext"/>
        </xsl:if>
      </context>
      <body>
        <xsl:attribute name="xsi:type">
          <xsl:value-of select="'out11:multiApiRequestMsg'"/>
        </xsl:attribute>
        <xsl:variable name="GetInventoryAvailability" select="in5:GetInventoryAvailability"/>
        <xsl:call-template name="GetInventoryAvailabilityToApiInput">
          <xsl:with-param name="GetInventoryAvailability" select="$GetInventoryAvailability"/>
        </xsl:call-template>
      </body>
    </RequestData>
  </xsl:template>
  <!-- ***************** Utility Templates ****************** -->
  <!-- copy the namespace declarations from the source to the target -->
  <xsl:template name="copyNamespaceDeclarations">
    <xsl:param name="root"/>
    <xsl:for-each select="$root/namespace::*">
      <xsl:copy/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>