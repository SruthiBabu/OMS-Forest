<?xml version='1.0'?>
<!-- Stylesheet for transforming EXTERNAL_DEMAND_CHANGE xml to adjustInventory input xml-->
<!--TO DO ETA-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"  />
<xsl:strip-space elements="*" />
<xsl:template match="/">		
	<xsl:element name="Items">
	<xsl:attribute name="QuickMode">N</xsl:attribute>
	
		<xsl:for-each select="/Items/Item/DemandChanges/Demand">
			<xsl:variable name="sConfirmShipment">
					<xsl:value-of select="@ConfirmShipment"/>
			</xsl:variable>	
			<xsl:variable name="sIsInboundOrder">
					<xsl:value-of select="@IsInboundOrder"/>
			</xsl:variable>	
			<xsl:choose>						
				<xsl:when test="$sConfirmShipment = 'Y' and $sIsInboundOrder != 'Y'">
								<xsl:element name="Item">
				<xsl:attribute name="AccountNo">
					<xsl:value-of select="@AccountNo"/>
				</xsl:attribute>
				<xsl:attribute name="AdjustmentType">
					<xsl:value-of select="@AdjustmentType"/>
				</xsl:attribute>
				<xsl:attribute name="UseHotSKUFeature">Y</xsl:attribute>
				<xsl:attribute name="Availability">TRACK</xsl:attribute>
				<xsl:attribute name="ETA"> </xsl:attribute>
				<xsl:attribute name="FromETA"> </xsl:attribute>
				<xsl:attribute name="FromLotNumber"> </xsl:attribute>
				<xsl:attribute name="FromSegment"> </xsl:attribute>
				<xsl:attribute name="FromShipByDate"> </xsl:attribute>
				<xsl:attribute name="FromSupplyLineReference"> </xsl:attribute>
				<xsl:attribute name="FromSupplyReference"> </xsl:attribute>
				<xsl:attribute name="FromSupplyReferenceType"> </xsl:attribute>
				<xsl:attribute name="FromSupplyType"> </xsl:attribute>
				<xsl:attribute name="ItemID">
					<xsl:value-of select="../../@ItemID"/>
				</xsl:attribute>
				<xsl:attribute name="LotAttribute1"> </xsl:attribute>
				<xsl:attribute name="LotAttribute2"> </xsl:attribute>
				<xsl:attribute name="LotAttribute3"> </xsl:attribute>
				<xsl:attribute name="LotKeyReference"> </xsl:attribute>
				<xsl:attribute name="LotNumber"> </xsl:attribute>
				<xsl:attribute name="ManufacturingDate"> </xsl:attribute>
				<xsl:attribute name="OrganizationCode">
					<xsl:value-of select="../../@OrganizationCode"/>
				</xsl:attribute>
				<xsl:attribute name="ProductClass">
					<xsl:value-of select="../../@ProductClass"/>
				</xsl:attribute>
				<xsl:attribute name="Quantity">
					<xsl:value-of select="@Quantity"/>
				</xsl:attribute>
				<xsl:attribute name="ReasonCode"> </xsl:attribute>
				<xsl:attribute name="ReasonText"> </xsl:attribute>
				<xsl:attribute name="Reference_1"> </xsl:attribute>
				<xsl:attribute name="Reference_2"> </xsl:attribute>
				<xsl:attribute name="Reference_3"> </xsl:attribute>
				<xsl:attribute name="Reference_4"> </xsl:attribute>
				<xsl:attribute name="Reference_5"> </xsl:attribute>
				<xsl:attribute name="RemoveInventoryNodeControl"> </xsl:attribute>
				<xsl:attribute name="Segment">
					<xsl:value-of select="@Segment"/>
				</xsl:attribute>
				<xsl:attribute name="SegmentType">
					<xsl:value-of select="@SegmentType"/>
				</xsl:attribute>
				<xsl:attribute name="ShipByDate">
					<xsl:value-of select="@MinShipByDate"/>
				</xsl:attribute>
				<xsl:attribute name="ShipNode">
					<xsl:value-of select="@ShipNode"/>
				</xsl:attribute>
				<xsl:attribute name="SupplyType">
					<xsl:value-of select="@SupplyType"/>
				</xsl:attribute>
				<xsl:attribute name="UnitCost">
					<xsl:value-of select="@UnitCost"/>
				</xsl:attribute>
				<xsl:attribute name="Currency">
					<xsl:value-of select="@CostCurrency"/>
				</xsl:attribute>
				<xsl:attribute name="CostReference">
					<xsl:value-of select="@CostReference"/>
				</xsl:attribute>
				<xsl:attribute name="UnitOfMeasure">
					<xsl:value-of select="../../@UnitOfMeasure"/>
				</xsl:attribute>
				
				<xsl:attribute name="ValidateTagInformation"> </xsl:attribute>
					<xsl:element name="FromTag">
						<xsl:attribute name="BatchNo"> </xsl:attribute>
						<xsl:attribute name="LotAttribute1"> </xsl:attribute>
						<xsl:attribute name="LotAttribute2"> </xsl:attribute>
						<xsl:attribute name="LotAttribute3"> </xsl:attribute>
						<xsl:attribute name="LotKeyReference"> </xsl:attribute>
						<xsl:attribute name="LotNumber"> </xsl:attribute>
						<xsl:attribute name="ManufacturingDate"> </xsl:attribute>
						<xsl:attribute name="RevisionNo"> </xsl:attribute>
					</xsl:element>	
					<xsl:element name="Tag">
						<xsl:attribute name="BatchNo"> 
						<xsl:value-of select="Tag/@BatchNo"/>
						</xsl:attribute>
						<xsl:attribute name="LotAttribute1"> </xsl:attribute>
						<xsl:attribute name="LotAttribute2"> </xsl:attribute>
						<xsl:attribute name="LotAttribute3"> </xsl:attribute>
						<xsl:attribute name="LotKeyReference"> </xsl:attribute>
						<xsl:attribute name="LotNumber">
						<xsl:value-of select="Tag/@LotNumber"/>
						</xsl:attribute>
						<xsl:attribute name="ManufacturingDate"> </xsl:attribute>
						<xsl:attribute name="RevisionNo">
						<xsl:value-of select="Tag/@RevisionNo"/>
						</xsl:attribute>						
					</xsl:element>	
				</xsl:element>	
				</xsl:when>
							
						</xsl:choose>
			
				</xsl:for-each>					
		</xsl:element>
</xsl:template>
</xsl:stylesheet>

