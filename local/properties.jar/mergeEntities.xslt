<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="new" />
    <xsl:param name="existing" />

    <xsl:variable name="newNodes" select="document($new)//Entities/*/@Name" />
    <xsl:variable name="existingNodes" select="document($existing)//Entities/*[not(@Name = $newNodes)]"/>

    <xsl:template match="/">
        <DBSchema>
            <Entities>
                <xsl:copy-of select="$existingNodes"/>
                <xsl:apply-templates/>
            </Entities>
        </DBSchema>
    </xsl:template>

    <xsl:template match="//Entities/*">
        <xsl:copy-of select="."/>
    </xsl:template>
    
</xsl:stylesheet>
