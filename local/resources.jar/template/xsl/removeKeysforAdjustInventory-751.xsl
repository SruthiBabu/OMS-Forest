<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Edited with XML Spy v2006 (http://www.altova.com) -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method='xml'  />
<xsl:preserve-space elements="*" />
<xsl:template match="/">
	
	<xsl:for-each select="//*">
		<xsl:variable name="node" select="name(.)"/>
		<xsl:value-of select="' '" />
		<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
		<xsl:value-of select="$node"/>
		<xsl:value-of select="' '" />
		<xsl:for-each select="./@*">
			<xsl:if test="not(contains(name(.),'Key')) ">
				<xsl:value-of select="name(.)"/>="<xsl:value-of select="."/>"
			</xsl:if>
		</xsl:for-each>
		<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
		<xsl:value-of select="' '" />
	</xsl:for-each>
		
	<xsl:variable name="ItemsNode" select="'Items'"/>
	<xsl:variable name="ItemNode" select="'Item'"/>
	<xsl:variable name="TagNode" select="'Tag'"/>
	
	<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
	<xsl:value-of select ="$TagNode"/>
	<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
	<xsl:value-of select="' '" />
	
	<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
	<xsl:value-of select ="$ItemNode"/>
	<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
	<xsl:value-of select="' '" />
	
	<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
	<xsl:value-of select ="$ItemsNode"/>
	<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
	<xsl:value-of select="' '" />

</xsl:template>
</xsl:stylesheet>