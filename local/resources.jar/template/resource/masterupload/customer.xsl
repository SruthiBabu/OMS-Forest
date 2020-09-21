<!--
  Licensed Materials - Property of IBM
  5725-F55
  Copyright IBM Corporation 2011. All Rights Reserved.
  US Government Users Restricted Rights- Use, duplication or disclosure
  restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:func="com.yantra.ysc.business.masterupload.YSCMasterUploadUtils" exclude-result-prefixes="func">
	
	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" omit-xml-declaration="yes" />
	
	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable> 
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable> 
	<xsl:variable name="businessCustTypeString"><xsl:text>business</xsl:text></xsl:variable>
	<xsl:variable name="consumerCustTypeString"><xsl:text>consumer</xsl:text></xsl:variable>
	<xsl:variable name="locale"><xsl:text>en_US_EST</xsl:text></xsl:variable>
	<xsl:variable name="status"><xsl:text>10</xsl:text></xsl:variable>
	
	<xsl:template match="/">
		<xsl:apply-templates select="CustomerRoot"/>
	</xsl:template>
	
	<xsl:template match="CustomerRoot">
		<Customer>	
			<xsl:apply-templates select="Action"/>
			<xsl:apply-templates select="Customer"/>
			<CustomerContactList>
				<xsl:apply-templates select="CustomerContact"/>
			</CustomerContactList>
			<CustomerAdditionalAddressList>
				<xsl:apply-templates select="CustomerAdditionalAddress"/>
			</CustomerAdditionalAddressList>
		</Customer>
	</xsl:template>
	
	<xsl:template match="Action">	
		<xsl:attribute name="Operation">
			<xsl:value-of select="@Action"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="Customer">	
		
		<xsl:variable name="CustType">
			<xsl:value-of select="translate(@CustomerType,$upper,$lower)"/>
		</xsl:variable>
		<xsl:variable name="CustomerID">
			<xsl:value-of select="@CustomerID"/>
		</xsl:variable>
		<xsl:variable name="OrganizationCode">
			<xsl:value-of select="/CustomerRoot/@OrganizationCode"/>
		</xsl:variable>
		<xsl:variable name="CustOrganizationCode">
			<xsl:value-of select="func:getCustomerOrganizationCode($CustomerID,$OrganizationCode)"/>
		</xsl:variable>
		<xsl:attribute name="CustomerID">
			<xsl:value-of select="$CustomerID"/>
		</xsl:attribute>
		<xsl:attribute name="OrganizationCode">
			<xsl:value-of select="$OrganizationCode"/>
		</xsl:attribute>
		<xsl:attribute name="Status">
			<xsl:value-of select="$status"/>
		</xsl:attribute>
		<xsl:attribute name="RelationshipType">
			<xsl:value-of select="@RelationshipType"/>
		</xsl:attribute>
		<xsl:attribute name="Vertical">
			<xsl:value-of select="@Vertical"/>
		</xsl:attribute>
		<xsl:if test="$businessCustTypeString=$CustType">
		<xsl:attribute name="CustomerType">
			<xsl:text>01</xsl:text>
		</xsl:attribute>
			<BuyerOrganization>
				<xsl:attribute name="DunsNumber">
					<xsl:value-of select="@DunsNumber"/>
				</xsl:attribute>
				<xsl:attribute name="TaxExemptFlag">
					<xsl:value-of select="@TaxExemptFlag"/>
				</xsl:attribute>
				<xsl:attribute name="LocaleCode">
					<xsl:value-of select="$locale"/>
				</xsl:attribute>
				<xsl:attribute name="OrganizationName">
					<xsl:value-of select="@OrganizationName"/>
				</xsl:attribute>
				<xsl:attribute name="OrganizationCode">
					<xsl:value-of select="$CustOrganizationCode"/>
				</xsl:attribute>
					<xsl:attribute name="ParentOrganizationCode">
					<xsl:value-of select="$OrganizationCode"/>
				</xsl:attribute>
				<xsl:attribute name="PrimaryEnterpriseKey">
					<xsl:value-of select="$OrganizationCode"/>
				</xsl:attribute>
			</BuyerOrganization>
		</xsl:if>
		<xsl:if test="$consumerCustTypeString=$CustType">
			<xsl:attribute name="CustomerType">
				<xsl:text>02</xsl:text>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="CustomerContact">
		<CustomerContact>
			<xsl:attribute name="Company">
				<xsl:value-of select="/CustomerRoot/Customer/@OrganizationName"/>
			</xsl:attribute>
			<xsl:attribute name="FirstName">
				<xsl:value-of select="@FirstName"/>
			</xsl:attribute>
			<xsl:attribute name="LastName">
				<xsl:value-of select="@LastName"/>
			</xsl:attribute>
			<xsl:attribute name="MiddleName">
				<xsl:value-of select="@MiddleName"/>
			</xsl:attribute>
			<xsl:attribute name="EmailID">
				<xsl:value-of select="@EmailID"/>
			</xsl:attribute>
			<xsl:attribute name="JobTitle">
				<xsl:value-of select="@JobTitle"/>
			</xsl:attribute>
			<xsl:attribute name="DayPhone">
				<xsl:value-of select="@DayPhone"/>
			</xsl:attribute>
			<CustomerAdditionalAddressList/>
		</CustomerContact>					
	</xsl:template>	
	
	<xsl:template match="CustomerAdditionalAddress">
		<CustomerAdditionalAddress>
			<xsl:attribute name="AddressType">
				<xsl:value-of select="@IsCommercialAddress"/>
			</xsl:attribute>
			<xsl:attribute name="IsDefaultBillTo">
				<xsl:value-of select="@IsDefaultBillTo"/>
			</xsl:attribute>
			<xsl:attribute name="IsDefaultShipTo">
				<xsl:value-of select="@IsDefaultShipTo"/>
			</xsl:attribute>
			<xsl:attribute name="IsDefaultSoldTo">
				<xsl:value-of select="@IsDefaultSoldTo"/>
			</xsl:attribute>
			<xsl:attribute name="IsBillTo">
				<xsl:value-of select="@IsDefaultBillTo"/>
			</xsl:attribute>
			<xsl:attribute name="IsShipTo">
				<xsl:value-of select="@IsDefaultShipTo"/>
			</xsl:attribute>
			<xsl:attribute name="IsSoldTo">
				<xsl:value-of select="@IsDefaultSoldTo"/>
			</xsl:attribute>			
				<PersonInfo>
					 <xsl:attribute name="Company">
						<xsl:value-of select="/CustomerRoot/Customer/@OrganizationName"/>
					</xsl:attribute>
					<xsl:attribute name="FirstName">
						<xsl:value-of select="@FirstName"/>
					</xsl:attribute>
					<xsl:attribute name="LastName">
						<xsl:value-of select="@LastName"/>
					</xsl:attribute>
					<xsl:attribute name="MiddleName">
						<xsl:value-of select="@MiddleName"/>
					</xsl:attribute>
					<xsl:attribute name="EmailID">
						<xsl:value-of select="@EmailID"/>
					</xsl:attribute>
					<xsl:attribute name="JobTitle">
						<xsl:value-of select="@JobTitle"/>
					</xsl:attribute>
					<xsl:attribute name="DayPhone">
						<xsl:value-of select="@DayPhone"/>
					</xsl:attribute>
					<xsl:attribute name="AddressLine1">
						<xsl:value-of select="@AddressLine1"/>
					</xsl:attribute>
					<xsl:attribute name="AddressLine2">
						<xsl:value-of select="@AddressLine2"/>
					</xsl:attribute>
					<xsl:attribute name="City">
						<xsl:value-of select="@City"/>
					</xsl:attribute>
					<xsl:attribute name="State">
						<xsl:value-of select="@State"/>
					</xsl:attribute>
					<xsl:attribute name="Country">
						<xsl:value-of select="@Country"/>
					</xsl:attribute>
					<xsl:attribute name="ZipCode">
						<xsl:value-of select="@ZipCode"/>
					</xsl:attribute>
					<xsl:attribute name="ZipCode">
						<xsl:value-of select="@ZipCode"/>
					</xsl:attribute>
				</PersonInfo>
			</CustomerAdditionalAddress>
	</xsl:template>	
	
	
</xsl:stylesheet>