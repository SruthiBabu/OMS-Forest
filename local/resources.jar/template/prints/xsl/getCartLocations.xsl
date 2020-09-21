<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document    getBatchSheetData2.xsl
    Created on  October 4, 2003
    Author      vinayb
    Description:
        This XSL obtains the Cart locations and the quantity in the CartLocation for each task.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:key name="distinct-task" match="Task" use="concat(@SourceLocationId,Inventory/@ItemId,Inventory/@UnitOfMeasure,Inventory/@ProductClass,@OrganizationCode)"/>

	<xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
    <xsl:template match="/">
        <Batch>
			<xsl:for-each select="Batch/@*">
				<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
			 </xsl:for-each> 
        <xsl:copy-of select="Batch/EquipmentType"/>   
        <xsl:copy-of select="Batch/BatchLocations"/>  
        <xsl:variable name="equipDtls" select="/Batch/EquipmentType/EquipmentTypeDetails/EquipmentTypeDetail"/>
	<xsl:variable name="equipDtlsCount" select="count($equipDtls)"/>
	<CartLocations>
	  <xsl:choose>
	      <xsl:when test="$equipDtlsCount &gt; 8">
	          <xsl:apply-templates select="$equipDtls" mode="mode1">
	          </xsl:apply-templates>
	      </xsl:when>
	      <xsl:otherwise>
	          <xsl:apply-templates select="$equipDtls" mode="mode2">
	          </xsl:apply-templates>
	      </xsl:otherwise>
           </xsl:choose>
	 </CartLocations>
	  <xsl:copy-of select="Batch/Tasks"/>   
	  <BatchTasks>
	  <xsl:variable name="unique-tasks" select="//Task[generate-id()=generate-id(key('distinct-task',concat(@SourceLocationId,Inventory/@ItemId,Inventory/@UnitOfMeasure,Inventory/@ProductClass,@OrganizationCode)))]" />
	      <xsl:for-each select="//Task">
		<BatchTask>
		    <xsl:for-each select="@*">
			 <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
		    </xsl:for-each>   
		    <xsl:copy-of select="Inventory"/>
		    <xsl:copy-of select="TaskReferences"/>
		    <xsl:copy-of select="Shipment"/>
		    <CartLocations>
			  <xsl:choose>
			      <xsl:when test="$equipDtlsCount &gt; 8">
				  <xsl:for-each select="$equipDtls">
				<CartLocation>
				   <xsl:attribute name="CartLocationId"><xsl:value-of select="@LocationLogicalName"/></xsl:attribute> 
				   <xsl:attribute name="CartQuantity"><xsl:text>0</xsl:text></xsl:attribute> 
				   <xsl:attribute name="CartonSize">
					<xsl:value-of select="Batch/BatchLocations/BatchLocation[@CartLocationId=current()/@LocationLogicalName and @SlotNumber='1']/Container/Corrugation/@ItemID" /> 
				   </xsl:attribute>
				</CartLocation>
				</xsl:for-each>
			      </xsl:when>
			      <xsl:otherwise>
				  <xsl:for-each select="$equipDtls">
				<CartLocation>
				    <xsl:attribute name="CartLocationId"><xsl:value-of select="concat(@LocationLogicalName,'1')"/></xsl:attribute> 
				    <xsl:attribute name="CartQuantity"><xsl:text>0</xsl:text></xsl:attribute> 
				    <xsl:attribute name="CartonSize">
					<xsl:value-of select="/Batch/BatchLocations/BatchLocation[@CartLocationId=current()/@LocationLogicalName and @SlotNumber='1']/Container/Corrugation/@ItemID" /> 
				    </xsl:attribute>
				 </CartLocation>
				 <CartLocation>
				    <xsl:attribute name="CartLocationId"><xsl:value-of select="concat(@LocationLogicalName,'2')"/></xsl:attribute> 
				    <xsl:attribute name="CartQuantity"><xsl:text>0</xsl:text></xsl:attribute> 
				    <xsl:attribute name="CartonSize">
					<xsl:value-of select="/Batch/BatchLocations/BatchLocation[@CartLocationId=current()/@LocationLogicalName and @SlotNumber='2']/Container/Corrugation/@ItemID" /> 
				    </xsl:attribute>
				 </CartLocation>   
				</xsl:for-each>
			      </xsl:otherwise>
			 </xsl:choose>
			 <xsl:for-each select="key('distinct-task',concat(@SourceLocationId,Inventory/@ItemId,Inventory/@UnitOfMeasure,Inventory/@ProductClass,@OrganizationCode))">
			 <xsl:variable name="cartQty" select="round(Inventory/@Quantity)"/>
			 <CartLocation>
			      <xsl:choose>
				  <xsl:when test="$equipDtlsCount &gt; 8">
				     <xsl:attribute name="CartLocationId"><xsl:value-of select="BatchLocation/@CartLocationId"/></xsl:attribute>
				  </xsl:when>
				  <xsl:otherwise>
				     <xsl:attribute name="CartLocationId">
					  <xsl:value-of select="concat(BatchLocation/@CartLocationId,BatchLocation/@SlotNumber)"/>
				     </xsl:attribute>
				  </xsl:otherwise>
			      </xsl:choose>	
			      <xsl:attribute name="ShipmentContainerKey">
				  <xsl:value-of select="BatchLocation/@ShipmentContainerKey"/>
			      </xsl:attribute>
			      <xsl:attribute name="CartQuantity"><xsl:value-of select="$cartQty"/></xsl:attribute>                         
			</CartLocation>  
			</xsl:for-each>
		    </CartLocations>
		</BatchTask>
	      </xsl:for-each>
	  </BatchTasks>
</Batch>  
</xsl:template>

<xsl:template match="EquipmentTypeDetail" mode="mode1">
<CartLocation>
   <xsl:attribute name="CartLocationId"><xsl:value-of select="@LocationLogicalName"/></xsl:attribute> 
   <xsl:attribute name="CartQuantity"><xsl:text>0</xsl:text></xsl:attribute> 
   <xsl:attribute name="CartonSize">
        <xsl:value-of select="Batch/BatchLocations/BatchLocation[@CartLocationId=current()/@LocationLogicalName and @SlotNumber='1']/Container/Corrugation/@ItemID" /> 
   </xsl:attribute>
</CartLocation>
</xsl:template>

<xsl:template match="EquipmentTypeDetail" mode="mode2">
<CartLocation>
    <xsl:attribute name="CartLocationId"><xsl:value-of select="concat(@LocationLogicalName,'1')"/></xsl:attribute> 
    <xsl:attribute name="CartQuantity"><xsl:text>0</xsl:text></xsl:attribute> 
    <xsl:attribute name="CartonSize">
	<xsl:value-of select="/Batch/BatchLocations/BatchLocation[@CartLocationId=current()/@LocationLogicalName and @SlotNumber='1']/Container/Corrugation/@ItemID" /> 
    </xsl:attribute>
 </CartLocation>
 <CartLocation>
    <xsl:attribute name="CartLocationId"><xsl:value-of select="concat(@LocationLogicalName,'2')"/></xsl:attribute> 
    <xsl:attribute name="CartQuantity"><xsl:text>0</xsl:text></xsl:attribute> 
    <xsl:attribute name="CartonSize">
	<xsl:value-of select="/Batch/BatchLocations/BatchLocation[@CartLocationId=current()/@LocationLogicalName and @SlotNumber='2']/Container/Corrugation/@ItemID" /> 
    </xsl:attribute>
 </CartLocation>   
</xsl:template>

</xsl:stylesheet> 
