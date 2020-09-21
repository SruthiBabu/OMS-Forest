<?xml version="1.0" encoding="UTF-8" ?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Call Center and Store
(C) Copyright IBM Corp. 2007, 2011 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
    <xsl:output indent="yes"/>
    <xsl:template match="Shipment">
    	 <MultiApi>
	<xsl:for-each select="ShipmentLines/ShipmentLine">
            <xsl:element name="API">
                  <xsl:attribute name="Name">
                     <xsl:text>getNodeInventory</xsl:text>
		 </xsl:attribute>
                 <xsl:element name="Input">    
			    	<xsl:element name="NodeInventory">				    
				    	<xsl:attribute name="EnterpriseCode">
							<xsl:value-of select="../../@EnterpriseCode"/>
				    	</xsl:attribute>			
				   		<xsl:attribute name="Node">
							<xsl:value-of select="../../@ShipNode"/>
				    	</xsl:attribute>
				    	<xsl:element name="Inventory">
				    		<xsl:element name="InventoryItem">
								<xsl:attribute name="ItemID">
									<xsl:value-of select="@ItemID"/>
								</xsl:attribute>
								<xsl:attribute name="ProductClass">
									<xsl:value-of select="@ProductClass"/>
								</xsl:attribute>
								<xsl:attribute name="UnitOfMeasure">
									<xsl:value-of select="@UnitOfMeasure"/>
								</xsl:attribute>
							</xsl:element>
				   		</xsl:element>
					</xsl:element>
				</xsl:element>   
                            <Template>	
					     <NodeInventory>
						<LocationInventoryList TotalNumberOfRecords="">
							<LocationInventory LocationId="" Quantity="">
								<InventoryItem ItemID="" OrganizationCode="" ProductClass="" UnitOfMeasure=""/>
							</LocationInventory>
						</LocationInventoryList>
						</NodeInventory>
                            </Template>                                        
                                             
                    </xsl:element>                    
           </xsl:for-each>
            
	    <xsl:element name="API">
		      <xsl:attribute name="Name">
                     <xsl:text>getSortedShipmentDetails</xsl:text>
                </xsl:attribute>
                <xsl:element name="Input">    
                      <xsl:element name="Shipment">
                              <xsl:attribute name="ShipmentKey">
			                	<xsl:value-of select="/Shipment/@ShipmentKey"/>
                             </xsl:attribute>

			      				<xsl:attribute name="EnterpriseCode">
			                		<xsl:value-of select="/Shipment/@EnterpriseCode"/>
                             	</xsl:attribute>
                       </xsl:element>
                 </xsl:element>
                
			     <Template>	                            
                                <Shipment ShipmentNo="" OrderNo="" Createts="" EnterpriseCode="" RequestedShipmentDate="" ShipNode="" ShipmentKey="">
					<Instructions>
						<Instruction InstructionText=""/>
					</Instructions>
					<ToAddress/>
				        <ShipNode   Localecode=""/> 
				        <ShipmentLines TotalNumberOfRecords="">
                                         <ShipmentLine ItemDesc="" ItemID="" OrderHeaderKey="" OrderNo="" Quantity="" UnitOfMeasure=""/>
                                    </ShipmentLines>
                                  </Shipment>
                                </Template>

                        
                      </xsl:element>

   

              <xsl:element name="API">
            
                    <xsl:attribute name="Name">
                         <xsl:text>getPrinter</xsl:text>
                    </xsl:attribute>
                
                    <xsl:element name="Input">    

                        <xsl:element name="GetPrinter">

                            <xsl:attribute name="PrintDocumentId">
			      <xsl:text>PRINT_PICK_TICKET</xsl:text>
                             </xsl:attribute>
                             <xsl:element name="PrinterPreference">
                                     <xsl:attribute name="OrganizationCode">
                                        <xsl:value-of select="/Shipment/@ShipNode"/>
                                    </xsl:attribute>
                                        
                               </xsl:element>
                                
                            </xsl:element>

                         </xsl:element>

                    </xsl:element>
                    
                
         </MultiApi>
         
    </xsl:template>
    
</xsl:stylesheet>
