<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/> 

<xsl:template match="/">
<Sync_Event >
	<xsl:attribute name="id">
		<xsl:value-of select="/Customer/@CustomerKey" />
	</xsl:attribute>
	<xsl:attribute name="CreateDate">
		<xsl:value-of select="/Customer/@MaxModifyTS" />
	</xsl:attribute>
	<Sync_Header EventCategory="User"  >
		<xsl:attribute name="Mod_Type">
			<xsl:choose>
				<!-- if SyncTS is set, then sync happened. Set operation as to what is passed in. -->
				<xsl:when test="/Customer/@SyncTS != ''" >
					<xsl:value-of select="/Customer/@Operation" />
				</xsl:when>
				<!-- if the operation is not Modify, it should be what was passed. -->
				<xsl:when test="/Customer/@Operation != 'Modify'" >
					<xsl:value-of select="/Customer/@Operation" />
				</xsl:when>
				<!-- otherwise, operation should be Create. -->
				<xsl:otherwise>
					<xsl:value-of select="'Create'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="Mod_Date">
			<xsl:value-of select="/Customer/@MaxModifyTS" />
		</xsl:attribute>
		<xsl:attribute name="OrganizationCode">
			<xsl:value-of select="/Customer/@OrganizationCode" />
		</xsl:attribute>
	</Sync_Header>

	<Sync_Data>
		<xsl:apply-templates/>
	</Sync_Data>
</Sync_Event>
</xsl:template>

<!-- copy input -->
<xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()" />
  </xsl:copy>
</xsl:template>

<!-- remove MaxModifyTS -->
<xsl:template match="@MaxModifyTS" />

<!-- remove CustomerKey -->
<xsl:template match="@CustomerKey" />

</xsl:stylesheet>
