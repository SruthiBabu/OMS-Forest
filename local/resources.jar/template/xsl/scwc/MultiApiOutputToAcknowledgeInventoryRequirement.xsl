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
    xmlns:in="http://www.sterlingcommerce.com/documentation/MasterOrder"
    xmlns:in8="wsdl.http://WCToSSFSMediationModule/SSFSInventoryHTTPInterface"
    xmlns:in2="http://www.sterlingcommerce.com/documentation/YFSError"
    xmlns:in3="http://www.sterlingcommerce.com/documentation/YFS/getOrderLineDetails/output"
    xmlns:in9="http://WCToSSFSMediationModule/documentation/SterlingResponseRoot"
    xmlns:in4="http://www.sterlingcommerce.com/documentation/YCP/multiApi/input"
    xmlns:in5="http://WCToSSFSMediationModule/multiApi"
    xmlns:in10="http://WCToSSFSMediationModule/SSFSInventoryHTTPInterface"
    xmlns:in11="http://www.sterlingcommerce.com/documentation/YFS/reserveAvailableInventory/output"
    xmlns:in6="http://www.sterlingcommerce.com/documentation/YFS/reserveAvailableInventory/input"
    xmlns:in12="http://www.sterlingcommerce.com/documentation/YFS/monitorItemAvailability/output"
    xmlns:in13="http://www.sterlingcommerce.com/documentation/YCP/multiApi/output"
    xmlns:in14="http://www.sterlingcommerce.com/documentation/YCP/getPage/output"
    xmlns:in7="http://WCToSSFSMediationModule/reserveAvailableInventory"
    xmlns:in15="http://www.sterlingcommerce.com/documentation/YFS/findInventory/output"
    xmlns:io3="http://www.w3.org/2003/05/soap-envelope"
    xmlns:io4="http://www.ibm.com/websphere/sibx/smo/v6.0.1"
    xmlns:out="http://www.openapplications.org/oagis/9"
    xmlns:out6="http://www.ibm.com/xmlns/prod/commerce/9/inventory"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:out7="http://www.openapplications.org/oagis/9/currencycode/54217:2001"
    xmlns:out8="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
    xmlns:out9="wsdl.http://www.ibm.com/xmlns/prod/commerce/9/inventory"
    xmlns:io="http://www.ibm.com/xmlns/prod/websphere/mq/sca/6.0.0"
    xmlns:io2="http://schemas.xmlsoap.org/ws/2004/08/addressing"
    xmlns:io5="http://www.ibm.com/xmlns/prod/websphere/http/sca/6.1.0"
    xmlns:out2="http://www.ibm.com/xmlns/prod/commerce/9/order"
    xmlns:out10="http://www.openapplications.org/oagis/9/unitcode/66411:2001"
    xmlns:out3="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
    xmlns:out4="http://www.openapplications.org/oagis/9/languagecode/5639:1988"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:io6="http://www.w3.org/2005/08/addressing"
    xmlns:out5="http://www.openapplications.org/oagis/9/IANAMIMEMediaTypes:2003"
    exclude-result-prefixes="xalan"
    version="1.0">

  <xsl:import href="template/xsl/scwc/custom/MultiApiOutputToAcknowledgeInventoryRequirement.xsl"/>
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>

  <xsl:template match="/" >
      	<xsl:apply-templates select="context" mode="localContextToContext_1166638733"/>
        <xsl:variable name="Root" select="/ResponseData/Body"/>
        <xsl:call-template name="RootToAcknowledgeInventoryRequirement">
          <xsl:with-param name="Root" select="$Root"/>
        </xsl:call-template>
  </xsl:template>

  <xsl:template match="context"  mode="localContextToContext_1166638733">
    <context>
      <xsl:if test="correlation">
        <xsl:copy-of select="correlation"/>
      </xsl:if>
    </context>
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
