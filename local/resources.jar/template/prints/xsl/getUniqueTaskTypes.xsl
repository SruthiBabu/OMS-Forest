<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <!-- template rule matching source root element -->
    <xsl:template match="/">
        <TaskTypes>
        <xsl:for-each select="TaskList/Task[not(@TaskType= preceding-sibling::Task/@TaskType)]">
			<TaskType>
                <xsl:attribute name="TaskId"><xsl:value-of select="@TaskId"/></xsl:attribute> 
                <xsl:attribute name="TaskType"><xsl:value-of select="@TaskType"/></xsl:attribute> 
			</TaskType>
        </xsl:for-each>
      </TaskTypes>
    </xsl:template>

</xsl:stylesheet> 
