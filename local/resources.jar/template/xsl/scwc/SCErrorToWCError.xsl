<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:oa="http://www.openapplications.org/oagis/9"
	 version="1.0">
	<xsl:output method="xml" encoding="UTF-8"
		omit-xml-declaration="yes" indent="no" />
	<xsl:strip-space elements="*" />
	<xsl:template name="VerbToErrors" match="/">
		<Errors>
			<xsl:for-each select="/" >
				<Error>
					<xsl:attribute name="ErrorCode">WC_ERROR</xsl:attribute>
					
					<xsl:attribute name="ErrorDescription">
                		<xsl:value-of select="oa:ChangeStatus/oa:Description"/>
              		</xsl:attribute>
              		<xsl:attribute name="ErrorRelatedMoreInfo">
                		<xsl:value-of select="oa:ChangeStatus/oa:ReasonCode"/>
              		</xsl:attribute>
              		<xsl:for-each select="oa:ChangeStatus/oa:Reason">
						<xsl:variable name="index" select="position()"></xsl:variable>
              			<Attribute>
							<xsl:attribute name="Name">
								<xsl:value-of select="concat('Parameter', $index)" />
							</xsl:attribute>
							<xsl:attribute name="Value">
								<xsl:value-of select="." />
							</xsl:attribute>
						</Attribute>
					</xsl:for-each>
				</Error>
			</xsl:for-each>
		</Errors>
	</xsl:template>
</xsl:stylesheet>