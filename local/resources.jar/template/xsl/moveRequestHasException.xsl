<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:lxslt="http://xml.apache.org/xslt"
                version="1.0">

<xsl:output indent="yes"/>
<xsl:template match="/">
    <xsl:apply-templates select="MoveRequest"/>
</xsl:template>

<xsl:template match="MoveRequest">
    <xsl:element name="Inbox">
        <xsl:attribute name="MoveRequestKey" > 
            <xsl:value-of select="@MoveRequestKey"/> 
        </xsl:attribute>
	        <xsl:attribute name="MoveRequestNo" > 
            <xsl:value-of select="@MoveRequestNo"/> 
        </xsl:attribute>
        <xsl:attribute name="ShipnodeKey" > 
            <xsl:value-of select="@Node"/> 
        </xsl:attribute>
        <xsl:attribute name="Description" >Move_Request_has_release_failures</xsl:attribute>
        <xsl:attribute name="ExceptionType" >
            <xsl:text>HAS_EXCEPTIONS</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="InboxType" >
            <xsl:text>RELEASE_MOVE_REQUEST</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="OwnerKey" >
            <xsl:value-of select="@Node"/> 
        </xsl:attribute>

        <xsl:element name="InboxReferencesList">
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
