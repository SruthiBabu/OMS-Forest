<!--
  Licensed Materials - Property of IBM
  5725-F55
  Copyright IBM Corporation 2011. All Rights Reserved.
  US Government Users Restricted Rights- Use, duplication or disclosure
  restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" omit-xml-declaration="yes" />
	
	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable> 
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable> 
	<xsl:variable name="businessCustTypeString"><xsl:text>business</xsl:text></xsl:variable>
	<xsl:variable name="consumerCustTypeString"><xsl:text>consumer</xsl:text></xsl:variable>
	<xsl:variable name="anonymousCustTypeString"><xsl:text>anonymous</xsl:text></xsl:variable>
	<xsl:variable name="allCustTypeString"><xsl:text>all</xsl:text></xsl:variable>
	
	<xsl:template match="/">
		<xsl:apply-templates select="Pricelist"/>
	</xsl:template>
	
	<xsl:template match="Pricelist">
		<PricelistAssignment>
				<xsl:apply-templates select="Action"/>
				<xsl:apply-templates select="PricelistAssignment"/>
				<xsl:apply-templates select="PricelistHeader"/>
		</PricelistAssignment>
	</xsl:template>
	
	<xsl:template match="Action">	
		<xsl:attribute name="Operation">
			<xsl:value-of select="@Operation"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="PricelistAssignment">	
		<xsl:variable name="CustType">
			<xsl:value-of select="translate(@CustomerType,$upper,$lower)"/>
		</xsl:variable>	
		<xsl:choose>
		<xsl:when test="$businessCustTypeString=$CustType">
			<xsl:attribute name="CustomerType">
				<xsl:text>01</xsl:text>
			</xsl:attribute>
		</xsl:when>
		<xsl:when test="$consumerCustTypeString=$CustType">
			<xsl:attribute name="CustomerType">
				<xsl:text>02</xsl:text>
			</xsl:attribute>
		</xsl:when>
		 <xsl:when test="$anonymousCustTypeString=$CustType">
			<xsl:attribute name="CustomerType">
				<xsl:text>03</xsl:text>
			</xsl:attribute>
		</xsl:when>
		<xsl:when test="$allCustTypeString=$CustType">
			<xsl:attribute name="CustomerType">
				<xsl:text>04</xsl:text>
			</xsl:attribute>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:attribute name="CustomerType">
				<xsl:value-of select="@CustomerType"/>
			</xsl:attribute>
		</xsl:otherwise>
	 </xsl:choose>
		<xsl:attribute name="CustomerID">
			<xsl:value-of select="@CustomerID"/>
		</xsl:attribute>
		<xsl:attribute name="EnterpriseCode">
			<xsl:value-of select="/Pricelist/@OrganizationCode"/>
		</xsl:attribute>
		<xsl:attribute name="RelationshipType">
			<xsl:value-of select="@RelationshipType"/>
		</xsl:attribute>
		<xsl:attribute name="Shareable">
			<xsl:value-of select="@Shareable"/>
		</xsl:attribute>
		<xsl:attribute name="Vertical">
			<xsl:value-of select="@Vertical"/>
		</xsl:attribute>
	</xsl:template>
	
	
	<xsl:template match="PricelistHeader">
		<PricelistHeader>
			<xsl:attribute name="PricelistName">
				<xsl:value-of select="@PricelistName"/>
			</xsl:attribute>
		</PricelistHeader>							
	</xsl:template>	
	
	
</xsl:stylesheet>