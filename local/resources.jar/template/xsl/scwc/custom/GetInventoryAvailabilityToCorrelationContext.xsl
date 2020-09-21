<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xalan="http://xml.apache.org/xslt" xmlns:oa="http://www.openapplications.org/oagis/9" 
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil" 
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation" 
	xmlns:_inv="http://www.ibm.com/xmlns/prod/commerce/9/inventory" 
	extension-element-prefixes="mediationUtil ValueMaps"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/" xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData" 
	exclude-result-prefixes="xalan oa _wcf _inv scwc" version="1.0">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="scwc:ValueMapsData" />
  <xsl:template name="GetInventoryAvailabilityToCorrelation">
    <xsl:param name="GetInventoryAvailability1"/>
    <xsl:variable name="expression" select="$GetInventoryAvailability1/_inv:DataArea/oa:Get/oa:Expression"/>
    <xsl:variable name="xpathParameters" select="mediationUtil:xpathParameters($expression)"/>
    <xsl:variable name="partNumbers" select="mediationUtil:getXPathValuesByParameterName($xpathParameters, 'PartNumber.1')"/>
    <xsl:variable name="uoms" select="mediationUtil:getXPathValuesByParameterName($xpathParameters, 'uom.1')"/>
    <xsl:variable name="physicalStoreIdentifiers" select="mediationUtil:getXPathValuesByParameterName($xpathParameters, 'ExternalIdentifier.1')"/>
    <xsl:variable name="onlineStoreIdentifiers" select="mediationUtil:getXPathValuesByParameterName($xpathParameters, 'NameIdentifier.1')"/>
    <xsl:variable name="totalNum" select="count($partNumbers)"/>
    
    <GetInvAvlMultiApi> 
      <xsl:call-template name="GetInventoryAvailabilityToCorrelationAndDeterminOnlineIndex">
        <xsl:with-param name="index" select="1"/>
        <xsl:with-param name="onlineStoreIndex" select="1"/>
        <xsl:with-param name="totalNum" select=" $totalNum"/>
        <xsl:with-param name="partNumbers" select=" $partNumbers"/>
        <xsl:with-param name="uoms" select=" $uoms"/>
        <xsl:with-param name="physicalStoreIdentifiers" select=" $physicalStoreIdentifiers"/>
        <xsl:with-param name="onlineStoreIdentifiers" select=" $onlineStoreIdentifiers"/>
      </xsl:call-template>
    </GetInvAvlMultiApi>
  </xsl:template>
  <xsl:template name="GetInventoryAvailabilityToCorrelationAndDeterminOnlineIndex">
    <xsl:param name="index"/>
    <xsl:param name="onlineStoreIndex"/>
    <xsl:param name="totalNum"/>
    <xsl:param name="partNumbers"/>
    <xsl:param name="uoms"/>
    <xsl:param name="physicalStoreIdentifiers"/>
    <xsl:param name="onlineStoreIdentifiers"/>
    <xsl:choose>
      <xsl:when test="$index &gt; $totalNum">
        <!-- Do nothing and Return -->
      </xsl:when>
      <xsl:otherwise>
        <!-- Part number -->
        <xsl:variable name="partNumber" select="$partNumbers[$index]"/>
        <!-- UOM -->
        <xsl:variable name="uom">
          <xsl:variable name="tmpUOM" select="$uoms[$index]"/>
          <xsl:choose>
            <xsl:when test="string-length(normalize-space($tmpUOM)) &gt; 0">
              <xsl:value-of select="$tmpUOM"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>C62</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- Physical store -->
        <xsl:variable name="physicalStoreIdentifier" select="$physicalStoreIdentifiers[$index]"/>
        <!-- Online store -->
        <xsl:variable name="onlineStoreIdentifier" select="$onlineStoreIdentifiers[$index]"/>
        <!-- SC UOM -->
        <xsl:variable name="scUOM">
          <xsl:choose>
			<xsl:when test="string-length(normalize-space($uom)) &gt; 0">
				<xsl:variable
					name="tmpSCUOM"
					select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'wcUOMToscUOM', $uom)" />
				<xsl:choose>
					<xsl:when test="string-length(normalize-space($tmpSCUOM)) &gt; 0">
						<xsl:value-of select="$tmpSCUOM" />
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
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($physicalStoreIdentifier)) &gt; 0">
            <APIInputExtn>
              <xsl:attribute name="partNumber">
                <xsl:value-of select="$partNumber"/>
              </xsl:attribute>
              <xsl:attribute name="uom">
                <xsl:value-of select="$uom"/>
              </xsl:attribute>
              <xsl:attribute name="scUOM">
                <xsl:value-of select="$scUOM"/>
              </xsl:attribute>
              <xsl:attribute name="physicalStoreIdentifier">
                <xsl:value-of select="$physicalStoreIdentifier"/>
              </xsl:attribute>
            </APIInputExtn>
            <xsl:call-template name="GetInventoryAvailabilityToCorrelationAndDeterminOnlineIndex">
              <xsl:with-param name="index" select="$index + 1"/>
              <xsl:with-param name="onlineStoreIndex" select="$onlineStoreIndex"/>
              <xsl:with-param name="totalNum" select="$totalNum"/>
              <xsl:with-param name="partNumbers" select=" $partNumbers"/>
              <xsl:with-param name="uoms" select=" $uoms"/>
              <xsl:with-param name="physicalStoreIdentifiers" select="$physicalStoreIdentifiers"/>
              <xsl:with-param name="onlineStoreIdentifiers" select="$onlineStoreIdentifiers"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="string-length(normalize-space($onlineStoreIdentifier)) &gt; 0">
            <APIInputExtn>
              <xsl:attribute name="partNumber">
                <xsl:value-of select="$partNumber"/>
              </xsl:attribute>
              <xsl:attribute name="uom">
                <xsl:value-of select="$uom"/>
              </xsl:attribute>
              <xsl:attribute name="scUOM">
                <xsl:value-of select="$scUOM"/>
              </xsl:attribute>
              <xsl:attribute name="onlineStoreIdentifier">
                <xsl:value-of select="$onlineStoreIdentifier"/>
              </xsl:attribute>
              <xsl:attribute name="onlineStoreIndex">
                <xsl:value-of select="$onlineStoreIndex"/>
              </xsl:attribute>
            </APIInputExtn>
            <xsl:call-template name="GetInventoryAvailabilityToCorrelationAndDeterminOnlineIndex">
              <xsl:with-param name="index" select="$index + 1"/>
              <xsl:with-param name="onlineStoreIndex" select="$onlineStoreIndex + 1"/>
              <xsl:with-param name="totalNum" select="$totalNum"/>
              <xsl:with-param name="partNumbers" select=" $partNumbers"/>
              <xsl:with-param name="uoms" select=" $uoms"/>
              <xsl:with-param name="physicalStoreIdentifiers" select="$physicalStoreIdentifiers"/>
              <xsl:with-param name="onlineStoreIdentifiers" select="$onlineStoreIdentifiers"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <!-- Do Nothing -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
