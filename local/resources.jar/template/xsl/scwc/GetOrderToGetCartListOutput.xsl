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
	xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order"
	xmlns="http://www.sterlingcommerce.com/documentation/YFS/createOrder/input"
	xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	extension-element-prefixes="ValueMaps"
	exclude-result-prefixes="xalan mm _wcf _ord" version="1.0">

	<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"
		indent="no" />
	<xsl:strip-space elements="*" />
	<xsl:param name="scwc:ValueMapsData" />

        <xsl:template match="/Errors">
		<xsl:copy-of select="/Errors"/>
  	</xsl:template>

	<xsl:template name="GetOrderToGetCartListOutput" match="/_ord:ShowOrder">
	<xsl:variable name="order"
					select="/_ord:ShowOrder/_ord:DataArea/_ord:Order" />
		<CartList>
			<xsl:for-each
				select="$order">
				
				<xsl:variable name="isLocked"
					select="_ord:OrderStatus/@locked" />

				<xsl:variable name="storeId">
					<xsl:value-of
						select="_ord:StoreIdentifier/_wcf:UniqueID/text()" />
				</xsl:variable>
				<xsl:variable name="OrganizationCode">
					<xsl:value-of
						select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $storeId)" />
				</xsl:variable>

				<Cart>
					<xsl:attribute name="CartId">
				<xsl:value-of
							select="_ord:OrderIdentifier/_wcf:UniqueID/text()" />
				</xsl:attribute>
				<xsl:attribute name="OrganizationCode">
				<xsl:value-of
							select="$OrganizationCode" />
				</xsl:attribute>
				<xsl:attribute name="OrderDate">
					<xsl:value-of select="_ord:LastUpdateDate" />
				</xsl:attribute>
					<xsl:attribute name="TotalAmount">
					<xsl:value-of
							select="_ord:OrderAmount/_wcf:GrandTotal" />
				</xsl:attribute>
					<xsl:attribute name="Currency">
				<xsl:variable name="currencyToCurrencyName"
							select="_ord:OrderAmount/_wcf:GrandTotal/@currency" />
				<xsl:variable name="sccurrencyToCurrencyName">
					<xsl:value-of
								select="ValueMaps:getMapValue($scwc:ValueMapsData, '', 'scCurrencyToWcCurency', $currencyToCurrencyName)" />
				</xsl:variable>
				<xsl:choose>
					<xsl:when
								test="string-length(normalize-space($sccurrencyToCurrencyName)) &gt; 0">
						<xsl:value-of
									select="$sccurrencyToCurrencyName" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$currencyToCurrencyName" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
					<xsl:attribute name="IsCartLocked">
						<xsl:choose>
				<xsl:when test="$isLocked = 'true'">
					<xsl:text>Y</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>N</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
					<Address>
						<xsl:variable name="ShippingAddress"
							select="_ord:OrderShippingInfo/_ord:ShippingAddress" />
						<xsl:attribute name="FirstName">
								<xsl:value-of
								select="$ShippingAddress/_wcf:ContactName/_wcf:FirstName" />
							</xsl:attribute>
						<xsl:attribute name="LastName">
								<xsl:value-of
								select="$ShippingAddress/_wcf:ContactName/_wcf:LastName" />
							</xsl:attribute>
						<xsl:attribute name="AddressLine1">
								<xsl:value-of
								select="$ShippingAddress/_wcf:Address/_wcf:AddressLine[1]" />
							</xsl:attribute>
						<xsl:attribute name="AddressLine2">
								<xsl:value-of
								select="$ShippingAddress/_wcf:Address/_wcf:AddressLine[2]" />
							</xsl:attribute>							
						<xsl:attribute name="City">
								<xsl:value-of
								select="$ShippingAddress/_wcf:Address/_wcf:City" />
							</xsl:attribute>
						<xsl:attribute name="State">
								<xsl:value-of
								select="$ShippingAddress/_wcf:Address/_wcf:StateOrProvinceName" />
							</xsl:attribute>
						<xsl:attribute name="Country">
								<xsl:value-of
								select="$ShippingAddress/_wcf:Address/_wcf:Country" />
							</xsl:attribute>
						<xsl:attribute name="ZipCode">
								<xsl:value-of
								select="$ShippingAddress/_wcf:Address/_wcf:PostalCode" />
							</xsl:attribute>
						<xsl:attribute name="EMailID">
								<xsl:value-of
								select="$ShippingAddress/_wcf:EmailAddress1/_wcf:Value" />
							</xsl:attribute>
						<!-- FEP5 and FEP3 enhancement -->
						<xsl:attribute name="DayPhone">
								<xsl:value-of
								select="$ShippingAddress/_wcf:Telephone1/_wcf:Value" />
							</xsl:attribute>						
						<xsl:attribute name="AddressID">
								<xsl:value-of
								select="$ShippingAddress/_wcf:ContactInfoIdentifier/_wcf:ExternalIdentifier/_wcf:ContactInfoNickName" />
							</xsl:attribute>
					</Address>
				</Cart>
			</xsl:for-each>
		</CartList>
	</xsl:template>

</xsl:stylesheet>
