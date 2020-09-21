<?xml version="1.0" encoding="UTF-8" ?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Call Center and Store
(C) Copyright IBM Corp. 2007, 2011 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->

<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">

    <xsl:output indent="yes"/>
    
    <xsl:template match="MultiApi">
    
           <PrintJasper>

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
	      		      	  <xsl:for-each select="Output/Shipment" >	      			
	      				<xsl:element name="Shipment">     				
	      					<xsl:attribute name="ShipmentNo">
	      						<xsl:value-of select="@ShipmentNo"/>
	      					</xsl:attribute>	
						<xsl:attribute name="ShipmentDate">
	      						<xsl:value-of select="@Createts"/>
	      					</xsl:attribute>
	      				<xsl:attribute name="PickDate">
	      						<xsl:value-of select="@RequestedShipmentDate"/>
	      					</xsl:attribute>     						      					
	      					<xsl:element name="Instruction">
							<xsl:attribute name="InstructionText">
	      							<xsl:value-of select="Instructions/Instruction/@InstructionText"/>
	      						</xsl:attribute>
						</xsl:element>

						<xsl:element name="ToAddress">
							<xsl:attribute name="FirstName">
	      							<xsl:value-of select="ToAddress/@FirstName"/>
	      						</xsl:attribute>
							<xsl:attribute name="LastName">
	      							<xsl:value-of select="ToAddress/@LastName"/>
	      						</xsl:attribute>
							<xsl:attribute name="CustomerName">
	      							<xsl:value-of select="ToAddress/@FirstName"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="ToAddress/@LastName"/>
	      						</xsl:attribute>
						</xsl:element>
						<xsl:for-each select="ShipmentLines">
						<xsl:element name="ShipmentLines">
								<xsl:attribute name="TotalNumberOfRecords">
	      								<xsl:value-of select="@TotalNumberOfRecords"/>
	      							</xsl:attribute>
	      					<xsl:for-each select="ShipmentLine">
	      						<xsl:element name="ShipmentLine">
	      							<xsl:attribute name="ItemID">
	      								<xsl:value-of select="@ItemID"/>
	      							</xsl:attribute>
	      							<xsl:attribute name="OrderNo">
	      						<xsl:value-of select="@OrderNo"/>
	      							</xsl:attribute>
								<xsl:variable name="ShipmentItem">
									<xsl:value-of select="@ItemID"/>
								</xsl:variable>
									<xsl:attribute name="ItemDesc">
	      								<xsl:value-of select="@ItemDesc"/>
	      							</xsl:attribute>
	      							<xsl:attribute name="Quantity">
	      								<xsl:value-of select="@Quantity"/>
	      							</xsl:attribute>
	      							<xsl:attribute name="UnitOfMeasure">
	      								<xsl:value-of select="@UnitOfMeasure"/>
	      							</xsl:attribute>

								<xsl:variable name="Locations">
								 <xsl:for-each select="/MultiApi/API[(normalize-space(@Name) = &quot;getNodeInventory&quot;)]" >
								
									<xsl:for-each select="Output/NodeInventory/LocationInventoryList">
								
										
											<xsl:for-each select="LocationInventory">
												<xsl:for-each select="InventoryItem">
													<xsl:if test="@ItemID=$ShipmentItem">
														<xsl:value-of select="concat(parent::LocationInventory/@LocationId,'-',parent::LocationInventory/@Quantity,'  ',';')"/>
													</xsl:if>
												</xsl:for-each>
											</xsl:for-each>
										
									</xsl:for-each>	
								
								 </xsl:for-each>
								 
								</xsl:variable>
										<xsl:variable name="LocationsDetail"><xsl:value-of select="substring($Locations,1,string-length($Locations)-2)"/></xsl:variable>
								
								<xsl:attribute name="LocationDetail">
	      								<xsl:value-of select="$LocationsDetail"/>
	      							</xsl:attribute>

	      						</xsl:element>
								
	      					</xsl:for-each>
	      					</xsl:element>
	      					</xsl:for-each>
	      						      				
	      				</xsl:element>
	      			
	      			</xsl:for-each>

	      			
	      		
	      		
	      	
	      </xsl:for-each>          
              

           </PrintJasper>    
    
    </xsl:template>

</xsl:stylesheet>
