<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
	Licensed Materials - Property of IBM
	IBM Sterling Order Management  (5725-D10)
	(C) Copyright IBM Corp. 2005, 2016 All Rights Reserved.
	US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:mm="http://WCToSSFSMediationModule"
	xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
	xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	xmlns:_mbr="http://www.ibm.com/xmlns/prod/commerce/9/member"
	xmlns:oa="http://www.openapplications.org/oagis/9"
	xmlns="http://www.sterlingcommerce.com/documentation/YFS/createOrder/input"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps"
	exclude-result-prefixes="xalan mm _wcf _mbr oa" version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"
		indent="no" />
	<xsl:strip-space elements="*" />
	<xsl:param name="scwc:ValueMapsData" />

	<xsl:template match="/Errors">
		<xsl:copy-of select="/Errors"/>
	</xsl:template>

	<xsl:template name="GetPersonToGetCustomerDetailsOutput" match="/_mbr:ShowPerson">
		<xsl:variable name="totalNumberOfRecords">
			<xsl:value-of
				select="/_mbr:ShowPerson/_mbr:DataArea/oa:Show/@recordSetTotal" />
		</xsl:variable>

		<xsl:variable name="person"
			select="/_mbr:ShowPerson/_mbr:DataArea/_mbr:Person" />

		<Customers>
			<xsl:attribute name="TotalNumberOfRecords">
				<xsl:value-of select="$totalNumberOfRecords" />
			</xsl:attribute>
			<xsl:for-each select="$person">
				<xsl:variable name="userId">
					<xsl:value-of
				select="_mbr:PersonIdentifier/_wcf:UniqueID/text()" />
				</xsl:variable>
				<xsl:variable name="loginId">
					<xsl:value-of
				select="_mbr:Credential/_mbr:LogonID/text()" />
				</xsl:variable>
				<Customer>
					<xsl:attribute name="UserId">
						<xsl:value-of select="$userId" />
					</xsl:attribute>
					<xsl:attribute name="LoginId">
						<xsl:value-of select="$loginId" />
					</xsl:attribute>
				</Customer>
			</xsl:for-each>
		</Customers>
	</xsl:template>
</xsl:stylesheet>
