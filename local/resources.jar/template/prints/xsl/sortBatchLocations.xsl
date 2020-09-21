<?xml version="1.0" encoding="UTF-8" ?>

<!--
    Document    sortBatchLocations.xsl
    Created on  October 7, 2003
    Author      vinayb
    Description
        This XSL sorts the cart locations in each task based on CartLocationId and descending order of Quantity.
-->

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
     <xsl:key name="distinct-shipment" match="TaskReferences" use="@ShipmentNo"/>
<xsl:key name="distinct-moverequest" match="TaskReferences" use="@MoveRequestNo"/>
<xsl:key name="distinct-receipt" match="TaskReferences" use="@ReceiptNo"/>
<xsl:key name="distinct-wave" match="TaskReferences" use="@WaveNo"/>
    
    <!-- template rule matching source root element -->
    <xsl:template match="Batch">
    <Batch>
	<xsl:for-each select="@*">
		<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
	</xsl:for-each> 
	<xsl:variable name="totalShipments" select="count(Tasks/Task/TaskReferences[generate-id()=generate-id(key('distinct-shipment',@ShipmentNo))])"/>
	<xsl:variable name="totalMoveRequest" select="count(Tasks/Task/TaskReferences[generate-id()=generate-id(key('distinct-moverequest',@MoveRequestNo))])"/>
	<xsl:variable name="totalReceipts" select="count(Tasks/Task/TaskReferences[generate-id()=generate-id(key('distinct-receipt',@ReceiptNo))])"/>
	<xsl:variable name="totalWave" select="count(Tasks/Task/TaskReferences[generate-id()=generate-id(key('distinct-wave',@WaveNo))])"/>
	<xsl:choose>
	    <xsl:when test="$totalWave = 1">
		<xsl:attribute name="WaveNo"><xsl:value-of select="Tasks/Task[1]/TaskReferences/@WaveNo"/></xsl:attribute>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:attribute name="WaveNo"/>
	    </xsl:otherwise>                         
	</xsl:choose>    
	<xsl:choose>
	    <xsl:when test="$totalShipments = 1">
		<xsl:attribute name="ShipmentNo"><xsl:value-of select="Tasks/Task[1]/TaskReferences/@ShipmentNo"/></xsl:attribute>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:attribute name="ShipmentNo"/>
	    </xsl:otherwise>                         
	</xsl:choose>    
	<xsl:choose>
	    <xsl:when test="$totalReceipts = 1">
		<xsl:attribute name="ReceiptNo"><xsl:value-of select="Tasks/Task[1]/TaskReferences/@ReceiptNo"/></xsl:attribute>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:attribute name="ReceiptNo"/>
	    </xsl:otherwise>                         
	</xsl:choose>    
	<xsl:choose>
	    <xsl:when test="$totalMoveRequest = 1">
	<xsl:attribute name="MoveRequestNo"><xsl:value-of select="Tasks/Task[1]/TaskReferences/@MoveRequestNo"/></xsl:attribute>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:attribute name="MoveRequestNo"/>
	    </xsl:otherwise>                         
	</xsl:choose> 
	<xsl:copy-of select="EquipmentType"/>  
        <xsl:copy-of select="BatchLocations"/>  
        <xsl:copy-of select="CartLocations"/>          
        <xsl:copy-of select="Tasks"/>  
    <BatchTasks>
      <xsl:for-each select="BatchTasks/BatchTask">  
        <BatchTask>
        <xsl:for-each select="@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>   
        <xsl:copy-of select="Inventory"/>
		<xsl:copy-of select="TaskReferences"/>
		<xsl:copy-of select="Shipment"/>
       <CartLocations> 
            <xsl:for-each select="CartLocations/CartLocation">
                <xsl:sort select="@CartLocationId" order="ascending" />
                <xsl:sort select="@CartQuantity" order="descending"/>
                 <xsl:copy-of select="."/>
            </xsl:for-each>  
         </CartLocations>   
       </BatchTask>   
      </xsl:for-each>  
      </BatchTasks>
    </Batch>  
    </xsl:template>

</xsl:stylesheet> 
