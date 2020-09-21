<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<!-- Stylesheet for transforming EXTERNAL_DEMAND_CHANGE xml to reserveItemInventoryList input xml-->
<!--TO DO ExpirationDate, Tags-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"  />
<xsl:strip-space elements="*" />
<xsl:template match="/">		
		<xsl:element name="ReserveItemInventoryList">		
			<xsl:attribute name="CheckInventory">N</xsl:attribute>
			<xsl:attribute name="ApplyFutureSafetyFactor">N</xsl:attribute>
			<xsl:attribute name="ApplyOnhandSafetyFactor">N</xsl:attribute>
			<xsl:attribute name="ReserveIfPartial">Y</xsl:attribute>			
			<xsl:attribute name="DemandUpdateOnlyMode">Y</xsl:attribute>
				<xsl:for-each select="/Items/Item/DemandChanges/Demand">
					<xsl:element name="ReserveItemInventory">
					<xsl:attribute name="DemandUpdateOnlyMode">Y</xsl:attribute>
						<xsl:attribute name="OrganizationCode">
							<xsl:value-of select="../../@OrganizationCode"/>
						</xsl:attribute>
						<xsl:attribute name="DemandType">
							<xsl:value-of select="@DemandType"/>
						</xsl:attribute>
						<xsl:attribute name="AgainstProcurement">
							<xsl:value-of select="@AgainstProcurement"/>
						</xsl:attribute>
						<xsl:attribute name="ItemID">
							<xsl:value-of select="../../@ItemID"/>
						</xsl:attribute>
						<xsl:attribute name="ProductClass">
							<xsl:value-of select="../../@ProductClass"/>
						</xsl:attribute>
						<xsl:attribute name="UnitOfMeasure">
							<xsl:value-of select="../../@UnitOfMeasure"/>
						</xsl:attribute>
						<xsl:attribute name="MinShipByDate">
							<xsl:value-of select="@MinShipByDate"/>
						</xsl:attribute>
						<xsl:attribute name="NodeControlType"> 
							<xsl:value-of select="InventoryNodeControl/@NodeControlType" />
							</xsl:attribute>
						<xsl:attribute name="InvPictureIncorrectTillDate">
							<xsl:value-of select="InventoryNodeControl/@InvPictureIncorrectTillDate" />
							</xsl:attribute>
						<xsl:attribute name="StartDate">
							<xsl:value-of select="InventoryNodeControl/@StartDate" />
							</xsl:attribute>
						<!--<xsl:attribute name="ExpirationDate">
							<xsl:value-of select="current-date() +xs:dayTimeDuration('P365D')"/>
						</xsl:attribute>-->

						<xsl:attribute name="ExpirationDate">
							<xsl:value-of select="@DemandCancelDate"/>
						</xsl:attribute>
						<xsl:attribute name="ReservationID">
							<xsl:value-of select="@OrderHeaderKey"/>
						</xsl:attribute>
						<xsl:attribute name="ShipDate">
							<xsl:value-of select="@DemandShipDate"/>
						</xsl:attribute>						
						<xsl:variable name="sNode">
								<xsl:value-of select="@ShipNode"/>
						</xsl:variable>						
						<xsl:choose>						
							<xsl:when test="normalize-space($sNode) != ''">
								<xsl:attribute name="ShipNode">
									<xsl:value-of select="$sNode"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="ShipNode">
									<xsl:value-of select="$sNode"/>
								</xsl:attribute>
								<xsl:attribute name="IsShipNodeRequired">N</xsl:attribute>								
							</xsl:otherwise>
						</xsl:choose>
						<xsl:attribute name="ReservationPool">
							<xsl:value-of select="@Segment"/>
						</xsl:attribute>
						<xsl:attribute name="DeliveryMethod">
							<xsl:value-of select="@DeliveryMethod"/>
						</xsl:attribute>
						<xsl:attribute name="ReservationPoolType">
							<xsl:value-of select="@SegmentType"/>
						</xsl:attribute>
						<xsl:variable name="dQuantity">
							<xsl:value-of select="@Quantity"/>
						</xsl:variable>							
						<xsl:choose>						
							<xsl:when test="number($dQuantity) &lt; 0">
								<xsl:attribute name="QtyToBeCancelled">
									<xsl:value-of select="-1*($dQuantity)"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="number($dQuantity) &gt; 0">
								<xsl:attribute name="QtyToBeReserved">
									<xsl:value-of select="$dQuantity"/>
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="QtyToBeReserved">
									<xsl:value-of select="@Quantity"/>
								</xsl:attribute>
								<!--<xsl:attribute name="SynchDemandExpirationDateOnly">Y</xsl:attribute>-->							
							</xsl:otherwise>
						</xsl:choose>
						<xsl:element name="Tag">
						<xsl:attribute name="BatchNo"> 
						<xsl:value-of select="Tag/@BatchNo"/>
						</xsl:attribute>						
						<xsl:attribute name="LotNumber">
						<xsl:value-of select="Tag/@LotNumber"/>
						</xsl:attribute>						
						<xsl:attribute name="RevisionNo">
						<xsl:value-of select="Tag/@RevisionNo"/>
						</xsl:attribute>						
					</xsl:element>	

					</xsl:element>	
				</xsl:for-each>			
					
		</xsl:element>
</xsl:template>
</xsl:stylesheet>

