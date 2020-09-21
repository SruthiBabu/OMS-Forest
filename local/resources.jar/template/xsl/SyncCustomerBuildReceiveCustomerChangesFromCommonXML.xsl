<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/> 
<xsl:template match="/">
  <Customer>
	<xsl:apply-templates select="Sync_Event/Sync_Data/Customer"/> 
  </Customer>
</xsl:template>
<xsl:template match="Sync_Event/Sync_Data/Customer">
	<xsl:copy-of select="@*" /> 
	<xsl:attribute name="RemoteModifyTS">
		<xsl:value-of select="/Sync_Event/Sync_Header/@Mod_Date" /> 
	</xsl:attribute> 
	<xsl:copy-of select="*" /> 
</xsl:template>
</xsl:stylesheet>