<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    getShipmentHazmatBOLData.xsl
    Created on  July 15, 2005
    Author      Sudheer
    Description
        Gets the data required for Shipment Hazmat BOL print from getShipmentDetails API output.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
     <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
	<xsl:template match="/">
            <xsl:element name="HazmatData">
            <xsl:copy-of select="/Shipment/Carrier/@ScacDesc"/>
	    <xsl:copy-of select="/Shipment/Carrier/@Scac"/>
            <xsl:copy-of select="/Shipment/@TrailerNo"/>
            <xsl:copy-of select="/Shipment/@BolNo"/>
            <xsl:copy-of select="/Shipment/@ProNo"/>
            <xsl:copy-of select="/Shipment/@TotalWeightUOM"/>
            <xsl:copy-of select="/Shipment/@ActualShipmentDate"/>
	    <xsl:copy-of select="/Shipment/ShipNode/@NodeOrgCode"/>
	    <xsl:copy-of select="/Shipment/@Modifyuserid"/>
            <xsl:element name="FromAddress">
                <xsl:copy-of select="/Shipment/ShipNode/ShipNodePersonInfo/@*"/>
            </xsl:element>
            <xsl:element name="ToAddress">
                <xsl:copy-of select="/Shipment/ToAddress/@*" /> 	
            </xsl:element>
            <xsl:element name="HazardousContainers">
            <xsl:for-each select="/Shipment/Containers/Container[(@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;))]">
			<xsl:if test="@IsHazmat='Y'">
				<xsl:element name="HazardousContainer">
                                    <xsl:copy-of select="ContainerDetails/ContainerDetail/ShipmentLine/Item/ClassificationCodes/@HazmatClass"/>
                                    <xsl:copy-of select="ContainerDetails/ContainerDetail/ShipmentLine/Item/@ItemID"/>
                                    <xsl:copy-of select="ContainerDetails/ContainerDetail/ShipmentLine/Item/@UnitOfMeasure"/>
                                    <!-- <xsl:copy-of select="@ActualWeight"/> -->
                                    <!-- <xsl:copy-of select="@ActualWeightUOM"/> -->
				    
					<xsl:choose>
					<xsl:when test="not(@ActualWeight) or @ActualWeight = &quot;&quot; or number(@ActualWeight) = 0">
						<xsl:attribute name="ActualWeight"><xsl:value-of select="@ContainerGrossWeight"/></xsl:attribute>
						<xsl:attribute name="ActualWeightUOM"><xsl:value-of select="@ContainerGrossWeightUOM"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="ActualWeight"><xsl:value-of select="@ActualWeight"/></xsl:attribute>
						<xsl:attribute name="ActualWeightUOM"><xsl:value-of select="@ActualWeightUOM"/></xsl:attribute>
					</xsl:otherwise>
					</xsl:choose>
                                 
				    <xsl:attribute name="IsHazmat"><xsl:text>X</xsl:text></xsl:attribute>
                                    <xsl:if test="@ContainerType='Case'">
					<xsl:attribute name="ContainerType"><xsl:text>ctns</xsl:text></xsl:attribute>
				    </xsl:if>
				    <xsl:if test="@ContainerType='Pallet'">
					<xsl:attribute name="ContainerType"><xsl:text>plts</xsl:text></xsl:attribute>
				    </xsl:if>
				    <xsl:choose>
                                        <xsl:when test="not(ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@ProperShippingName) or
                                         (ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@ProperShippingName=&quot;&quot;) or
                                         (ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@ProperShippingName=&quot; &quot;)">
                                            <xsl:attribute name="ProperShippingName"><xsl:value-of select="concat('ERROR:HazmatData Not Available for - ',ContainerDetails/ContainerDetail/ShipmentLine/Item/@ItemID)"/></xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="ProperShippingName"><xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@ProperShippingName"/></xsl:attribute>
					</xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="not(ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@HazardClass) or
                                         (ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@HazardClass=&quot;&quot;) or
                                         (ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@HazardClass=&quot; &quot;)">
                                            <xsl:attribute name="HazardClass"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="HazardClass"><xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@HazardClass"/></xsl:attribute>
					</xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="not(ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@Label) or
                                         (ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@Label=&quot;&quot;) or
                                         (ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@Label=&quot; &quot;)">
                                            <xsl:attribute name="LabelCode"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="LabelCode"><xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@Label"/></xsl:attribute>
					</xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="not(ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@UNNumber) or
                                         (ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@UNNumber=&quot;&quot;) or
                                         (ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@UNNumber=&quot; &quot;)">
                                            <xsl:attribute name="UNNumber"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="UNNumber"><xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@UNNumber"/></xsl:attribute>
					</xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="not(ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@PackingGroup) or
                                         (ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@PackingGroup=&quot;&quot;) or
                                         (ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@PackingGroup=&quot; &quot;)">
                                            <xsl:attribute name="PackingGroup"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="PackingGroup"><xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/Item/HazmatInformation/@PackingGroup"/></xsl:attribute>
					</xsl:otherwise>
                                    </xsl:choose>
				    
				</xsl:element>
			 </xsl:if>     
               </xsl:for-each>
            </xsl:element>
            </xsl:element>
	</xsl:template>
</xsl:stylesheet>