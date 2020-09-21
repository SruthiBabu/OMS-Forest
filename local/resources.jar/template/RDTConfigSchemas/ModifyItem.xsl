<?xml version='1.0' encoding='utf-8' ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
       <xsl:output method="xml"/>	
       <xsl:template match="/">
     	 <ItemList>
    		<xsl:for-each select="/ItemList/Item">
			<xsl:element name="{name()}">
				<xsl:attribute name="ItemID">
						<xsl:value-of select="@ItemID"/>
				</xsl:attribute>
				<xsl:attribute name="OrganizationCode">
						<xsl:value-of select="@OrganizationCode"/>
				</xsl:attribute>
				<xsl:attribute name="UnitOfMeasure">
						<xsl:value-of select="@UnitOfMeasure"/>
				</xsl:attribute>
				<xsl:attribute name="GlobalItemID">
						<xsl:value-of select="@GlobalItemID"/>
				</xsl:attribute>
				<xsl:attribute name="ItemGroupCode">
						<xsl:value-of select="@ItemGroupCode"/>
				</xsl:attribute>
			<xsl:element name="PrimaryInformation">
				<xsl:attribute name="Description">
					<xsl:value-of select="@Description"/>
				</xsl:attribute>
				<xsl:attribute name="ProductLine">
						<xsl:value-of select="@ProductLine"/>
				</xsl:attribute>
					<xsl:attribute name="KitCode">
						<xsl:value-of select="@KitCode"/>
				</xsl:attribute>
					<xsl:attribute name="UnitCost">
						<xsl:value-of select="@UnitCost"/>
				</xsl:attribute>
					<xsl:attribute name="CostCurrency">
						<xsl:value-of select="@CostCurrency"/>
				</xsl:attribute> 
				<xsl:attribute name="CountryOfOrigin">
						<xsl:value-of select="@CountryOfOrigin"/>
				</xsl:attribute>
				<xsl:attribute name="ItemType">
						<xsl:value-of select="@ItemType"/>
				</xsl:attribute>
				<xsl:attribute name="UnitWeight">
						<xsl:value-of select="@UnitWeight"/>
				</xsl:attribute>
					<xsl:attribute name="UnitWeightUOM">
						<xsl:value-of select="@WeightUOM"/>
				</xsl:attribute>
					<xsl:attribute name="UnitHeight">
						<xsl:value-of select="@UnitHeight"/>
				</xsl:attribute>
				<xsl:attribute name="UnitHeightUOM">
						<xsl:value-of select="@DimensionUOM"/>
				</xsl:attribute>
				<xsl:attribute name="UnitLength">
						<xsl:value-of select="@UnitLength"/>
				</xsl:attribute>
				<xsl:attribute name="UnitLengthUOM">
						<xsl:value-of select="@DimensionUOM"/>
				</xsl:attribute>
				<xsl:attribute name="UnitWidth">
						<xsl:value-of select="@UnitWidth"/>
				</xsl:attribute>
				<xsl:attribute name="UnitWidthUOM">
						<xsl:value-of select="@DimensionUOM"/>
				</xsl:attribute>
				<xsl:attribute name="SerializedFlag">
						<xsl:value-of select="@SerializedFlag"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="InventoryParameters">
				<xsl:attribute name="TagControlFlag">
						<xsl:value-of select="@TagControlFlag"/>
				</xsl:attribute>
				<xsl:attribute name="TimeSensitive">
						<xsl:value-of select="@TimeSensitive"/>
				</xsl:attribute>
				<xsl:attribute name="IsFifoTracked">
						<xsl:value-of select="@IsFifoTracked"/>
				</xsl:attribute>
				<xsl:attribute name="IsSerialTracked">
						<xsl:value-of select="@IsSerialTracked"/>
				</xsl:attribute>
			</xsl:element>
			<xsl:element name="ClassificationCodes">
				<xsl:attribute name="HarmonizedCode">
						<xsl:value-of select="@HarmonizedCode"/>
				</xsl:attribute>
				 <xsl:attribute name="NMFCCode">
						<xsl:value-of select="@NMFCCode"/>
				 </xsl:attribute>
					<xsl:attribute name="VelocityCode">
						<xsl:value-of select="@VelocityCode"/>
				</xsl:attribute>
				<xsl:attribute name="ECCNNo">
						 <xsl:value-of select="@ECCNNo"/>
				</xsl:attribute>
				<xsl:attribute name="Schedule_B_Code">
						<xsl:value-of select="@Schedule_B_Code"/>
				</xsl:attribute>
				<xsl:attribute name="HazmatClass">
						<xsl:value-of select="@HazmatClass"/>
				</xsl:attribute>
				<xsl:attribute name="CommodityCode">
						<xsl:value-of select="@CommodityCode"/>
				 </xsl:attribute>
			</xsl:element>
			<AlternateUOMList>
				 <xsl:if test="normalize-space(@CaseQuantity) != &quot;&quot;">
					<xsl:element name="AlternateUOM">
						<xsl:attribute name="UnitOfMeasure">
							<xsl:text>CASE </xsl:text>
						</xsl:attribute>
						<xsl:attribute name="Quantity">
							<xsl:value-of select="@CaseQuantity"/>
						</xsl:attribute>
						<xsl:attribute name="Length">
							<xsl:value-of select="@CaseLength"/>
						</xsl:attribute> 
						<xsl:attribute name="LengthUOM">
							<xsl:value-of select="@DimensionUOM"/>
						</xsl:attribute>        
						<xsl:attribute name="Width">
							<xsl:value-of select="@CaseWidth"/>
						</xsl:attribute>  
						<xsl:attribute name="WidthUOM">
							<xsl:value-of select="@DimensionUOM"/>
						</xsl:attribute>
						<xsl:attribute name="Height">
							<xsl:value-of select="@CaseHeight"/>
						</xsl:attribute>
						<xsl:attribute name="HeightUOM">
							<xsl:value-of select="@DimensionUOM"/>
						</xsl:attribute>
						<xsl:attribute name="Weight">
							<xsl:value-of select="@CaseWeight"/>
						</xsl:attribute>
						<xsl:attribute name="WeightUOM">
							<xsl:value-of select="@WeightUOM"/>
						</xsl:attribute>      
						   
					</xsl:element>
				</xsl:if>
				<xsl:if test="normalize-space(@PalletQuantity) != &quot;&quot;">
					<xsl:element name="AlternateUOM">
						<xsl:attribute name="UnitOfMeasure">
							<xsl:text>PALLET</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="Quantity">
							<xsl:value-of select="@PalletQuantity"/>
						</xsl:attribute>
						<xsl:attribute name="Length">
							<xsl:value-of select="@PalletLength"/>
						</xsl:attribute>      
						<xsl:attribute name="LengthUOM">
							<xsl:value-of select="@DimensionUOM"/>
						</xsl:attribute>      
						<xsl:attribute name="Width">
							<xsl:value-of select="@PalletWidth"/>
						</xsl:attribute>  
						<xsl:attribute name="WidthUOM">
							<xsl:value-of select="@DimensionUOM"/>
						</xsl:attribute>
						<xsl:attribute name="Height">
							<xsl:value-of select="@PalletHeight"/>
						</xsl:attribute>
						<xsl:attribute name="HeightUOM">
							<xsl:value-of select="@DimensionUOM"/>
						</xsl:attribute>
						<xsl:attribute name="Weight">
							<xsl:value-of select="@PalletWeight"/>
						</xsl:attribute>
						<xsl:attribute name="WeightUOM">
							<xsl:value-of select="@WeightUOM"/>
						</xsl:attribute>      
					</xsl:element>
				</xsl:if>
			</AlternateUOMList>
			<AdditionalAttributeList>
				<xsl:if test="normalize-space(@AddName1) != &quot;&quot;">
					<xsl:element name="AdditionalAttribute">
						<xsl:attribute name="Name">
							<xsl:value-of select="@AddName1"/>
						</xsl:attribute>
						<xsl:attribute name="Value">
							<xsl:value-of select="@AddValue1"/>
						</xsl:attribute>      
					</xsl:element>
				</xsl:if>
				<xsl:if test="normalize-space(@AddName2) != &quot;&quot;">
					<xsl:element name="AdditionalAttribute">
						<xsl:attribute name="Name">
							<xsl:value-of select="@AddName2"/>
						</xsl:attribute>
						<xsl:attribute name="Value">
							<xsl:value-of select="@AddValue2"/>
						</xsl:attribute>      
					 </xsl:element>
				</xsl:if>
			</AdditionalAttributeList>
			<xsl:if test="normalize-space(@TagControlFlag) = 'Y'">
				<xsl:if test="normalize-space(@LotNumber)!=&quot;&quot; or normalize-space(@LotAttribute1)!=&quot;&quot; or normalize-space(@LotAttribute2)!=&quot;&quot;">
					<xsl:element name="InventoryTagAttributes">
						<xsl:attribute name="LotNumber">
								<xsl:value-of select="@LotNumber"/>
						</xsl:attribute>
							<xsl:attribute name="LotAttribute1">
								<xsl:value-of select="@LotAttribute1"/>
						</xsl:attribute>
							<xsl:attribute name="LotAttribute2">
								 <xsl:value-of select="@LotAttribute2"/>
						</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:if>
			</xsl:element>
      		</xsl:for-each>
     	</ItemList>
 </xsl:template>
 </xsl:stylesheet>