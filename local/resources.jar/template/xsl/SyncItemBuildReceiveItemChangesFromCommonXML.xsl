<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10), IBM Order Management (5737-D18)
  (C) Copyright IBM Corp. 2018  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/> 

<xsl:template match="/">
  <Item>
	<xsl:apply-templates select="Sync_Event/Sync_Data/Item"/> 
  </Item>
</xsl:template>

<xsl:template match="Sync_Event/Sync_Data/Item">
	<xsl:attribute name="Action">
		<xsl:value-of select="/Sync_Event/Sync_Header/@Mod_Type" /> 
	</xsl:attribute>
	<xsl:attribute name="ItemID">
		<xsl:value-of select="@ItemID" /> 
	</xsl:attribute>
	<xsl:attribute name="UnitOfMeasure">
		<xsl:value-of select="@UnitOfMeasure" /> 
	</xsl:attribute>
	<xsl:attribute name="OrganizationCode">
		<xsl:value-of select="@OrganizationCode" /> 
	</xsl:attribute>
	<xsl:attribute name="RemoteModifyTS">
		<xsl:value-of select="/Sync_Event/Sync_Header/@Mod_Date" /> 
	</xsl:attribute>
	<PrimaryInformation>
		<xsl:attribute name="ShortDescription">
			<xsl:value-of select="@ShortDescription" /> 
		</xsl:attribute>
		<xsl:attribute name="ExtendedDescription">
			<xsl:value-of select="@ExtendedDescription" /> 
		</xsl:attribute>
		<xsl:attribute name="MinOrderQuantity">
			<xsl:value-of select="@MinOrderQuantity" /> 
		</xsl:attribute>
		<xsl:attribute name="Status">
			<xsl:value-of select="@Status" /> 
		</xsl:attribute>
		<xsl:attribute name="IsModelItem">
			<xsl:value-of select="@IsModelItem" /> 
		</xsl:attribute>
		<xsl:attribute name="ModelItemUnitOfMeasure">
			<xsl:value-of select="@ModelItemUnitOfMeasure" /> 
		</xsl:attribute>
		<xsl:attribute name="KitCode">
			<xsl:value-of select="@KitCode" /> 
		</xsl:attribute>
		<xsl:attribute name="ConfiguredModelKey">
			<xsl:value-of select="@ConfiguredModelKey" /> 
		</xsl:attribute>
		<xsl:attribute name="IsConfigurable">
			<xsl:value-of select="@IsConfigurable" /> 
		</xsl:attribute>
		<xsl:attribute name="IsPreConfigured">
			<xsl:value-of select="@IsPreConfigured" /> 
		</xsl:attribute>
	</PrimaryInformation>
	<InventoryParameters>
		<xsl:attribute name="LeadTime">
			<xsl:value-of select="@LeadTime" /> 
		</xsl:attribute>
	</InventoryParameters>
	<ClassificationCodes>
		<xsl:attribute name="Model">
			<xsl:value-of select="@Model" /> 
		</xsl:attribute>
	</ClassificationCodes>
	<!-- Copy the child elements -->
	<xsl:copy-of select="*" /> 
</xsl:template>

</xsl:stylesheet>


