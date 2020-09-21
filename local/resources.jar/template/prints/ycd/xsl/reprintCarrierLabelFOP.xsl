<?xml version="1.0" encoding="utf-8"?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Selling and Fulfillment Suite - Foundation
(C) Copyright IBM Corp. 2011, 2012 All Rights Reserved. 
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:fopUtil="com.yantra.pca.ycd.fop.YCDFOPUtils"
	exclude-result-prefixes="java"
	xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml" indent="yes" />
	<xsl:variable name="locale">en_US_EST</xsl:variable>

<xsl:template match="/">
	<fo:root>
			<fo:layout-master-set>
				<xsl:call-template name="Label_Layout" />
			</fo:layout-master-set>
			<fo:page-sequence master-reference="Label">
				<fo:flow flow-name="xsl-region-body"
					font-family="Arial">
					<xsl:apply-templates select="/reprintCarrierLabel" />
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
	
	<xsl:template match="reprintCarrierLabel">
		<xsl:apply-templates select="Container" />
		<fo:block id="last-page"/>
	</xsl:template>

	<xsl:template match="Container">
		<fo:table background-color="White" table-layout="fixed"
			border-width="0mm" width="100%">
			<fo:table-column column-width="100%" />
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell>
						<fo:block font-family="Arial"
							text-align="center" font-size="18pt" font-weight="bold"
							space-before="100mm" text-align-last="center">
							<xsl:variable name="path"
								select="concat(@PierbridgeServerURL, '?', @PierbridgeLabelURL)">
							</xsl:variable>
					
							<fo:external-graphic height="6in" width="4in" content-height="scale-to-fit" content-width="scale-to-fit" src="url({$path})" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>

			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template name="Label_Layout">
		 <fo:simple-page-master master-name="Label"  
				page-height="15.24cm" page-width="10.16cm">
				<fo:region-body />
				<fo:region-before/>
			</fo:simple-page-master>
	</xsl:template>
	
</xsl:stylesheet>