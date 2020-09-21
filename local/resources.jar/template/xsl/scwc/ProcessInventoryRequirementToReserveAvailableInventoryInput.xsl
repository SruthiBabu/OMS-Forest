<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xalan="http://xml.apache.org/xslt"
    xmlns:in="http://www.openapplications.org/oagis/9"
    xmlns:in6="http://www.ibm.com/xmlns/prod/commerce/9/inventory"
    xmlns:in7="http://www.openapplications.org/oagis/9/currencycode/54217:2001"
    xmlns:in8="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
    xmlns:in9="wsdl.http://www.ibm.com/xmlns/prod/commerce/9/inventory"
    xmlns:in2="http://www.ibm.com/xmlns/prod/commerce/9/order"
    xmlns:in10="http://www.openapplications.org/oagis/9/unitcode/66411:2001"
    xmlns:in3="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
    xmlns:in4="http://www.openapplications.org/oagis/9/languagecode/5639:1988"
    xmlns:in5="http://www.openapplications.org/oagis/9/IANAMIMEMediaTypes:2003"
    xmlns:io3="http://www.w3.org/2003/05/soap-envelope"
    xmlns:out="http://www.sterlingcommerce.com/documentation/MasterOrder"
    xmlns:io4="http://www.ibm.com/websphere/sibx/smo/v6.0.1"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:out9="wsdl.http://WCToSSFSMediationModule/SSFSInventoryHTTPInterface"
    xmlns:out2="http://www.sterlingcommerce.com/documentation/YFSError"
    xmlns:out3="http://www.sterlingcommerce.com/documentation/YFS/getOrderLineDetails/output"
    xmlns:out10="http://WCToSSFSMediationModule/documentation/SterlingResponseRoot"
    xmlns:out4="http://www.sterlingcommerce.com/documentation/YCP/multiApi/input"
    xmlns:out5="http://www.sterlingcommerce.com/documentation/YFS/cancelReservation/output"
    xmlns:out6="http://WCToSSFSMediationModule/multiApi"
    xmlns:out12="http://www.sterlingcommerce.com/documentation/YFS/reserveAvailableInventory/output"
    xmlns:out11="http://WCToSSFSMediationModule/SSFSInventoryHTTPInterface"
    xmlns:io="http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0"
    xmlns:io2="http://schemas.xmlsoap.org/ws/2004/08/addressing"
    xmlns:out7="http://www.sterlingcommerce.com/documentation/YFS/reserveAvailableInventory/input"
    xmlns:io5="http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0"
    xmlns:out13="http://www.sterlingcommerce.com/documentation/YFS/monitorItemAvailability/output"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:out15="http://www.sterlingcommerce.com/documentation/YCP/getPage/output"
    xmlns:out14="http://www.sterlingcommerce.com/documentation/YCP/multiApi/output"
    xmlns:io6="http://www.w3.org/2005/08/addressing"
    xmlns:out8="http://WCToSSFSMediationModule/reserveAvailableInventory"
    xmlns:map="http://WCToSSFSMediationModule/xslt/ProcessInventoryRequirementToReserveAvailableInventoryInput"
    xmlns:out16="http://www.sterlingcommerce.com/documentation/YFS/findInventory/output"
    exclude-result-prefixes="xalan"
    version="1.0">

  <!-- imports  -->
  <xsl:import href="template/xsl/scwc/custom/ProcessInventoryRequirementToReserveAvailableInventoryHTTPInput.xsl"/>
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <!-- root template  -->
  <xsl:template match="/">
  <!-- 
    <xsl:apply-templates select="io4:smo" mode="ProcessInventoryRequirementToReserveAvailableInventoryInput"/>
   -->
   <RequestData>
      <body>
        <xsl:variable name="ProcessInventoryRequirement" select="in6:ProcessInventoryRequirement"/>
          <xsl:call-template name="ProcessInventoryRequirementToApiInput_reserveAvailableInventory">
            <xsl:with-param name="ProcessInventoryRequirement" select="$ProcessInventoryRequirement"/>
          </xsl:call-template>
      </body>
      </RequestData> 
  </xsl:template>

  <!-- This rule represents an element mapping: "io4:smo" to "io4:smo".  -->
  <xsl:template match="io4:smo"  mode="ProcessInventoryRequirementToReserveAvailableInventoryInput">
    <io4:smo>
      <!-- a structural mapping: "context"(ContextType) to "context"(ContextType) -->
      <xsl:apply-templates select="context" mode="localContextToContext_216827260"/>
      <!-- a structural mapping: "headers"(HeadersType) to "headers"(HeadersType) -->
      <xsl:apply-templates select="headers" mode="localHeadersToHeaders_694789293"/>
      <body>
        <out11:reserveAvailableInventory>
          <!-- a structural mapping: "body/in6:ProcessInventoryRequirement"(ProcessInventoryRequirementType) to "ApiInput"(ApiInputType_reserveAvailableInventory) -->
          <!-- variables for custom code -->
          <xsl:variable name="ProcessInventoryRequirement" select="body/in5:ProcessInventoryRequirement"/>
          <xsl:call-template name="ProcessInventoryRequirementToApiInput_reserveAvailableInventory">
            <xsl:with-param name="ProcessInventoryRequirement" select="$ProcessInventoryRequirement"/>
          </xsl:call-template>
        </out11:reserveAvailableInventory>
      </body>
    </io4:smo>
  </xsl:template>

  <!-- This rule represents an element mapping: "context" to "context".  -->
  <xsl:template match="context"  mode="localContextToContext_216827260">
    <context>
      <!-- a structural mapping: "correlation"(anyType) to "correlation"(anyType) -->
      <xsl:if test="correlation">
        <xsl:copy-of select="correlation"/>
      </xsl:if>
      <!-- a structural mapping: "transient"(anyType) to "transient"(anyType) -->
      <xsl:if test="transient">
        <xsl:copy-of select="transient"/>
      </xsl:if>
      <!-- a structural mapping: "failInfo"(FailInfoType) to "failInfo"(FailInfoType) -->
      <xsl:apply-templates select="failInfo" mode="localFailInfoToFailInfo_223610110"/>
      <!-- a structural mapping: "primitiveContext"(PrimitiveContextType) to "primitiveContext"(PrimitiveContextType) -->
      <xsl:apply-templates select="primitiveContext" mode="localPrimitiveContextToPrimitiveContext_129093411"/>
      <!-- a structural mapping: "shared"(anyType) to "shared"(anyType) -->
      <xsl:if test="shared">
        <xsl:copy-of select="shared"/>
      </xsl:if>
      <!-- a structural mapping: "dynamicProperty"(DynamicPropertyContextType) to "dynamicProperty"(DynamicPropertyContextType) -->
      <xsl:apply-templates select="dynamicProperty" mode="localDynamicPropertyToDynamicProperty_1600078886"/>
      <!-- a structural mapping: "userContext"(UserContextType) to "userContext"(UserContextType) -->
      <xsl:apply-templates select="userContext" mode="localUserContextToUserContext_1301323730"/>
    </context>
  </xsl:template>

  <!-- This rule represents an element mapping: "failInfo" to "failInfo".  -->
  <xsl:template match="failInfo"  mode="localFailInfoToFailInfo_223610110">
    <failInfo>
      <!-- a simple data mapping: "@lang"(<Anonymous>) to "lang"(<Anonymous>) -->
      <xsl:if test="@lang">
        <xsl:attribute name="lang">
          <xsl:value-of select="@lang"/>
        </xsl:attribute>
      </xsl:if>
      <!-- a simple data mapping: "failureString"(string) to "failureString"(string) -->
      <failureString>
        <xsl:value-of select="failureString"/>
      </failureString>
      <!-- a simple data mapping: "origin"(string) to "origin"(string) -->
      <origin>
        <xsl:value-of select="origin"/>
      </origin>
      <!-- a structural mapping: "invocationPath"(<Anonymous>) to "invocationPath"(<Anonymous>) -->
      <xsl:apply-templates select="invocationPath" mode="localInvocationPathToInvocationPath_308147340"/>
      <!-- a structural mapping: "predecessor"(FailInfoType) to "predecessor"(FailInfoType) -->
      <xsl:if test="predecessor">
        <xsl:copy-of select="predecessor"/>
      </xsl:if>
    </failInfo>
  </xsl:template>

  <!-- This rule represents an element mapping: "invocationPath" to "invocationPath".  -->
  <xsl:template match="invocationPath"  mode="localInvocationPathToInvocationPath_308147340">
    <invocationPath>
      <!-- a for-each transform: "primitive"(PrimitiveType) to "primitive"(PrimitiveType) -->
      <xsl:apply-templates select="primitive" mode="localPrimitiveToPrimitive_2026946338"/>
    </invocationPath>
  </xsl:template>

  <!-- This rule represents a for-each transform: "primitive" to "primitive".  -->
  <xsl:template match="primitive"  mode="localPrimitiveToPrimitive_2026946338">
    <primitive>
      <!-- a simple data mapping: "@inTerminal"(string) to "inTerminal"(string) -->
      <xsl:attribute name="inTerminal">
        <xsl:value-of select="@inTerminal"/>
      </xsl:attribute>
      <!-- a simple data mapping: "@name"(string) to "name"(string) -->
      <xsl:attribute name="name">
        <xsl:value-of select="@name"/>
      </xsl:attribute>
      <!-- a simple data mapping: "@outTerminal"(string) to "outTerminal"(string) -->
      <xsl:if test="@outTerminal">
        <xsl:attribute name="outTerminal">
          <xsl:value-of select="@outTerminal"/>
        </xsl:attribute>
      </xsl:if>
    </primitive>
  </xsl:template>

  <!-- This rule represents an element mapping: "primitiveContext" to "primitiveContext".  -->
  <xsl:template match="primitiveContext"  mode="localPrimitiveContextToPrimitiveContext_129093411">
    <primitiveContext>
      <!-- a for-each transform: "EndpointLookupContext"(EndpointLookupContextType) to "EndpointLookupContext"(EndpointLookupContextType) -->
      <xsl:apply-templates select="EndpointLookupContext" mode="localEndpointLookupContextToEndpointLookupContext_780041759"/>
      <!-- a structural mapping: "FanOutContext"(FanOutContextType) to "FanOutContext"(FanOutContextType) -->
      <xsl:apply-templates select="FanOutContext" mode="localFanOutContextToFanOutContext_181003012"/>
      <!-- a structural mapping: "WTXContext"(WTXContextType) to "WTXContext"(WTXContextType) -->
      <xsl:apply-templates select="WTXContext" mode="localWTXContextToWTXContext_1327933576"/>
    </primitiveContext>
  </xsl:template>

  <!-- This rule represents a for-each transform: "EndpointLookupContext" to "EndpointLookupContext".  -->
  <xsl:template match="EndpointLookupContext"  mode="localEndpointLookupContextToEndpointLookupContext_780041759">
    <EndpointLookupContext>
      <!-- a structural mapping: "endpointReference"(EndpointReferenceType) to "endpointReference"(EndpointReferenceType) -->
      <xsl:apply-templates select="endpointReference" mode="localEndpointReferenceToEndpointReference_1753904695"/>
      <!-- a structural mapping: "registryAnnotations"(RegistryAnnotationsType) to "registryAnnotations"(RegistryAnnotationsType) -->
      <xsl:apply-templates select="registryAnnotations" mode="localRegistryAnnotationsToRegistryAnnotations_45790590"/>
    </EndpointLookupContext>
  </xsl:template>

  <!-- This rule represents an element mapping: "endpointReference" to "endpointReference".  -->
  <xsl:template match="endpointReference"  mode="localEndpointReferenceToEndpointReference_1753904695">
    <endpointReference>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a structural mapping: "io2:Address"(AttributedURI) to "io2:Address"(AttributedURI) -->
      <xsl:apply-templates select="io2:Address" mode="localAddressToAddress_1711011206"/>
      <!-- a structural mapping: "io2:ReferenceProperties"(ReferencePropertiesType) to "io2:ReferenceProperties"(ReferencePropertiesType) -->
      <xsl:apply-templates select="io2:ReferenceProperties" mode="localReferencePropertiesToReferenceProperties_496416130"/>
      <!-- a structural mapping: "io2:ReferenceParameters"(ReferenceParametersType) to "io2:ReferenceParameters"(ReferenceParametersType) -->
      <xsl:apply-templates select="io2:ReferenceParameters" mode="localReferenceParametersToReferenceParameters_2030645020"/>
      <!-- a structural mapping: "io2:PortType"(AttributedQName) to "io2:PortType"(AttributedQName) -->
      <xsl:apply-templates select="io2:PortType" mode="localPortTypeToPortType_679608081"/>
      <!-- a structural mapping: "io2:ServiceName"(ServiceNameType) to "io2:ServiceName"(ServiceNameType) -->
      <xsl:apply-templates select="io2:ServiceName" mode="localServiceNameToServiceName_344056098"/>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="io2:ServiceName/following-sibling::*[namespace-uri(.) != namespace-uri(..) ]"/>
    </endpointReference>
  </xsl:template>

  <!-- This rule represents an element mapping: "io2:Address" to "io2:Address".  -->
  <xsl:template match="io2:Address"  mode="localAddressToAddress_1711011206">
    <io2:Address>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a simple content mapping -->
      <xsl:value-of select="."/>
    </io2:Address>
  </xsl:template>

  <!-- This rule represents an element mapping: "io2:ReferenceProperties" to "io2:ReferenceProperties".  -->
  <xsl:template match="io2:ReferenceProperties"  mode="localReferencePropertiesToReferenceProperties_496416130">
    <io2:ReferenceProperties>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="*"/>
    </io2:ReferenceProperties>
  </xsl:template>

  <!-- This rule represents an element mapping: "io2:ReferenceParameters" to "io2:ReferenceParameters".  -->
  <xsl:template match="io2:ReferenceParameters"  mode="localReferenceParametersToReferenceParameters_2030645020">
    <io2:ReferenceParameters>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="*"/>
    </io2:ReferenceParameters>
  </xsl:template>

  <!-- This rule represents an element mapping: "io2:PortType" to "io2:PortType".  -->
  <xsl:template match="io2:PortType"  mode="localPortTypeToPortType_679608081">
    <io2:PortType>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a simple content mapping -->
      <xsl:value-of select="."/>
    </io2:PortType>
  </xsl:template>

  <!-- This rule represents an element mapping: "io2:ServiceName" to "io2:ServiceName".  -->
  <xsl:template match="io2:ServiceName"  mode="localServiceNameToServiceName_344056098">
    <io2:ServiceName>
      <!-- a simple data mapping: "@PortName"(NCName) to "PortName"(NCName) -->
      <xsl:if test="@PortName">
        <xsl:attribute name="PortName">
          <xsl:value-of select="@PortName"/>
        </xsl:attribute>
      </xsl:if>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a simple content mapping -->
      <xsl:value-of select="."/>
    </io2:ServiceName>
  </xsl:template>

  <!-- This rule represents an element mapping: "registryAnnotations" to "registryAnnotations".  -->
  <xsl:template match="registryAnnotations"  mode="localRegistryAnnotationsToRegistryAnnotations_45790590">
    <registryAnnotations>
      <!-- a for-each transform: "property"(RegistryPropertyType) to "property"(RegistryPropertyType) -->
      <xsl:apply-templates select="property" mode="localPropertyToProperty_1154585188"/>
      <!-- a simple data mapping: "classification"(anyURI) to "classification"(anyURI) -->
      <xsl:for-each select="classification">
        <classification>
          <xsl:value-of select="."/>
        </classification>
      </xsl:for-each>
      <!-- a for-each transform: "relationship"(RegistryRelationshipType) to "relationship"(RegistryRelationshipType) -->
      <xsl:apply-templates select="relationship" mode="localRelationshipToRelationship_1256469474"/>
    </registryAnnotations>
  </xsl:template>

  <!-- This rule represents a for-each transform: "property" to "property".  -->
  <xsl:template match="property"  mode="localPropertyToProperty_1154585188">
    <property>
      <!-- a simple data mapping: "name"(string) to "name"(string) -->
      <name>
        <xsl:value-of select="name"/>
      </name>
      <!-- a simple data mapping: "value"(string) to "value"(string) -->
      <xsl:if test="value">
        <value>
          <xsl:value-of select="value"/>
        </value>
      </xsl:if>
    </property>
  </xsl:template>

  <!-- This rule represents a for-each transform: "relationship" to "relationship".  -->
  <xsl:template match="relationship"  mode="localRelationshipToRelationship_1256469474">
    <relationship>
      <!-- a simple data mapping: "relationshipName"(string) to "relationshipName"(string) -->
      <relationshipName>
        <xsl:value-of select="relationshipName"/>
      </relationshipName>
      <!-- a simple data mapping: "targetName"(string) to "targetName"(string) -->
      <xsl:if test="targetName">
        <targetName>
          <xsl:value-of select="targetName"/>
        </targetName>
      </xsl:if>
      <!-- a simple data mapping: "targetNamespace"(anyURI) to "targetNamespace"(anyURI) -->
      <xsl:if test="targetNamespace">
        <targetNamespace>
          <xsl:value-of select="targetNamespace"/>
        </targetNamespace>
      </xsl:if>
      <!-- a simple data mapping: "targetVersion"(string) to "targetVersion"(string) -->
      <xsl:if test="targetVersion">
        <targetVersion>
          <xsl:value-of select="targetVersion"/>
        </targetVersion>
      </xsl:if>
    </relationship>
  </xsl:template>

  <!-- This rule represents an element mapping: "FanOutContext" to "FanOutContext".  -->
  <xsl:template match="FanOutContext"  mode="localFanOutContextToFanOutContext_181003012">
    <FanOutContext>
      <!-- a simple data mapping: "iteration"(integer) to "iteration"(integer) -->
      <xsl:if test="iteration">
        <iteration>
          <xsl:value-of select="iteration"/>
        </iteration>
      </xsl:if>
      <!-- a structural mapping: "occurrence"(anyType) to "occurrence"(anyType) -->
      <xsl:if test="occurrence">
        <xsl:copy-of select="occurrence"/>
      </xsl:if>
    </FanOutContext>
  </xsl:template>

  <!-- This rule represents an element mapping: "WTXContext" to "WTXContext".  -->
  <xsl:template match="WTXContext"  mode="localWTXContextToWTXContext_1327933576">
    <WTXContext>
      <!-- a simple data mapping: "mapServerLocation"(anyURI) to "mapServerLocation"(anyURI) -->
      <xsl:if test="mapServerLocation">
        <mapServerLocation>
          <xsl:value-of select="mapServerLocation"/>
        </mapServerLocation>
      </xsl:if>
      <!-- a simple data mapping: "dynamicMap"(hexBinary) to "dynamicMap"(hexBinary) -->
      <xsl:if test="dynamicMap">
        <dynamicMap>
          <xsl:value-of select="dynamicMap"/>
        </dynamicMap>
      </xsl:if>
      <!-- a for-each transform: "mapInstances"(WTXMapInstanceType) to "mapInstances"(WTXMapInstanceType) -->
      <xsl:apply-templates select="mapInstances" mode="localMapInstancesToMapInstances_741331074"/>
    </WTXContext>
  </xsl:template>

  <!-- This rule represents a for-each transform: "mapInstances" to "mapInstances".  -->
  <xsl:template match="mapInstances"  mode="localMapInstancesToMapInstances_741331074">
    <mapInstances>
      <!-- a simple data mapping: "mapInstance"(integer) to "mapInstance"(integer) -->
      <mapInstance>
        <xsl:value-of select="mapInstance"/>
      </mapInstance>
      <!-- a simple data mapping: "auditInfo"(string) to "auditInfo"(string) -->
      <auditInfo>
        <xsl:value-of select="auditInfo"/>
      </auditInfo>
    </mapInstances>
  </xsl:template>

  <!-- This rule represents an element mapping: "dynamicProperty" to "dynamicProperty".  -->
  <xsl:template match="dynamicProperty"  mode="localDynamicPropertyToDynamicProperty_1600078886">
    <dynamicProperty>
      <!-- a simple data mapping: "@isPropagated"(boolean) to "isPropagated"(boolean) -->
      <xsl:if test="@isPropagated">
        <xsl:attribute name="isPropagated">
          <xsl:value-of select="@isPropagated"/>
        </xsl:attribute>
      </xsl:if>
      <!-- a for-each transform: "propertySets"(DynamicPropertySetType) to "propertySets"(DynamicPropertySetType) -->
      <xsl:apply-templates select="propertySets" mode="localPropertySetsToPropertySets_1862919943"/>
    </dynamicProperty>
  </xsl:template>

  <!-- This rule represents a for-each transform: "propertySets" to "propertySets".  -->
  <xsl:template match="propertySets"  mode="localPropertySetsToPropertySets_1862919943">
    <propertySets>
      <!-- a simple data mapping: "group"(string) to "group"(string) -->
      <group>
        <xsl:value-of select="group"/>
      </group>
      <!-- a for-each transform: "properties"(PropertyType) to "properties"(PropertyType) -->
      <xsl:apply-templates select="properties" mode="localPropertiesToProperties_1983580309"/>
    </propertySets>
  </xsl:template>

  <!-- This rule represents a for-each transform: "properties" to "properties".  -->
  <xsl:template match="properties"  mode="localPropertiesToProperties_1983580309">
    <properties>
      <!-- a simple data mapping: "name"(string) to "name"(string) -->
      <name>
        <xsl:value-of select="name"/>
      </name>
      <!-- a simple data mapping: "value"(anySimpleType) to "value"(anySimpleType) -->
      <value>
        <xsl:value-of select="value"/>
      </value>
      <!-- a simple data mapping: "type"(string) to "type"(string) -->
      <xsl:if test="type">
        <type>
          <xsl:value-of select="type"/>
        </type>
      </xsl:if>
    </properties>
  </xsl:template>

  <!-- This rule represents an element mapping: "userContext" to "userContext".  -->
  <xsl:template match="userContext"  mode="localUserContextToUserContext_1301323730">
    <userContext>
      <!-- a for-each transform: "entries"(ComplexPropertyType) to "entries"(ComplexPropertyType) -->
      <xsl:apply-templates select="entries" mode="localEntriesToEntries_188273756"/>
    </userContext>
  </xsl:template>

  <!-- This rule represents a for-each transform: "entries" to "entries".  -->
  <xsl:template match="entries"  mode="localEntriesToEntries_188273756">
    <entries>
      <!-- a simple data mapping: "name"(string) to "name"(string) -->
      <name>
        <xsl:value-of select="name"/>
      </name>
      <!-- a structural mapping: "value"(anyType) to "value"(anyType) -->
      <xsl:copy-of select="value"/>
      <!-- a simple data mapping: "type"(string) to "type"(string) -->
      <xsl:if test="type">
        <type>
          <xsl:value-of select="type"/>
        </type>
      </xsl:if>
    </entries>
  </xsl:template>

  <!-- This rule represents an element mapping: "headers" to "headers".  -->
  <xsl:template match="headers"  mode="localHeadersToHeaders_694789293">
    <headers>
      <!-- a structural mapping: "SMOHeader"(SMOHeaderType) to "SMOHeader"(SMOHeaderType) -->
      <xsl:apply-templates select="SMOHeader" mode="localSMOHeaderToSMOHeader_31207990"/>
      <!-- a structural mapping: "JMSHeader"(JMSHeaderType) to "JMSHeader"(JMSHeaderType) -->
      <xsl:apply-templates select="JMSHeader" mode="localJMSHeaderToJMSHeader_1626224205"/>
      <!-- a for-each transform: "SOAPHeader"(SOAPHeaderType) to "SOAPHeader"(SOAPHeaderType) -->
      <xsl:apply-templates select="SOAPHeader" mode="localSOAPHeaderToSOAPHeader_963349770"/>
      <!-- a structural mapping: "SOAPFaultInfo"(SOAPFaultInfoType) to "SOAPFaultInfo"(SOAPFaultInfoType) -->
      <xsl:apply-templates select="SOAPFaultInfo" mode="localSOAPFaultInfoToSOAPFaultInfo_1902466804"/>
      <!-- a for-each transform: "properties"(PropertyType) to "properties"(PropertyType) -->
      <xsl:apply-templates select="properties" mode="localPropertiesToProperties_1209214213"/>
      <!-- a structural mapping: "MQHeader"(MQHeaderType) to "MQHeader"(MQHeaderType) -->
      <xsl:apply-templates select="MQHeader" mode="localMQHeaderToMQHeader_1730935063"/>
      <!-- a structural mapping: "HTTPHeader"(HTTPHeaderType) to "HTTPHeader"(HTTPHeaderType) -->
      <xsl:apply-templates select="HTTPHeader" mode="localHTTPHeaderToHTTPHeader_604367301"/>
      <!-- a structural mapping: "EISHeader"(EISHeaderType) to "EISHeader"(EISHeaderType) -->
      <xsl:apply-templates select="EISHeader" mode="localEISHeaderToEISHeader_1781709972"/>
      <!-- a structural mapping: "WSAHeader"(WSAHeaderType) to "WSAHeader"(WSAHeaderType) -->
      <xsl:apply-templates select="WSAHeader" mode="localWSAHeaderToWSAHeader_414362306"/>
    </headers>
  </xsl:template>

  <!-- This rule represents an element mapping: "SMOHeader" to "SMOHeader".  -->
  <xsl:template match="SMOHeader"  mode="localSMOHeaderToSMOHeader_31207990">
    <SMOHeader>
      <!-- a simple data mapping: "MessageUUID"(string) to "MessageUUID"(string) -->
      <MessageUUID>
        <xsl:value-of select="MessageUUID"/>
      </MessageUUID>
      <!-- a structural mapping: "Version"(VersionType) to "Version"(VersionType) -->
      <xsl:apply-templates select="Version" mode="localVersionToVersion_1336211371"/>
      <!-- a simple data mapping: "MessageType"(string) to "MessageType"(string) -->
      <xsl:if test="MessageType">
        <MessageType>
          <xsl:value-of select="MessageType"/>
        </MessageType>
      </xsl:if>
      <!-- a simple data mapping: "Operation"(string) to "Operation"(string) -->
      <xsl:if test="Operation">
        <Operation>
          <xsl:value-of select="Operation"/>
        </Operation>
      </xsl:if>
      <!-- a simple data mapping: "Action"(string) to "Action"(string) -->
      <xsl:if test="Action">
        <Action>
          <xsl:value-of select="Action"/>
        </Action>
      </xsl:if>
      <!-- a structural mapping: "Target"(TargetAddressType) to "Target"(TargetAddressType) -->
      <xsl:apply-templates select="Target" mode="localTargetToTarget_1530941858"/>
      <!-- a for-each transform: "AlternateTarget"(TargetAddressType) to "AlternateTarget"(TargetAddressType) -->
      <xsl:apply-templates select="AlternateTarget" mode="localAlternateTargetToAlternateTarget_841286515"/>
      <!-- a simple data mapping: "SourceNode"(string) to "SourceNode"(string) -->
      <xsl:if test="SourceNode">
        <SourceNode>
          <xsl:value-of select="SourceNode"/>
        </SourceNode>
      </xsl:if>
      <!-- a simple data mapping: "SourceBindingType"(BindingTypeType) to "SourceBindingType"(BindingTypeType) -->
      <xsl:if test="SourceBindingType">
        <SourceBindingType>
          <xsl:value-of select="SourceBindingType"/>
        </SourceBindingType>
      </xsl:if>
      <!-- a simple data mapping: "Interface"(string) to "Interface"(string) -->
      <xsl:if test="Interface">
        <Interface>
          <xsl:value-of select="Interface"/>
        </Interface>
      </xsl:if>
    </SMOHeader>
  </xsl:template>

  <!-- This rule represents an element mapping: "Version" to "Version".  -->
  <xsl:template match="Version"  mode="localVersionToVersion_1336211371">
    <Version>
      <!-- a simple data mapping: "Version"(integer) to "Version"(integer) -->
      <Version>
        <xsl:value-of select="Version"/>
      </Version>
      <!-- a simple data mapping: "Release"(integer) to "Release"(integer) -->
      <Release>
        <xsl:value-of select="Release"/>
      </Release>
      <!-- a simple data mapping: "Modification"(integer) to "Modification"(integer) -->
      <Modification>
        <xsl:value-of select="Modification"/>
      </Modification>
    </Version>
  </xsl:template>

  <!-- This rule represents an element mapping: "Target" to "Target".  -->
  <xsl:template match="Target"  mode="localTargetToTarget_1530941858">
    <Target>
      <!-- a simple data mapping: "@bindingType"(BindingTypeType) to "bindingType"(BindingTypeType) -->
      <xsl:if test="@bindingType">
        <xsl:attribute name="bindingType">
          <xsl:value-of select="@bindingType"/>
        </xsl:attribute>
      </xsl:if>
      <!-- a simple data mapping: "@import"(string) to "import"(string) -->
      <xsl:if test="@import">
        <xsl:attribute name="import">
          <xsl:value-of select="@import"/>
        </xsl:attribute>
      </xsl:if>
      <!-- a simple data mapping: "@repositoryMetadata"(string) to "repositoryMetadata"(string) -->
      <xsl:if test="@repositoryMetadata">
        <xsl:attribute name="repositoryMetadata">
          <xsl:value-of select="@repositoryMetadata"/>
        </xsl:attribute>
      </xsl:if>
      <!-- a simple data mapping: "address"(anyURI) to "address"(anyURI) -->
      <address>
        <xsl:value-of select="address"/>
      </address>
    </Target>
  </xsl:template>

  <!-- This rule represents a for-each transform: "AlternateTarget" to "AlternateTarget".  -->
  <xsl:template match="AlternateTarget"  mode="localAlternateTargetToAlternateTarget_841286515">
    <AlternateTarget>
      <!-- a simple data mapping: "@bindingType"(BindingTypeType) to "bindingType"(BindingTypeType) -->
      <xsl:if test="@bindingType">
        <xsl:attribute name="bindingType">
          <xsl:value-of select="@bindingType"/>
        </xsl:attribute>
      </xsl:if>
      <!-- a simple data mapping: "@import"(string) to "import"(string) -->
      <xsl:if test="@import">
        <xsl:attribute name="import">
          <xsl:value-of select="@import"/>
        </xsl:attribute>
      </xsl:if>
      <!-- a simple data mapping: "@repositoryMetadata"(string) to "repositoryMetadata"(string) -->
      <xsl:if test="@repositoryMetadata">
        <xsl:attribute name="repositoryMetadata">
          <xsl:value-of select="@repositoryMetadata"/>
        </xsl:attribute>
      </xsl:if>
      <!-- a simple data mapping: "address"(anyURI) to "address"(anyURI) -->
      <address>
        <xsl:value-of select="address"/>
      </address>
    </AlternateTarget>
  </xsl:template>

  <!-- This rule represents an element mapping: "JMSHeader" to "JMSHeader".  -->
  <xsl:template match="JMSHeader"  mode="localJMSHeaderToJMSHeader_1626224205">
    <JMSHeader>
      <!-- a simple data mapping: "JMSDestination"(anyURI) to "JMSDestination"(anyURI) -->
      <xsl:if test="JMSDestination">
        <JMSDestination>
          <xsl:value-of select="JMSDestination"/>
        </JMSDestination>
      </xsl:if>
      <!-- a simple data mapping: "JMSDeliveryMode"(persistenceType) to "JMSDeliveryMode"(persistenceType) -->
      <xsl:if test="JMSDeliveryMode">
        <JMSDeliveryMode>
          <xsl:value-of select="JMSDeliveryMode"/>
        </JMSDeliveryMode>
      </xsl:if>
      <!-- a simple data mapping: "JMSMessageID"(string) to "JMSMessageID"(string) -->
      <xsl:if test="JMSMessageID">
        <JMSMessageID>
          <xsl:value-of select="JMSMessageID"/>
        </JMSMessageID>
      </xsl:if>
      <!-- a simple data mapping: "JMSTimestamp"(long) to "JMSTimestamp"(long) -->
      <xsl:if test="JMSTimestamp">
        <JMSTimestamp>
          <xsl:value-of select="JMSTimestamp"/>
        </JMSTimestamp>
      </xsl:if>
      <!-- a simple data mapping: "JMSCorrelationID"(string) to "JMSCorrelationID"(string) -->
      <xsl:if test="JMSCorrelationID">
        <JMSCorrelationID>
          <xsl:value-of select="JMSCorrelationID"/>
        </JMSCorrelationID>
      </xsl:if>
      <!-- a simple data mapping: "JMSReplyTo"(anyURI) to "JMSReplyTo"(anyURI) -->
      <xsl:if test="JMSReplyTo">
        <JMSReplyTo>
          <xsl:value-of select="JMSReplyTo"/>
        </JMSReplyTo>
      </xsl:if>
      <!-- a simple data mapping: "JMSRedelivered"(boolean) to "JMSRedelivered"(boolean) -->
      <xsl:if test="JMSRedelivered">
        <JMSRedelivered>
          <xsl:value-of select="JMSRedelivered"/>
        </JMSRedelivered>
      </xsl:if>
      <!-- a simple data mapping: "JMSType"(string) to "JMSType"(string) -->
      <xsl:if test="JMSType">
        <JMSType>
          <xsl:value-of select="JMSType"/>
        </JMSType>
      </xsl:if>
      <!-- a simple data mapping: "JMSExpiration"(long) to "JMSExpiration"(long) -->
      <xsl:if test="JMSExpiration">
        <JMSExpiration>
          <xsl:value-of select="JMSExpiration"/>
        </JMSExpiration>
      </xsl:if>
      <!-- a simple data mapping: "JMSPriority"(priorityType) to "JMSPriority"(priorityType) -->
      <xsl:if test="JMSPriority">
        <JMSPriority>
          <xsl:value-of select="JMSPriority"/>
        </JMSPriority>
      </xsl:if>
    </JMSHeader>
  </xsl:template>

  <!-- This rule represents a for-each transform: "SOAPHeader" to "SOAPHeader".  -->
  <xsl:template match="SOAPHeader"  mode="localSOAPHeaderToSOAPHeader_963349770">
    <SOAPHeader>
      <!-- a simple data mapping: "nameSpace"(anyURI) to "nameSpace"(anyURI) -->
      <nameSpace>
        <xsl:value-of select="nameSpace"/>
      </nameSpace>
      <!-- a simple data mapping: "name"(NCName) to "name"(NCName) -->
      <name>
        <xsl:value-of select="name"/>
      </name>
      <!-- a simple data mapping: "prefix"(NCName) to "prefix"(NCName) -->
      <xsl:if test="prefix">
        <prefix>
          <xsl:value-of select="prefix"/>
        </prefix>
      </xsl:if>
      <!-- a structural mapping: "value"(anyType) to "value"(anyType) -->
      <xsl:copy-of select="value"/>
    </SOAPHeader>
  </xsl:template>

  <!-- This rule represents an element mapping: "SOAPFaultInfo" to "SOAPFaultInfo".  -->
  <xsl:template match="SOAPFaultInfo"  mode="localSOAPFaultInfoToSOAPFaultInfo_1902466804">
    <SOAPFaultInfo>
      <!-- a simple data mapping: "faultcode"(QName) to "faultcode"(QName) -->
      <faultcode>
        <xsl:value-of select="faultcode"/>
      </faultcode>
      <!-- a simple data mapping: "faultstring"(string) to "faultstring"(string) -->
      <faultstring>
        <xsl:value-of select="faultstring"/>
      </faultstring>
      <!-- a simple data mapping: "faultactor"(anyURI) to "faultactor"(anyURI) -->
      <xsl:if test="faultactor">
        <faultactor>
          <xsl:value-of select="faultactor"/>
        </faultactor>
      </xsl:if>
      <!-- a structural mapping: "extendedFaultInfo"(FaultType) to "extendedFaultInfo"(FaultType) -->
      <xsl:apply-templates select="extendedFaultInfo" mode="localExtendedFaultInfoToExtendedFaultInfo_1740545093"/>
    </SOAPFaultInfo>
  </xsl:template>

  <!-- This rule represents an element mapping: "extendedFaultInfo" to "extendedFaultInfo".  -->
  <xsl:template match="extendedFaultInfo"  mode="localExtendedFaultInfoToExtendedFaultInfo_1740545093">
    <extendedFaultInfo>
      <!-- a structural mapping: "Code"(faultcode) to "Code"(faultcode) -->
      <xsl:apply-templates select="Code" mode="localCodeToCode_936517073"/>
      <!-- a structural mapping: "Reason"(faultreason) to "Reason"(faultreason) -->
      <xsl:apply-templates select="Reason" mode="localReasonToReason_491303778"/>
      <!-- a simple data mapping: "Node"(anyURI) to "Node"(anyURI) -->
      <xsl:if test="Node">
        <Node>
          <xsl:value-of select="Node"/>
        </Node>
      </xsl:if>
      <!-- a simple data mapping: "Role"(anyURI) to "Role"(anyURI) -->
      <xsl:if test="Role">
        <Role>
          <xsl:value-of select="Role"/>
        </Role>
      </xsl:if>
    </extendedFaultInfo>
  </xsl:template>

  <!-- This rule represents an element mapping: "Code" to "Code".  -->
  <xsl:template match="Code"  mode="localCodeToCode_936517073">
    <Code>
      <!-- a simple data mapping: "io3:Value"(faultcodeEnum) to "io3:Value"(faultcodeEnum) -->
      <io3:Value>
        <xsl:value-of select="io3:Value"/>
      </io3:Value>
      <!-- a structural mapping: "io3:Subcode"(subcode) to "io3:Subcode"(subcode) -->
      <xsl:apply-templates select="io3:Subcode" mode="localSubcodeToSubcode_1579899917"/>
    </Code>
  </xsl:template>

  <!-- This rule represents an element mapping: "io3:Subcode" to "io3:Subcode".  -->
  <xsl:template match="io3:Subcode"  mode="localSubcodeToSubcode_1579899917">
    <io3:Subcode>
      <!-- a simple data mapping: "io3:Value"(QName) to "io3:Value"(QName) -->
      <io3:Value>
        <xsl:value-of select="io3:Value"/>
      </io3:Value>
      <!-- a structural mapping: "io3:Subcode"(subcode) to "io3:Subcode"(subcode) -->
      <xsl:if test="io3:Subcode">
        <xsl:copy-of select="io3:Subcode"/>
      </xsl:if>
    </io3:Subcode>
  </xsl:template>

  <!-- This rule represents an element mapping: "Reason" to "Reason".  -->
  <xsl:template match="Reason"  mode="localReasonToReason_491303778">
    <Reason>
      <!-- a for-each transform: "io3:Text"(reasontext) to "io3:Text"(reasontext) -->
      <xsl:apply-templates select="io3:Text" mode="localTextToText_1671562477"/>
    </Reason>
  </xsl:template>

  <!-- This rule represents a for-each transform: "io3:Text" to "io3:Text".  -->
  <xsl:template match="io3:Text"  mode="localTextToText_1671562477">
    <io3:Text>
      <!-- a simple data mapping: "@lang"(<Anonymous>) to "lang"(<Anonymous>) -->
      <xsl:attribute name="lang">
        <xsl:value-of select="@lang"/>
      </xsl:attribute>
      <!-- a simple content mapping -->
      <xsl:value-of select="."/>
    </io3:Text>
  </xsl:template>

  <!-- This rule represents a for-each transform: "properties" to "properties".  -->
  <xsl:template match="properties"  mode="localPropertiesToProperties_1209214213">
    <properties>
      <!-- a simple data mapping: "name"(string) to "name"(string) -->
      <name>
        <xsl:value-of select="name"/>
      </name>
      <!-- a simple data mapping: "value"(anySimpleType) to "value"(anySimpleType) -->
      <value>
        <xsl:value-of select="value"/>
      </value>
      <!-- a simple data mapping: "type"(string) to "type"(string) -->
      <xsl:if test="type">
        <type>
          <xsl:value-of select="type"/>
        </type>
      </xsl:if>
    </properties>
  </xsl:template>

  <!-- This rule represents an element mapping: "MQHeader" to "MQHeader".  -->
  <xsl:template match="MQHeader"  mode="localMQHeaderToMQHeader_1730935063">
    <MQHeader>
      <!-- a structural mapping: "md"(MQMD) to "md"(MQMD) -->
      <xsl:apply-templates select="md" mode="localMdToMd_1109811226"/>
      <!-- a structural mapping: "control"(MQControl) to "control"(MQControl) -->
      <xsl:apply-templates select="control" mode="localControlToControl_1394642261"/>
      <!-- a for-each transform: "header"(MQChainedHeaderType) to "header"(MQChainedHeaderType) -->
      <xsl:apply-templates select="header" mode="localHeaderToHeader_2095590147"/>
    </MQHeader>
  </xsl:template>

  <!-- This rule represents an element mapping: "md" to "md".  -->
  <xsl:template match="md"  mode="localMdToMd_1109811226">
    <md>
      <!-- a simple data mapping: "Report"(MQLONG) to "Report"(MQLONG) -->
      <xsl:if test="Report">
        <Report>
          <xsl:value-of select="Report"/>
        </Report>
      </xsl:if>
      <!-- a simple data mapping: "MsgType"(MQLONG) to "MsgType"(MQLONG) -->
      <xsl:if test="MsgType">
        <MsgType>
          <xsl:value-of select="MsgType"/>
        </MsgType>
      </xsl:if>
      <!-- a simple data mapping: "Expiry"(MQLONG) to "Expiry"(MQLONG) -->
      <xsl:if test="Expiry">
        <Expiry>
          <xsl:value-of select="Expiry"/>
        </Expiry>
      </xsl:if>
      <!-- a simple data mapping: "Feedback"(MQLONG) to "Feedback"(MQLONG) -->
      <xsl:if test="Feedback">
        <Feedback>
          <xsl:value-of select="Feedback"/>
        </Feedback>
      </xsl:if>
      <!-- a simple data mapping: "Priority"(MQLONG) to "Priority"(MQLONG) -->
      <xsl:if test="Priority">
        <Priority>
          <xsl:value-of select="Priority"/>
        </Priority>
      </xsl:if>
      <!-- a simple data mapping: "Persistence"(MQLONG) to "Persistence"(MQLONG) -->
      <xsl:if test="Persistence">
        <Persistence>
          <xsl:value-of select="Persistence"/>
        </Persistence>
      </xsl:if>
      <!-- a simple data mapping: "MsgId"(MQBYTE24) to "MsgId"(MQBYTE24) -->
      <xsl:if test="MsgId">
        <MsgId>
          <xsl:value-of select="MsgId"/>
        </MsgId>
      </xsl:if>
      <!-- a simple data mapping: "CorrelId"(MQBYTE24) to "CorrelId"(MQBYTE24) -->
      <xsl:if test="CorrelId">
        <CorrelId>
          <xsl:value-of select="CorrelId"/>
        </CorrelId>
      </xsl:if>
      <!-- a simple data mapping: "BackoutCount"(MQLONG) to "BackoutCount"(MQLONG) -->
      <xsl:if test="BackoutCount">
        <BackoutCount>
          <xsl:value-of select="BackoutCount"/>
        </BackoutCount>
      </xsl:if>
      <!-- a simple data mapping: "ReplyToQ"(MQCHAR48) to "ReplyToQ"(MQCHAR48) -->
      <xsl:if test="ReplyToQ">
        <ReplyToQ>
          <xsl:value-of select="ReplyToQ"/>
        </ReplyToQ>
      </xsl:if>
      <!-- a simple data mapping: "ReplyToQMgr"(MQCHAR48) to "ReplyToQMgr"(MQCHAR48) -->
      <xsl:if test="ReplyToQMgr">
        <ReplyToQMgr>
          <xsl:value-of select="ReplyToQMgr"/>
        </ReplyToQMgr>
      </xsl:if>
      <!-- a simple data mapping: "UserIdentifier"(MQCHAR12) to "UserIdentifier"(MQCHAR12) -->
      <xsl:if test="UserIdentifier">
        <UserIdentifier>
          <xsl:value-of select="UserIdentifier"/>
        </UserIdentifier>
      </xsl:if>
      <!-- a simple data mapping: "AccountingToken"(MQBYTE32) to "AccountingToken"(MQBYTE32) -->
      <xsl:if test="AccountingToken">
        <AccountingToken>
          <xsl:value-of select="AccountingToken"/>
        </AccountingToken>
      </xsl:if>
      <!-- a simple data mapping: "ApplIdentityData"(MQCHAR32) to "ApplIdentityData"(MQCHAR32) -->
      <xsl:if test="ApplIdentityData">
        <ApplIdentityData>
          <xsl:value-of select="ApplIdentityData"/>
        </ApplIdentityData>
      </xsl:if>
      <!-- a simple data mapping: "PutApplType"(MQLONG) to "PutApplType"(MQLONG) -->
      <xsl:if test="PutApplType">
        <PutApplType>
          <xsl:value-of select="PutApplType"/>
        </PutApplType>
      </xsl:if>
      <!-- a simple data mapping: "PutApplName"(MQCHAR28) to "PutApplName"(MQCHAR28) -->
      <xsl:if test="PutApplName">
        <PutApplName>
          <xsl:value-of select="PutApplName"/>
        </PutApplName>
      </xsl:if>
      <!-- a simple data mapping: "PutDate"(MQCHAR8) to "PutDate"(MQCHAR8) -->
      <xsl:if test="PutDate">
        <PutDate>
          <xsl:value-of select="PutDate"/>
        </PutDate>
      </xsl:if>
      <!-- a simple data mapping: "PutTime"(MQCHAR8) to "PutTime"(MQCHAR8) -->
      <xsl:if test="PutTime">
        <PutTime>
          <xsl:value-of select="PutTime"/>
        </PutTime>
      </xsl:if>
      <!-- a simple data mapping: "ApplOriginData"(MQCHAR4) to "ApplOriginData"(MQCHAR4) -->
      <xsl:if test="ApplOriginData">
        <ApplOriginData>
          <xsl:value-of select="ApplOriginData"/>
        </ApplOriginData>
      </xsl:if>
      <!-- a simple data mapping: "GroupId"(MQBYTE24) to "GroupId"(MQBYTE24) -->
      <xsl:if test="GroupId">
        <GroupId>
          <xsl:value-of select="GroupId"/>
        </GroupId>
      </xsl:if>
      <!-- a simple data mapping: "MsgSeqNumber"(MQLONG) to "MsgSeqNumber"(MQLONG) -->
      <xsl:if test="MsgSeqNumber">
        <MsgSeqNumber>
          <xsl:value-of select="MsgSeqNumber"/>
        </MsgSeqNumber>
      </xsl:if>
      <!-- a simple data mapping: "Offset"(MQLONG) to "Offset"(MQLONG) -->
      <xsl:if test="Offset">
        <Offset>
          <xsl:value-of select="Offset"/>
        </Offset>
      </xsl:if>
      <!-- a simple data mapping: "MsgFlags"(MQLONG) to "MsgFlags"(MQLONG) -->
      <xsl:if test="MsgFlags">
        <MsgFlags>
          <xsl:value-of select="MsgFlags"/>
        </MsgFlags>
      </xsl:if>
      <!-- a simple data mapping: "OriginalLength"(MQLONG) to "OriginalLength"(MQLONG) -->
      <xsl:if test="OriginalLength">
        <OriginalLength>
          <xsl:value-of select="OriginalLength"/>
        </OriginalLength>
      </xsl:if>
    </md>
  </xsl:template>

  <!-- This rule represents an element mapping: "control" to "control".  -->
  <xsl:template match="control"  mode="localControlToControl_1394642261">
    <control>
      <!-- a simple data mapping: "Encoding"(MQLONG) to "Encoding"(MQLONG) -->
      <xsl:if test="Encoding">
        <Encoding>
          <xsl:value-of select="Encoding"/>
        </Encoding>
      </xsl:if>
      <!-- a simple data mapping: "CodedCharSetId"(MQLONG) to "CodedCharSetId"(MQLONG) -->
      <xsl:if test="CodedCharSetId">
        <CodedCharSetId>
          <xsl:value-of select="CodedCharSetId"/>
        </CodedCharSetId>
      </xsl:if>
      <!-- a simple data mapping: "Format"(MQCHAR8) to "Format"(MQCHAR8) -->
      <xsl:if test="Format">
        <Format>
          <xsl:value-of select="Format"/>
        </Format>
      </xsl:if>
    </control>
  </xsl:template>

  <!-- This rule represents a for-each transform: "header" to "header".  -->
  <xsl:template match="header"  mode="localHeaderToHeader_2095590147">
    <header>
      <!-- a simple data mapping: "Encoding"(MQLONG) to "Encoding"(MQLONG) -->
      <xsl:if test="Encoding">
        <Encoding>
          <xsl:value-of select="Encoding"/>
        </Encoding>
      </xsl:if>
      <!-- a simple data mapping: "CodedCharSetId"(MQLONG) to "CodedCharSetId"(MQLONG) -->
      <xsl:if test="CodedCharSetId">
        <CodedCharSetId>
          <xsl:value-of select="CodedCharSetId"/>
        </CodedCharSetId>
      </xsl:if>
      <!-- a simple data mapping: "Format"(MQCHAR8) to "Format"(MQCHAR8) -->
      <xsl:if test="Format">
        <Format>
          <xsl:value-of select="Format"/>
        </Format>
      </xsl:if>
      <!-- a structural mapping: "value"(anyType) to "value"(anyType) -->
      <xsl:if test="value">
        <xsl:copy-of select="value"/>
      </xsl:if>
      <!-- a structural mapping: "opaque"(MQOpaqueHeader) to "opaque"(MQOpaqueHeader) -->
      <xsl:apply-templates select="opaque" mode="localOpaqueToOpaque_790139518"/>
      <!-- a structural mapping: "rfh"(MQRFH) to "rfh"(MQRFH) -->
      <xsl:apply-templates select="rfh" mode="localRfhToRfh_839866166"/>
      <!-- a structural mapping: "rfh2"(MQRFH2) to "rfh2"(MQRFH2) -->
      <xsl:apply-templates select="rfh2" mode="localRfh2ToRfh2_446765729"/>
    </header>
  </xsl:template>

  <!-- This rule represents an element mapping: "opaque" to "opaque".  -->
  <xsl:template match="opaque"  mode="localOpaqueToOpaque_790139518">
    <opaque>
      <!-- a simple data mapping: "StrucId"(MQCHAR4) to "StrucId"(MQCHAR4) -->
      <xsl:if test="StrucId">
        <StrucId>
          <xsl:value-of select="StrucId"/>
        </StrucId>
      </xsl:if>
      <!-- a simple data mapping: "Version"(MQLONG) to "Version"(MQLONG) -->
      <xsl:if test="Version">
        <Version>
          <xsl:value-of select="Version"/>
        </Version>
      </xsl:if>
      <!-- a simple data mapping: "Flags"(MQLONG) to "Flags"(MQLONG) -->
      <xsl:if test="Flags">
        <Flags>
          <xsl:value-of select="Flags"/>
        </Flags>
      </xsl:if>
      <!-- a simple data mapping: "data"(hexBinary) to "data"(hexBinary) -->
      <xsl:if test="data">
        <data>
          <xsl:value-of select="data"/>
        </data>
      </xsl:if>
    </opaque>
  </xsl:template>

  <!-- This rule represents an element mapping: "rfh" to "rfh".  -->
  <xsl:template match="rfh"  mode="localRfhToRfh_839866166">
    <rfh>
      <!-- a simple data mapping: "Flags"(MQLONG) to "Flags"(MQLONG) -->
      <Flags>
        <xsl:value-of select="Flags"/>
      </Flags>
      <!-- a for-each transform: "property"(MQRFHProperty) to "property"(MQRFHProperty) -->
      <xsl:apply-templates select="property" mode="localPropertyToProperty_1285315084"/>
    </rfh>
  </xsl:template>

  <!-- This rule represents a for-each transform: "property" to "property".  -->
  <xsl:template match="property"  mode="localPropertyToProperty_1285315084">
    <property>
      <!-- a simple data mapping: "name"(string) to "name"(string) -->
      <name>
        <xsl:value-of select="name"/>
      </name>
      <!-- a simple data mapping: "value"(string) to "value"(string) -->
      <value>
        <xsl:value-of select="value"/>
      </value>
    </property>
  </xsl:template>

  <!-- This rule represents an element mapping: "rfh2" to "rfh2".  -->
  <xsl:template match="rfh2"  mode="localRfh2ToRfh2_446765729">
    <rfh2>
      <!-- a simple data mapping: "Flags"(MQLONG) to "Flags"(MQLONG) -->
      <Flags>
        <xsl:value-of select="Flags"/>
      </Flags>
      <!-- a simple data mapping: "NameValueCCSID"(MQLONG) to "NameValueCCSID"(MQLONG) -->
      <NameValueCCSID>
        <xsl:value-of select="NameValueCCSID"/>
      </NameValueCCSID>
      <!-- a for-each transform: "folder"(MQRFH2Group) to "folder"(MQRFH2Group) -->
      <xsl:apply-templates select="folder" mode="localFolderToFolder_185226835"/>
    </rfh2>
  </xsl:template>

  <!-- This rule represents a for-each transform: "folder" to "folder".  -->
  <xsl:template match="folder"  mode="localFolderToFolder_185226835">
    <folder>
      <!-- a simple data mapping: "name"(NCName) to "name"(NCName) -->
      <name>
        <xsl:value-of select="name"/>
      </name>
      <!-- a for-each transform: "group"(MQRFH2Group) to "group"(MQRFH2Group) -->
      <xsl:for-each select="group">
        <xsl:copy-of select="."/>
      </xsl:for-each>
      <!-- a for-each transform: "property"(MQRFH2Property) to "property"(MQRFH2Property) -->
      <xsl:apply-templates select="property" mode="localPropertyToProperty_1582827566"/>
    </folder>
  </xsl:template>

  <!-- This rule represents a for-each transform: "property" to "property".  -->
  <xsl:template match="property"  mode="localPropertyToProperty_1582827566">
    <property>
      <!-- a simple data mapping: "name"(NCName) to "name"(NCName) -->
      <name>
        <xsl:value-of select="name"/>
      </name>
      <!-- a simple data mapping: "type"(MQRFH2PropertyType) to "type"(MQRFH2PropertyType) -->
      <xsl:if test="type">
        <type>
          <xsl:value-of select="type"/>
        </type>
      </xsl:if>
      <!-- a simple data mapping: "value"(string) to "value"(string) -->
      <value>
        <xsl:value-of select="value"/>
      </value>
    </property>
  </xsl:template>

  <!-- This rule represents an element mapping: "HTTPHeader" to "HTTPHeader".  -->
  <xsl:template match="HTTPHeader"  mode="localHTTPHeaderToHTTPHeader_604367301">
    <HTTPHeader>
      <!-- a structural mapping: "control"(HTTPControl) to "control"(HTTPControl) -->
      <xsl:apply-templates select="control" mode="localControlToControl_536989076"/>
      <!-- a for-each transform: "header"(HTTPHeader) to "header"(HTTPHeader) -->
      <xsl:apply-templates select="header" mode="localHeaderToHeader_1546632877"/>
    </HTTPHeader>
  </xsl:template>

  <!-- This rule represents an element mapping: "control" to "control".  -->
  <xsl:template match="control"  mode="localControlToControl_536989076">
    <control>
      <!-- a simple data mapping: "io5:URL"(anyURI) to "io5:URL"(anyURI) -->
      <xsl:if test="io5:URL">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:URL)">
            <io5:URL>
              <xsl:value-of select="io5:URL"/>
            </io5:URL>
          </xsl:when>
          <xsl:otherwise>
            <io5:URL xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a simple data mapping: "io5:Version"(HTTPVersion) to "io5:Version"(HTTPVersion) -->
      <xsl:if test="io5:Version">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:Version)">
            <io5:Version>
              <xsl:value-of select="io5:Version"/>
            </io5:Version>
          </xsl:when>
          <xsl:otherwise>
            <io5:Version xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a simple data mapping: "io5:Method"(string) to "io5:Method"(string) -->
      <xsl:if test="io5:Method">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:Method)">
            <io5:Method>
              <xsl:value-of select="io5:Method"/>
            </io5:Method>
          </xsl:when>
          <xsl:otherwise>
            <io5:Method xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a simple data mapping: "io5:DynamicOverrideURL"(anyURI) to "io5:DynamicOverrideURL"(anyURI) -->
      <xsl:if test="io5:DynamicOverrideURL">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:DynamicOverrideURL)">
            <io5:DynamicOverrideURL>
              <xsl:value-of select="io5:DynamicOverrideURL"/>
            </io5:DynamicOverrideURL>
          </xsl:when>
          <xsl:otherwise>
            <io5:DynamicOverrideURL xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a simple data mapping: "io5:DynamicOverrideVersion"(HTTPVersion) to "io5:DynamicOverrideVersion"(HTTPVersion) -->
      <xsl:if test="io5:DynamicOverrideVersion">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:DynamicOverrideVersion)">
            <io5:DynamicOverrideVersion>
              <xsl:value-of select="io5:DynamicOverrideVersion"/>
            </io5:DynamicOverrideVersion>
          </xsl:when>
          <xsl:otherwise>
            <io5:DynamicOverrideVersion xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a simple data mapping: "io5:DynamicOverrideMethod"(string) to "io5:DynamicOverrideMethod"(string) -->
      <xsl:if test="io5:DynamicOverrideMethod">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:DynamicOverrideMethod)">
            <io5:DynamicOverrideMethod>
              <xsl:value-of select="io5:DynamicOverrideMethod"/>
            </io5:DynamicOverrideMethod>
          </xsl:when>
          <xsl:otherwise>
            <io5:DynamicOverrideMethod xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a simple data mapping: "io5:MediaType"(string) to "io5:MediaType"(string) -->
      <xsl:if test="io5:MediaType">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:MediaType)">
            <io5:MediaType>
              <xsl:value-of select="io5:MediaType"/>
            </io5:MediaType>
          </xsl:when>
          <xsl:otherwise>
            <io5:MediaType xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a simple data mapping: "io5:Charset"(string) to "io5:Charset"(string) -->
      <xsl:if test="io5:Charset">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:Charset)">
            <io5:Charset>
              <xsl:value-of select="io5:Charset"/>
            </io5:Charset>
          </xsl:when>
          <xsl:otherwise>
            <io5:Charset xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a simple data mapping: "io5:TransferEncoding"(string) to "io5:TransferEncoding"(string) -->
      <xsl:if test="io5:TransferEncoding">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:TransferEncoding)">
            <io5:TransferEncoding>
              <xsl:value-of select="io5:TransferEncoding"/>
            </io5:TransferEncoding>
          </xsl:when>
          <xsl:otherwise>
            <io5:TransferEncoding xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a simple data mapping: "io5:ContentEncoding"(string) to "io5:ContentEncoding"(string) -->
      <xsl:if test="io5:ContentEncoding">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:ContentEncoding)">
            <io5:ContentEncoding>
              <xsl:value-of select="io5:ContentEncoding"/>
            </io5:ContentEncoding>
          </xsl:when>
          <xsl:otherwise>
            <io5:ContentEncoding xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a simple data mapping: "io5:StatusCode"(int) to "io5:StatusCode"(int) -->
      <xsl:if test="io5:StatusCode">
        <io5:StatusCode>
          <xsl:value-of select="io5:StatusCode"/>
        </io5:StatusCode>
      </xsl:if>
      <!-- a simple data mapping: "io5:ReasonPhrase"(string) to "io5:ReasonPhrase"(string) -->
      <xsl:if test="io5:ReasonPhrase">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:ReasonPhrase)">
            <io5:ReasonPhrase>
              <xsl:value-of select="io5:ReasonPhrase"/>
            </io5:ReasonPhrase>
          </xsl:when>
          <xsl:otherwise>
            <io5:ReasonPhrase xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a simple data mapping: "io5:ContentLength"(int) to "io5:ContentLength"(int) -->
      <xsl:if test="io5:ContentLength">
        <io5:ContentLength>
          <xsl:value-of select="io5:ContentLength"/>
        </io5:ContentLength>
      </xsl:if>
      <!-- a simple data mapping: "io5:ExportContextPath"(string) to "io5:ExportContextPath"(string) -->
      <xsl:if test="io5:ExportContextPath">
        <xsl:choose>
          <xsl:when test="normalize-space(io5:ExportContextPath)">
            <io5:ExportContextPath>
              <xsl:value-of select="io5:ExportContextPath"/>
            </io5:ExportContextPath>
          </xsl:when>
          <xsl:otherwise>
            <io5:ExportContextPath xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <!-- a structural mapping: "io5:Authentication"(HTTPAuthentication) to "io5:Authentication"(HTTPAuthentication) -->
      <xsl:apply-templates select="io5:Authentication" mode="localAuthenticationToAuthentication_753827268"/>
      <!-- a structural mapping: "io5:SSLSettings"(HTTPSSLSettings) to "io5:SSLSettings"(HTTPSSLSettings) -->
      <xsl:apply-templates select="io5:SSLSettings" mode="localSSLSettingsToSSLSettings_233931345"/>
      <!-- a for-each transform: "io5:ProxySettings"(HTTPProxySettings) to "io5:ProxySettings"(HTTPProxySettings) -->
      <xsl:apply-templates select="io5:ProxySettings" mode="localProxySettingsToProxySettings_115436088"/>
    </control>
  </xsl:template>

  <!-- This rule represents an element mapping: "io5:Authentication" to "io5:Authentication".  -->
  <xsl:template match="io5:Authentication"  mode="localAuthenticationToAuthentication_753827268">
    <io5:Authentication>
      <!-- a structural mapping: "io5:credentials"(HTTPCredentials) to "io5:credentials"(HTTPCredentials) -->
      <xsl:apply-templates select="io5:credentials" mode="localCredentialsToCredentials_343782122"/>
      <!-- a simple data mapping: "io5:authenticationType"(HTTPAuthenticationType) to "io5:authenticationType"(HTTPAuthenticationType) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:authenticationType)">
          <io5:authenticationType>
            <xsl:value-of select="io5:authenticationType"/>
          </io5:authenticationType>
        </xsl:when>
        <xsl:otherwise>
          <io5:authenticationType xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
    </io5:Authentication>
  </xsl:template>

  <!-- This rule represents an element mapping: "io5:credentials" to "io5:credentials".  -->
  <xsl:template match="io5:credentials"  mode="localCredentialsToCredentials_343782122">
    <io5:credentials>
      <!-- a simple data mapping: "io5:userId"(string) to "io5:userId"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:userId)">
          <io5:userId>
            <xsl:value-of select="io5:userId"/>
          </io5:userId>
        </xsl:when>
        <xsl:otherwise>
          <io5:userId xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:password"(string) to "io5:password"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:password)">
          <io5:password>
            <xsl:value-of select="io5:password"/>
          </io5:password>
        </xsl:when>
        <xsl:otherwise>
          <io5:password xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
    </io5:credentials>
  </xsl:template>

  <!-- This rule represents an element mapping: "io5:SSLSettings" to "io5:SSLSettings".  -->
  <xsl:template match="io5:SSLSettings"  mode="localSSLSettingsToSSLSettings_233931345">
    <io5:SSLSettings>
      <!-- a simple data mapping: "io5:SSLVersion"(string) to "io5:SSLVersion"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:SSLVersion)">
          <io5:SSLVersion>
            <xsl:value-of select="io5:SSLVersion"/>
          </io5:SSLVersion>
        </xsl:when>
        <xsl:otherwise>
          <io5:SSLVersion xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:SSLDebug"(boolean) to "io5:SSLDebug"(boolean) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:SSLDebug)">
          <io5:SSLDebug>
            <xsl:value-of select="io5:SSLDebug"/>
          </io5:SSLDebug>
        </xsl:when>
        <xsl:otherwise>
          <io5:SSLDebug xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:KeyStoreType"(string) to "io5:KeyStoreType"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:KeyStoreType)">
          <io5:KeyStoreType>
            <xsl:value-of select="io5:KeyStoreType"/>
          </io5:KeyStoreType>
        </xsl:when>
        <xsl:otherwise>
          <io5:KeyStoreType xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:TrustStoreType"(string) to "io5:TrustStoreType"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:TrustStoreType)">
          <io5:TrustStoreType>
            <xsl:value-of select="io5:TrustStoreType"/>
          </io5:TrustStoreType>
        </xsl:when>
        <xsl:otherwise>
          <io5:TrustStoreType xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:KeyStore"(string) to "io5:KeyStore"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:KeyStore)">
          <io5:KeyStore>
            <xsl:value-of select="io5:KeyStore"/>
          </io5:KeyStore>
        </xsl:when>
        <xsl:otherwise>
          <io5:KeyStore xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:KeyStoreAlias"(string) to "io5:KeyStoreAlias"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:KeyStoreAlias)">
          <io5:KeyStoreAlias>
            <xsl:value-of select="io5:KeyStoreAlias"/>
          </io5:KeyStoreAlias>
        </xsl:when>
        <xsl:otherwise>
          <io5:KeyStoreAlias xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:KeyStorePassword"(string) to "io5:KeyStorePassword"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:KeyStorePassword)">
          <io5:KeyStorePassword>
            <xsl:value-of select="io5:KeyStorePassword"/>
          </io5:KeyStorePassword>
        </xsl:when>
        <xsl:otherwise>
          <io5:KeyStorePassword xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:TrustStore"(string) to "io5:TrustStore"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:TrustStore)">
          <io5:TrustStore>
            <xsl:value-of select="io5:TrustStore"/>
          </io5:TrustStore>
        </xsl:when>
        <xsl:otherwise>
          <io5:TrustStore xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:TrustStorePassword"(string) to "io5:TrustStorePassword"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:TrustStorePassword)">
          <io5:TrustStorePassword>
            <xsl:value-of select="io5:TrustStorePassword"/>
          </io5:TrustStorePassword>
        </xsl:when>
        <xsl:otherwise>
          <io5:TrustStorePassword xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:UseClientAuth"(boolean) to "io5:UseClientAuth"(boolean) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:UseClientAuth)">
          <io5:UseClientAuth>
            <xsl:value-of select="io5:UseClientAuth"/>
          </io5:UseClientAuth>
        </xsl:when>
        <xsl:otherwise>
          <io5:UseClientAuth xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
    </io5:SSLSettings>
  </xsl:template>

  <!-- This rule represents a for-each transform: "io5:ProxySettings" to "io5:ProxySettings".  -->
  <xsl:template match="io5:ProxySettings"  mode="localProxySettingsToProxySettings_115436088">
    <io5:ProxySettings>
      <!-- a simple data mapping: "io5:proxyHost"(string) to "io5:proxyHost"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:proxyHost)">
          <io5:proxyHost>
            <xsl:value-of select="io5:proxyHost"/>
          </io5:proxyHost>
        </xsl:when>
        <xsl:otherwise>
          <io5:proxyHost xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:proxyPort"(int) to "io5:proxyPort"(int) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:proxyPort)">
          <io5:proxyPort>
            <xsl:value-of select="io5:proxyPort"/>
          </io5:proxyPort>
        </xsl:when>
        <xsl:otherwise>
          <io5:proxyPort xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:proxyType"(HTTPProxyType) to "io5:proxyType"(HTTPProxyType) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:proxyType)">
          <io5:proxyType>
            <xsl:value-of select="io5:proxyType"/>
          </io5:proxyType>
        </xsl:when>
        <xsl:otherwise>
          <io5:proxyType xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a structural mapping: "io5:proxyCredentials"(HTTPCredentials) to "io5:proxyCredentials"(HTTPCredentials) -->
      <xsl:apply-templates select="io5:proxyCredentials" mode="localProxyCredentialsToProxyCredentials_1746894026"/>
      <!-- a simple data mapping: "io5:nonProxyHost"(string) to "io5:nonProxyHost"(string) -->
      <xsl:for-each select="io5:nonProxyHost">
        <xsl:choose>
          <xsl:when test="normalize-space(.)">
            <io5:nonProxyHost>
              <xsl:value-of select="."/>
            </io5:nonProxyHost>
          </xsl:when>
          <xsl:otherwise>
            <io5:nonProxyHost xsi:nil="true"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </io5:ProxySettings>
  </xsl:template>

  <!-- This rule represents an element mapping: "io5:proxyCredentials" to "io5:proxyCredentials".  -->
  <xsl:template match="io5:proxyCredentials"  mode="localProxyCredentialsToProxyCredentials_1746894026">
    <io5:proxyCredentials>
      <!-- a simple data mapping: "io5:userId"(string) to "io5:userId"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:userId)">
          <io5:userId>
            <xsl:value-of select="io5:userId"/>
          </io5:userId>
        </xsl:when>
        <xsl:otherwise>
          <io5:userId xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- a simple data mapping: "io5:password"(string) to "io5:password"(string) -->
      <xsl:choose>
        <xsl:when test="normalize-space(io5:password)">
          <io5:password>
            <xsl:value-of select="io5:password"/>
          </io5:password>
        </xsl:when>
        <xsl:otherwise>
          <io5:password xsi:nil="true"/>
        </xsl:otherwise>
      </xsl:choose>
    </io5:proxyCredentials>
  </xsl:template>

  <!-- This rule represents a for-each transform: "header" to "header".  -->
  <xsl:template match="header"  mode="localHeaderToHeader_1546632877">
    <header>
      <!-- a simple data mapping: "io5:name"(string) to "io5:name"(string) -->
      <io5:name>
        <xsl:value-of select="io5:name"/>
      </io5:name>
      <!-- a simple data mapping: "io5:value"(string) to "io5:value"(string) -->
      <io5:value>
        <xsl:value-of select="io5:value"/>
      </io5:value>
    </header>
  </xsl:template>

  <!-- This rule represents an element mapping: "EISHeader" to "EISHeader".  -->
  <xsl:template match="EISHeader"  mode="localEISHeaderToEISHeader_1781709972">
    <EISHeader>
      <!-- a structural mapping: "EISInteractionSpec"(anyType) to "EISInteractionSpec"(anyType) -->
      <xsl:if test="EISInteractionSpec">
        <xsl:copy-of select="EISInteractionSpec"/>
      </xsl:if>
      <!-- a structural mapping: "EISConnectionSpec"(anyType) to "EISConnectionSpec"(anyType) -->
      <xsl:if test="EISConnectionSpec">
        <xsl:copy-of select="EISConnectionSpec"/>
      </xsl:if>
    </EISHeader>
  </xsl:template>

  <!-- This rule represents an element mapping: "WSAHeader" to "WSAHeader".  -->
  <xsl:template match="WSAHeader"  mode="localWSAHeaderToWSAHeader_414362306">
    <WSAHeader>
      <!-- a simple data mapping: "@version"(WSASchemaType) to "version"(WSASchemaType) -->
      <xsl:if test="@version">
        <xsl:attribute name="version">
          <xsl:value-of select="@version"/>
        </xsl:attribute>
      </xsl:if>
      <!-- a structural mapping: "io6:To"(AttributedURIType) to "io6:To"(AttributedURIType) -->
      <xsl:apply-templates select="io6:To" mode="localToToTo_629933223"/>
      <!-- a structural mapping: "ReferenceParameters"(ReferenceParametersType) to "ReferenceParameters"(ReferenceParametersType) -->
      <xsl:apply-templates select="ReferenceParameters" mode="localReferenceParametersToReferenceParameters_1792540345"/>
      <!-- a structural mapping: "io6:From"(EndpointReferenceType) to "io6:From"(EndpointReferenceType) -->
      <xsl:apply-templates select="io6:From" mode="localFromToFrom_387787347"/>
      <!-- a structural mapping: "io6:ReplyTo"(EndpointReferenceType) to "io6:ReplyTo"(EndpointReferenceType) -->
      <xsl:apply-templates select="io6:ReplyTo" mode="localReplyToToReplyTo_421465974"/>
      <!-- a structural mapping: "io6:FaultTo"(EndpointReferenceType) to "io6:FaultTo"(EndpointReferenceType) -->
      <xsl:apply-templates select="io6:FaultTo" mode="localFaultToToFaultTo_971596560"/>
      <!-- a structural mapping: "io6:Action"(AttributedURIType) to "io6:Action"(AttributedURIType) -->
      <xsl:apply-templates select="io6:Action" mode="localActionToAction_692257208"/>
      <!-- a structural mapping: "io6:MessageID"(AttributedURIType) to "io6:MessageID"(AttributedURIType) -->
      <xsl:apply-templates select="io6:MessageID" mode="localMessageIDToMessageID_195348630"/>
      <!-- a for-each transform: "io6:RelatesTo"(RelatesToType) to "io6:RelatesTo"(RelatesToType) -->
      <xsl:apply-templates select="io6:RelatesTo" mode="localRelatesToToRelatesTo_1402638946"/>
    </WSAHeader>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:To" to "io6:To".  -->
  <xsl:template match="io6:To"  mode="localToToTo_629933223">
    <io6:To>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a simple content mapping -->
      <xsl:value-of select="."/>
    </io6:To>
  </xsl:template>

  <!-- This rule represents an element mapping: "ReferenceParameters" to "ReferenceParameters".  -->
  <xsl:template match="ReferenceParameters"  mode="localReferenceParametersToReferenceParameters_1792540345">
    <ReferenceParameters>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="*"/>
    </ReferenceParameters>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:From" to "io6:From".  -->
  <xsl:template match="io6:From"  mode="localFromToFrom_387787347">
    <io6:From>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a structural mapping: "io6:Address"(AttributedURIType) to "io6:Address"(AttributedURIType) -->
      <xsl:apply-templates select="io6:Address" mode="localAddressToAddress_365092316"/>
      <!-- a structural mapping: "io6:ReferenceParameters"(ReferenceParametersType) to "io6:ReferenceParameters"(ReferenceParametersType) -->
      <xsl:apply-templates select="io6:ReferenceParameters" mode="localReferenceParametersToReferenceParameters_680978330"/>
      <!-- a structural mapping: "io6:Metadata"(MetadataType) to "io6:Metadata"(MetadataType) -->
      <xsl:apply-templates select="io6:Metadata" mode="localMetadataToMetadata_937846653"/>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="io6:Metadata/following-sibling::*[namespace-uri(.) != namespace-uri(..) ]"/>
    </io6:From>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:Address" to "io6:Address".  -->
  <xsl:template match="io6:Address"  mode="localAddressToAddress_365092316">
    <io6:Address>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a simple content mapping -->
      <xsl:value-of select="."/>
    </io6:Address>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:ReferenceParameters" to "io6:ReferenceParameters".  -->
  <xsl:template match="io6:ReferenceParameters"  mode="localReferenceParametersToReferenceParameters_680978330">
    <io6:ReferenceParameters>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="*"/>
    </io6:ReferenceParameters>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:Metadata" to "io6:Metadata".  -->
  <xsl:template match="io6:Metadata"  mode="localMetadataToMetadata_937846653">
    <io6:Metadata>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="*"/>
    </io6:Metadata>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:ReplyTo" to "io6:ReplyTo".  -->
  <xsl:template match="io6:ReplyTo"  mode="localReplyToToReplyTo_421465974">
    <io6:ReplyTo>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a structural mapping: "io6:Address"(AttributedURIType) to "io6:Address"(AttributedURIType) -->
      <xsl:apply-templates select="io6:Address" mode="localAddressToAddress_1048936638"/>
      <!-- a structural mapping: "io6:ReferenceParameters"(ReferenceParametersType) to "io6:ReferenceParameters"(ReferenceParametersType) -->
      <xsl:apply-templates select="io6:ReferenceParameters" mode="localReferenceParametersToReferenceParameters_1160029694"/>
      <!-- a structural mapping: "io6:Metadata"(MetadataType) to "io6:Metadata"(MetadataType) -->
      <xsl:apply-templates select="io6:Metadata" mode="localMetadataToMetadata_114091420"/>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="io6:Metadata/following-sibling::*[namespace-uri(.) != namespace-uri(..) ]"/>
    </io6:ReplyTo>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:Address" to "io6:Address".  -->
  <xsl:template match="io6:Address"  mode="localAddressToAddress_1048936638">
    <io6:Address>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a simple content mapping -->
      <xsl:value-of select="."/>
    </io6:Address>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:ReferenceParameters" to "io6:ReferenceParameters".  -->
  <xsl:template match="io6:ReferenceParameters"  mode="localReferenceParametersToReferenceParameters_1160029694">
    <io6:ReferenceParameters>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="*"/>
    </io6:ReferenceParameters>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:Metadata" to "io6:Metadata".  -->
  <xsl:template match="io6:Metadata"  mode="localMetadataToMetadata_114091420">
    <io6:Metadata>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="*"/>
    </io6:Metadata>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:FaultTo" to "io6:FaultTo".  -->
  <xsl:template match="io6:FaultTo"  mode="localFaultToToFaultTo_971596560">
    <io6:FaultTo>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a structural mapping: "io6:Address"(AttributedURIType) to "io6:Address"(AttributedURIType) -->
      <xsl:apply-templates select="io6:Address" mode="localAddressToAddress_2103321810"/>
      <!-- a structural mapping: "io6:ReferenceParameters"(ReferenceParametersType) to "io6:ReferenceParameters"(ReferenceParametersType) -->
      <xsl:apply-templates select="io6:ReferenceParameters" mode="localReferenceParametersToReferenceParameters_2017955769"/>
      <!-- a structural mapping: "io6:Metadata"(MetadataType) to "io6:Metadata"(MetadataType) -->
      <xsl:apply-templates select="io6:Metadata" mode="localMetadataToMetadata_872258529"/>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="io6:Metadata/following-sibling::*[namespace-uri(.) != namespace-uri(..) ]"/>
    </io6:FaultTo>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:Address" to "io6:Address".  -->
  <xsl:template match="io6:Address"  mode="localAddressToAddress_2103321810">
    <io6:Address>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a simple content mapping -->
      <xsl:value-of select="."/>
    </io6:Address>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:ReferenceParameters" to "io6:ReferenceParameters".  -->
  <xsl:template match="io6:ReferenceParameters"  mode="localReferenceParametersToReferenceParameters_2017955769">
    <io6:ReferenceParameters>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="*"/>
    </io6:ReferenceParameters>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:Metadata" to "io6:Metadata".  -->
  <xsl:template match="io6:Metadata"  mode="localMetadataToMetadata_872258529">
    <io6:Metadata>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a wildcard mapping: "any" to "any" -->
      <xsl:copy-of select="*"/>
    </io6:Metadata>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:Action" to "io6:Action".  -->
  <xsl:template match="io6:Action"  mode="localActionToAction_692257208">
    <io6:Action>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a simple content mapping -->
      <xsl:value-of select="."/>
    </io6:Action>
  </xsl:template>

  <!-- This rule represents an element mapping: "io6:MessageID" to "io6:MessageID".  -->
  <xsl:template match="io6:MessageID"  mode="localMessageIDToMessageID_195348630">
    <io6:MessageID>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a simple content mapping -->
      <xsl:value-of select="."/>
    </io6:MessageID>
  </xsl:template>

  <!-- This rule represents a for-each transform: "io6:RelatesTo" to "io6:RelatesTo".  -->
  <xsl:template match="io6:RelatesTo"  mode="localRelatesToToRelatesTo_1402638946">
    <io6:RelatesTo>
      <!-- a simple data mapping: "@RelationshipType"(RelationshipTypeOpenEnum) to "RelationshipType"(RelationshipTypeOpenEnum) -->
      <xsl:if test="@RelationshipType">
        <xsl:attribute name="RelationshipType">
          <xsl:value-of select="@RelationshipType"/>
        </xsl:attribute>
      </xsl:if>
      <!-- an attribute wildcard mapping: "@anyAttribute" to "anyAttribute" -->
      <xsl:copy-of select="@*[namespace-uri(.) != namespace-uri(..) ]"/>
      <!-- a simple content mapping -->
      <xsl:value-of select="."/>
    </io6:RelatesTo>
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
