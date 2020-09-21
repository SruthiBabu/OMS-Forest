<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="/">
	 <Output>
   <xsl:choose>
  <xsl:when test="/Failed">
	<xsl:attribute name="Failed">
		<xsl:text>Y</xsl:text>
	</xsl:attribute>
  </xsl:when>
<xsl:otherwise>  
  <xsl:variable name="document">
    <xsl:copy-of select="." />
  </xsl:variable>
   
		<xsl:attribute name="out">
                  <xsl:apply-templates select="exsl:node-set($document)/* | exsl:node-set($document)/text()" mode="to_string" />
		</xsl:attribute>
    
	</xsl:otherwise>
</xsl:choose>	
</Output>
</xsl:template>

<!--Template to transform XML node-set to string  -->
<xsl:variable name="q">
	<xsl:text>"</xsl:text>
</xsl:variable>
<xsl:variable name="empty"/>

<xsl:template match="*" mode="selfclosetag">
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:apply-templates select="@*" mode="attribs"/>
	<xsl:text>/&gt;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="opentag">
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:apply-templates select="@*" mode="attribs"/>
	<xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="closetag">
	<xsl:text>&lt;/</xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template match="* | text()" mode="to_string">
	<xsl:choose>
		<xsl:when test="boolean(name())">
			<xsl:choose>
				<!--
					 if element is not empty
				-->
				<xsl:when test="normalize-space(.) != $empty or *">
					<xsl:apply-templates select="." mode="opentag"/>
						<xsl:apply-templates select="* | text()" mode="to_string"/>
					<xsl:apply-templates select="." mode="closetag"/>
				</xsl:when>
				<!--
					 assuming empty tags are self closing, e.g. <img/>, <source/>, <input/>
				-->
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="selfclosetag"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="."/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="@*" mode="attribs">
	<xsl:if test="position() = 1">
		<xsl:text> </xsl:text>
	</xsl:if>
	<xsl:value-of select="concat(name(), '=', $q, ., $q)"/>
	<xsl:if test="position() != last()">
		<xsl:text> </xsl:text>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>