<?xml version="1.0" encoding="UTF-8" ?>
<!--
  Licensed Materials - Property of IBM
  IBM Sterling Order Management (5725-D10)
  (C) Copyright IBM Corp. 2016  All Rights Reserved.
  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
-->
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:strip-space elements="..."/>
              
    <xsl:preserve-space elements="..."/>

    <!-- template rule matching source root element -->
    <xsl:template match="/Loads">
        <Load>
            <xsl:copy-of select="Load/@*"/>
         </Load>   
    </xsl:template>

</xsl:stylesheet> 
