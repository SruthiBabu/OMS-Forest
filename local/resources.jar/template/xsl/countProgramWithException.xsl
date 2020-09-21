<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:lxslt="http://xml.apache.org/xslt"
                version="1.0">

<xsl:output indent="yes"/>
<xsl:template match="/">
    <xsl:apply-templates select="CountProgram"/>
</xsl:template>

<xsl:template match="CountProgram">
    <xsl:element name="Inbox">
        <xsl:attribute name="CountProgramName" > 
            <xsl:value-of select="@CountProgramName"/> 
        </xsl:attribute>
        <xsl:attribute name="ShipnodeKey" > 
            <xsl:value-of select="@Node"/> 
        </xsl:attribute>
	<xsl:attribute name="EnterpriseKey" > 
            <xsl:value-of select="@EnterpriseCode"/> 
        </xsl:attribute>
        <xsl:attribute name="Description" >Count Program <xsl:value-of select="@CountProgramName"/> didn't generate cycle counts.</xsl:attribute>
        <xsl:attribute name="ExceptionType" >
            <xsl:text>NO_REQUESTS_CREATED</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="InboxType" >
            <xsl:text>EXECUTE_COUNT_PROGRAM</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="OwnerKey" >
            <xsl:value-of select="@Node"/> 
        </xsl:attribute>

        <xsl:element name="InboxReferencesList">
            <xsl:for-each select="LogMessage"> 
                <xsl:variable name="count">
                    <xsl:number count="LogMessage" />
                </xsl:variable>
                <xsl:element name="InboxReferences" > 
                    <xsl:attribute name="ReferenceType">
                        <xsl:text>TEXT</xsl:text>
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
