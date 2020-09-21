<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output  method="xml" indent="yes" omit-xml-declaration="yes"/> 

<xsl:template match="/Customer">
<Customer SyncTS=" " >
	<xsl:attribute name="CustomerKey">
	  <xsl:value-of select="@CustomerKey" />
	</xsl:attribute>
</Customer>
</xsl:template >

</xsl:stylesheet>
