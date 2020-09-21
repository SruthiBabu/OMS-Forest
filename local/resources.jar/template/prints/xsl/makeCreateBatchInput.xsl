<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
    <xsl:template match="/">
        <Batch>
			<xsl:attribute name="OrganizationCode"><xsl:value-of select="TaskList/Task/@OrganizationCode"/></xsl:attribute>
			<xsl:attribute name="TaskType"><xsl:value-of select="TaskList/Task/@TaskType"/></xsl:attribute>
			<xsl:attribute name="WaveNo">
				<xsl:value-of select="TaskList/Task/TaskReferences/@WaveNo"/>
			</xsl:attribute>
			<xsl:attribute name="CountRequestNo">
				<xsl:value-of select="TaskList/Task/TaskReferences/@CountRequestNo"/>
			</xsl:attribute>
			<xsl:attribute name="MoveRequestNo">
				<xsl:value-of select="TaskList/Task/TaskReferences/@MoveRequestNo"/>
			</xsl:attribute>
			<xsl:attribute name="ShipmentNo">
				<xsl:value-of select="TaskList/Task/TaskReferences/@ShipmentNo"/>
			</xsl:attribute>
            <Tasks>
        <xsl:for-each select="TaskList/Task">
			<Task>
                <xsl:attribute name="TaskId"><xsl:value-of select="@TaskId"/></xsl:attribute> 
			</Task>
        </xsl:for-each>
        </Tasks>
      </Batch>
    </xsl:template>

</xsl:stylesheet> 
