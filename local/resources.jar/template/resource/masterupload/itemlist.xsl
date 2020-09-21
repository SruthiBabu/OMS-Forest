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
		<xsl:apply-templates select="ItemList"/>
	</xsl:template>
	
	<xsl:template match="ItemList">
		<ItemList>
			<Item>	
				<xsl:attribute name="OrganizationCode">
					<xsl:value-of select="@OrganizationCode"/>
				</xsl:attribute>
				<xsl:apply-templates select="Action"/>
				<xsl:apply-templates select="Item"/>		
				<PrimaryInformation>
					<xsl:apply-templates select="PrimaryInformation"/>
				</PrimaryInformation>
				<AlternateUOMList>
					<AlternateUOM>
						<xsl:apply-templates select="AlernateUOM"/>
					</AlternateUOM>
				</AlternateUOMList>
				<ItemInstructionList>
					<ItemInstruction>
						<xsl:apply-templates select="ItemInstruction"/>
					</ItemInstruction>
				</ItemInstructionList>
				<AdditionalAttributeList>
					<xsl:apply-templates select="AdditionalAttribute"/>	
				</AdditionalAttributeList>	
				<AssetList>
					<xsl:apply-templates select="Asset"/>	
				</AssetList>
				<Components>
					<xsl:apply-templates select="Component"/>	
				</Components>
			</Item>
		</ItemList>	
	</xsl:template>
	
	<xsl:template match="Action">	
		<xsl:attribute name="Action">
			<xsl:value-of select="@Action"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="Item">	
		<xsl:attribute name="ItemID">
			<xsl:value-of select="@ItemID"/>
		</xsl:attribute>
		<xsl:attribute name="UnitOfMeasure">
			<xsl:value-of select="@UnitOfMeasure"/>
		</xsl:attribute>
		<xsl:attribute name="SubCatalogOrganizationCode">
			<xsl:value-of select="@SubCatalogOrganizationCode"/>
		</xsl:attribute>
	</xsl:template>
	
	
	<xsl:template match="PrimaryInformation">
		<xsl:attribute name="Description">
			<xsl:value-of select="@Description"/>
		</xsl:attribute>
		<xsl:attribute name="EffectiveStartDate">
			<xsl:value-of select="@EffectiveStartDate"/>
		</xsl:attribute>
		<xsl:attribute name="EffectiveEndDate">
			<xsl:value-of select="@EffectiveEndDate"/>
		</xsl:attribute>
		<xsl:attribute name="ManufacturerItem">
			<xsl:value-of select="@ManufactureItem"/>
		</xsl:attribute>
		<xsl:attribute name="ManufacturerName">
			<xsl:value-of select="@ManufactureName"/>
		</xsl:attribute>
		<xsl:attribute name="TaxableFlag">
			<xsl:value-of select="@TaxableFlag"/>
		</xsl:attribute>
		<xsl:attribute name="UnitCost">
			<xsl:value-of select="@UnitCost"/>
		</xsl:attribute>
		<xsl:attribute name="ImageID">
			<xsl:value-of select="@ImageID"/>
		</xsl:attribute>
		<xsl:attribute name="ImageLabel">
			<xsl:value-of select="@ImageLabel"/>
		</xsl:attribute>
		<xsl:attribute name="ImageLocation">
			<xsl:value-of select="@ImageLocation"/>
		</xsl:attribute>
		<xsl:attribute name="DefaultProductClass">
			<xsl:value-of select="@DefaultProductClass"/>
		</xsl:attribute>
		<xsl:attribute name="ExtendedDescription">
			<xsl:value-of select="@ExtendedDescription"/>
		</xsl:attribute>
		<xsl:attribute name="IsModelItem">
			<xsl:value-of select="@IsModelItem"/>
		</xsl:attribute>
		<xsl:attribute name="IsPickupAllowed">
			<xsl:value-of select="@IsPickupAllowed"/>
		</xsl:attribute>
		<xsl:attribute name="IsShippingAllowed">
			<xsl:value-of select="@IsShippingAllowed"/>
		</xsl:attribute>
		<xsl:attribute name="IsValid">
			<xsl:value-of select="@IsValid"/>
		</xsl:attribute>
		<xsl:attribute name="KitCode">
			<xsl:value-of select="@KitCode"/>
		</xsl:attribute>
		<xsl:attribute name="MaxOrderQuantity">
			<xsl:value-of select="@MaxOrderQuantity"/>
		</xsl:attribute>
		<xsl:attribute name="MinOrderQuantity">
			<xsl:value-of select="@MinOrderQuantity"/>
		</xsl:attribute>
		<xsl:attribute name="ShortDescription">
			<xsl:value-of select="@ShortDescription"/>
		</xsl:attribute>
		<xsl:attribute name="BundlePricingStrategy">
			<xsl:value-of select="@BundlePricingStrategy"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="AlernateUOM">
		<xsl:attribute name="Quantity">
			<xsl:value-of select="@Quantity"/>
		</xsl:attribute>
		<xsl:attribute name="UnitOfMeasure">
			<xsl:value-of select="@UnitOfMeasure"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="ItemInstruction">
		<xsl:attribute name="InstructionType">
			<xsl:value-of select="@InstructionType"/>
		</xsl:attribute>
		<xsl:attribute name="InstructionText">
			<xsl:value-of select="@InstructionText"/>
		</xsl:attribute>
		<xsl:attribute name="SeqNo">
			<xsl:text>1</xsl:text>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="AdditionalAttribute">
		<AdditionalAttribute>
			<xsl:attribute name="AttributeDomainID">
				<xsl:value-of select="@AttributeDomainID"/>
			</xsl:attribute>
			<xsl:attribute name="AttributeGroupID">
				<xsl:value-of select="@AttributeGroupID"/>
			</xsl:attribute>
			<xsl:attribute name="Name">
				<xsl:value-of select="@Name"/>
			</xsl:attribute>
			<xsl:attribute name="Value">
				<xsl:value-of select="@Value"/>
			</xsl:attribute>
		</AdditionalAttribute>
	</xsl:template>
	
		<xsl:template match="Asset">
		<Asset>
			<xsl:attribute name="AssetID">
				<xsl:value-of select="@AssetID"/>
			</xsl:attribute>
			<xsl:attribute name="ContentID">
				<xsl:value-of select="@ContentID"/>
			</xsl:attribute>
			<xsl:attribute name="ContentLocation">
				<xsl:value-of select="@ContentLocation"/>
			</xsl:attribute>
			<xsl:attribute name="Description">
				<xsl:value-of select="@Description"/>
			</xsl:attribute>
			<xsl:attribute name="Label">
				<xsl:value-of select="@Label"/>
			</xsl:attribute>
			<xsl:attribute name="Type">
				<xsl:value-of select="@Type"/>
			</xsl:attribute>
		</Asset>
	</xsl:template>
	<xsl:template match="Component">
		<Component>
			<xsl:attribute name="ComponentItemGroupCode">
				<xsl:value-of select="@ComponentItemGroupCode"/>
			</xsl:attribute>
			<xsl:attribute name="ComponentItemID">
				<xsl:value-of select="@ComponentItemID"/>
			</xsl:attribute>
			<xsl:attribute name="ComponentOrganizationCode">
				<xsl:value-of select="@ComponentOrganizationCode"/>
			</xsl:attribute>
			<xsl:attribute name="ComponentUnitOfMeasure">
				<xsl:value-of select="@ComponentUnitOfMeasure"/>
			</xsl:attribute>
			<xsl:attribute name="KitQuantity">
				<xsl:value-of select="@KitQuantity"/>
			</xsl:attribute>
		</Component>
	</xsl:template>
</xsl:stylesheet>