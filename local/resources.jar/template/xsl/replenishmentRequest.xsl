<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:template match="/Alert">
	<xsl:element name="MoveRequest">
		<xsl:attribute name="FromActivityGroup">
			<xsl:text>REPLENISHMENT</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="Release">
			<xsl:text>Y</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="Node">
			<xsl:value-of select="@Node"/>
		</xsl:attribute>
		<xsl:element name="MoveRequestLines">
			<xsl:for-each select="Location">
				<xsl:element name="MoveRequestLine">
					<xsl:if test="( /Alert/@AlertId = &quot;INVENTORY_BELOW_MIN&quot; ) or ( /Alert/@AlertId = &quot;INVENTORY_BELOW_FULL_CAPACITY&quot; ) or ( /Alert/@AlertId = &quot;INVENTORY_BELOW_MIN_QTY&quot; )">
						<xsl:attribute name="TargetLocationId"><xsl:value-of select="@LocationId"/></xsl:attribute>
						<xsl:attribute name="RequestQuantity"><xsl:value-of select="(Inventory/@MaxQuantity)-(Inventory/@CurrentQuantity)-(Inventory/@PendInQuantity)"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="( /Alert/@AlertId = &quot;INVENTORY_BELOW_CURRENT_DEMAND&quot; )">
						<xsl:attribute name="TargetLocationId"><xsl:value-of select="@LocationId"/></xsl:attribute>
						<xsl:attribute name="RequestQuantity"><xsl:value-of select="(Inventory/@PendOutQuantity)-(Inventory/@PendInQuantity)-(Inventory/@CurrentQuantity)"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="( /Alert/@AlertId = &quot;INVENTORY_ABOVE_CURRENT_DEMAND&quot; )">
						<xsl:attribute name="SourceLocationId"><xsl:value-of select="@LocationId"/></xsl:attribute>
						<xsl:attribute name="RequestQuantity"><xsl:value-of select="(Inventory/@CurrentQuantity)+(Inventory/@PendInQuantity)-(Inventory/@PendOutQuantity)"/></xsl:attribute>
					</xsl:if>
					<xsl:for-each select="Inventory">
						<xsl:attribute name="ItemId"><xsl:value-of select="@ItemId"/></xsl:attribute>
						<xsl:attribute name="UnitOfMeasure"><xsl:value-of select="@UnitOfMeasure"/></xsl:attribute>
						<xsl:attribute name="EnterpriseCode"><xsl:value-of select="@EnterpriseCode"/></xsl:attribute>
						<xsl:attribute name="ProductClass"><xsl:value-of select="@ProductClass"/></xsl:attribute>
						<xsl:attribute name="InventoryStatus"><xsl:value-of select="@InventoryStatus"/></xsl:attribute>
						<xsl:attribute name="SegmentType"><xsl:value-of select="@SegmentType"/></xsl:attribute>
						<xsl:attribute name="Segment"><xsl:value-of select="@Segment"/></xsl:attribute>
						<xsl:attribute name="CaseId"><xsl:value-of select="@CaseId"/></xsl:attribute>
						<xsl:attribute name="PalletId"><xsl:value-of select="@PalletId"/></xsl:attribute>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:element>
</xsl:template>
</xsl:stylesheet>
