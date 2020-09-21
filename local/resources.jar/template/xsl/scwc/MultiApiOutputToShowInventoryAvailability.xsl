<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<!-- @generated mapFile="xslt/MultiApiOutputToShowInventoryAvailability.map" md5sum="c075f4721ce9e1ad459da24b8ef8a780" version="7.0.401" -->
<!--

*****************************************************************************
*   This file has been generated by the IBM XML Mapping Editor V7.0.401
*
*   Mapping file:		MultiApiOutputToShowInventoryAvailability.map
*   Map declaration(s):	MultiApiOutputToShowInventoryAvailability
*   Input file(s):		smo://smo/name%3Dwsdl-primary/correlationContext%3D%257Bhttp%253A%252F%252FWCToSSFSMediationModule%257DGetInvAvlMultiApiCorrelationContextType/message%3D%257Bhttp%253A%252F%252FWCToSSFSMediationModule%252FSSFSHttpPostInterface%257DmultiApiResponseMsg/xpath%3D%252F/smo.xsd
*   Output file(s):		smo://smo/name%3Dwsdl-primary/correlationContext%3D%257Bhttp%253A%252F%252FWCToSSFSMediationModule%257DGetInvAvlMultiApiCorrelationContextType/message%3D%257Bhttp%253A%252F%252Fwww.ibm.com%252Fxmlns%252Fprod%252Fcommerce%252F9%252Finventory%257DShowInventoryAvailability/xpath%3D%252F/smo.xsd
*   XSLT import(s):   	custom/MultiApiOutputToShowInventoryAvailability.xsl
*
*   Note: Do not modify the contents of this file as it is overwritten
*         each time the mapping model is updated.
*****************************************************************************
-->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xalan="http://xml.apache.org/xslt"
    xmlns:str="http://exslt.org/strings"
    xmlns:set="http://exslt.org/sets"
    xmlns:math="http://exslt.org/math"
    xmlns:exsl="http://exslt.org/common"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:in="http://www.sterlingcommerce.com/documentation/MasterOrder"
    xmlns:in2="http://www.sterlingcommerce.com/documentation/YFSError"
    xmlns:in3="http://www.sterlingcommerce.com/documentation/YFS/findInventory/input"
    xmlns:in4="http://www.sterlingcommerce.com/documentation/YFS/getOrderLineDetails/output"
    xmlns:in5="http://www.sterlingcommerce.com/documentation/YCP/multiApi/input"
    xmlns:in6="http://www.sterlingcommerce.com/documentation/YCP/getPage/input"
    xmlns:in7="http://WCToSSFSMediationModule/multiApi"
    xmlns:in8="http://WCToSSFSMediationModule/findInventory"
    xmlns:in9="http://WCToSSFSMediationModule/SSFSHttpPostInterface"
    xmlns:in10="http://www.sterlingcommerce.com/documentation/YFS/reserveAvailableInventory/input"
    xmlns:in11="wsdl.http://WCToSSFSMediationModule/SSFSHttpPostInterface"
    xmlns:in12="http://WCToSSFSMediationModule/reserveAvailableInventory"
    xmlns:in13="http://www.sterlingcommerce.com/documentation/YFS/getOrderLineDetails/input"
    xmlns:in14="http://WCToSSFSMediationModule/getOrderLineDetails"
    xmlns:in15="http://WCToSSFSMediationModule/documentation/SterlingResponseRoot"
    xmlns:in16="http://www.sterlingcommerce.com/documentation/YFS/monitorItemAvailability/input"
    xmlns:in17="http://www.sterlingcommerce.com/documentation/YFS/reserveAvailableInventory/output"
    xmlns:in18="http://WCToSSFSMediationModule/getPage"
    xmlns:in19="http://WCToSSFSMediationModule/monitorItemAvailability"
    xmlns:in20="http://www.sterlingcommerce.com/documentation/YFS/monitorItemAvailability/output"
    xmlns:in21="http://www.sterlingcommerce.com/documentation/YCP/multiApi/output"
    xmlns:in22="http://www.sterlingcommerce.com/documentation/YCP/getPage/output"
    xmlns:in23="http://www.sterlingcommerce.com/documentation/YFS/findInventory/output"
    xmlns:io3="http://www.w3.org/2003/05/soap-envelope"
    xmlns:io4="http://www.ibm.com/websphere/sibx/smo/v6.0.1"
    xmlns:out="http://www.openapplications.org/oagis/9"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:out5="http://www.ibm.com/xmlns/prod/commerce/9/inventory"
    xmlns:out6="http://www.openapplications.org/oagis/9/currencycode/54217:2001"
    xmlns:out7="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
    xmlns:out8="wsdl.http://www.ibm.com/xmlns/prod/commerce/9/inventory"
    xmlns:io="http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0"
    xmlns:io2="http://schemas.xmlsoap.org/ws/2004/08/addressing"
    xmlns:io5="http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0"
    xmlns:out9="http://www.openapplications.org/oagis/9/unitcode/66411:2001"
    xmlns:out2="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
    xmlns:out3="http://www.openapplications.org/oagis/9/languagecode/5639:1988"
    xmlns:xsd4xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:io6="http://www.w3.org/2005/08/addressing"
    xmlns:io7="http://WCToSSFSMediationModule"
    xmlns:out4="http://www.openapplications.org/oagis/9/IANAMIMEMediaTypes:2003"
    xmlns:map="http://WCToSSFSMediationModule/xslt/MultiApiOutputToShowInventoryAvailability"
    exclude-result-prefixes="in10 in11 in12 in13 math in14 in15 in16 in17 exsl in18 in19 xalan map set in20 in21 in in22 in23 in2 date in3 in4 in5 in6 str in7 in8 in9"
    version="1.0">

  <!-- imports  -->
  <xsl:import href="template/xsl/scwc/custom/MultiApiOutputToShowInventoryAvailability.xsl"/>
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>
  
  <!-- root template  -->
  <xsl:template match="/ResponseData/Body/MultiApi">
  <!-- 
    <xsl:apply-templates select="io4:smo" mode="map:MultiApiOutputToShowInventoryAvailability"/>
     -->
     <xsl:variable name="Root" select="/ResponseData/Body"/>
     <xsl:variable name="correlation" select="/ResponseData/context/correlation"/>
     <xsl:call-template name="RootToShowInventoryAvailability">
          <xsl:with-param name="Root" select="$Root"/>
          <xsl:with-param name="correlation" select="$correlation"/>
     </xsl:call-template>
  </xsl:template>

  <!-- This rule represents an element mapping: "io4:smo" to "io4:smo".  -->
  <xsl:template match="io4:smo"  mode="map:MultiApiOutputToShowInventoryAvailability">
    <io4:smo>
      <!-- a structural mapping: "context"(<Anonymous>) to "context"(<Anonymous>) -->
      <xsl:copy-of select="context"/>
      <!-- a structural mapping: "headers"(HeadersType) to "headers"(HeadersType) -->
      <xsl:copy-of select="headers"/>
      <body>
        <xsl:attribute name="xsi:type">
          <xsl:value-of select="'out8:ShowInventoryAvailability'"/>
        </xsl:attribute>
        <!-- a structural mapping: "body/in9:multiApiResponse/Root"(ResponseRootType_multiApi) to "out5:ShowInventoryAvailability"(ShowInventoryAvailabilityType) -->
        <!-- variables for custom code -->
        <xsl:variable name="Root" select="body/in9:multiApiResponse/Root"/>
        <xsl:variable name="correlation" select="context/correlation"/>
        <xsl:call-template name="RootToShowInventoryAvailability">
          <xsl:with-param name="Root" select="$Root"/>
          <xsl:with-param name="correlation" select="$correlation"/>
        </xsl:call-template>
      </body>
    </io4:smo>
  </xsl:template>

  <!-- This rule represents a type mapping: "io4:smo" to "io4:smo".  -->
  <xsl:template name="map:MultiApiOutputToShowInventoryAvailability2">
    <xsl:param name="smo"/>
    <!-- a structural mapping: "$smo/context"(<Anonymous>) to "context"(<Anonymous>) -->
    <xsl:copy-of select="$smo/context"/>
    <!-- a structural mapping: "$smo/headers"(HeadersType) to "headers"(HeadersType) -->
    <xsl:copy-of select="$smo/headers"/>
    <body>
      <xsl:attribute name="xsi:type">
        <xsl:value-of select="'out8:ShowInventoryAvailability'"/>
      </xsl:attribute>
      <!-- a structural mapping: "$smo/body/in9:multiApiResponse/Root"(ResponseRootType_multiApi) to "out5:ShowInventoryAvailability"(ShowInventoryAvailabilityType) -->
      <!-- variables for custom code -->
      <xsl:variable name="Root" select="$smo/body/in9:multiApiResponse/Root"/>
      <xsl:variable name="correlation" select="$smo/context/correlation"/>
      <xsl:call-template name="RootToShowInventoryAvailability">
        <xsl:with-param name="Root" select="$Root"/>
        <xsl:with-param name="correlation" select="$correlation"/>
      </xsl:call-template>
    </body>
  </xsl:template>

  <!-- *****************    Utility Templates    ******************  -->
  <!-- copy the namespace declarations from the source to the target -->
  <xsl:template name="copyNamespaceDeclarations">
    <xsl:param name="root"/>
    <xsl:for-each select="$root/namespace::*">
      <xsl:copy/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
