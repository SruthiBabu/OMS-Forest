<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10), IBM Order Management (5737-D18)
  (C) Copyright IBM Corp. 2018  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output  method="xml" indent="yes" omit-xml-declaration="yes"/> 

<xsl:template match="/Item">
<ItemList>
	<Item Action="Manage" SyncTS=" " >
		<xsl:attribute name="ItemKey">
		  <xsl:value-of select="@ItemKey" />
		</xsl:attribute>
		<xsl:attribute name="ItemID">
		  <xsl:value-of select="@ItemID" />
		</xsl:attribute>
		<xsl:attribute name="UnitOfMeasure">
		  <xsl:value-of select="@UnitOfMeasure" />
		</xsl:attribute>
		<xsl:attribute name="OrganizationCode">
		  <xsl:value-of select="@OrganizationCode" />
		</xsl:attribute>
	</Item>
</ItemList>
</xsl:template >

</xsl:stylesheet>
