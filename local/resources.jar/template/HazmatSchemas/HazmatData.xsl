<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document    HazmatData.xsl
    Created on  July 05, 2005
    Author      Sudheer
    Description
       Converts the xml generated by text transalator to manageHazmatCompliance Api Input.
-->

<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="/HAZMATDATALIST">
	<xsl:element name="HazmatCompliance">
		<xsl:for-each select="HAZMATDATA">
			<xsl:attribute name="Symbols">
				<xsl:value-of select="@Symbols"/>
      			</xsl:attribute>
			<xsl:attribute name="ProperShippingName">
				<xsl:value-of select="@ProperShippingName"/>
      			</xsl:attribute>
			<xsl:attribute name="HazardClass">
		         	<xsl:value-of select="@HazardClass"/>
      			</xsl:attribute>
			<xsl:attribute name="UNNumber">
		         	<xsl:value-of select="@UNNumber"/>
      			</xsl:attribute>
			<xsl:attribute name="PackingGroup">
		         	<xsl:value-of select="@PackingGroup"/>
      			</xsl:attribute>
			<xsl:attribute name="Label">
		         	<xsl:value-of select="@Label"/>
      			</xsl:attribute>
			<xsl:attribute name="SpecialProvisions">
		         	<xsl:value-of select="@SpecialProvisions"/>
      			</xsl:attribute>
			<xsl:attribute name="Exception">
		         	<xsl:value-of select="@Exception"/>
      			</xsl:attribute>
			<xsl:attribute name="QtyNonBulk">
		         	<xsl:value-of select="@QtyNonBulk"/>
      			</xsl:attribute>
			<xsl:attribute name="QtyBulk">
		         	<xsl:value-of select="@QtyBulk"/>
      			</xsl:attribute>
			<xsl:attribute name="PassengerAir">
		         	<xsl:value-of select="@PassengerAir"/>
      			</xsl:attribute>
			<xsl:attribute name="CargoAir">
		         	<xsl:value-of select="@CargoAir"/>
      			</xsl:attribute>
			<xsl:attribute name="Vessel">
		         	<xsl:value-of select="@Vessel"/>
      			</xsl:attribute>
			<xsl:attribute name="VesselSP">
		         	<xsl:value-of select="@VesselSP"/>
      			</xsl:attribute>
			<xsl:attribute name="SortOrder">
		         	<xsl:value-of select="@SortOrder"/>
      			</xsl:attribute>
			<xsl:if test="(/HAZMATDATALIST/HAZMATDATA/@Action = &quot;DEL&quot; ) ">
				<xsl:attribute name="Operation">
					<xsl:text>Delete</xsl:text>
				</xsl:attribute>
			</xsl:if>
		</xsl:for-each>
	</xsl:element>
	</xsl:template>
</xsl:stylesheet>
