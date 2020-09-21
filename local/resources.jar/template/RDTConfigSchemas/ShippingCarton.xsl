<?xml version='1.0' encoding='utf-8' ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml"/>	
	<xsl:template match="/">
       <ItemList>
     	<xsl:for-each select="/ItemList/Item">
    	<xsl:element name="{name()}">
	 		<xsl:attribute name="ItemID">
         				<xsl:value-of select="@ItemID"/>
      			</xsl:attribute>
    			<xsl:attribute name="OrganizationCode">
         				<xsl:value-of select="@OrganizationCode"/>
      			</xsl:attribute>
    			<xsl:attribute name="UnitOfMeasure">
         				<xsl:value-of select="@UnitOfMeasure"/>
      			</xsl:attribute>
    			<xsl:attribute name="IsShippingCntr"><xsl:text>Y</xsl:text></xsl:attribute>
      		<xsl:element name="PrimaryInformation">
			<xsl:attribute name="UnitWeight">
         				<xsl:value-of select="@UnitWeight"/>
      			</xsl:attribute>
 			<xsl:attribute name="UnitHeight">
         				<xsl:value-of select="@UnitHeight"/>
      			</xsl:attribute>
 			<xsl:attribute name="UnitLength">
         				<xsl:value-of select="@UnitLength"/>
      			</xsl:attribute>
 			<xsl:attribute name="UnitWidth">
         				<xsl:value-of select="@UnitWidth"/>
      			</xsl:attribute>
 		 </xsl:element>
       		 <xsl:element name="ContainerInformation">
      			 <xsl:attribute name="EmptyCntrWeight">
         				<xsl:value-of select="@UnitWeight"/>
      			</xsl:attribute>
			<xsl:attribute name="MaxCntrWeight">
         				<xsl:value-of select="@MaxCntrWeight"/>
      			</xsl:attribute>
       		</xsl:element>
          	 </xsl:element>
      	</xsl:for-each>
     </ItemList>
 </xsl:template>
 </xsl:stylesheet>