<!--
  Licensed Materials - Property of IBM
  5725-F55
  Copyright IBM Corporation 2011. All Rights Reserved.
  US Government Users Restricted Rights- Use, duplication or disclosure
  restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" omit-xml-declaration="yes" />
	
	<xsl:template match="/">
		<xsl:apply-templates select="ModifyCategoryItems"/>
	</xsl:template>
	
	<xsl:template match="ModifyCategoryItems">
		<ModifyCategoryItems>
			<Category>	
				<xsl:apply-templates select="Category"/>
				<CategoryItemList>
					<xsl:apply-templates select="CategoryItem"/>
				</CategoryItemList>
			</Category>
		</ModifyCategoryItems>
	</xsl:template>
	
	<xsl:template match="Category">		
		<xsl:attribute name="CategoryPath">
			<xsl:value-of select="@CategoryPath"/>
		</xsl:attribute>
		<xsl:attribute name="OrganizationCode">
			<xsl:value-of select="/ModifyCategoryItems/@OrganizationCode"/>
		</xsl:attribute>
	</xsl:template>
	
	
	<xsl:template match="CategoryItem">
		<CategoryItem>
			<xsl:attribute name="Action">
				<xsl:value-of select="/ModifyCategoryItems/Action/@Action"/>
			</xsl:attribute>
			<xsl:attribute name="ItemID">
				<xsl:value-of select="@ItemID"/>
			</xsl:attribute>
			<xsl:attribute name="UnitOfMeasure">
				<xsl:value-of select="@UnitOfMeasure"/>
			</xsl:attribute>
			<xsl:attribute name="OrganizationCode">
				<xsl:value-of select="/ModifyCategoryItems/@OrganizationCode"/>
			</xsl:attribute>			
		</CategoryItem>							
	</xsl:template>	
	
	
</xsl:stylesheet>