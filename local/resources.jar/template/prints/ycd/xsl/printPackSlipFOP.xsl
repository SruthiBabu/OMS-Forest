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
	<xsl:import href="/template/prints/ycd/xsl/CommonTemplates_FOP.xsl"/>
	<xsl:output method="xml" indent="yes" />


	<!-- This template accepts multi api with getSortedShipmentDetails	 api out put  -->
	<xsl:variable name="locale">
		<xsl:value-of select="/MultiApi/API[@Name='getUserHierarchy']/Output/User/@Localecode" />
	</xsl:variable>

	<xsl:variable name="locale">en_US_EST</xsl:variable>
	<xsl:template match="/">
	<fo:root>
			<fo:layout-master-set>
				<xsl:call-template name="A4-landscape_layout-master-set" />
			</fo:layout-master-set>
			<fo:page-sequence master-reference="A4-landscape">
		
				<xsl:call-template name="orderFooter"/>

				<fo:flow flow-name="xsl-region-body"
					font-family="Arial">
					<xsl:apply-templates select="/MultiApi" />
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<xsl:template match="MultiApi">
		<xsl:for-each
			select="API[(normalize-space(@Name) = &quot;getSortedShipmentDetails&quot;)]">
			<xsl:apply-templates select="Output/Shipment" />
		</xsl:for-each>
		<fo:block id="last-page"/>

	</xsl:template>

	<xsl:template match="Shipment">
		<xsl:apply-templates select="ShipNode" />
		<xsl:call-template name="addEmptyBlock" />
		<xsl:call-template name="formatAddress" />
		<!--<xsl:call-template name="CarrierInfo" />-->
		<xsl:call-template name="addEmptyBlock" />
		<xsl:apply-templates select="Instructions" />
		<xsl:call-template name="addEmptyBlock" />
		<xsl:apply-templates select="ShipmentLines" />
	</xsl:template>


	<xsl:template match="ShipNode">
		<!-- Ship node information -->
		<xsl:variable name="StoreName" select="@Description">
		</xsl:variable>
		<xsl:variable name="StoreAddress"
			select="ShipNodePersonInfo/@AddressLine1">
		</xsl:variable>
		<xsl:variable name="StoreCity"
			select="ShipNodePersonInfo/@City">
		</xsl:variable>
		<xsl:variable name="StoreState"
			select="ShipNodePersonInfo/@State">
		</xsl:variable>
		<xsl:variable name="StoreZipCode"
			select="ShipNodePersonInfo/@ZipCode">
		</xsl:variable>
		<xsl:variable name="StorePhone"
			select="ShipNodePersonInfo/@DayPhone">
		</xsl:variable>
		<xsl:variable name="FormattedCityStateZipCodeStore">
			<xsl:value-of
				select="concat($StoreCity,',' ,$StoreState,',', $StoreZipCode)" />
		</xsl:variable>
		<xsl:variable name="StoreEmailID"
			select="ShipNodePersonInfo/@EMailID">
		</xsl:variable>

		<xsl:variable name="ShipmentDate"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/@ExpectedShipmentDate" />
		<xsl:variable name="ShipmentNo"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/@ShipmentNo" />

		<xsl:variable name="FreightTerm"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/@FreightTerms" />
		<xsl:variable name="Carrier"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/@SCAC" />

		<fo:table background-color="White" table-layout="fixed"
			border-style="solid" border-width="0mm" width="100%">
			<fo:table-column column-width="100%" />
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell>
						<fo:block font-family="Arial"
							text-align="center" font-size="20pt" font-weight="bold"
							space-before="100mm" text-align-last="center">
							<xsl:value-of
													select="fopUtil:getLocalizedString('PACKING SLIP',$locale)" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>



		<fo:table table-layout="fixed" border-width="0mm"
			border-style="solid" width="100%">
			<fo:table-column column-width="35%" />
			<fo:table-column column-width="30%" />
			<fo:table-column column-width="35%" />

			<fo:table-body>
				<!-- first row ship from label -->
				<fo:table-row>
					<fo:table-cell padding="1mm"
						background-color="#CCCCFF" starts-row="true">
						<fo:block font-weight="bold">
							<xsl:value-of
								select="fopUtil:getLocalizedString('Ship From ',$locale)" />
						</fo:block>
					</fo:table-cell>

					<fo:table-cell empty-cells="hide">
						<fo:block />
					</fo:table-cell>

					<fo:table-cell padding="1mm">
						<fo:block text-align="justify">
							<fo:table table-layout="fixed"
								border-width="0mm" width="100%">
								<fo:table-body>
									<!--1st row -->
									<fo:table-row>
										<fo:table-cell padding="1mm"
											border-width=".15pt">
											<fo:block
												text-align="left">
												<xsl:value-of
													select="fopUtil:getLocalizedString('Date :',$locale)" />
											</fo:block>
										</fo:table-cell>
										<fo:table-cell padding="1mm"
											border-width=".15pt">
											<fo:block
												text-align="left">
												<xsl:value-of
													select="fopUtil:getCurrentDate($locale,'true')" />
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>

				<!-- second row -->
				<fo:table-row>
					<fo:table-cell padding="1mm">
						<fo:block text-align="justify">
							<fo:list-block>
								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$StoreName" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$StoreAddress" />
										</fo:block>

									</fo:list-item-body>
								</fo:list-item>
								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$FormattedCityStateZipCodeStore" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>

								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$StorePhone" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$StoreEmailID" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
							</fo:list-block>
						</fo:block>
					</fo:table-cell>

					<fo:table-cell empty-cells="hide">
						<fo:block />
					</fo:table-cell>

					<fo:table-cell padding="1mm">
						<fo:block text-align="justify">
							<fo:table table-layout="fixed"
								border-width="0mm" width="100%">
								<fo:table-body>
									<!--1st row -->
									<fo:table-row>
										<fo:table-cell padding="1mm"
											border-width=".15pt">
											<fo:block
												text-align="left">
												<xsl:value-of
													select="fopUtil:getLocalizedString('Carrier :',$locale)" />
											</fo:block>
										</fo:table-cell>
										<fo:table-cell padding="1mm"
											border-width=".15pt">
											<fo:block
												text-align="left">
												<xsl:value-of
													select="$Carrier" />
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell padding="1mm"
											border-width=".15pt">
											<fo:block
												text-align="left">
												<xsl:value-of
													select="fopUtil:getLocalizedString('Freight Terms :',$locale)" />
											</fo:block>
										</fo:table-cell>
										<fo:table-cell padding="1mm"
											border-width=".15pt">
											<fo:block
												text-align="left">
												<xsl:value-of
													select="$FreightTerm" />
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
									<fo:table-row>
										<fo:table-cell padding="1mm"
											border-width=".15pt">
											<fo:block
												text-align="left">
												<xsl:value-of
													select="fopUtil:getLocalizedString('Shipment No:',$locale)" />
											</fo:block>
										</fo:table-cell>
										<fo:table-cell padding="1mm"
											border-width=".15pt">
											<fo:block
												text-align="left">
												<xsl:value-of
													select="$ShipmentNo" />
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
	</xsl:template>
	<!-- End Ship node information -->

	<xsl:template name="formatAddress">

		<!--  Bill to address  info -->
		<xsl:variable name="billtocustFirstName"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/BillToAddress/@FirstName">
		</xsl:variable>
		<xsl:variable name="billtocustLastName"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/BillToAddress/@LastName">
		</xsl:variable>
		<xsl:variable name="billtoCustAddress"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/BillToAddress/@AddressLine1">
		</xsl:variable>
		<xsl:variable name="billtoCustCity"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/BillToAddress/@City">
		</xsl:variable>
		<xsl:variable name="billtoCustState"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/BillToAddress/@State">
		</xsl:variable>
		<xsl:variable name="billtoCustZipCode"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/BillToAddress/@ZipCode">
		</xsl:variable>
		<xsl:variable name="billtoCustPhone"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/BillToAddress/@DayPhone">
		</xsl:variable>
		<xsl:variable name="billtoCustEmailID"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/BillToAddress/@EMailID">
		</xsl:variable>
		<xsl:variable name="FormattedBillToCityStateZipCode">
			<xsl:value-of
				select="concat($billtoCustCity,',' ,$billtoCustState,',', $billtoCustZipCode)" />
		</xsl:variable>

		<xsl:variable name="custFirstName"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/ToAddress/@FirstName">
		</xsl:variable>
		<xsl:variable name="custLastName"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/ToAddress/@LastName">
		</xsl:variable>
		<xsl:variable name="CustAddress"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/ToAddress/@AddressLine1">
		</xsl:variable>
		<xsl:variable name="CustCity"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/ToAddress/@City">
		</xsl:variable>
		<xsl:variable name="CustState"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/ToAddress/@State">
		</xsl:variable>
		<xsl:variable name="CustZipCode"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/ToAddress/@ZipCode">
		</xsl:variable>
		<xsl:variable name="CustPhone"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/ToAddress/@DayPhone">
		</xsl:variable>
		<xsl:variable name="CustEmailID"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/ToAddress/@EmailID">
		</xsl:variable>
		<xsl:variable name="FormattedCustCityStateZipCode">
			<xsl:value-of
				select="concat($CustCity,',' ,$CustState,',', $CustZipCode)" />
		</xsl:variable>
		<xsl:variable name="FreightTerm"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/@FreightTerms" />
		<xsl:variable name="Carrier"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/@SCAC" />
		<xsl:variable name="ShipmentDate"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/@ExpectedShipmentDate" />
		<fo:table table-layout="fixed" border-width="0mm"
			border-style="solid" width="100%" font-family="Arial">
			<fo:table-column column-width="35%" />
			<fo:table-column column-width="30%" />
			<fo:table-column column-width="35%" />
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell padding="1mm"
						background-color="#CCCCFF" starts-row="true">
						<fo:block font-weight="bold">
							<xsl:value-of
								select="fopUtil:getLocalizedString('Ship To ',$locale)" />
						</fo:block>
					</fo:table-cell>

					<fo:table-cell empty-cells="hide">
						<fo:block />
					</fo:table-cell>

					<fo:table-cell padding="1mm" ends-row="true"
						background-color="#CCCCFF">
						<fo:block font-weight="bold">
							<xsl:value-of
								select="fopUtil:getLocalizedString('Bill To ',$locale)" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>

				<fo:table-row>

					<fo:table-cell padding="1mm">
						<fo:block text-align="justify">
							<fo:list-block>

								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="concat($custFirstName, ' ', $custLastName)" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$CustAddress" />
										</fo:block>

									</fo:list-item-body>
								</fo:list-item>
								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$FormattedCustCityStateZipCode" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>

								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$CustPhone" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$CustEmailID" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
							</fo:list-block>
						</fo:block>
					</fo:table-cell>


					<fo:table-cell empty-cells="hide">
						<fo:block />
					</fo:table-cell>



					<fo:table-cell padding="1mm">
						<fo:block text-align="justify">
							<fo:list-block>

								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="concat($billtocustFirstName, ' ', $billtocustLastName)" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>

								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$billtoCustAddress" />
										</fo:block>

									</fo:list-item-body>
								</fo:list-item>

								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$FormattedBillToCityStateZipCode" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>

								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$billtoCustPhone" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
								<fo:list-item>
									<fo:list-item-label>
										<fo:block />
									</fo:list-item-label>
									<fo:list-item-body>
										<fo:block>
											<xsl:value-of
												select="$billtoCustEmailID" />
										</fo:block>
									</fo:list-item-body>
								</fo:list-item>
							</fo:list-block>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template name="CarrierInfo">

		<xsl:variable name="FreightTerm"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/@FreightTerms" />
		<xsl:variable name="Carrier"
			select="/MultiApi/API[@Name='getSortedShipmentDetails']/Output/Shipment/@SCAC" />

		<fo:table table-layout="fixed" border-width="0.5mm"
			border-color="black" border-style="solid" width="100%">
			<fo:table-column column-width="10%" />
			<fo:table-column column-width="90%" />

			<fo:table-body>
				<!--1st row -->
				<fo:table-row>
					<fo:table-cell padding="1mm" border-width=".15pt">
						<fo:block text-align="left">
							<xsl:value-of
								select="fopUtil:getLocalizedString('Carrier :',$locale)" />
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="1mm" border-width=".15pt">
						<fo:block text-align="left">
							<xsl:value-of select="$Carrier" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
				<!-- second row -->
				<fo:table-row>
					<fo:table-cell padding="1mm" border-width=".15pt">
						<fo:block text-align="left">
							<xsl:value-of
								select="fopUtil:getLocalizedString('Freight Terms :',$locale)" />
						</fo:block>
					</fo:table-cell>
					<fo:table-cell padding="1mm" border-width=".15pt">
						<fo:block text-align="left">
							<xsl:value-of select="$FreightTerm" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template match="ShipmentLines">
		<fo:table background-color="#CCCCFF" table-layout="fixed"
			border-style="solid" border-width="0.5mm" border-color="black"
			width="100%">
			<fo:table-column column-width="100%" />
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell>
						<fo:block font-family="Arial"
							text-align="center" font-size="11pt" space-before="100mm"
							text-align-last="center">
							<xsl:value-of
													select="fopUtil:getLocalizedString('SHIPPING INFORMATION',$locale)" />

						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
		<fo:table border-width=".5mm" border-style="solid"
			border-color="black" width="100%" font-size="10pt">
			<fo:table-column column-width="10%" />
			<fo:table-column column-width="50%" />
			<fo:table-column column-width="20%" />
			<fo:table-column column-width="20%" />

			<fo:table-body>
				<fo:table-row background-color="White">
					<fo:table-cell border-width=".2mm"
						border-style="solid" border-color="black" text-align="center">
						<fo:block font-weight="bold">
							<xsl:value-of
								select="fopUtil:getLocalizedString('Sl. No',$locale)" />
						</fo:block>
					</fo:table-cell>

					<fo:table-cell border-width=".2mm"
						border-style="solid" border-color="black" text-align="center">
						<fo:block font-weight="bold">
							<xsl:value-of
								select="fopUtil:getLocalizedString('Description',$locale)" />
						</fo:block>
					</fo:table-cell>


					<fo:table-cell border-width=".2mm"
						border-style="solid" border-color="black" text-align="center">
						<fo:block font-weight="bold">
							<xsl:value-of
								select="fopUtil:getLocalizedString('Ordered Quantity',$locale)" />
						</fo:block>
					</fo:table-cell>
					<fo:table-cell border-width=".2mm"
						border-style="solid" border-color="black" text-align="center">
						<fo:block font-weight="bold">
							<xsl:value-of
								select="fopUtil:getLocalizedString('Shipped Quantity',$locale)" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>

				<xsl:for-each select="ShipmentLine">
					<fo:table-row border-style="solid"
						border-width=".5pt" border-color="black">
						<xsl:variable name="i" select="position()" />
						<fo:table-cell padding="1mm" border-width=".2mm"
							border-style="solid" border-color="black">
							<fo:block>
								<xsl:value-of select="$i" />
							</fo:block>
						</fo:table-cell>
						<fo:table-cell padding="1mm" border-width=".2mm"
							border-style="solid" border-color="black">
							<fo:block>
								<xsl:value-of
									select="concat(OrderLine/ItemDetails/PrimaryInformation/@ShortDescription,' (', OrderLine/ItemDetails/@ItemID,')' )" />
							</fo:block>
						</fo:table-cell>


						<fo:table-cell padding="1mm" border-width=".2mm"
							border-style="solid" border-color="black">
							<xsl:variable name="lineQty"
								select="@ActualQuantity" />
							<xsl:variable name="UOM"
								select="@UnitOfMeasure">
							</xsl:variable>
							<fo:block text-align="right">
								<xsl:value-of
									select="concat(fopUtil:getFormattedDouble($lineQty,$locale),' ',/MultiApi/API[@Name='getItemUOMMasterList']/Output/ItemUOMMasterList/ItemUOMMaster[@UnitOfMeasure=$UOM]/@Description)" />
							</fo:block>
						</fo:table-cell>

						<fo:table-cell padding="1mm" border-width=".2mm"
							border-style="solid" border-color="black">
							<xsl:variable name="ShippedQty"
								select="@ContainerizedQuantity" />
							<xsl:variable name="UOM"
								select="@UnitOfMeasure">
							</xsl:variable>
							<fo:block text-align="right">
								<xsl:value-of
									select="concat(fopUtil:getFormattedDouble($ShippedQty,$locale),' ',/MultiApi/API[@Name='getItemUOMMasterList']/Output/ItemUOMMasterList/ItemUOMMaster[@UnitOfMeasure=$UOM]/@Description)" />
							</fo:block>
						</fo:table-cell>

					</fo:table-row>
				</xsl:for-each>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	<xsl:template match="Instructions">
		<xsl:variable name="instructionText"
			select="Instruction/@InstructionText" />
		<xsl:if test="$instructionText != ''">
			<fo:table table-layout="fixed" border-width="0mm"
				border-style="solid" width="100%">
				<fo:table-column column-width="30%" />
				<fo:table-column column-width="70%" />
				<fo:table-body>
					<!--1st row -->
					<fo:table-row>
						<fo:table-cell padding="1mm"
							background-color="White" border-width=".15pt">
							<fo:block text-align="left">
								<xsl:value-of
									select="fopUtil:getLocalizedString('Special Instructions :',$locale)" />
							</fo:block>
						</fo:table-cell>

						<!--2nd row -->
						<fo:table-cell padding="1mm"
							border-width=".15pt">
							<fo:block text-align="left">
								<xsl:value-of select="$instructionText" />
							</fo:block>
						</fo:table-cell>
					</fo:table-row>

				</fo:table-body>
			</fo:table>
		</xsl:if>
	</xsl:template>

	<xsl:template name="addEmptyBlock">
		<xsl:param name="hightinpt" />
		<fo:table width="100%">
			<fo:table-column column-width="100%" />
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell>
						<fo:block white-space-treatment="preserve"
							linefeed-treatment="preserve">
							<xsl:text> &#x00A0;</xsl:text>
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>
</xsl:stylesheet>
