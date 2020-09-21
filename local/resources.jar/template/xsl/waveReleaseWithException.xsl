<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:lxslt="http://xml.apache.org/xslt"
                version="1.0">

<xsl:output indent="yes"/>
<xsl:template match="/">
    <xsl:apply-templates select="Wave"/>
</xsl:template>

<xsl:template match="Wave">
    <xsl:element name="Inbox">
	<xsl:attribute name="AssignedToUserKey">
	     <xsl:text></xsl:text>
        </xsl:attribute>
	<xsl:attribute name="Description">
	     <xsl:text>Exceptions_encountered_during_wave_release</xsl:text>
        </xsl:attribute>
	<xsl:attribute name="ExceptionType">
	     <xsl:text>SHORTAGES_DETECTED</xsl:text>
        </xsl:attribute>
	<xsl:attribute name="Priority">
	     <xsl:text>0</xsl:text>
        </xsl:attribute>
	<xsl:attribute name="QueueKey">
	     <xsl:text>DEFAULT</xsl:text>
        </xsl:attribute>
	<xsl:attribute name="EnterpriseKey">
		<xsl:text></xsl:text>
	</xsl:attribute>
	<xsl:attribute name="YFC_Locale_Code">
		<xsl:text>en_US_EST</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="InboxType">
		<xsl:text>RELEASE_WAVE.4001</xsl:text>
	</xsl:attribute>
	<xsl:attribute name="ItemId">
		<xsl:text></xsl:text>
	</xsl:attribute>
	<xsl:attribute name="OrderHeaderKey">
		<xsl:text></xsl:text>
	</xsl:attribute>
	<xsl:attribute name="OrderLineKey">
		<xsl:text></xsl:text>
	</xsl:attribute>
	<xsl:attribute name="OrderNo">
		<xsl:text></xsl:text>
	</xsl:attribute>
	<xsl:attribute name="ShipnodeKey">
		<xsl:value-of select="@Node" />
	</xsl:attribute>
	<xsl:attribute name="WaveKey">
		<xsl:value-of select="@WaveKey" />
	</xsl:attribute>
	<xsl:attribute name="WaveNo">
		<xsl:value-of select="@WaveNo" />
	</xsl:attribute>
	<xsl:attribute name="SupplierKey">
		<xsl:text></xsl:text>
	</xsl:attribute>
	<xsl:attribute name="ShipmentNo">
		<xsl:text></xsl:text>
	</xsl:attribute>
	<xsl:attribute name="LoadNo">
		<xsl:text></xsl:text>
	</xsl:attribute>
	
        <xsl:element name="InboxReferencesList">
		<xsl:attribute name="MaximumRecords">
                        <xsl:text>100</xsl:text>
                </xsl:attribute>
		<xsl:attribute name="ResourceIDForMasterData">
                        <xsl:text>YCPIF039</xsl:text>
                </xsl:attribute>
		<xsl:attribute name="YFC_Locale_Code">
                        <xsl:text>en_US_EST</xsl:text>
                </xsl:attribute>

		<xsl:element name="InboxReferences" > 
                    <xsl:attribute name="ReferenceType">
                        <xsl:text>TEXT</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="Name">
                         <xsl:text>Wave_Key</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="Value">
                        <xsl:value-of select="@WaveKey" />
                    </xsl:attribute>
		    <xsl:attribute name="ModifyFlag">
                        <xsl:text>Y</xsl:text>
                    </xsl:attribute>
		    <xsl:attribute name="ResourceIDForMasterData">
                        <xsl:text>YCPIF040</xsl:text>
                    </xsl:attribute>
		</xsl:element>
		<xsl:element name="InboxReferences" > 
                    <xsl:attribute name="ReferenceType">
                        <xsl:text>TEXT</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="Name">
                         <xsl:text>WaveNo</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="Value">
                        <xsl:value-of select="@WaveNo" />
                    </xsl:attribute>
		    <xsl:attribute name="ModifyFlag">
                        <xsl:text>Y</xsl:text>
                    </xsl:attribute>
		    <xsl:attribute name="ResourceIDForMasterData">
                        <xsl:text>YCPIF040</xsl:text>
                    </xsl:attribute>
		</xsl:element>
            <xsl:for-each select="Trace/LogMessage"> 
                <xsl:variable name="count">
                    <xsl:number count="Trace/LogMessage" />
                </xsl:variable>
                <xsl:element name="InboxReferences" > 
                    <xsl:attribute name="ReferenceType">
                        <xsl:value-of select="@ReferenceType"/> 
                    </xsl:attribute>
                    <xsl:attribute name="Name">
                        <xsl:value-of select="$count"/>
                    </xsl:attribute>
                    <xsl:attribute name="Value">
                        <xsl:value-of select="@Message" />
                    </xsl:attribute>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:element>
</xsl:template>
</xsl:stylesheet>