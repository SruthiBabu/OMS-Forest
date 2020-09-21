<?xml version = "1.0" encoding = "UTF-8"?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Selling and fulfillment Suite
(C) Copyright IBM Corp. 2011 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp -->

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
		 <Manifest>
			    <xsl:attribute name="ManifestKey">
		               <xsl:value-of select="Print/Manifest/@ManifestKey"/>
		            </xsl:attribute>
			    <xsl:attribute name="ManifestNo">
			      <xsl:value-of select="Print/Manifest/@ManifestNo"/>
			    </xsl:attribute>
	         </Manifest>
                 <xsl:if test="(Print/Container/ContainerReturnTrackingList)">
                          <ContainerReturnTrackingList>
                                     <xsl:copy-of select="Print/Container/ContainerReturnTrackingList/ContainerReturnTracking"/>
                          </ContainerReturnTrackingList>
                 </xsl:if>
	      </Container>	
        </xsl:template>
</xsl:stylesheet>