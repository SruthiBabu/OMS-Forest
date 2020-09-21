<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<InventoryVisibilityAPI URL="" HTTPMethod="" Content-Type="application/json">
<Input>
{ "supplies":[
         <xsl:for-each select="Supplies">
            <xsl:for-each select="Supply">
                {
                   "itemId":"<xsl:value-of select="@ItemID"/>",
                   "unitOfMeasure":"<xsl:value-of select="@UnitOfMeasure"/>",
                   "productClass":"<xsl:value-of select="@ProductClass"/>",
                   "type":"<xsl:value-of select="@SupplyType"/>",
                   "shipNode":"<xsl:value-of select="@ShipNode"/>",
                   "adjustmentReason":"<xsl:value-of select="@AdjustmentReason"/>",
                   "referenceType":"<xsl:value-of select="@ActualSupplyReferenceType"/>",
                   "reference":"<xsl:value-of select="@ActualSupplyReference"/>",
                   "lineReference":"<xsl:value-of select="@SupplyLineReference"/>",
                   "segmentType":"<xsl:value-of select="@SegmentType"/>",
                   "segment":"<xsl:value-of select="@Segment"/>",
                   <xsl:choose><xsl:when test='string-length(@ETA)=0'>"eta":"1900-01-01T00:00:00Z"</xsl:when><xsl:otherwise>"eta":"<xsl:value-of select="concat(@ETA,'T00:00:00Z')"/>"</xsl:otherwise></xsl:choose>,
                   <xsl:choose><xsl:when test='string-length(@ShipByDate)=0'>"shipByDate":"2500-01-01T00:00:00Z"</xsl:when><xsl:otherwise>"shipByDate":"<xsl:value-of select="concat(@ShipByDate,'T00:00:00Z')"/>"</xsl:otherwise> 
                   </xsl:choose>,<xsl:if test="not(@SuppressTagInfo = 'Y')">
                   "tagNumber":<xsl:choose><xsl:when test='@TagNumber'>"<xsl:value-of select="@TagNumber"/>"</xsl:when><xsl:otherwise>"<xsl:value-of select="normalize-space(Tag/@BatchNo)"/>|<xsl:value-of select="normalize-space(Tag/@LotNumber)"/>|<xsl:value-of select="normalize-space(Tag/@ManufacturingDate)"/>|<xsl:value-of select="normalize-space(Tag/@RevisionNo)"/>"</xsl:otherwise></xsl:choose>,</xsl:if>
                   "changedQuantity":<xsl:value-of select="@Quantity"/>,
                   "quantity":<xsl:value-of select="@Quantity"/>,
                   "sourceTs":"<xsl:value-of select="@SourceTs"/>" 
                  }
                 <xsl:if test="./following-sibling::Supply">,</xsl:if>
                </xsl:for-each>
       ]
  </xsl:for-each>
}
</Input>
</InventoryVisibilityAPI>
</xsl:template>
</xsl:stylesheet>