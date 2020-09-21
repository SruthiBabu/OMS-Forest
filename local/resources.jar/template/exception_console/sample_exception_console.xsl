<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:lxslt="http://xml.apache.org/xslt"
                version="1.0">
<xsl:output method="text"/>
<xsl:template match="/">Order number <xsl:value-of select="/Order/@OrderNo"/> has been backordered.</xsl:template>
</xsl:stylesheet>
