<?xml version="1.0" encoding="UTF-8" ?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Call Center and Store
(C) Copyright IBM Corp. 2010, 2011 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:output indent="yes" />
	<xsl:template match="/PrintJasper">
		<PrintJasper>

			<xsl:if test="element-available('UserInput')=true">
				<xsl:copy-of select="UserInput" />
			</xsl:if>
			<xsl:if test="element-available('Resource')=true">
				<xsl:copy-of select="Resource/child::node()" />
			</xsl:if>			
			
			<Order>

				<xsl:attribute name="ExpirationDate">
       <xsl:value-of select="/PrintJasper/Order/@ExpirationDate" />
    </xsl:attribute>

    <xsl:attribute name="Status">
       <xsl:value-of select="/PrintJasper/Order/@Status" />
    </xsl:attribute>
    <xsl:attribute name="CustomerFirstName">
       <xsl:value-of select="/PrintJasper/Order/@CustomerFirstName" />
    </xsl:attribute>
    <xsl:attribute name="CustomerLastName">
       <xsl:value-of select="/PrintJasper/Order/@CustomerLastName" />
    </xsl:attribute>
    
    <xsl:attribute name="LocaleCode">
       <xsl:value-of select="/PrintJasper/Order/@Localecode" />
    </xsl:attribute>
    
    
    <xsl:attribute name="RecommendedLineType">
       <xsl:value-of select="/PrintJasper/Order/@RecommendedLineType" />
    </xsl:attribute>
    <xsl:variable name="RecommendedLineType">
			<xsl:value-of select="/PrintJasper/Order/@RecommendedLineType" />
	</xsl:variable>
	
    <xsl:attribute name="BillToID">
       <xsl:value-of select="/PrintJasper/Order/@BillToID" />
    
    </xsl:attribute>
				<xsl:attribute name="OrderName">
       <xsl:value-of select="/PrintJasper/Order/@OrderName" />
    </xsl:attribute>

    <xsl:attribute name="OrderNo">
       <xsl:value-of select="/PrintJasper/Order/@OrderNo" />
    </xsl:attribute>

    <xsl:attribute name="ReqDeliveryDate">
       <xsl:value-of select="/PrintJasper/Order/@ReqDeliveryDate" />
    </xsl:attribute>

    <xsl:attribute name="LevelOfService">
       <xsl:value-of select="/PrintJasper/Order/@LevelOfService" />
    </xsl:attribute>
    <xsl:attribute name="TermsCode">
       <xsl:value-of select="/PrintJasper/Order/@TermsCode" />
    </xsl:attribute>

    <xsl:attribute name="SCAC">
       <xsl:value-of select="/PrintJasper/Order/@SCAC" />
    </xsl:attribute>
	
	<xsl:attribute name="InstructionText">
       <xsl:value-of
					select="/PrintJasper/Order/Instructions/Instruction/@InstructionText" />
    </xsl:attribute>
	
			<xsl:if test="element-available('ItemUOMMasterList')=true">
				<xsl:copy-of select="ItemUOMMasterList" />
			</xsl:if>

				<xsl:if
					test="element-available('Order/PriceInfo')=true">
					<xsl:copy-of select="Order/PriceInfo" />
				</xsl:if>

				<xsl:apply-templates select="/PrintJasper/Order"
					mode="Terms">
				</xsl:apply-templates>
				
				<xsl:apply-templates select="/PrintJasper/Order"
					mode="QuoteLines">
				</xsl:apply-templates>
				
				<xsl:apply-templates select="/PrintJasper/Order"
					mode="RecommendedLines">
			</xsl:apply-templates>
			
				<xsl:copy-of select="Order/OverallTotals" />
				<xsl:apply-templates
					select="/PrintJasper/Order/PersonInfoContact">
				</xsl:apply-templates>
				<xsl:apply-templates
					select="/PrintJasper/Order/PersonInfoShipTo">
				</xsl:apply-templates>
				<xsl:apply-templates
					select="/PrintJasper/Order/PersonInfoBillTo">
				</xsl:apply-templates>

			</Order>
			
		</PrintJasper>
	</xsl:template>

	<xsl:template match="Order" mode="Terms">
		<Terms>

			<xsl:attribute name="PaymentTerms">
       <xsl:value-of select="/PrintJasper/Order/@TermsCode" />
    </xsl:attribute>
			<xsl:attribute name="ShippngTerms">
       <xsl:value-of select="/PrintJasper/Order/@SCAC" />
    </xsl:attribute>

			<xsl:attribute name="LevelOfService">
       <xsl:value-of select="/PrintJasper/Order/@LevelOfService" />
    </xsl:attribute>

			<xsl:attribute name="DeliveryDate">
       <xsl:value-of select="/PrintJasper/Order/@ReqDeliveryDate" />
    </xsl:attribute>
	<xsl:attribute name="InstructionText">
       <xsl:value-of
					select="/PrintJasper/Order/Instructions/Instruction/@InstructionText" />
    </xsl:attribute>


		</Terms>

	</xsl:template>

	<xsl:template match="PersonInfoContact">
		<xsl:copy-of select="self::PersonInfoContact" />
	</xsl:template>
	
	<xsl:template match="PersonInfoBillTo">
		<xsl:copy-of select="self::PersonInfoBillTo" />
	</xsl:template>
	<xsl:template match="PersonInfoShipTo">
		<xsl:copy-of select="self::PersonInfoShipTo" />
	</xsl:template>

	<xsl:template match="Order/OverallTotals">
		<xsl:value-of select="@EMailID" />
	</xsl:template>

	<xsl:template match="Order" mode="RecommendedLines">
		<xsl:variable name="RecommendedLineType">
			<xsl:value-of select="@RecommendedLineType" />
	</xsl:variable>

		<RecommendedLines>
			<xsl:if
					test="''!=$RecommendedLineType">
				<xsl:for-each
				select="child::OrderLines/OrderLine[@LineType=$RecommendedLineType]">
				<xsl:copy-of select="self::OrderLine" />
			</xsl:for-each>
			</xsl:if>
			
		</RecommendedLines>
	</xsl:template>
	
	<xsl:template match="Order" mode="QuoteLines">
		<xsl:variable name="RecommendedLineType">
			<xsl:value-of select="@RecommendedLineType" />
		</xsl:variable>
		<OrderLines>
			<xsl:if
					test="''!=$RecommendedLineType">
					<NewElement/>
			<xsl:for-each
				select="child::OrderLines/OrderLine[not(@LineType=$RecommendedLineType)]">
				<xsl:copy-of select="self::OrderLine" />
			</xsl:for-each>
				</xsl:if>
				
			<xsl:if
					test="''=$RecommendedLineType">
					
			<xsl:for-each
				select="child::OrderLines/OrderLine">
				<xsl:copy-of select="self::OrderLine" />
			</xsl:for-each>
				</xsl:if>	
		</OrderLines>
	</xsl:template>
</xsl:stylesheet>
