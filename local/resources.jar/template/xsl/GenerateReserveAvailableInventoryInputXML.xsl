<?xml version='1.0'?>
<!-- 
 * Stylesheet for transforming YFSGetExternalAvailabilityUE to reserveAvailableInventory input
 * 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"  />
<xsl:strip-space elements="*" />
<xsl:template match="/">
	<xsl:apply-templates select="Promise" />
</xsl:template>

<xsl:template match="Promise">
	
	<xsl:copy>
	        <xsl:copy-of select="@*"/>
		<xsl:call-template name="ReservationParameters"/> 
		<xsl:copy-of select="*"/>
	</xsl:copy>

	

		
</xsl:template>

<xsl:template name="ReservationParameters">
	<ReservationParameters AllowPartialReservation="Y" AllowMultipleReservations="Y">
	    <xsl:attribute name="ReservationID">
                <xsl:value-of select="@OrderReference"/>
            </xsl:attribute>
	<xsl:attribute name="ExpirationDate">
                <xsl:value-of select="@ExpirationDate"/>
            </xsl:attribute>
	</ReservationParameters>
	
</xsl:template>


</xsl:stylesheet>