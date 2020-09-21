<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output indent="yes"/>
    <xsl:template match="/Container">
        <Container>
            <xsl:for-each select="@*">
		<xsl:choose>
                    <xsl:when test="name() = 'ActualWeight'">
			<xsl:attribute name="ActualWeight"><xsl:value-of select="round(number(.))"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
			<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                    </xsl:otherwise>
		</xsl:choose>	
            </xsl:for-each>

            <xsl:copy-of select="ContainerDetails"/>
            <xsl:copy-of select="ScacEx"/>
	    <xsl:copy-of select="RoutingInstructions"/>
	    <xsl:copy-of select="SpecialServices"/>
			<Shipment>
				<xsl:copy-of select="Shipment/@*"/>
				<ToAddress>
					<xsl:choose>
						<xsl:when test="string-length(Shipment/ToAddress/@ZipCode) &gt; 5">
							<xsl:attribute name="ZipCode"><xsl:value-of select="concat(substring(Shipment/ToAddress/@ZipCode,1,5),'-',substring(Shipment/ToAddress/@ZipCode,6))"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="ZipCode"><xsl:value-of select="Shipment/ToAddress/@ZipCode"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:for-each select="Shipment/ToAddress/@*">
						<xsl:if test="not(name() = &quot;ZipCode&quot;)">
							<xsl:copy-of select="."/>
						</xsl:if>
					</xsl:for-each>
				</ToAddress>
				<ShipNode>
					<xsl:copy-of select="Shipment/ShipNode/@*"/>
					<ShipNodePersonInfo>
					<xsl:choose>
						<xsl:when test="string-length(Shipment/ShipNode/ShipNodePersonInfo/@ZipCode) &gt; 5">
							<xsl:attribute name="ZipCode"><xsl:value-of select="concat(substring(Shipment/ShipNode/ShipNodePersonInfo/@ZipCode,1,5),'-',substring(Shipment/ShipNode/ShipNodePersonInfo/@ZipCode,6))"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="ZipCode"><xsl:value-of select="Shipment/ShipNode/ShipNodePersonInfo/@ZipCode"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
						<xsl:for-each select="Shipment/ShipNode/ShipNodePersonInfo/@*">
							<xsl:if test="not(name() = &quot;ZipCode&quot;)">
								<xsl:copy-of select="."/>
							</xsl:if>
						</xsl:for-each>
					</ShipNodePersonInfo>
				</ShipNode>
				<xsl:copy-of select="Shipment/BillingInformation"/>
				<xsl:copy-of select="Shipment/Containers"/>
				<xsl:copy-of select="Shipment/Carrier"/>
				<xsl:copy-of select="Shipment/ScacAndService"/>
			</Shipment>
			<xsl:variable name="ServiceIndicator" select="substring(@TrackingNo,9,2)"/>
            <ContainerInfo>
			   <xsl:attribute name="PackageNumber"><xsl:value-of select="count(Shipment/Containers/Container[not(@ManifestKey=&quot;&quot;)])"/></xsl:attribute>
			   <xsl:attribute name="TotalPackages"><xsl:value-of select="count(Shipment/Containers/Container)"/></xsl:attribute> 
	           <xsl:attribute name="AddressValidation"><xsl:text>N</xsl:text></xsl:attribute>
		        <xsl:attribute name="CarrierServiceIcon">
					<xsl:choose>
						<!-- UPS EARLY A.M. , Delivery Confirmation Adult Signature Required -->
						<xsl:when test="$ServiceIndicator = &quot;32&quot; or $ServiceIndicator = &quot;A9&quot; or $ServiceIndicator = &quot;15&quot; or $ServiceIndicator = &quot;A0&quot; ">
							<xsl:value-of select="'1+'"/>
						</xsl:when>
						<!-- Saturday Delivery, Saturday Delivery,Delivery Confirmation Adult Signature Required -->
						<xsl:when test="$ServiceIndicator = &quot;33&quot; or $ServiceIndicator = &quot;AA&quot;  or $ServiceIndicator = &quot;41&quot; or $ServiceIndicator = &quot;A1&quot;">
							<xsl:value-of select="'1+S'"/>
						</xsl:when>
						<!-- UPS Next Day Air, Delivery Confirmation, Delivery Confirmation Signature Required,Delivery Confirmation Adult Signature Required -->
						<xsl:when test="$ServiceIndicator = &quot;01&quot; or $ServiceIndicator = &quot;25&quot; or $ServiceIndicator = &quot;24&quot; or $ServiceIndicator = &quot;A2&quot; or $ServiceIndicator = &quot;59&quot; or $ServiceIndicator = &quot;AC&quot; ">
							<xsl:value-of select="'1'"/>
						</xsl:when>
						<!-- UPS Next Day Air, Saturday Delivery,Saturday Delivery,Delivery Confirmation, Saturday Delivery,Delivery Confirmation Signature Required, Saturday Delivery, Delivery Confirmation Adult Signature Required -->
						<xsl:when test="$ServiceIndicator = &quot;44&quot; or $ServiceIndicator = &quot;47&quot; or $ServiceIndicator = &quot;58&quot; or $ServiceIndicator = &quot;A3&quot;  or $ServiceIndicator = &quot;60&quot; or $ServiceIndicator = &quot;AD&quot; ">
							<xsl:value-of select="'1 S'"/>
						</xsl:when>  
						<!-- UPS NEXT DAY AIR SAVER, Delivery Confirmation, Delivery Confirmation Signature Required, Delivery Confirmation Adult Signature Required -->
						<xsl:when test="$ServiceIndicator = &quot;13&quot; or $ServiceIndicator = &quot;30&quot; or $ServiceIndicator = &quot;29&quot; or $ServiceIndicator = &quot;A4&quot;  or $ServiceIndicator = &quot;62&quot; or $ServiceIndicator = &quot;AE&quot;">
							<xsl:value-of select="'1P'"/>
						</xsl:when>     
						<!-- UPS 2ND DAY AIR A.M., Delivery Confirmation, Delivery Confirmation Signature Required,Delivery Confirmation Adult Signature Required -->
						<xsl:when test="$ServiceIndicator = &quot;07&quot; or $ServiceIndicator = &quot;18&quot; or $ServiceIndicator = &quot;19&quot; or $ServiceIndicator = &quot;A5&quot;  or $ServiceIndicator = &quot;65&quot; or $ServiceIndicator = &quot;AF&quot;">
							<xsl:value-of select="'2A'"/>
						</xsl:when> 
						<!-- UPS 2ND DAY AIR, Delivery Confirmation, Delivery Confirmation Signature Required,Delivery Confirmation Adult Signature Required -->
						<xsl:when test="$ServiceIndicator = &quot;02&quot; or $ServiceIndicator = &quot;36&quot; or $ServiceIndicator = &quot;35&quot; or $ServiceIndicator = &quot;A6&quot;  or $ServiceIndicator = &quot;70&quot; or $ServiceIndicator = &quot;AG&quot; ">
							<xsl:value-of select="'2'"/>
						</xsl:when>   
						<!-- UPS 3 DAY SELECT, Delivery Confirmation, Delivery Confirmation Signature Required, Delivery Confirmation Adult Signature Required -->
						<xsl:when test="$ServiceIndicator = &quot;12&quot; or $ServiceIndicator = &quot;40&quot; or $ServiceIndicator = &quot;39&quot; or $ServiceIndicator = &quot;A7&quot;  or $ServiceIndicator = &quot;71&quot; or $ServiceIndicator = &quot;AH&quot;">
							<xsl:value-of select="'3'"/>
						</xsl:when>                
					</xsl:choose>
		       </xsl:attribute>
	           <xsl:attribute name="BillingOption">
		           <xsl:choose>
				        <xsl:when test="Shipment/BillingInformation/@ShipmentChargeType = &quot;COLLECT&quot;">
						    <xsl:value-of select="'CONSIGNEE'"/>
			            </xsl:when>
					    <xsl:when test="Shipment/BillingInformation/@ShipmentChargeType = &quot;PREPAID&quot;">
							<xsl:value-of select="'P/P'"/>
		                </xsl:when>                
						<xsl:when test="Shipment/BillingInformation/@ShipmentChargeType = &quot;THIRDPARTY&quot;">
							<xsl:value-of select="'3RD PARTY'"/>
						</xsl:when>                
	               </xsl:choose>
           </xsl:attribute>
		   <xsl:copy-of select="ContainerInfo/@*"/>
           </ContainerInfo>
           <LabelFormat>
		    <!-- UPS Ground, UPS STANDARD -->
             <xsl:if test="$ServiceIndicator = &quot;03&quot; or $ServiceIndicator = &quot;72&quot; or $ServiceIndicator = &quot;AJ&quot; or $ServiceIndicator = &quot;26&quot; or $ServiceIndicator = &quot;43&quot; or $ServiceIndicator = &quot;42&quot; or $ServiceIndicator = &quot;A8&quot; or $ServiceIndicator = &quot;51&quot;">
                <xsl:attribute name="LabelFormatId"><xsl:text>UPS_CARRIER_LABEL_GROUND</xsl:text></xsl:attribute>
             </xsl:if>
           </LabelFormat>
        </Container>
    </xsl:template>
</xsl:stylesheet> 
