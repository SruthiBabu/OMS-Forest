<?xml version="1.0" encoding="UTF-8" ?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Call Center and Store
(C) Copyright IBM Corp. 2006, 2011 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">

<xsl:output indent="yes"/>
			    
<xsl:template match="MultiApi">
   <PrintJasper>
	<xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getUserHierarchy&quot;)]" >
                  
		             <xsl:attribute name="Localecode">
				<xsl:value-of select="Output/User/@Localecode"/>
			   </xsl:attribute>
		    
	</xsl:for-each>
	<xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getPrinter&quot;)]" >
                  <xsl:for-each select="Output/Printer/PrinterParams/Attributes/Attribute">
		       <xsl:if test="@Name=&quot;PrinterAlias&quot;">
		             <xsl:attribute name="PrinterName">
				<xsl:value-of select="@Value"/>
			   </xsl:attribute>
		     </xsl:if>
	           </xsl:for-each>
	</xsl:for-each>
	<xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getCompleteOrderDetails&quot;)]">
		<xsl:copy-of select="Output/Order">
		</xsl:copy-of>
	</xsl:for-each>

	<xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getShipNodeList&quot;)]" >
		
		<xsl:copy-of select="Output/ShipNodeList/ShipNode">
		</xsl:copy-of>
		
	</xsl:for-each>
	<xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getUserHierarchy&quot;)]" >
		
		<xsl:copy-of select="Output/User">
		</xsl:copy-of>
		
	</xsl:for-each>
	<xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getCommonCodeList&quot;)]" >
		
		<xsl:copy-of select="Output/CommonCodeList">
		</xsl:copy-of>
		
	</xsl:for-each>
	<xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getCurrencyList&quot;)]" >
		
		<xsl:copy-of select="Output/CurrencyList">
		</xsl:copy-of>
		
	</xsl:for-each>
	<xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getItemUOMMasterList&quot;)]" >
		
		<xsl:copy-of select="Output/ItemUOMMasterList">
		</xsl:copy-of>
		
	</xsl:for-each>
   </PrintJasper>
</xsl:template>
</xsl:stylesheet>
