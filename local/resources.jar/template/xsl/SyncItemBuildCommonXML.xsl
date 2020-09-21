<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10), IBM Order Management (5737-D18)
  (C) Copyright IBM Corp. 2018  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/> 

<xsl:template match="/">
<Sync_Event id="" CreateDate="">
	<xsl:attribute name="id">
		<xsl:value-of select="/Item/@ItemID" />
	</xsl:attribute>
	<xsl:attribute name="CreateDate">
		<xsl:value-of select="/Item/@MaxModifyTS" />
	</xsl:attribute>
	<Sync_Header EventCategory="Product" Mod_Type="" Mod_Date="">
		<xsl:attribute name="Mod_Type">
			<xsl:value-of select="/Item/@Action" />
		</xsl:attribute>
		<xsl:attribute name="Mod_Date">
			<xsl:value-of select="/Item/@MaxModifyTS" />
		</xsl:attribute>
		<xsl:attribute name="OrganizationCode">
			<xsl:value-of select="/Item/@OrganizationCode" />
		</xsl:attribute>
	</Sync_Header>
	<Sync_Data>
	        <Item>	
			<xsl:apply-templates select="Item"/>
			<xsl:apply-templates select="Item/PrimaryInformation"/>
			<xsl:apply-templates select="Item/InventoryParameters|Item/ClassificationCodes"/>
			<xsl:apply-templates select="Item/ItemInstructionList"/>
			<xsl:apply-templates select="Item/Components"/>
			<xsl:apply-templates select="Item/Extn"/>
			
		</Item>
	</Sync_Data>
</Sync_Event>
</xsl:template>

<!-- copy input --> 

<xsl:template match="Item">
  <xsl:copy-of select="@*" /> 
  <xsl:apply-templates select="@MaxModifyTS"/>
</xsl:template>

<xsl:template match="Item/PrimaryInformation">
  <xsl:copy-of select="@*" /> 
  <xsl:copy-of select="*" />
</xsl:template>

<xsl:template match="Item/InventoryParameters|Item/ClassificationCodes">
  <xsl:copy-of select="@*" /> 
  <xsl:copy-of select="*" /> 
</xsl:template>

<xsl:template match="Item/ItemInstructionList">
  <ItemInstructionList>
  <xsl:copy-of select="@*" /> 
  <xsl:copy-of select="*" /> 
  </ItemInstructionList>
</xsl:template>

<xsl:template match="Item/Components">
  <Components>
  <xsl:copy-of select="@*" /> 
  <xsl:copy-of select="*" /> 
  </Components>
</xsl:template>

<xsl:template match="Item/Extn">
  <Extn>
  <xsl:copy-of select="@*" /> 
  <xsl:copy-of select="*" /> 
  </Extn>
</xsl:template>

<!-- remove MaxModifyTS -->
<xsl:template match="@MaxModifyTS" />
<!-- remove ItemKey -->
<xsl:template match="@ItemKey" />

</xsl:stylesheet>
