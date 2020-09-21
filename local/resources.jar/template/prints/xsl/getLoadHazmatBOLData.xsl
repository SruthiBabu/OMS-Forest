<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<!--
    Document    getLoadHazmatBOLData.xsl
    Created on  July 19, 2005
    Author      Sudheer
    Description
        Gets the data required for Load Hazmat BOL print from getLoadDetails API output.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
     <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
	<xsl:template match="/">
            <xsl:element name="HazmatData">
            <xsl:copy-of select="/Load/Carrier/@ScacDesc"/>
	    <xsl:copy-of select="/Load/Carrier/@Scac"/>
            <xsl:copy-of select="/Load/@TrailerNo"/>
	    <xsl:attribute name="ActualShipmentDate">
		<xsl:value-of select="/Load/@ActualDepartureDate"/>
	    </xsl:attribute>
            <xsl:copy-of select="/Load/@BolNo"/>
            <xsl:copy-of select="/Load/@ProNo"/>
            <xsl:copy-of select="/Load/@TotalWeightUOM"/>
	    <xsl:attribute name="NodeOrgCode">
		<xsl:value-of select="/Load/@OriginNode"/>
	    </xsl:attribute>
	    <xsl:copy-of select="/Load/@Modifyuserid"/>
            <xsl:element name="FromAddress">
                <xsl:copy-of select="/Load/OriginAddress/@*"/>
            </xsl:element>
            <xsl:element name="ToAddress">
                <xsl:copy-of select="/Load/DestinationAddress/@*" /> 	
            </xsl:element>
            <xsl:element name="HazardousContainers">
            <xsl:for-each select="/Load/LoadShipments/LoadShipment/Shipment/Containers/Container[(@ParentContainerKey=&quot;&quot; or not(@ParentContainerGroup=&quot;SHIPMENT&quot;))]/ContainerDetails/ContainerDetail/ShipmentLine">
			<xsl:if test="@IsHazmat='Y'">
				<xsl:element name="HazardousContainer">
                                    <xsl:copy-of select="Item/ClassificationCodes/@HazmatClass"/>
                                    <xsl:copy-of select="Item/@ItemID"/>
                                    <xsl:copy-of select="Item/@UnitOfMeasure"/>
				    <!-- 
                                    <xsl:copy-of select="@ActualWeight"/>
                                    <xsl:copy-of select="@ActualWeightUOM"/>
				    -->
				    <xsl:choose>
				    
				        <xsl:when test="parent::ContainerDetail/@ShipmentContainerKey = preceding::ContainerDetail/@ShipmentContainerKey">
						<!--
						<xsl:attribute name="ActualWeight"><xsl:value-of select="&quot;&quot;"/></xsl:attribute>
						<xsl:attribute name="ActualWeightUOM"/>
						<xsl:attribute name="ContainerType"/>
						-->
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
						<xsl:when test="not(ancestor::Container/@ActualWeight) or ancestor::Container/@ActualWeight = &quot;&quot; or number(ancestor::Container/@ActualWeight) = 0">
							<xsl:attribute name="ActualWeight"><xsl:value-of select="ancestor::Container/@ContainerGrossWeight"/></xsl:attribute>
							<xsl:attribute name="ActualWeightUOM"><xsl:value-of select="ancestor::Container/@ContainerGrossWeightUOM"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
								<xsl:attribute name="ActualWeight"><xsl:value-of select="ancestor::Container/@ActualWeight"/></xsl:attribute>
								<xsl:attribute name="ActualWeightUOM"><xsl:value-of select="ancestor::Container/@ActualWeightUOM"/></xsl:attribute>
						</xsl:otherwise>
						</xsl:choose>
						
					</xsl:otherwise>
				    </xsl:choose>
                                 
				  <xsl:if test="ancestor::Container/@ContainerType='Case'">
					    <xsl:attribute name="ContainerType"><xsl:text>ctns</xsl:text></xsl:attribute>
				                 </xsl:if>
				                 <xsl:if test="ancestor::Container/@ContainerType='Pallet'">
							<xsl:attribute name="ContainerType"><xsl:text>plts</xsl:text></xsl:attribute>
				                 </xsl:if>
				    <xsl:attribute name="IsHazmat"><xsl:text>X</xsl:text></xsl:attribute>
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
				</xsl:element>
			 </xsl:if>     
               </xsl:for-each>
	       <xsl:for-each select="/Load/LoadContainers/Container[(@ParentContainerKey=&quot;&quot; or (@LoadKey=&quot;&quot; and @ParentContainerGroup='INVENTORY') )]">
			<xsl:if test="@IsHazmat='Y' and ContainerDetails/ContainerDetail">
				<xsl:element name="HazardousContainer">
                                    <xsl:copy-of select="ContainerDetails/ContainerDetail/ShipmentLine/Item/ClassificationCodes/@HazmatClass"/>
                                    <xsl:copy-of select="ContainerDetails/ContainerDetail/ShipmentLine/Item/@ItemID"/>
                                    <xsl:copy-of select="ContainerDetails/ContainerDetail/ShipmentLine/Item/@UnitOfMeasure"/>
				    <!--
                                    <xsl:copy-of select="@ActualWeight"/>
                                    <xsl:copy-of select="@ActualWeightUOM"/>
				    -->
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
