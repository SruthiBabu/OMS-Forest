<?xml version = "1.0" encoding = "UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
<xsl:output indent="yes"/>
    <xsl:template match="/Container">
	<xsl:variable name="isMultiSKU">
            <xsl:value-of select="ContainerDetails/@TotalNumberOfRecords"/>
        </xsl:variable>    
        <Container>
			<xsl:copy-of select="@*"/>
			<xsl:copy-of select="ContainerDetails"/>
				<xsl:choose>
				<xsl:when test="Shipment/MarkForAddress">
					<MarkForAddress>
						<xsl:if test="Shipment/MarkForAddress/@Department and not(Shipment/MarkForAddress/@Department = &quot;&quot;)">
							<xsl:attribute name="MarkForBarCode">
								<xsl:value-of select="concat('(','91',')', Shipment/MarkForAddress/@Department)"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:copy-of select="Shipment/MarkForAddress/@*"/>
					</MarkForAddress>
				</xsl:when>
				<xsl:when test="ContainerDetails/ContainerDetail/ShipmentLine/MarkForAddress">
				<MarkForAddress>
					<xsl:if test="ContainerDetails/ContainerDetail/ShipmentLine/MarkForAddress/@Department and not(ContainerDetails/ContainerDetail/ShipmentLine/MarkForAddress/@Department = &quot;&quot;)">
						<xsl:attribute name="MarkForBarCode">
							<xsl:value-of select="concat('(','91',')', ContainerDetails/ContainerDetail/ShipmentLine/MarkForAddress/@Department)"/>
						</xsl:attribute>
						<xsl:attribute name="Department">
							<xsl:value-of select="ContainerDetails/ContainerDetail/ShipmentLine/MarkForAddress/@Department"/>
						</xsl:attribute>

					</xsl:if>
				</MarkForAddress>
				</xsl:when>
			</xsl:choose>
			<Shipment>
				<xsl:copy-of select="Shipment/@*"/>
				<xsl:copy-of select="Shipment/ScacAndService"/>
				<xsl:copy-of select="Shipment/ToAddress"/>
				<xsl:copy-of select="Shipment/FromAddress"/>
				<xsl:copy-of select="Shipment/ShipNode"/>
			</Shipment>
			<xsl:copy-of select="Corrugation"/>
	       	<References>
                    <xsl:if test="Shipment/ScacAndService/@CarrierType = &quot;PARCEL&quot;">
                     <Reference>
                            <xsl:attribute name="ReferenceName"><xsl:text>TRACKING:</xsl:text></xsl:attribute>
                            <xsl:attribute name="ReferenceNo"><xsl:value-of select="@TrackingNo"/></xsl:attribute>
                      </Reference>
                    </xsl:if>
                    <xsl:if test="Shipment/ScacAndService/@CarrierType = &quot;LTL&quot;">
                     <Reference>
                            <xsl:attribute name="ReferenceName"><xsl:text>PRO:</xsl:text></xsl:attribute>
                            <xsl:attribute name="ReferenceNo"><xsl:value-of select="Shipment/@ProNo"/></xsl:attribute>
                    </Reference>
                    <Reference>
                            <xsl:attribute name="ReferenceName"><xsl:text>B/L:</xsl:text></xsl:attribute>
                            <xsl:attribute name="ReferenceNo"><xsl:value-of select="Shipment/@BolNo"/></xsl:attribute>
                      </Reference>
                    </xsl:if>
                    <xsl:if test="Shipment/ScacAndService/@CarrierType = &quot;TL&quot;">
                     <Reference>
                            <xsl:attribute name="ReferenceName"><xsl:text>TRAILER:</xsl:text></xsl:attribute>
                            <xsl:attribute name="ReferenceNo"><xsl:value-of select="Shipment/@TrailerNo"/></xsl:attribute>
                    </Reference>
                    <Reference>
                            <xsl:attribute name="ReferenceName"><xsl:text>B/L:</xsl:text></xsl:attribute>
                            <xsl:attribute name="ReferenceNo"><xsl:value-of select="Shipment/@BolNo"/></xsl:attribute>
                     </Reference>
                    </xsl:if>
            </References>
			<xsl:if  test="BatchLocation">
			 <BatchLocation>	
				<xsl:if test="not(BatchLocation/@BatchNo = &quot;&quot;)">
						<xsl:attribute name="BatchNoLiteral"><xsl:text>BATCH:</xsl:text></xsl:attribute>
						<xsl:attribute name="BatchNo"><xsl:value-of select="BatchLocation/@BatchNo"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="not(BatchLocation/@CartLocationId = &quot;&quot;)">
					<xsl:attribute name="CartLocationLiteral"><xsl:text>Slot No:</xsl:text></xsl:attribute>
					<xsl:attribute name="CartLocationId"><xsl:value-of select="concat(BatchLocation/@CartLocationId,BatchLocation/@SlotNumber)"/></xsl:attribute>
				</xsl:if>
			</BatchLocation>
		</xsl:if>
        </Container>    
    </xsl:template>
</xsl:stylesheet>
		