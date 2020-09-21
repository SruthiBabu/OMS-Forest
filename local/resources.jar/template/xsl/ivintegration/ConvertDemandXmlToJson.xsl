<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<InventoryVisibilityAPI URL="" HTTPMethod="" Content-Type="application/json">
<Input>
{ "demands":[
<xsl:apply-templates select="*" />
]
}
</Input>
</InventoryVisibilityAPI>
</xsl:template>
<xsl:template match="Demand">
                {
                        "itemId":"<xsl:value-of select="@ItemID"/>",
                        "unitOfMeasure":"<xsl:value-of select="@UnitOfMeasure"/>",
                        "productClass":"<xsl:value-of select="@ProductClass"/>",
                        "type":"<xsl:value-of select="@DemandType"/>",
                        "shipNode":"<xsl:value-of select="@ShipNode"/>",
                        "cancelDate":<xsl:choose><xsl:when test='string-length(@DemandCancelDate)=0'>""</xsl:when><xsl:otherwise>"<xsl:value-of select="@DemandCancelDate"/>T00:00:00Z"</xsl:otherwise></xsl:choose>,
                        "shipDate":<xsl:choose><xsl:when test='string-length(@DemandShipDate)=0'>""</xsl:when><xsl:otherwise>"<xsl:value-of select="@DemandShipDate"/>T00:00:00Z"</xsl:otherwise></xsl:choose>,
                        <xsl:choose><xsl:when test='string-length(@MinShipByDate)=0'>"minShipByDate":"1900-01-01T00:00:00Z"</xsl:when><xsl:otherwise>"minShipByDate":"<xsl:value-of select="concat(@MinShipByDate,'T00:00:00Z')"/>"</xsl:otherwise></xsl:choose>,
                        "referenceType":"<xsl:value-of select="@DemandReferenceType"/>",
                        "reference":"<xsl:value-of select="@DemandReference"/>",
                        "segmentType":"<xsl:value-of select="@SegmentType"/>",
                        "segment":"<xsl:value-of select="@Segment"/>",<xsl:if test="not(@SuppressTagInfo = 'Y')">
                        "tagNumber":<xsl:choose><xsl:when test='@TagNumber'>"<xsl:value-of select="@TagNumber"/>"</xsl:when><xsl:otherwise>"<xsl:value-of select="normalize-space(Tag/@BatchNo)"/>|<xsl:value-of select="normalize-space(Tag/@LotNumber)"/>|<xsl:value-of select="normalize-space(Tag/@ManufacturingDate)"/>|<xsl:value-of select="normalize-space(Tag/@RevisionNo)"/>"</xsl:otherwise></xsl:choose>,</xsl:if>
                        "changedQuantity":<xsl:value-of select="@Quantity"/>,
                        "quantity":<xsl:value-of select="@Quantity"/>,
                        "sourceTs":"<xsl:value-of select="@SourceTs"/>",
                        "reservations":[<xsl:apply-templates select="Reservations" />
                        ]
            }<xsl:if test="./following-sibling::Demand">,</xsl:if>
    </xsl:template>
    <xsl:template match="Reservations"><xsl:apply-templates select="Reservation" />
    </xsl:template>
    <xsl:template match="Reservation">
                            {
                                "id":"<xsl:value-of select="@ReservationId"/>",
                                "quantity":"<xsl:value-of select="@ReservationQuantity"/>",
                                "reference":"<xsl:value-of select="@ReservationReference"/>"
                            }<xsl:if test="./following-sibling::Reservation">,</xsl:if>
    </xsl:template>
</xsl:stylesheet>