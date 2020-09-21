<?xml version="1.0" encoding="UTF-8" ?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Call Center and Store
(C) Copyright IBM Corp. 2008, 2011 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->

<!--
    Document   : StoreAcknowledgementPrintJasper_Comp2.xsl
    Author     : lbramhanandamurthy
    Description: This xsl is used to format the multiApi output and prepare an xml for the jasper print.
-->

<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">

    <xsl:output indent="yes"/>
    
    <xsl:template match="Shipment">
    
	<PrintJasper>

		<xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getUserHierarchy&quot;)]" >
			<xsl:attribute name="Localecode">
				<xsl:value-of select="Output/User/@Localecode"/>
			</xsl:attribute>
		</xsl:for-each>

           <xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getPrinter&quot;)]" >
                 
		 <xsl:for-each select="Output/Printer/PrinterParams/Attributes/Attribute">
		   <xsl:if test="@Name=&quot;PrinterAlias&quot;">
		         <xsl:attribute name="PrinterName">
				<xsl:value-of select="@Value"/>
			 </xsl:attribute>
		    </xsl:if>
	       </xsl:for-each>
         </xsl:for-each>


	<xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getSortedShipmentDetails&quot;)]" >
		<Shipment>
			<xsl:for-each select="Output/Shipment">
				<xsl:copy-of select="@*"/>
				<xsl:for-each select="ShipmentLines">
					<ShipmentLines>
						<xsl:copy-of select="@*"/>
						<xsl:for-each select="ShipmentLine">
							<ShipmentLine>
								<xsl:copy-of select="@*"/>
								<xsl:attribute name="Localecode">
									<xsl:value-of select="/MultiApi/API/Output/User/@Localecode"/>
								</xsl:attribute>
								<xsl:copy-of select="OrderLine"/>
								<!--<OrderLine>
								<xsl:copy-of select="@*"/>
								<xsl:for-each select="OrderLine/Instructions/Instruction[(normalize-space(@InstructionType) = 'GIFT')]" >
									<xsl:copy-of select="."/>
								</xsl:for-each>
								</OrderLine>-->
							</ShipmentLine>
						</xsl:for-each>
					</ShipmentLines>
				</xsl:for-each>
				<xsl:for-each select="ToAddress">
					<ToAddress>
						<xsl:copy-of select="@*"/>
					</ToAddress>
				</xsl:for-each>
				<xsl:for-each select="FromAddress">
					<FromAddress>
						<xsl:copy-of select="@*"/>
					</FromAddress>
				</xsl:for-each>
				<xsl:for-each select="ShipNode">
					<ShipNode>
						<xsl:copy-of select="@*"/>
					</ShipNode>
				</xsl:for-each>
			</xsl:for-each>
		</Shipment>
	</xsl:for-each>
	         
	    <xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getCurrencyList&quot;)]" >
		<xsl:copy-of select="Output/CurrencyList">
		</xsl:copy-of>
			</xsl:for-each>
		
			<xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getItemUOMMasterList&quot;)]" >
				<xsl:copy-of select="Output/ItemUOMMasterList">
				</xsl:copy-of>
	</xsl:for-each>
	
        </PrintJasper>
    
    </xsl:template>

</xsl:stylesheet>
