<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->

<!--
    Document    getShippersDeclarationData.xsl
    Created on  July 12, 2005
    Author      Sudheer
    Description
        Gets the data required for Shippers Decalration print from getManifestDetails API output.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
     <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
	<xsl:template match="/">
            <xsl:element name="Manifest">
	    <xsl:copy-of select="/Manifest/@Modifyuserid"/>
	    <xsl:copy-of select="/Manifest/@ShipNode"/>
            <xsl:element name="ShipNodePersonInfo">
            <xsl:copy-of select="/Manifest/ShipNode/ShipNodePersonInfo/@*"/>
            </xsl:element>
            <xsl:element name="HazardousLines">
            <xsl:for-each select="/Manifest/Shipments/Shipment/ShipmentLines/ShipmentLine">
			<xsl:if test="@IsHazmat='Y'">
				<xsl:element name="HazardousLine">
                                    <xsl:copy-of select="../../@ProNo"/>
                                    <xsl:copy-of select="Item/@UnitOfMeasure"/>
                                
                                    <xsl:choose>
                                        <xsl:when test="not(Item/HazmatInformation/@ProperShippingName) or
                                         (Item/HazmatInformation/@ProperShippingName=&quot;&quot;) or
                                         (Item/HazmatInformation/@ProperShippingName=&quot; &quot;)">
                                            <xsl:attribute name="ProperShippingName"><xsl:value-of select="concat('ERROR:Hazmat Data Not Available for  ',Item/@ItemID)"/></xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="ProperShippingName"><xsl:value-of select="Item/HazmatInformation/@ProperShippingName"/></xsl:attribute>
					</xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="not(Item/HazmatInformation/@HazardClass) or
                                         (Item/HazmatInformation/@HazardClass=&quot;&quot;) or
                                         (Item/HazmatInformation/@HazardClass=&quot; &quot;)">
                                            <xsl:attribute name="HazardClass"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="HazardClass"><xsl:value-of select="Item/HazmatInformation/@HazardClass"/></xsl:attribute>
					</xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="not(Item/HazmatInformation/@Label) or
                                         (Item/HazmatInformation/@Label=&quot;&quot;) or
                                         (Item/HazmatInformation/@Label=&quot; &quot;)">
                                            <xsl:attribute name="LabelCode"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="LabelCode"><xsl:value-of select="Item/HazmatInformation/@Label"/></xsl:attribute>
					</xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="not(Item/HazmatInformation/@UNNumber) or
                                         (Item/HazmatInformation/@UNNumber=&quot;&quot;) or
                                         (Item/HazmatInformation/@UNNumber=&quot; &quot;)">
                                            <xsl:attribute name="UNNumber"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="UNNumber"><xsl:value-of select="Item/HazmatInformation/@UNNumber"/></xsl:attribute>
					</xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when test="not(Item/HazmatInformation/@PackingGroup) or
                                         (Item/HazmatInformation/@PackingGroup=&quot;&quot;) or
                                         (Item/HazmatInformation/@PackingGroup=&quot; &quot;)">
                                            <xsl:attribute name="PackingGroup"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="PackingGroup"><xsl:value-of select="Item/HazmatInformation/@PackingGroup"/></xsl:attribute>
					</xsl:otherwise>
                                    </xsl:choose>
				    <xsl:element name="ToAddress">
                                        <xsl:copy-of select="../../ToAddress/@*" /> 	
                                    </xsl:element>
				</xsl:element>
			 </xsl:if>     
		</xsl:for-each>
            </xsl:element>
            </xsl:element>
	</xsl:template>
</xsl:stylesheet>