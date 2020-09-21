<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
IBM Sterling Configure Price Quote (5725-D11)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	  xmlns:xalan="http://xml.apache.org/xalan"
	  xmlns:datetime="http://exslt.org/dates-and-times"
	  xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
      xmlns="http://www.sterlingcommerce.com/documentation/YCP/getPage/output"
      xmlns:oa="http://www.openapplications.org/oagis/9"
	  xmlns:udt="http://www.openapplications.org/oagis/9/unqualifieddatatypes/1.1"
	  xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order"	
	  xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
	  xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	  xmlns:java="http://xml.apache.org/xslt/java"
      xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	  extension-element-prefixes="datetime mediationUtil ValueMaps"
     exclude-result-prefixes="xalan java"
     version="1.0">
     <xsl:param name="scwc:ValueMapsData" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2"/>
  <xsl:strip-space elements="*"/>

  <xsl:template name="RootToShowOrder" match="/">

    <xsl:variable name="Root" select="/ResponseData/Body"/>
    <xsl:variable name="Page" select="$Root/Page"/>
    <xsl:variable name="OrganizationCode"><xsl:value-of select="$Page/Output/OrderList/Order/@EnterpriseCode" /></xsl:variable>	  
	<xsl:variable name="storeId">
		<xsl:value-of select="ValueMaps:getValueForMapKey($scwc:ValueMapsData, 'DEFAULT', 'storeIdToOrganizationCode', $OrganizationCode)" />
	</xsl:variable>	
	<_ord:ShowOrder>
		   <_wcf:ApplicationArea>
				<oa:CreationDateTime xsi:type="udt:DateTimeType">
		            <xsl:variable name="datePattern">yyyy-MM-dd'T'HH:mm:ss'Z'</xsl:variable>
			    <xsl:value-of select="java:format(java:java.text.SimpleDateFormat.new($datePattern), java:java.util.Date.new())" />
				</oa:CreationDateTime>
			</_wcf:ApplicationArea>
			<_ord:DataArea>
				<oa:Show>
					<xsl:attribute name="recordSetCount">
					    <xsl:choose>
							<xsl:when test="string-length(normalize-space($Page/Output/OrderList/@TotalOrderList)) &gt; 0">
							    <xsl:value-of select="$Page/Output/OrderList/@TotalOrderList" />
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="recordSetTotal">
					    <xsl:choose>
							<xsl:when test="string-length(normalize-space($Page/Output/OrderList/@TotalNumberOfRecords)) &gt; 0">
							    <xsl:value-of select="$Page/Output/OrderList/@TotalNumberOfRecords" />
							</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="$Page/@IsLastPage='Y'">						
							<xsl:attribute name="recordSetCompleteIndicator">true</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="recordSetCompleteIndicator">false</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</oa:Show>
				<xsl:for-each
					select="$Page/Output/OrderList/Order">
					<_ord:Order>
						<_ord:OrderIdentifier>
							<_wcf:UniqueID>
								<xsl:choose>
									<xsl:when test="starts-with(@OrderNo, 'WC_')">
										<xsl:value-of select="substring-after(@OrderNo, 'WC_')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@OrderNo" />
									</xsl:otherwise>
								</xsl:choose>
							</_wcf:UniqueID>
							<_wcf:ExternalOrderID>
								<xsl:value-of select="@OrderHeaderKey" />
							</_wcf:ExternalOrderID>
						</_ord:OrderIdentifier>
						<_ord:PlacedDate>
							<xsl:value-of select="@OrderDate" />
						</_ord:PlacedDate>
						<xsl:variable name="scStatus"><xsl:value-of select="@MaxOrderStatus" /></xsl:variable>
						<xsl:variable name="status"><!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='scStatusToWcStatus']/mm:Entry[@key=$scStatus]/text()" /> -->
						<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'scStatusToWcStatus', $scStatus)" /></xsl:variable>
						<_ord:OrderStatus>
							<_ord:Status>
								<xsl:choose>
									<xsl:when test="@MultipleStatusesExist = 'Y' and $status = 'S'">
										<xsl:text>V</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$status" />
									</xsl:otherwise>
								</xsl:choose>
							</_ord:Status>
						</_ord:OrderStatus>
						<xsl:variable name="scCurrency" select="PriceInfo/@Currency"/>
						<xsl:variable name="wcCurrency"><!-- <xsl:value-of select="document('../../ValueMaps.xml')/mm:ValueMaps/mm:Map[@name='wcCurrencyToScCurency']/mm:Entry[text()=$scCurrency]/@key"/> flipping as there is no map entry. -->
						<xsl:value-of select="ValueMaps:getMapValue($scwc:ValueMapsData, 'DEFAULT', 'scCurrencyToWcCurency', $scCurrency)" /></xsl:variable>
						<_ord:OrderAmount>
							<_wcf:GrandTotal>
								<xsl:attribute name="currency">
									<xsl:choose>
										<xsl:when test="string-length(normalize-space($wcCurrency)) &gt; 0">
											<xsl:value-of select="$wcCurrency" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$scCurrency" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>								
								<xsl:value-of select="OverallTotals/@GrandTotal" />								
							</_wcf:GrandTotal>	
						</_ord:OrderAmount>
                        <_wcf:UserData>
						    <xsl:if test="@MaxOrderStatus">
							    <_wcf:UserDataField>
							        <xsl:attribute name="name">MaxOrderStatus</xsl:attribute>
								    <xsl:value-of select="@MaxOrderStatus" />
							    </_wcf:UserDataField>
							</xsl:if>
							<xsl:if test="@MaxOrderStatusDesc">
							    <_wcf:UserDataField>
							        <xsl:attribute name="name">MaxOrderStatusDesc</xsl:attribute>
								    <xsl:value-of select="@MaxOrderStatusDesc" />
							    </_wcf:UserDataField>
							</xsl:if>
						    <xsl:if test="@MinOrderStatus">
							    <_wcf:UserDataField>
							        <xsl:attribute name="name">MinOrderStatus</xsl:attribute>
								    <xsl:value-of select="@MinOrderStatus" />
							    </_wcf:UserDataField>
							</xsl:if>
							<xsl:if test="@MinOrderStatusDesc">
							    <_wcf:UserDataField>
							        <xsl:attribute name="name">MinOrderStatusDesc</xsl:attribute>
								    <xsl:value-of select="@MinOrderStatusDesc" />
							    </_wcf:UserDataField>
							</xsl:if>
							<xsl:if test="@Status">
							    <_wcf:UserDataField>
							        <xsl:attribute name="name">Status</xsl:attribute>
								    <xsl:value-of select="@Status" />
							    </_wcf:UserDataField>
							</xsl:if>
                        </_wcf:UserData>						
					</_ord:Order>
				</xsl:for-each>
			</_ord:DataArea>
		</_ord:ShowOrder>
  </xsl:template>
</xsl:stylesheet>