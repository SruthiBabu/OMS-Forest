<?xml version='1.0' ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<xsl:apply-templates select="Task"/>
		<xsl:apply-templates select="Wave"/>
	</xsl:template>
	<xsl:template match="Task">
		<Message FlowName="RELEASE_TASK" TransactionKey="RELEASE_TASK">
			<AgentDetails>
				<MessageXml Action="Get">
					<xsl:attribute name="OrganizationCode">
						<xsl:value-of select="@OrganizationCode"/>
					</xsl:attribute>
					<xsl:attribute name="LocationId">
						<xsl:if test="normalize-space(@TaskStatus) = &quot;1300&quot;">
							<xsl:value-of select="@SourceLocationId"/>
						</xsl:if>
						<xsl:if test="normalize-space(@TaskStatus) = &quot;2000&quot;">
						<xsl:value-of select="@TargetLocationId"/>
						</xsl:if>
					</xsl:attribute>
				</MessageXml>
			</AgentDetails>
		</Message>
	</xsl:template>
	<xsl:template match="Wave">
		<Message FlowName="RELEASE_TASK" TransactionKey="RELEASE_TASK">
			<AgentDetails>
				<MessageXml Action="Get">
					<xsl:attribute name="OrganizationCode">
						<xsl:value-of select="@Node"/>
					</xsl:attribute>
					<xsl:attribute name="WaveKey">
						<xsl:value-of select="@WaveKey"/>
					</xsl:attribute>
					<xsl:attribute name="WaveNo">
						<xsl:value-of select="@WaveNo"/>
					</xsl:attribute>
				</MessageXml>
			</AgentDetails>
		</Message>
	</xsl:template>
</xsl:stylesheet>