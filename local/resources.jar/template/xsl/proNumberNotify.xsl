<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <xsl:element name="Inbox">
            <xsl:attribute name="ShipnodeKey">
                <xsl:value-of select="/ProNoData/@Node"/>
            </xsl:attribute>            
			<xsl:attribute name="DetailDescription">
				<xsl:value-of select="concat('SCAC=',(ProNoData/@Scac),' CurrentProNumber=',(ProNoData/@CurrentProNumber),' ProNo1Start=',(ProNoData/@ProNo1Start),' ProNo1End=',(ProNoData/@ProNo1End),' ProNo2Start=',(ProNoData/@ProNo2Start),' ProNo2End=',(ProNoData/@ProNo2End),' ProNoLength=',(ProNoData/@ProNoLength),' ProNoSet1ReachedLimit=',(ProNoData/@ProNoSet1ReachedLimit),' ProNoSet2ReachedLimit=',(ProNoData/@ProNoSet2ReachedLimit),' TransactionId=',(ProNoData/@TransactionId))"/>
			</xsl:attribute>			
			<xsl:attribute name="QueueKey">
                <xsl:text>DEFAULT</xsl:text>
            </xsl:attribute>            
            <xsl:copy-of select="/ProNoData/@*"/>            
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>