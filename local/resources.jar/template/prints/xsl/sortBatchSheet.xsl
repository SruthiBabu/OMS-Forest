<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
    <xsl:template match="Batch">
        <Batch>
		<xsl:attribute name="DepositedLPN">
			<xsl:choose>
				<xsl:when test="Tasks/Task[1]/PredecessorTask/@TargetPalletId != &quot;&quot;">
					<xsl:value-of select="Tasks/Task[1]/PredecessorTask/@TargetPalletId"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="Tasks/Task[1]/PredecessorTask/Inventory/@SourcePalletId != &quot;&quot;">
								<xsl:value-of select="Tasks/Task[1]/PredecessorTask/Inventory/@SourcePalletId"/>
							</xsl:when>
					</xsl:choose>
				 </xsl:otherwise>
			 </xsl:choose>
		 </xsl:attribute>
        <xsl:for-each select="@*">
            <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
        </xsl:for-each>		
        <xsl:copy-of select="BatchLocations"/>   
        <xsl:copy-of select="CartLocations"/>           
        <EquipmentType>
                <xsl:for-each select="EquipmentType/@*">
                    <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                </xsl:for-each> 
           <EquipmentTypeDetails>
            
            <xsl:for-each select="EquipmentType/EquipmentTypeDetails/EquipmentTypeDetail">
                <xsl:sort select="@LocationLogicalName"/>
                <xsl:copy-of select="."/>
             </xsl:for-each>   
           </EquipmentTypeDetails>  
        </EquipmentType>       
            <Tasks>
        <xsl:for-each select="Tasks/Task">
           <xsl:sort select="concat(@SourceLocationId,Inventory/@ItemId,@TargetSortSequence,@TargetLocationId,@TargetLPNNo)"/>
                <xsl:copy-of select="."/>
        </xsl:for-each>
            </Tasks>
        </Batch>
    </xsl:template>

</xsl:stylesheet> 
