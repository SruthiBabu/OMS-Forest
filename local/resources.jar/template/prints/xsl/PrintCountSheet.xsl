<?xml version = "1.0" encoding = "UTF-8"?>
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
	<xsl:output indent="yes"/>
	<xsl:template match="Print | Batch">
	<PrintDocuments>
		<xsl:attribute name="PrintName">
			<xsl:text>countSheet</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="FlushToPrinter">
			<xsl:text>Y</xsl:text>
		</xsl:attribute>
		<PrintDocument>
			<xsl:attribute name="BeforeChildrenPrintDocumentId">
				<xsl:text>COUNTSHEET</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="DataElementPath">
				<xsl:text>xml:/Batch</xsl:text>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="name()=&quot;Print&quot;">
					<xsl:copy-of select="PrinterPreference"/>
					<xsl:copy-of select="LabelPreference"/>
				</xsl:when>
				<xsl:when test="name()=&quot;Batch&quot;">
					<PrinterPreference>
						<xsl:attribute name="PrinterId"/>
						<xsl:attribute name="UsergroupId"/>
						<xsl:attribute name="UserId"><xsl:text>xml:/Batch/Task/@AssignedToUserId</xsl:text></xsl:attribute>
						<xsl:attribute name="WorkStationId"/>
						<xsl:attribute name="OrganizationCode"><xsl:text>xml:/Batch/@OrganizationCode</xsl:text></xsl:attribute>
					</PrinterPreference>
					<LabelPreference>
						<xsl:attribute name="EnterpriseCode">
							<xsl:text>xml:/Batch/@Node</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="BuyerOrganizationCode">
							<xsl:text>xml:/Batch/@Node</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="SellerOrganizationCode">
							<xsl:text>xml:/Batch/@Node</xsl:text>
						</xsl:attribute>
					</LabelPreference>
				</xsl:when>
			</xsl:choose>
			
			<KeyAttributes>
				<KeyAttribute>
					<xsl:attribute name="Name"><xsl:text>BatchKey</xsl:text></xsl:attribute>
				</KeyAttribute>
			</KeyAttributes>
			<InputData>
				<xsl:attribute name="APIName">
					<xsl:text>getBatchDetails</xsl:text>
				</xsl:attribute>
				<Batch>
				<xsl:choose>
					<xsl:when test="name()=&quot;Print&quot;">
						<xsl:copy-of select="Batch/@*" /> 
					</xsl:when>
					<xsl:when test="name()=&quot;Batch&quot;">
						<xsl:copy-of select="@*" /> 
					</xsl:when>
				</xsl:choose>	
				</Batch>
				<Template>
					 <Batch>
					 <Tasks>
							<Task>
								 <Inventory> 
										<Item>
											<PrimaryInformation/>
										</Item>								
								 </Inventory>
							 </Task>
						 </Tasks>
					 </Batch>
				</Template>
			</InputData>
	</PrintDocument>
</PrintDocuments>
</xsl:template>
</xsl:stylesheet>