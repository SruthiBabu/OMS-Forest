<?xml version='1.0' encoding='utf-8' ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml"/>	
<xsl:template match="/">
 	<xsl:for-each select="/AdjustLocationInventoryList/AdjustLocationInventory">
     	<xsl:element name="{name()}">
        		<xsl:attribute name="EnterpriseCode">
         			<xsl:value-of select="@EnterpriseCode"/>
      		</xsl:attribute>
       		<xsl:attribute name="Node">
         			<xsl:value-of select="@Node"/>
      		</xsl:attribute>
		<Source>
        			<xsl:attribute name="CaseId">
         				<xsl:value-of select="@CaseId"/>
      			</xsl:attribute>
        			<xsl:attribute name="LocationId">
         				<xsl:value-of select="@LocationId"/>
      			</xsl:attribute>
        			<xsl:attribute name="PalletId">
         				<xsl:value-of select="@PalletId"/>
      			</xsl:attribute>
        		<Inventory>
          		<xsl:attribute name="InventoryStatus">
         				<xsl:value-of select="@InventoryStatus"/>
      			</xsl:attribute>
          		<xsl:attribute name="ShipByDate">
         				<xsl:value-of select="@ShipByDate"/>
      			</xsl:attribute>
      			<xsl:attribute name="Quantity">
         				<xsl:value-of select="@Quantity"/>
      			</xsl:attribute>
        			<xsl:attribute name="Segment">
         				<xsl:value-of select="@Segment"/>
      			</xsl:attribute>
        			<xsl:attribute name="SegmentType">
         				<xsl:value-of select="@SegmentType"/>
      			</xsl:attribute>
        			<xsl:element name="InventoryItem">
        				<xsl:attribute name="ItemID">
         					<xsl:value-of select="@ItemID"/>
      				</xsl:attribute>
      				<xsl:attribute name="ProductClass">
        					 <xsl:value-of select="@ProductClass"/>
      				</xsl:attribute>
        				<xsl:attribute name="UnitOfMeasure">
         					<xsl:value-of select="@UnitOfMeasure"/>
     			 	</xsl:attribute>
            			</xsl:element>
       			<xsl:element name="TagDetail">
                				<xsl:attribute name="LotAttribute1">
         					<xsl:value-of select="@LotAttribute1"/>
      				</xsl:attribute>
        				<xsl:attribute name="LotAttribute2">
         					<xsl:value-of select="@LotAttribute2"/>
      				</xsl:attribute>
         				<xsl:attribute name="LotNumber">
         					<xsl:value-of select="@LotNumber"/>
      				</xsl:attribute>
       			</xsl:element>
      			<SerialList>
      			<xsl:element name="SerialDetail">
            				<xsl:attribute name="SerialNo">
         					<xsl:value-of select="@SerialNo"/>
      				</xsl:attribute>
       			</xsl:element>
      			</SerialList>
       		</Inventory>
      		</Source>
      		<xsl:element name="Audit">
            			<xsl:attribute name="ReasonCode">
         				<xsl:value-of select="@ReasonCode"/>
      			</xsl:attribute>
      		 </xsl:element>
      	</xsl:element>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>