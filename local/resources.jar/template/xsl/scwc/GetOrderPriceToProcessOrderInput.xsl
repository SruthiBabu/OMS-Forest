<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:xalan="http://xml.apache.org/xslt" 
 exclude-result-prefixes="xalan" version="1.0">
  <!-- imports -->
  <xsl:import href="template/xsl/scwc/custom/GetOrderPriceToProcessOrderInput.xsl"/>
  <xsl:output method="xml" encoding="UTF-8" indent="no"/>
   <xsl:template match="/" >
    <xsl:variable name="Order" select="/Order"/>
    <RequestData>
      <context>
        <correlation>
            <OrderInfo>
              <xsl:if test="$Order/@BuyerUserId">
                <xsl:attribute name="BuyerUserId">
                  <xsl:value-of select="$Order/@BuyerUserId"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$Order/@CustomerID">
                <xsl:attribute name="CustomerID">
                  <xsl:value-of select="$Order/@CustomerID"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$Order/@EnterpriseCode">
                <xsl:attribute name="EnterpriseCode">
                  <xsl:value-of select="$Order/@EnterpriseCode"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$Order/@OrderReference">
                <xsl:attribute name="OrderReference">
                  <xsl:value-of select="$Order/@OrderReference"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:attribute name="OrganizationCode">
                <xsl:value-of select="$Order/@OrganizationCode"/>
              </xsl:attribute>
              <xsl:if test="$Order/@PricingDate">
                <xsl:attribute name="PricingDate">
                  <xsl:value-of select="$Order/@PricingDate"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$Order/@RunCatalogOnlyRules">
                <xsl:attribute name="RunCatalogOnlyRules">
                  <xsl:value-of select="$Order/@RunCatalogOnlyRules"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$Order/@SuggestManualRuleAdjustments">
                <xsl:attribute name="SuggestManualRuleAdjustments">
                  <xsl:value-of select="$Order/@SuggestManualRuleAdjustments"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$Order/@SuppressRuleExecution">
                <xsl:attribute name="SuppressRuleExecution">
                  <xsl:value-of select="$Order/@SuppressRuleExecution"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$Order/@SuppressShipping">
                <xsl:attribute name="SuppressShipping">
                  <xsl:value-of select="$Order/@SuppressShipping"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:variable name="OrderLine" select="$Order/OrderLines/OrderLine"/>
              <OrderLines>
                <xsl:for-each select="$OrderLine">
                  <OrderLine>
                    <xsl:if test="@DeliveryMethod">
                      <xsl:attribute name="DeliveryMethod">
                        <xsl:value-of select="@DeliveryMethod"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@EligibleForShippingDiscount">
                      <xsl:attribute name="EligibleForShippingDiscount">
                        <xsl:value-of select="@EligibleForShippingDiscount"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@IsLinePriceForInformationOnly">
                      <xsl:attribute name="IsLinePriceForInformationOnly">
                        <xsl:value-of select="@IsLinePriceForInformationOnly"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@IsPriceLocked">
                      <xsl:attribute name="IsPriceLocked">
                        <xsl:value-of select="@IsPriceLocked"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@ItemID">
                      <xsl:attribute name="ItemID">
                        <xsl:value-of select="@ItemID"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@LineID">
                      <xsl:attribute name="LineID">
                        <xsl:value-of select="@LineID"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@ParentLineID">
                      <xsl:attribute name="ParentLineID">
                        <xsl:value-of select="@ParentLineID"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@Quantity">
                      <xsl:attribute name="Quantity">
                        <xsl:value-of select="@Quantity"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@UnitOfMeasure">
                      <xsl:attribute name="UnitOfMeasure">
                        <xsl:value-of select="@UnitOfMeasure"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@UnitPrice">
                      <xsl:attribute name="UnitPrice">
                        <xsl:value-of select="@UnitPrice"/>
                      </xsl:attribute>
                    </xsl:if>
                  </OrderLine>
                </xsl:for-each>
              </OrderLines>
              <xsl:if test="$Order/Shipping">
                <Shipping>
                  <xsl:if test="Shipping/@Carrier">
                    <xsl:attribute name="Carrier">
                      <xsl:value-of select="Shipping/@Carrier"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="Shipping/@CarrierServiceCode">
                    <xsl:attribute name="CarrierServiceCode">
                      <xsl:value-of select="Shipping/@CarrierServiceCode"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:if test="Shipping/@MinimizeNumberOfShipments">
                    <xsl:attribute name="MinimizeNumberOfShipments">
                      <xsl:value-of select="Shipping/@MinimizeNumberOfShipments"/>
                    </xsl:attribute>
                  </xsl:if>
                </Shipping>
              </xsl:if>
            </OrderInfo>
        </correlation>
      </context>
      <body>
        <xsl:call-template name="OrderToProcessOrder">
          <xsl:with-param name="Order" select="$Order"/>
        </xsl:call-template>
      </body>
    </RequestData>
  </xsl:template>
</xsl:stylesheet>
