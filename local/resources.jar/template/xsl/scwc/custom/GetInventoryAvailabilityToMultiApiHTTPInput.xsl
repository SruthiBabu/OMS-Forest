<?xml version="1.0" encoding="UTF-8"?>
<!-- 	Licensed Materials - Property of IBM 	IBM Sterling Order Management (5725-D10) 	IBM Sterling Configure Price Quote (5725-D11) 	(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved. 	US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp. -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xalan="http://xml.apache.org/xslt" 
	xmlns:oa="http://www.openapplications.org/oagis/9" 
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil" 
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation" 
	xmlns:_inv="http://www.ibm.com/xmlns/prod/commerce/9/inventory" 
	xmlns:ma="http://www.sterlingcommerce.com/documentation/YCP/multiApi/input" 
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData" 
	extension-element-prefixes="mediationUtil ValueMaps" exclude-result-prefixes="xalan oa _wcf _inv ma scwc" version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>
  <xsl:strip-space elements="*"/>
  <!--	The rule represents a custom mapping: "in5:GetInventoryAvailability"	to "ApiInput". 	-->
  <xsl:template name="GetInventoryAvailabilityToApiInput">
    <xsl:param name="GetInventoryAvailability"/>
    <xsl:variable name="storeId" select="$GetInventoryAvailability/*[local-name()='ApplicationArea']/_wcf:BusinessContext/_wcf:ContextData[@name='storeId']/text()"/>
    <xsl:variable name="organizationCode" select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $storeId)"/>
    <xsl:variable name="expression" select="$GetInventoryAvailability/_inv:DataArea/oa:Get/oa:Expression"/>
    <xsl:variable name="xpathParameters" select="mediationUtil:xpathParameters($expression)"/>
    <xsl:variable name="partNumbers" select="mediationUtil:getXPathValuesByParameterName($xpathParameters, 'PartNumber.1')"/>
    <xsl:variable name="uoms" select="mediationUtil:getXPathValuesByParameterName($xpathParameters, 'uom.1')"/>
    <xsl:variable name="physicalStoreIdentifiers" select="mediationUtil:getXPathValuesByParameterName($xpathParameters, 'ExternalIdentifier.1')"/>
    <xsl:variable name="onlineStoreIdentifiers" select="mediationUtil:getXPathValuesByParameterName($xpathParameters, 'NameIdentifier.1')"/>
    <xsl:variable name="totalNum" select="count($partNumbers)"/>
    <xsl:variable name="isPhysicalExist">
      <xsl:call-template name="determinePhysicalStore">
        <xsl:with-param name="index" select="1"/>
        <xsl:with-param name="totalNum" select=" $totalNum"/>
        <xsl:with-param name="physicalStoreIdentifiers" select=" $physicalStoreIdentifiers"/>
      </xsl:call-template>
    </xsl:variable>
    <MultiApi>
      <xsl:for-each select="$partNumbers">
        <xsl:variable name="index" select="position()"/>
        <!-- Part number -->
        <xsl:variable name="partNumber" select="."/>
        <!-- Online store -->
        <xsl:variable name="onlineStoreIdentifier" select="$onlineStoreIdentifiers[$index]"/>
        <xsl:if test="string-length(normalize-space($onlineStoreIdentifier)) &gt; 0">
          <!-- UOM -->
          <xsl:variable name="wcUOM" select="$uoms[$index]"/>
          <xsl:variable name="scUOM">
            <xsl:choose>
              <xsl:when test="string-length(normalize-space($wcUOM)) &gt; 0">
                <xsl:variable name="tmpSCUOM" select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcUOMToscUOM', $wcUOM)"/>
                <xsl:choose>
                  <xsl:when test="string-length(normalize-space($tmpSCUOM)) &gt; 0">
                    <xsl:value-of select="$tmpSCUOM"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>EACH</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>EACH</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <!-- API call for online store -->
          <API Name="monitorItemAvailability">
            <Input>
              <MonitorItemAvailability>
                <xsl:attribute name="ItemID">
                  <xsl:value-of select="$partNumber"/>
                </xsl:attribute>
                <xsl:attribute name="CallingOrganizationCode">
                  <xsl:value-of select="$organizationCode"/>
                </xsl:attribute>
                <xsl:attribute name="UnitOfMeasure">
                  <xsl:value-of select="$scUOM"/>
                </xsl:attribute>
              </MonitorItemAvailability>
            </Input>
          </API>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="$isPhysicalExist='true'">
        <API Name="findInventory">
          <Input>
            <Promise>
              <xsl:attribute name="OrganizationCode">
                <xsl:value-of select="$organizationCode"/>
              </xsl:attribute>
              <PromiseLines>
                <xsl:for-each select="$partNumbers">
                  <xsl:variable name="index" select="position()"/>
                  <!-- Part number -->
                  <xsl:variable name="partNumber" select="."/>
                  <!-- Physical store -->
                  <xsl:variable name="physicalStoreIdentifier" select="$physicalStoreIdentifiers[$index]"/>
                  <xsl:if test="string-length(normalize-space($physicalStoreIdentifier)) &gt; 0">
                    <!-- UOM -->
                    <xsl:variable name="wcUOM" select="$uoms[$index]"/>
                    <xsl:variable name="scUOM">
                      <xsl:choose>
                        <xsl:when test="string-length(normalize-space($wcUOM)) &gt; 0">
                          <xsl:variable name="tmpSCUOM" select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcUOMToscUOM', $wcUOM)"/>
                          <xsl:choose>
                            <xsl:when test="string-length(normalize-space($tmpSCUOM)) &gt; 0">
                              <xsl:value-of select="$tmpSCUOM"/>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>EACH</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:text>EACH</xsl:text>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <!-- API call for physical store -->
                    <PromiseLine RequiredQty="999999999">
                      <xsl:variable name="lineId" select="$index"/>
                      <xsl:variable name="scShipNode">
                        <xsl:variable name="tmpSCShipNode" select="ValueMaps:getMapValue($scwc:ValueMapsData, $organizationCode, 'wcShipNodeToscShipNode', $physicalStoreIdentifier)"/>
                        <xsl:choose>
                          <xsl:when test="string-length(normalize-space($tmpSCShipNode)) &gt; 0">
                            <xsl:value-of select="$tmpSCShipNode"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="$physicalStoreIdentifier"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <xsl:attribute name="UnitOfMeasure">
                        <xsl:value-of select="$scUOM"/>
                      </xsl:attribute>
                      <xsl:attribute name="ItemID">
                        <xsl:value-of select="$partNumber"/>
                      </xsl:attribute>
                      <xsl:attribute name="ShipNode">
                        <xsl:value-of select="$scShipNode"/>
                      </xsl:attribute>
                      <xsl:attribute name="LineId">
                        <xsl:value-of select="concat('physical_', format-number($lineId, '#'))"/>
                      </xsl:attribute>
                    </PromiseLine>
                  </xsl:if>
                </xsl:for-each>
              </PromiseLines>
            </Promise>
          </Input>
        </API>
      </xsl:if>
    </MultiApi>
  </xsl:template>
  <xsl:template name="determinePhysicalStore">
    <xsl:param name="index"/>
    <xsl:param name="totalNum"/>
    <xsl:param name="physicalStoreIdentifiers"/>
    <xsl:choose>
      <xsl:when test="$index &gt; $totalNum">
        <xsl:text>false</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="physicalStoreIdentifier" select="$physicalStoreIdentifiers[$index]"/>
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($physicalStoreIdentifier)) &gt; 0 ">
            <xsl:text>true</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="determinePhysicalStore">
              <xsl:with-param name="index" select="$index + 1"/>
              <xsl:with-param name="totalNum" select="$totalNum"/>
              <xsl:with-param name="physicalStoreIdentifiers" select="$physicalStoreIdentifiers"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
