<?xml version="1.0" encoding="utf-8"?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Selling and Fulfillment Suite - Foundation
(C) Copyright IBM Corp. 2007, 2012 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:reportUtil="java:com.yantra.pca.ycd.jasperreports.orderSummaryReportScriptlet"
	xmlns:yfcDate="java:com.yantra.yfc.util.YFCDate"
	xmlns:yfcLocale="java:com.yantra.yfc.util.YFCLocale"
	xmlns:fopUtil="com.yantra.pca.ycd.fop.YCDFOPUtils"
	exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml" indent="yes" />
   
     <!-- layout-master-set of type A4-landscape -->
	<xsl:template name="A4-landscape_layout-master-set">
		 <fo:simple-page-master master-name="A4-landscape"  
				page-height="21.0cm" page-width="35cm" font-size="10pt" font-family="arial,sans-serif" margin-top="1cm" 
				margin-bottom="2cm" margin-left="1cm" margin-right="1cm">
				<fo:region-body />
				<fo:region-before region-name="header-blank" extent="297mm"/>
				<fo:region-after />
		</fo:simple-page-master>
	</xsl:template>
   
    <!-- layout-master-set of type A4-portrait -->
	<xsl:template name="A4-portrait_layout-master-set">
		 <fo:simple-page-master master-name="A4-portrait"  
				page-height="29.7cm" page-width="21.0cm" margin-top="1cm"
					margin-bottom="2cm" margin-left="1.5cm" margin-right="1.5cm">
				<fo:region-body />
				<fo:region-before region-name="header-blank" extent="297mm"/>
				<fo:region-after />
		</fo:simple-page-master>
	</xsl:template>
	
	
      <!--commonHeader -->
	<xsl:template name="commonHeader">
		 <xsl:param name="reportHeading"/>
		 <xsl:param name="storeName"/>
	    <fo:table table-layout="fixed" border-width="0mm" width="100%">
		 <fo:table-column column-width="100%"/>
 		   <fo:table-body>
			 <fo:table-row>
			  <fo:table-cell>  
			    <fo:block font-family="Arial" text-align="center" text-decoration="underline" 
			     	font-size="18pt" font-weight="bold" space-before="100mm" text-align-last="center">
				<xsl:value-of select="$reportHeading" />
				</fo:block>
		     </fo:table-cell>
		    </fo:table-row>
		    <fo:table-row>
			   <fo:table-cell padding="2mm">
			  <fo:block font-size="35pt" font-family="Arial" color="#8fbc8f" text-align-last="left" >
			  <xsl:value-of select="$storeName" />
			  </fo:block>
			  </fo:table-cell>
			   </fo:table-row>
		   </fo:table-body>
		  </fo:table> 
	</xsl:template>

	<xsl:template name="commonHeaderStatic-content">
		 <xsl:param name="reportHeading"/>
	      <fo:static-content flow-name="header-blank">
		     <fo:table table-layout="fixed" border-width="0mm" width="100%">
			  <fo:table-column column-width="100%" /> 
			  <fo:table-body> 
			  <fo:table-row>
			   <fo:table-cell padding="2mm">
			  <fo:block font-size="28pt" color="#8fbc8f" text-align-last="left" >
			  <xsl:text>MATRIX</xsl:text> 
			  </fo:block>
			  </fo:table-cell>
			   </fo:table-row>
			    <fo:table-row>
			 <fo:table-cell padding="2mm">
			  <fo:block font-family="sans-serif" text-align="center" text-decoration="underline" font-size="18pt" font-weight="bold" space-before="100mm" text-align-last="center">
								<xsl:value-of select="$reportHeading" /></fo:block>
			  </fo:table-cell>
			 </fo:table-row>
			</fo:table-body>
			</fo:table>
		  </fo:static-content>
	</xsl:template>
 <!--Common footer with Order number  -->
     <xsl:template name="orderFooter">
		 <xsl:param name="orderNumber"/>
	      <fo:static-content flow-name="xsl-region-after" font-size="8pt">
			<fo:block text-align="center" font-size="9pt" font-family="sans-serif"
				background-color="White" white-space-collapse="false">
				<xsl:value-of select="fopUtil:getLocalizedString('Copyright IBM Corp. [2010, 2011] All Rights Reserved',$locale)" />
				<xsl:text>&#x20;&#x20;&#x20;</xsl:text>
				<xsl:value-of select="fopUtil:getLocalizedString('Page ',$locale)" />
				<fo:page-number />
				<xsl:value-of select="fopUtil:getLocalizedString(' of ',$locale)" /> 
				<fo:page-number-citation ref-id="last-page" />
			 </fo:block>
		</fo:static-content>
	</xsl:template>

	 <xsl:template name="orderFooterForWebStore">
		 <xsl:param name="orderNumber"/>
	      <fo:static-content flow-name="xsl-region-after" font-size="8pt">
			<fo:block text-align="center" font-size="9pt" font-family="sans-serif"
				background-color="White" white-space-collapse="false">
				<xsl:value-of select="fopUtil:getLocalizedString('Copyright IBM Corp. 2014 All Rights Reserved',$locale)" />
				<xsl:text>&#x20;&#x20;&#x20;</xsl:text>
				<xsl:value-of select="fopUtil:getLocalizedString('Page ',$locale)" />
				<fo:page-number />
				<xsl:value-of select="fopUtil:getLocalizedString(' of ',$locale)" /> 
				<fo:page-number-citation ref-id="last-page" />
			 </fo:block>
		</fo:static-content>
	</xsl:template>
	
	
	 <!-- empty block  -->
      <xsl:template name="addEmptyBlock">
		 <xsl:param name="hightinpt"/>
	    <fo:table width="100%">
	    <fo:table-column column-width="100%"/>
	    <fo:table-body> <fo:table-row> <fo:table-cell> 
	 	  <fo:block white-space-treatment="preserve" linefeed-treatment="preserve">
		  <xsl:text> &#x00A0;</xsl:text> 
    	 </fo:block></fo:table-cell></fo:table-row></fo:table-body>
		 </fo:table>
	 </xsl:template>
	
    <!-- xsl:template name="TodaysDate">
         <xsl:param name="localeValue"/>
		 <xsl:value-of select="yfcDate.getString(yfcLocale.getYFCLocale($localeValue), 'true')"/>
    </xsl:template -->
    
</xsl:stylesheet>
