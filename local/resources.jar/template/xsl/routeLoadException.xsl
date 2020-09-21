<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:lxslt="http://xml.apache.org/xslt"
                version="1.0">
<xsl:output indent="yes"/>
<xsl:template match="/">
    <xsl:apply-templates select="Load"/>
</xsl:template>
<xsl:template match="Load">
    <xsl:element name="Inbox">
        <xsl:attribute name="LoadKey" > 
            <xsl:value-of select="@LoadKey"/> 
        </xsl:attribute>
        <xsl:attribute name="ShipnodeKey" > 
            <xsl:value-of select="@ShipNode"/> 
        </xsl:attribute>
        <xsl:attribute name="Description" >Route Load <xsl:value-of select="@LoadKey"/> has routing failures.</xsl:attribute>
        <xsl:attribute name="ExceptionType" >
            <xsl:text>ON_ROUTE_LOAD_FAILURE</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="InboxType" >
            <xsl:text>ROUTE_SHIPMENT.0001</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="OwnerKey" >
            <xsl:value-of select="@ShipNode"/> 
        </xsl:attribute>

        <xsl:element name="InboxReferencesList">
            <xsl:for-each select="Trace/LogMessage"> 
                <xsl:variable name="count">
                    <xsl:number count="Trace/LogMessage" />
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
