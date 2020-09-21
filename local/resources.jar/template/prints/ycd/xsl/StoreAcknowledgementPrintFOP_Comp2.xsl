<?xml version="1.0" encoding="utf-8"?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Selling and Fulfillment Suite - Foundation
(C) Copyright IBM Corp. 2007, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:fopUtil="com.yantra.pca.ycd.fop.YCDFOPUtils"
	exclude-result-prefixes="java" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:import href="/template/prints/ycd/xsl/CommonTemplates_FOP.xsl"/>
	<xsl:output method="xml" indent="yes" />
 	<xsl:variable name="ireport.scriptlethandling" select="2"/>
	<xsl:variable name="ireport.encoding" select="UTF-8"/>
	<xsl:variable name="DelMethodShip">SHP</xsl:variable>
	<xsl:variable name="DelMethodPick">PICK</xsl:variable>
	<xsl:variable name="DelMethodDel">DEL</xsl:variable>

 	<xsl:variable name="locale">
		<xsl:value-of select="/MultiApi/API[@Name='getUserHierarchy']/Output/User/@Localecode" />
	</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates select="/MultiApi" />
	</xsl:template>
	<xsl:template match="MultiApi">
		<fo:root>
			<fo:layout-master-set>
				<xsl:call-template name="A4-landscape_layout-master-set" />
			</fo:layout-master-set>
			<fo:page-sequence master-reference="A4-landscape">
			<!--Page Footer -->
				<xsl:call-template name="orderFooterForWebStore"/>
				<fo:flow flow-name="xsl-region-body" font-family="Arial">
					<fo:block>
						<xsl:for-each select="API[(normalize-space(@Name) = &quot;getSortedShipmentDetails&quot;)]">
							<xsl:apply-templates select="Output/Shipment">
							 <xsl:with-param name="islast" select="position()=last()" />
							</xsl:apply-templates>
						</xsl:for-each>
					</fo:block>
					<fo:block id="last-page"/>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<xsl:template match="Shipment">
	    <xsl:param name="islast" /> 
		<xsl:apply-templates select="ShipNode" />
		<xsl:call-template name="addEmptyBlock" />
		<xsl:variable name="Instruction" select="Instructions/Instruction/@InstructionText" />
		<xsl:variable name="City" select="ToAddress/@City" />
		<xsl:variable name="State" select="ToAddress/@State" />
		<xsl:variable name="ShortZipCode" select="ToAddress/@ShortZipCode" />
		<xsl:variable name="FormattedCityStateZipCodeStore">
		    <xsl:value-of select="concat($City,',' ,$State,',', $ShortZipCode)" />
		</xsl:variable>
		

		<!-- table 2: Order header details table starts -->
		<fo:table table-layout="fixed" width="100%" font-size="12pt">
			<fo:table-column column-width="35%" />
			<fo:table-column column-width="35%" />
			<fo:table-column column-width="30%" />
			
			<fo:table-body>
					<!-- table2 cell1: Order header - customer details table starts -->
					<fo:table-cell>
						<fo:table border-width="0mm" font-size="12pt" table-layout="fixed" width="100%">
							<fo:table-column column-width="50%"/>
							<fo:table-column column-width="50%"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell border-width=".10pt" padding="1mm">
										<fo:block font-weight="bold" text-align="left">
											<xsl:value-of select="fopUtil:getLocalizedString('Shipment #',$locale)" />
										</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width=".10pt" padding="1mm">
										<fo:block text-align="left">
											<xsl:value-of select="@ShipmentNo" />
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row>
									<fo:table-cell border-width=".10pt" padding="1mm">
										<fo:block font-weight="bold" text-align="left">
											<xsl:value-of select="fopUtil:getLocalizedString('Pickup Date',$locale)" />
										</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width=".10pt" padding="1mm">
										<fo:block text-align="left">											
											<xsl:value-of select="fopUtil:getCurrentDate($locale,'true')" />
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<fo:table width="100%">
												<fo:table-column column-width="100%"/>
												<fo:table-body>
													<fo:table-row>
														<fo:table-cell>
															<fo:block linefeed-treatment="preserve" white-space-treatment="preserve">  
															</fo:block>
														</fo:table-cell>
													</fo:table-row>
												</fo:table-body>
											</fo:table>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:table-cell>
					<!-- table2 cell1: Order header - customer details table ends -->

					<!-- table2 cell2: Order Header - order number and date table starts -->
					
					<fo:table-cell text-align="center">
								<fo:block linefeed-treatment="preserve"/>
					</fo:table-cell>
					
					<fo:table-cell>
						<fo:table border-width="0mm" font-size="12pt" table-layout="fixed" width="100%">
							<fo:table-column column-width="50%"/>
							<fo:table-column column-width="50%"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell border-width=".15pt" padding="1mm">
										<fo:block text-align="right" font-weight="bold">
											<xsl:value-of select="fopUtil:getLocalizedString('Customer Name',$locale)" />
										</fo:block>
									</fo:table-cell>
									<fo:table-cell border-width=".15pt" padding="1mm">
										<fo:block text-align="left" >
											<xsl:value-of select="concat(ToAddress/@FirstName,' ',ToAddress/@LastName)"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:table-cell>
			</fo:table-body>
		</fo:table>
		<!-- table 2: Order header details table ends -->
		<xsl:apply-templates select="ShipmentLines" />
		<xsl:if test="$islast!='true'" >
		 <fo:block break-before="page"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ShipNode">
		<!-- Ship node information -->
		<xsl:variable name="StoreName" select="@Description">
		</xsl:variable>
		<xsl:variable name="Company" select="ShipNodePersonInfo/@Company">
		</xsl:variable>
		<xsl:variable name="StoreAddress" select="ShipNodePersonInfo/@AddressLine1">
		</xsl:variable>
		<xsl:variable name="StoreAddress1" select="ShipNodePersonInfo/@AddressLine2">
		</xsl:variable>
		<xsl:variable name="StoreCity" select="ShipNodePersonInfo/@City">
		</xsl:variable>
		<xsl:variable name="StoreState" select="ShipNodePersonInfo/@State">
		</xsl:variable>
		<xsl:variable name="StoreZipCode" select="ShipNodePersonInfo/@ZipCode">
		</xsl:variable>
		<xsl:variable name="StorePhone" select="ShipNodePersonInfo/@DayPhone">
		</xsl:variable>
		<xsl:variable name="EmailId" select="ShipNodePersonInfo/@EMailID">
		</xsl:variable>
		<xsl:variable name="FormattedCityStateZipCodeStore">
			<xsl:value-of select="concat($StoreCity,',' ,$StoreState,',', $StoreZipCode)" />
		</xsl:variable>
		<fo:table table-layout="fixed" border-width="0mm" width="100%">
			<fo:table-column column-width="proportional-column-width(1)" />
			<fo:table-column />
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell padding="2mm">
						<fo:block font-size="40pt" font-family="Arial" color="#CCCCFF" text-align-last="left">
						</fo:block>
					</fo:table-cell>
					<fo:table-cell text-align-last="right">
						<fo:block font-size="12pt" background-color="White">
							<fo:table table-layout="fixed" width="100%">
								<fo:table-column column-width="proportional-column-width(1)" />
								<fo:table-column />
								<fo:table-body>
									<fo:table-row>
										<fo:table-cell font-size="14pt" border-width=".15pt" column-number="2">
											<fo:block font-weight="bold" text-align-last="right">
												<xsl:value-of select="$StoreName" />
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell border-width=".15pt" column-number="2">
											<fo:block text-align-last="right">
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell border-width=".15pt" column-number="2">
											<fo:block text-align-last="right">
												<xsl:value-of select="$StoreAddress" />
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell border-width=".15pt" column-number="2">
											<fo:block text-align-last="right">
												<xsl:value-of select="$StoreAddress1" />
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell border-width=".15pt" column-number="2">
											<fo:block text-align-last="right">
												<xsl:value-of select="$FormattedCityStateZipCodeStore" />
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell border-width=".15pt" column-number="2">
											<fo:block text-align-last="right">
												<xsl:value-of select="$StorePhone" />
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell border-width=".15pt" column-number="2">
											<fo:block text-align-last="right">
												<xsl:value-of select="$EmailId" />
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
		<fo:table table-layout="fixed" border-width="0mm" width="100%">
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell>
						<fo:block font-family="Arial" text-align="center" font-size="20pt" font-weight="bold"
							space-before="100mm" text-align-last="center">
							<xsl:value-of select="fopUtil:getLocalizedString('STORE ACKNOWLEDGEMENT',$locale)" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
		<!-- End Ship node information -->
	</xsl:template>
	
	<!--Page Structure -->
	<xsl:template match="ShipmentLines">
		<xsl:call-template name="addEmptyBlock" />
		<!-- table 3: Order line details table Starts -->
		<fo:table border-width=".5mm" border-style="solid" border-color="black" width="95%" font-size="12pt">
			<fo:table-column column-width="5%"/>
			<fo:table-column column-width="15%"/>
			<fo:table-column column-width="15%"/>
			<fo:table-column column-width="31%"/>
			<fo:table-column column-width="12%"/>
			<fo:table-column column-width="10%"/>
			<fo:table-column column-width="12%"/>
			<fo:table-body>
				<fo:table-row background-color="#CCCCFF">
					<fo:table-cell border-width=".2mm" border-style="solid" border-color="black" text-align="center">
						<fo:block>
							<xsl:value-of select="fopUtil:getLocalizedString('Sl. No',$locale)" />
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="1mm" border-width=".10pt">
						<fo:block font-weight="bold" text-align="left">
							<xsl:value-of select="fopUtil:getLocalizedString('Order #',$locale)" />
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-width=".2mm" border-style="solid" border-color="black" text-align="center">
						<fo:block>
							<xsl:value-of select="fopUtil:getLocalizedString('Item ID',$locale)" />
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-width=".2mm" border-style="solid" border-color="black" text-align="center">
						<fo:block>
							<xsl:value-of select="fopUtil:getLocalizedString('Item Description',$locale)" />
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-width=".2mm" border-style="solid" border-color="black" text-align="center">
						<fo:block>
							<xsl:value-of select="fopUtil:getLocalizedString('Quantity',$locale)" />
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-width=".2mm" border-style="solid" border-color="black" text-align="center">
						<fo:block>
							<xsl:value-of select="fopUtil:getLocalizedString('UOM',$locale)" />
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-width=".2mm" border-style="solid" border-color="black" text-align="center">
						<fo:block>
							<xsl:value-of select="fopUtil:getLocalizedString('Price',$locale)" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="ShipmentLine">
				    <xsl:variable name="lineqty" select="@Quantity">
		            </xsl:variable>
				    <xsl:if test="$lineqty &gt; 0">
					    <fo:table-row border-style="solid" border-width=".5pt" border-color="black">
						<xsl:variable name="i" select="position()" />
						<fo:table-cell padding="1mm" border-width=".2mm" border-style="solid" border-color="black">
							<fo:block>
								<xsl:value-of select="$i" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding="1mm" border-width=".2mm" border-style="solid" border-color="black">
							<xsl:variable name="orderNo" select="@OrderNo" />
							<fo:block text-align="left">
								<xsl:value-of select="fopUtil:handleWordWrap($orderNo,$locale,'20')" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding="1mm" border-width=".2mm" border-style="solid" border-color="black">
							<xsl:variable name="itemID" select="@ItemID" />
							<fo:block text-align="left">
								<xsl:value-of select="fopUtil:handleWordWrap($itemID,$locale,'20')" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding="1mm" border-width=".2mm" border-style="solid" border-color="black">
							<fo:block>
								<xsl:value-of select="@ItemDesc" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding="1mm" border-width=".2mm" border-style="solid" border-color="black">
							<xsl:variable name="lineQty" select="@Quantity" />
							<fo:block text-align="right">
								<xsl:value-of select="fopUtil:getFormattedDouble($lineQty,$locale)" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding="1mm" border-width=".2mm" border-style="solid" border-color="black">
							<xsl:variable name="lineUOM" select="@UnitOfMeasure" />
							<fo:block>
								<xsl:value-of select="/MultiApi/API[@Name='getItemUOMMasterList']/Output/ItemUOMMasterList/ItemUOMMaster[@UnitOfMeasure=$lineUOM]/@Description" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding="1mm" border-width=".2mm" border-style="solid" border-color="black">
							<xsl:variable name="price" select="OrderLine/LinePriceInfo/@UnitPrice" />
							<xsl:variable name="postFixSymbol" select="/MultiApi/API[@Name='getCurrencyList']/Output/CurrencyList/Currency/@PostfixSymbol" />
							<xsl:variable name="preFixSymbol" select="/MultiApi/API[@Name='getCurrencyList']/Output/CurrencyList/Currency/@PrefixSymbol" />
							<fo:block text-align="right">
								<xsl:value-of select="fopUtil:getFormattedCurrency($price,$preFixSymbol,$postFixSymbol,$locale)" />
							</fo:block>
						</fo:table-cell>
					    </fo:table-row>
				    </xsl:if>	
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
		<!-- table 3: Order line details table ends -->
	</xsl:template>
</xsl:stylesheet>
