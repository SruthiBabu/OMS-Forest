<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="new" />
    <xsl:param name="existing" />

    <xsl:variable name="newDatatypes" select="document($new)//DataType/@Name" />
    <xsl:variable name="existingNodes" select="document($existing)//DataType/self::node()[not(@Name = $newDatatypes)]"/>

    <xsl:template match="/">
        <DataTypes>
            <xsl:apply-templates/>
            <xsl:copy-of select="$existingNodes"/>
        </DataTypes>
    </xsl:template>

    <xsl:template match="//DataType">
        <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet>
