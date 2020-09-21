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
		<Order>
			<xsl:variable name="deliveryMethod">
				<xsl:value-of select="Output/Order/@DeliveryMethod"/>
			</xsl:variable>
			<xsl:for-each select="Output/Order/@*">
				<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
			</xsl:for-each>			
			<xsl:attribute name="DeliveryMethod">
				<xsl:value-of select="ancestor::MultiApi/API[./@Name = 'getCommonCodeList']/Output/CommonCodeList/CommonCode[./@CodeValue = $deliveryMethod]/@CodeShortDescription"/>
			</xsl:attribute>
			<OrderLines>
				<xsl:for-each select="Output/Order/OrderLines/OrderLine">
					<xsl:variable name="lineDelMethod">
						<xsl:value-of select="@DeliveryMethod"/>
					</xsl:variable>
					<OrderLine>
						<xsl:for-each select="@*">
							<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
						</xsl:for-each>						
						<xsl:attribute name="DeliveryMethod">
							<xsl:value-of select="ancestor::MultiApi/API[./@Name = 'getCommonCodeList']/Output/CommonCodeList/CommonCode[./@CodeValue = $lineDelMethod]/@CodeShortDescription"/>
						</xsl:attribute>
						<xsl:copy-of select="*"/>
					</OrderLine>
				</xsl:for-each>
			</OrderLines>
			<xsl:copy-of select="Output/Order/*[not(name() = 'OrderLines')]"/>
		</Order>
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
