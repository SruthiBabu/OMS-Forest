<?xml version="1.0" encoding="UTF-8"?>
<!-- Licensed Materials - Property of IBM IBM Sterling Selling and Fulfillment 
	Suite - Foundation (C) Copyright IBM Corp. 2007, 2016 All Rights Reserved. 
	US Government Users Restricted Rights - Use, duplication or disclosure restricted 
	by GSA ADP Schedule Contract with IBM Corp. -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:java="http://xml.apache.org/xslt/java" xmlns:fopUtil="com.yantra.pca.ycd.fop.YCDFOPUtils" exclude-result-prefixes="java">
	<xsl:import href="/template/prints/ycd/xsl/CommonTemplates_HTML.xsl" />
	<xsl:output method="html" encoding="UTF-8" indent="yes" />
	<xsl:variable name="ireport.scriptlethandling" select="2" />
	<xsl:variable name="ireport.encoding" select="UTF-8" />

	<xsl:variable name="locale">
		<xsl:value-of select="/MultiApi/API[@Name='getOrganizationHierarchy']/Output/Organization/@LocaleCode" />
	</xsl:variable>

	<xsl:variable name="prefixSymbol">
		<xsl:value-of select="/MultiApi/API[@Name='getCurrencyList']/Output/CurrencyList/Currency/@PrefixSymbol" />
	</xsl:variable>

	<xsl:variable name="postfixSymbol">
		<xsl:value-of select="/MultiApi/API[@Name='getCurrencyList']/Output/CurrencyList/Currency/@PostfixSymbol" />
	</xsl:variable>

	<xsl:variable name="ShipNodeDesc">
		<xsl:value-of select="/MultiApi/API[@Name='getShipNodeList']/Output/ShipNodeList/ShipNode/@Description" />
	</xsl:variable>
	
	<xsl:variable name="RuleValue">
		<xsl:value-of select="/MultiApi/API[@Name='getRuleDetails']/Output/Rules/@RuleSetValue" />
	</xsl:variable>

	<xsl:variable name="TotalLines">
		<xsl:value-of select="/MultiApi/API[@Name='getCompleteOrderDetails']/Output/Order/OrderLines/@TotalNumberOfRecords" />
	</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates select="/MultiApi" />
	</xsl:template>
	<xsl:template match="MultiApi">
		<html>
			<xsl:attribute name="lang">
				<xsl:value-of select="$locale" />
			</xsl:attribute>
			<body>
				<style>
					<xsl:text disable-output-escaping="yes">

						body {
							font-family: "HelvNeueRomanforIBM", Helvetica, Arial, Tahoma, Verdana, sans-serif;
							font-size: 12px;
							padding: 10px 0px;
							border: 1px solid #C7C7CC;
						}
				
						table {
							font-size: 12px;
						}
				
						div.page {
							width: 100%;
						}
						div.page:not(:last-child) {
							page-break-after: always;
						}
						div.already_printed, div.already_printed table {
							color: #666;
						}

						
						.storedetails {
							width: 100%;
						}
						.storedetails td {
							width: 50%;
						}
						.storedetails td:first-child{
							font-size: 40px;
							color: #C8C8F8;
						}
				
						.storedetails .storeaddress {
							float: right;
						}
				
						.storedetails .storeaddress .company {
							font-weight: bold;
						}
						
					
						.title {
							text-align: left;
							font-size: 25px;
							margin-bottom: 10px;
							background-color: #C8C8F8;
							padding: 2px 0px 2px 9px;
						}
						
						.header {
						    display: table;
						    width: 100%;
						}
						
						.header-col1 {
							display: table-cell;
							width: 40%;
							vertical-align: top;
						}

						.header-col2 {
							display: table-cell;
							width: 60%;
							vertical-align: top;
						}
										
						.headerinformation {
							width: 100%;
						}
				
						.headerinformation .headerrow > td {
							width: 50%;
							vertical-align: top;
						}
				
						.headerinformation .headerrow td+td table {
							float: right;
						}
				
						.headerinformation tr td table{
							width: 100%;
						}
				
						.headerinformation tr td table td:first-child{
							width:10em;
						}
				
						.addressheader th{
							background-color: C8C8F8;
							text-align: left;
							padding: 5px;
						}
						
						.addressdetails td {
							width: 50%;
							vertical-align: top;
						}
				
						.addressdetails td > div {
							padding: 1px 5px;
						}
				
						.addressdetails td div {
							padding-top:1px;
							padding-bottom: 1px;
						}
						
						.store-address {
							text-align: right;
						}
						
						.store-address .store-address-holder {
							float: right;
						}
						
						.store-address .store-address-header {
							display: table;
						    padding-top: 0px;
						    padding-bottom: 0px;							
						}
						
						.store-address .store-address-header .store-img , .store-address .store-address-header .header-font{
							display: table-cell;
						}
						.store-address .store-address-header .store-img {
							margin-right: 5px;
							height: 20px;
						}												
						
						.addressdetails {
							font-size: 14px;
						}
						
						.orderheader table {
							font-size: 16px;
						}
						
						.orderheader table tr td:first-child {
							font-weight: 500;
							padding-right: 20px;
							padding-left: 5px;
						}
				
						.orderheader .currentdate {
							vertical-align:top;
						}
				
						.orderheader .currentdate table{
							float: right;
						}
				
						.orderheader .addressheader {
							background-color: C8C8F8;
						}
				
						.orderheader .addressheader td{
							padding: 5px;
						}
				
						.orderheader table tr.addressdetails td{
							font-weight: normal;
						}
						
						table.shipmentlines {
							width: 100%;
							margin-top: 10px;
						}
				
						table.shipmentlines, table.shipmentlines th, table.shipmentlines td {
							border-collapse: collapse;
							padding: 2px 2px;
						    vertical-align: top;
						}
						
						table.shipmentlines > tbody > tr:first-child > td {
							padding-top: 10px;
						}

						table.shipmentlines > tbody > tr > td {
							padding-bottom: 10px;
						}						
				
						table.shipmentlines th {
							padding: 7px 3px;
							border-top: 1px solid #C7C7CC;
							border-bottom: 1px solid #C7C7CC;
							text-align: left;
							font-size: 14px;
    						font-weight: 500;							
						}
						
						table.shipmentlines > tbody > tr > td:first-child,
						table.shipmentlines th:first-child{
							padding-left: 20px;
						}						
						
						table.shipmentlines .image-holder {
							width: 50px;
						}
						
						table.shipmentlines .image-holder .giftIcon {
							position: absolute;
							top: 5px;
							right: 5px;							
						}

						table.shipmentlines .price-holder {
							width: 120px;
						}						
						table.shipmentlines .image-div {
							width: 60px;
							height: 60px;
							position: relative;
    						border: 1px solid #C7C7CC;
    						margin-top: 3px;
						}

						table.shipmentlines .image-div .product-image{
							width: 60px;
							height: 60px;
							//position: absolute;
							margin: auto;
							top: 0px;
							bottom: 0px;
							left: 0px;
							right: 0px;
						}

						table.innerLines, table.innerLines th, table.innerLines td {
							border:none;
							border-collapse: collapse;
							border-spacing: 0px;
							vertical-align: top;
						}
				
						table.innerLines th {
							padding: 5px 2px;
							background-color:#ffffff;
						}
						
						.header-font {
						    font-size: 16px;
						    font-weight: 500;
						}

						.product-default-font {
						    font-size: 14px;
						    font-weight: 500;
						}
						
						.ordertotal {
							padding-top: 10px;
							width: 100%;
							margin-right: 5px;
							border-top: 1px solid #C7C7CC;
							margin-top: 10px;						
						}
						
						.ordertotal .ordertotalholder {
							float: right;
							margin-right: 50px;
						}
						
						.ordertotal table {
						    width: 200px;
						}
						
						.ordertotal table tr {
							height: 20px;
						}

						.ordertotal table tr td:first-child {
							padding-right: 20px;
							padding-left: 5px;
							text-align: right;
						}
						.ordertotal table .header-row  {
							font-weight: bold;
						}

						.ordertotal .seperator-row {
							height: 0px;
						}

						.ordertotal .seperator-row .seperator{
							border-top: 1px solid #C7C7CC;
							margin: 5px 0px 5px 0px;
						}						
						
						.footer {
							padding-top: 10px;
							bottom:0px;
							text-align:center;
							position:absolute;
							width:100%;
				
						}
				</xsl:text>
				</style>
				<xsl:for-each select="API[(normalize-space(@Name) = &quot;getCompleteOrderDetails&quot;)]">
					<div class="page">
						<xsl:apply-templates select="Output/Order" />
						<xsl:apply-templates select="Output/Order/OrderLines" />
						<xsl:apply-templates select="Output/Order/OverallTotals" />
					</div>
				</xsl:for-each>


			</body>
		</html>
	</xsl:template>

	<xsl:template match="Order">

		<div class="title">
			<xsl:value-of select="fopUtil:getLocalizedString('ORDER SUMMARY',$locale)" />
		</div>
		<div class="header">
			<div class="header-col1">
				<table class="orderheader">
					<tr>
						<td>
							<table>
								<tr>
									<td>
										<xsl:value-of select="fopUtil:getLocalizedString('Order Number:',$locale)" />
									</td>
									<td>
										<xsl:value-of select="fopUtil:getDisplayOrderNo(@OrderNo)" />
									</td>
								</tr>

								<tr>
									<td>
										<span>
											<xsl:value-of select="OrderLines/@TotalNumberOfRecords" />
										</span>
										
										<xsl:choose>
										<xsl:when test="$TotalLines = '1'">
											<span>
												<xsl:value-of select="fopUtil:getLocalizedString('Product',$locale)" />
											</span>

										</xsl:when>
										<xsl:otherwise>
												<span>
													<xsl:value-of select="fopUtil:getLocalizedString('Products',$locale)" />
												</span>
										</xsl:otherwise>
									</xsl:choose>
										
									</td>
									<td>
									</td>
								</tr>
		
								<tr>
									<td>
										<xsl:value-of select="fopUtil:getLocalizedString('Order Total:',$locale)" />
									</td>
									<td>
										<xsl:value-of select="fopUtil:getFormattedCurrency(OverallTotals/@GrandTotal,$prefixSymbol,$postfixSymbol,$locale)" />
									</td>
								</tr>
								
								<tr>
									<td>
										<xsl:value-of select="fopUtil:getLocalizedString('Order Status:',$locale)" />
									</td>
									<td>
										<xsl:value-of select="@Status" />
									</td>
								</tr>
							</table>
						</td>
		
					</tr>
				</table>
			</div>
			<div class="header-col2">
				<table class="headerinformation">
					<tr class="headerrow">
						<td>
							<xsl:variable name="City">
								<xsl:if test="string-length(PersonInfoShipTo/@City)">
									<xsl:value-of select="concat(PersonInfoShipTo/@City,', ')" />
								</xsl:if>
							</xsl:variable>
							<xsl:variable name="State">
								<xsl:if test="string-length(PersonInfoShipTo/@State)">
									<xsl:value-of select="concat(PersonInfoShipTo/@State,', ')" />
								</xsl:if>
							</xsl:variable>
							<xsl:variable name="ZipCode" select="PersonInfoShipTo/@ZipCode" />
							<xsl:variable name="FormattedCityStateZipCode">
								<xsl:value-of select="concat($City, $State, $ZipCode)" />
							</xsl:variable>
		
							<xsl:variable name="shipNodeCity">
								<xsl:if test="string-length(ShipNodePersonInfo/@City)">
									<xsl:value-of select="concat(ShipNodePersonInfo/@City,', ')" />
								</xsl:if>
							</xsl:variable>
							<xsl:variable name="shipNodeState">
								<xsl:if test="string-length(ShipNodePersonInfo/@State)">
									<xsl:value-of select="concat(ShipNodePersonInfo/@State,', ')" />
								</xsl:if>
							</xsl:variable>
							<xsl:variable name="shipNodeZipCode" select="ShipNodePersonInfo/@ZipCode" />
							<xsl:variable name="FormattedBillToCityStateZipCodeForStore">
								<xsl:value-of select="concat($shipNodeCity,$shipNodeState,$shipNodeZipCode)" />
							</xsl:variable>
		
							<table>
		
								<tr class="addressdetails">
								
									<td>
										<image src="/wsc/ngstore/style/images/userSmall.png">
										</image>
									</td>
									<td>
										<div class="header-font">
											<xsl:value-of select="concat(@CustomerFirstName,' ',@CustomerLastName)" />
										</div>
										<div>
											<xsl:value-of select="PersonInfoShipTo/@Company" />
										</div>
										<div>
											<xsl:value-of select="PersonInfoShipTo/@AddressLine1" />
										</div>
										<div>
											<xsl:value-of select="PersonInfoShipTo/@AddressLine2" />
										</div>
										<div>
											<xsl:value-of select="$FormattedCityStateZipCode" />
										</div>
										<div>
											<xsl:value-of select="PersonInfoShipTo/@Country" />
										</div>
										<div>
											<xsl:value-of select="PersonInfoShipTo/@DayPhone" />
										</div>
										<div>
											<xsl:value-of select="PersonInfoShipTo/@EmailID" />
										</div>
									</td>
									<td class="store-address">

										<div class="store-address-holder">
											<div class="store-address-header">
												<image class="store-img" src="/wsc/ngstore/style/images/store_icon.png">
												</image>												
												<div class="header-font">
													<xsl:value-of select="$ShipNodeDesc" />
												</div>
											</div>
											<div>
												<xsl:value-of select="ShipNodePersonInfo/@AddressLine1" />
											</div>
											<div>
												<xsl:value-of select="ShipNodePersonInfo/@AddressLine2" />
											</div>
											<div>
												<xsl:value-of select="$FormattedBillToCityStateZipCodeForStore" />
											</div>
											<div>
												<xsl:value-of select="ShipNodePersonInfo/@Country" />
											</div>
											<div>
												<xsl:value-of select="ShipNodePersonInfo/@DayPhone" />
											</div>
											<div>
												<xsl:value-of select="ShipNodePersonInfo/@EmailID" />
											</div>
										</div>
									</td>
		
		
								</tr>
							</table>
						</td>
		
					</tr>
				</table>
			</div>
		</div>
	</xsl:template>


	<xsl:template match="OrderLines">
		<table class="shipmentlines">
			<thead>
				<tr>

					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('PRODUCT',$locale)" />
					</th>

					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('DESCRIPTION',$locale)" />
					</th>
					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('DELIVERY METHOD',$locale)" />
					</th>
					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('QUANTITY',$locale)" />
					</th>
					<th>
						<xsl:value-of select="fopUtil:getLocalizedString('PRICE',$locale)" />
					</th>

				</tr>
			</thead>
			<xsl:for-each select="OrderLine">

				<tr>

					<td class="image-holder">
						<div class="image-div">
							<image class="product-image">
								<xsl:attribute name="src">
									<xsl:value-of select="@ImageURL" />
								</xsl:attribute>
							</image>
							<xsl:if test="@GiftFlag = 'Y'">
								<image class="giftIcon" src="/wsc/ngstore/style/images/giftLine.png">
								</image>							
							</xsl:if>
						</div>						
					</td>

					<td>
						<table class="innerLines">
							<tr>
								<td class="header-font">
									<xsl:value-of select="ItemDetails/PrimaryInformation/@ExtendedDisplayDescription" />
								</td>
							</tr>

								<tr>
									<td>
										<xsl:value-of select="fopUtil:getLocalizedString('SKU:',$locale)" />
										<xsl:text>
										</xsl:text>
										<xsl:value-of select="ItemDetails/@ItemID" />
									</td>
								</tr>
								<tr>
									<td>
										<xsl:value-of select="@Variation" />
									</td>
								</tr>
						</table>
					</td>

					<td>
						<table class="innerLines">
							<xsl:variable name="delMethod" select="@DeliveryMethod" />
							<xsl:choose>
								<xsl:when test="$delMethod ='SHP'">
									<xsl:variable name="earliestShipDate" select="@IsEarliestShipDateToday" />
									<tr>
										<td class="product-default-font">
											<xsl:value-of select="fopUtil:getLocalizedString('Shipping',$locale)" />
										</td>
									</tr>
									<tr>
										<td class="product-default-font">
											<xsl:value-of select="@Status" />
										</td>
									</tr>
									<xsl:choose>
										<xsl:when test="$earliestShipDate ='Y'">

											<tr>
												<td>
													<xsl:value-of select="fopUtil:getLocalizedString('Within 24 hours',$locale)" />
												</td>
											</tr>


										</xsl:when>
										<xsl:otherwise>


											<tr>
												<td>
													<xsl:value-of select="fopUtil:getFormattedDate(@EarliestShipDate,$locale)" />
												</td>
											</tr>

										</xsl:otherwise>

									</xsl:choose>

									<xsl:variable name="City">
										<xsl:if test="string-length(PersonInfoShipTo/@City)">
											<xsl:value-of select="concat(PersonInfoShipTo/@City,', ')" />
										</xsl:if>
									</xsl:variable>
									<xsl:variable name="State">
										<xsl:if test="string-length(PersonInfoShipTo/@State)">
											<xsl:value-of select="concat(PersonInfoShipTo/@State,', ')" />
										</xsl:if>
									</xsl:variable>
									<xsl:variable name="ZipCode" select="PersonInfoShipTo/@ZipCode" />
									<xsl:variable name="FormattedCityStateZipCodeStore">
										<xsl:value-of select="concat($City, $State, $ZipCode)" />
									</xsl:variable>

									<tr>

										<td>
											<div>
												<xsl:value-of select="concat(PersonInfoShipTo/@FirstName,' ',PersonInfoShipTo/@LastName)" />
											</div>
											
											<div>
												<xsl:value-of select="$FormattedCityStateZipCodeStore" />
											</div>
											
										</td>

									</tr>


								</xsl:when>


								<xsl:when test="$delMethod ='PICK'">

									<tr>
										<td class="product-default-font">
											<xsl:value-of select="fopUtil:getLocalizedString('Pick Up',$locale)" />
										</td>
									</tr>
									<tr>
										<td class="product-default-font">
											<xsl:value-of select="@Status" />
										</td>
									</tr>

									<xsl:variable name="earliestPickDate" select="@IsReqShipDateToday" />

									<xsl:choose>
										<xsl:when test="$earliestPickDate ='Y'">

											<tr>
												<td>
													<xsl:value-of select="fopUtil:getLocalizedString('Today',$locale)" />
												</td>
											</tr>

										</xsl:when>
										<xsl:otherwise>

											<tr>
												<td>
													<xsl:value-of select="fopUtil:getFormattedDate(@ReqShipDate,$locale)" />
												</td>
											</tr>

										</xsl:otherwise>

									</xsl:choose>

									<xsl:variable name="City">
										<xsl:if test="string-length(Shipnode/ShipNodePersonInfo/@City)">
											<xsl:value-of select="concat(Shipnode/ShipNodePersonInfo/@City,', ')" />
										</xsl:if>
									</xsl:variable>
									
									<xsl:variable name="State">
										<xsl:if test="string-length(Shipnode/ShipNodePersonInfo/@State)">
											<xsl:value-of select="concat(Shipnode/ShipNodePersonInfo/@State,', ')" />
										</xsl:if>
									</xsl:variable>
									<xsl:variable name="ZipCode" select="Shipnode/ShipNodePersonInfo/@ZipCode" />
									<xsl:variable name="FormattedCityStateZipCodeStore">
										<xsl:value-of select="concat($City, $State, $ZipCode)" />
									</xsl:variable>
									
									<xsl:variable name="Name">
										<xsl:value-of select="concat(Shipnode/ShipNodePersonInfo/@FirstName,' ',Shipnode/ShipNodePersonInfo/@LastName)" />
									</xsl:variable>

									<tr>

										<td>
											
											<div>
												<xsl:value-of select="Shipnode/@Description" />
											</div>
											<div>
												<xsl:value-of select="$Name" />
											</div>
											<div>
												<xsl:value-of select="$FormattedCityStateZipCodeStore" />
											</div>
											
										</td>

									</tr>
								</xsl:when>
								<xsl:when test="$delMethod ='CARRY'">
									<tr>
										<td class="product-default-font">
											<xsl:value-of select="fopUtil:getLocalizedString('Carry',$locale)" />
										</td>
									</tr>
									<tr>
										<td class="product-default-font">
											<xsl:value-of select="@Status" />
										</td>
									</tr>
								</xsl:when>
							</xsl:choose>

						</table>
					</td>
					
					
					<td class="product-default-font">
						<xsl:variable name="uom" select="ItemDetails/@UnitOfMeasure" />
						<xsl:choose>
							<xsl:when test="$RuleValue !='H'">
								<xsl:value-of select="concat(fopUtil:getFormattedDouble(OrderLineTranQuantity/@OrderedQty,$locale),' ',/MultiApi/API[@Name='getItemUOMMasterList']/Output/ItemUOMMasterList/ItemUOMMaster[@UnitOfMeasure=$uom]/@Description)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="fopUtil:getFormattedDouble(OrderLineTranQuantity/@OrderedQty,$locale)" />
							</xsl:otherwise>
						</xsl:choose>
						
					</td>

					<td class="price-holder product-default-font">
						<xsl:variable name="listPrice" select="OrderLine/LinePriceInfo/@ListPrice" />
						<xsl:variable name="displayUnitPrice" select="OrderLine/LinePriceInfo/@DisplayUnitPrice" />
						<xsl:choose>
							<xsl:when test="not($listPrice = $displayUnitPrice)">
								<xsl:value-of select="fopUtil:getFormattedCurrency(LinePriceInfo/@DisplayUnitPrice,$prefixSymbol,$postfixSymbol,$locale)" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="fopUtil:getFormattedCurrency(LinePriceInfo/@ListPrice,$prefixSymbol,$postfixSymbol,$locale)" />
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>



	<xsl:template match="OverallTotals">

		<table class="ordertotal">
			<tr>
				<td>
					<div class="ordertotalholder">
						<table>
							<tr class="header-row">
								<td>
									<xsl:value-of select="fopUtil:getLocalizedString('Order Total',$locale)" />
								</td>
								<td>
									<xsl:value-of select="fopUtil:getFormattedCurrency(@GrandTotal,$prefixSymbol,$postfixSymbol,$locale)" />
								</td>
							</tr>
							<tr class="header-row">
								<td>
									<span>
										<xsl:value-of select="$TotalLines" />
									</span>
									
									<xsl:choose>
										<xsl:when test="$TotalLines = '1'">
											<span>
												<xsl:value-of select="fopUtil:getLocalizedString('Product',$locale)" />
											</span>

										</xsl:when>
										<xsl:otherwise>
												<span>
													<xsl:value-of select="fopUtil:getLocalizedString('Products',$locale)" />
												</span>
										</xsl:otherwise>
									</xsl:choose>
									
								</td>
								<td>
									<xsl:value-of select="fopUtil:getFormattedCurrency(@LineSubTotal,$prefixSymbol,$postfixSymbol,$locale)" />
								</td>
							</tr>
							<tr class="seperator-row">
								<td  colspan="2">
									<div class="seperator"></div>
								</td>
							</tr>
							
							<tr>
								<td>
									<xsl:value-of select="fopUtil:getLocalizedString('Charges',$locale)" />
								</td>
								<td>
									<xsl:value-of select="fopUtil:getFormattedCurrency(@GrandShippingTotal,$prefixSymbol,$postfixSymbol,$locale)" />
								</td>
							</tr>
							<tr>
								<td>
									<xsl:value-of select="fopUtil:getLocalizedString('Tax',$locale)" />
								</td>
								<td>
									<xsl:value-of select="fopUtil:getFormattedCurrency(@GrandTax,$prefixSymbol,$postfixSymbol,$locale)" />
								</td>
							</tr>
							<tr class="seperator-row">
								<td  colspan="2">
									<div class="seperator"></div>
								</td>
							</tr>
							<tr>
								<td>
									<xsl:value-of select="fopUtil:getLocalizedString('Discounts:',$locale)" />
								</td>
								<td>
									<xsl:value-of select="fopUtil:getFormattedCurrency(@GrandDiscount,$prefixSymbol,$postfixSymbol,$locale)" />
								</td>
							</tr>
						</table>
					</div>
				</td>

			</tr>
		</table>
	</xsl:template>




</xsl:stylesheet>
