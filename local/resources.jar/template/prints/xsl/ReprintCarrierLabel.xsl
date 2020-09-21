<?xml version = "1.0" encoding = "UTF-8"?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet xmlns:xsl = "http://www.w3.org/1999/XSL/Transform" version = "1.0">
  <xsl:output indent="yes"/>
	<xsl:template match="/">
	        <xsl:variable name="NoOfCopies">
		  <xsl:value-of select="Print/LabelPreference/@NoOfCopies"/>
		</xsl:variable>
		<Container>
		   <xsl:attribute name="ShipmentContainerKey">
		       <xsl:value-of select="Print/Container/@ShipmentContainerKey"/>
		   </xsl:attribute> 
		    <xsl:attribute name="NoOfCopies">
		       <xsl:value-of select="$NoOfCopies"/>
		   </xsl:attribute> 		  
		  <PrinterPreference>
			    <xsl:attribute name="UsergroupId">
		               <xsl:value-of select="Print/PrinterPreference/@UsergroupId"/>
		            </xsl:attribute>

			    <xsl:attribute name="UserId">
			      <xsl:value-of select="Print/PrinterPreference/@UserId"/>
			    </xsl:attribute>

			    <xsl:attribute name="PrinterId">
			      <xsl:value-of select="Print/PrinterPreference/@PrinterId"/>
			    </xsl:attribute>
	         </PrinterPreference>
                 <xsl:if test="(Print/Container/ContainerReturnTrackingList)">
                          <ContainerReturnTrackingList>
                                     <xsl:copy-of select="Print/Container/ContainerReturnTrackingList/ContainerReturnTracking"/>
                          </ContainerReturnTrackingList>
                 </xsl:if>
	      </Container>	
        </xsl:template>
</xsl:stylesheet>