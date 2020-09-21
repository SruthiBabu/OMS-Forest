<?xml version="1.0" encoding="utf-8"?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Selling and Fulfillment Suite - Foundation
(C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->

<!--
	Document   : CommonTemplates_HTML.xsl
	Author     : Pradeep Kariyappa
	Description: This xsl is used to format the input xml to facilitate call to multiApi.
	-->
	
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"	
	xmlns:yfcDate="java:com.yantra.yfc.util.YFCDate"
	xmlns:yfcLocale="java:com.yantra.yfc.util.YFCLocale"
	xmlns:fopUtil="com.yantra.pca.ycd.fop.YCDFOPUtils"
	exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html" indent="yes" />
	
	
	
	
	
	<!--xsl:template name="addFooter">
		<footer class="footer">
			<xsl:if test="Output/Shipment/@PickTicketPrinted = 'Y'">
				<div><xsl:text>REPRINT</xsl:text></div>
			</xsl:if>
			<div><xsl:value-of select="fopUtil:getLocalizedString('@ Copyright 2014 IBM Corporation All Rights Reserved',$locale)" /></div>
		</footer>
		
	</xsl:template-->
	
	<xsl:template match="ShipNode">
		<xsl:variable name="StoreCity"  >
			<xsl:if test="string-length(ShipNodePersonInfo/@City)">
				<xsl:value-of select="concat(ShipNodePersonInfo/@City,', ')" />
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="StoreState">
			<xsl:if test="string-length(ShipNodePersonInfo/@State)">
				<xsl:value-of select="concat(ShipNodePersonInfo/@State,', ')" />
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="StoreZipCode" select="ShipNodePersonInfo/@ZipCode"/>
		<xsl:variable name="FormattedCityStateZipCodeStore">
			<xsl:value-of select="concat($StoreCity, $StoreState, $StoreZipCode)" />
		</xsl:variable>
		<table class="storedetails">
			<tr>
				<td><xsl:value-of select="@Description" /></td>
				<td>
					<div class="storeaddress">
					<div class="company"><xsl:value-of select="ShipNodePersonInfo/@Company" /></div>
					<div><xsl:value-of select="ShipNodePersonInfo/@AddressLine1" /></div>
					<div><xsl:value-of select="ShipNodePersonInfo/@AddressLine2" /></div>
					<div><xsl:value-of select="$FormattedCityStateZipCodeStore" /></div>
					<div><xsl:value-of select="ShipNodePersonInfo/@DayPhone" /></div>
					<div><xsl:value-of select="ShipNodePersonInfo/@EMailID" /></div>
					</div>
				</td>
			</tr>
		</table>		
	</xsl:template>
	
</xsl:stylesheet>