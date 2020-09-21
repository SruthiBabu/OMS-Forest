<?xml version="1.0" encoding="UTF-8" ?>
<!--
Licensed Materials - Property of IBM
IBM Sterling Call Center and Store
(C) Copyright IBM Corp. 2007, 2011 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
    <xsl:output indent="yes"/>
    
    <xsl:template match="/">
          <xsl:apply-templates select="/MultiApi"/>
    </xsl:template>
    <xsl:template match="MultiApi">
	<MultiApi>
	   <xsl:apply-templates select="Shipments"/>
	   <xsl:for-each select="API[@Name='getShipmentList']" >
		<xsl:apply-templates select="Output/Shipments/Shipment" />
	    <xsl:if test="position()=last()"> 
	     <xsl:element name="API">
            
		<xsl:attribute name="Name">
			<xsl:text>getItemUOMMasterList</xsl:text>
		</xsl:attribute>
		<Input>
			<ItemUOMMaster>
				<xsl:attribute name="CallingOrganizationCode">
					<xsl:value-of select="@ShipNode"/>
				</xsl:attribute>
			</ItemUOMMaster>
		</Input>
		<Template>
			<ItemUOMMasterList>
				<ItemUOMMaster UnitOfMeasure="" Description=""/> 
			</ItemUOMMasterList>
		</Template>

	    </xsl:element>
	    </xsl:if>
     </xsl:for-each>
	   <xsl:for-each select="API[@Name='getUserHierarchy']" >
		<xsl:apply-templates select="Output/User" />
	   </xsl:for-each>
       </MultiApi>
   </xsl:template>
  
    <xsl:template match="Shipment">
    	
	 
         
            
	    <xsl:element name="API">
		      <xsl:attribute name="Name">
                     <xsl:text>getSortedShipmentDetails</xsl:text>
                </xsl:attribute>
                <xsl:element name="Input">    
                      <xsl:element name="Shipment">
                              <xsl:attribute name="ShipmentKey">
			                	<xsl:value-of select="@ShipmentKey"/>
                             </xsl:attribute>

			      				<xsl:attribute name="EnterpriseCode">
			                		<xsl:value-of select="@EnterpriseCode"/>
                             	</xsl:attribute>
                       </xsl:element>
                 </xsl:element>
                
			     <Template>	                            
                   <Shipment ShipmentNo="" OrderNo="" Createts="" EnterpriseCode="" RequestedShipmentDate="" ShipNode="" ShipmentKey="">
					<Instructions>
						<Instruction InstructionText=""/>
					</Instructions>
					<ToAddress/>
				    <ShipNode Description="" ShipNode="">
					   <ShipNodePersonInfo AddressLine1=""
						AddressLine2="" AddressLine3="" AddressLine4=""
						AddressLine5="" AddressLine6="" AlternateEmailID=""
						Beeper="" City="Boston" Company="Matrix Retail" Country="US"
						DayFaxNo="" DayPhone="" Department="" EMailID="" ErrorTxt=""
						EveningFaxNo="" EveningPhone="" FirstName="John" HttpUrl=""
						JobTitle="" LastName="Roberts" MiddleName="" MobilePhone=""
						OtherPhone="" PersonID=""
						PersonInfoKey="" PreferredShipAddress=""
						State="MA" Suffix="" Title="" UseCount="0"
						VerificationStatus="" ZipCode=""/>
					</ShipNode>

					<ShipmentLines TotalNumberOfRecords="">
						 <ShipmentLine ItemDesc="" ItemID="" OrderHeaderKey="" OrderNo="" Quantity="" UnitOfMeasure=""/>
					</ShipmentLines>
				  </Shipment>
				</Template>

            </xsl:element>

	   

     
         
    </xsl:template>
    

<xsl:template match="User">
  <xsl:element name="API">
  	<xsl:attribute name="Name">
	<xsl:text>getUserHierarchy</xsl:text>
	</xsl:attribute>
	 <xsl:element name="Input"> 
	<xsl:element name="User">  
		<xsl:attribute name="Loginid">
		<xsl:value-of select="@Loginid"/>
		</xsl:attribute>
	</xsl:element> 
	</xsl:element> 
	<xsl:element name="Template"> 
	<xsl:element name="User">
		<xsl:attribute name="Localecode" />
		<xsl:attribute name="UserName" />
	</xsl:element>  
	</xsl:element> 

    </xsl:element>       
 </xsl:template>

</xsl:stylesheet>
