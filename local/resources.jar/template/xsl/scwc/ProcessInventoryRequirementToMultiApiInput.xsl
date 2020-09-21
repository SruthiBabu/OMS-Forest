<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Order Management  (5725-D10)
(C) Copyright IBM Corp. 2005, 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:xalan="http://xml.apache.org/xslt"
     xmlns:oa="http://www.openapplications.org/oagis/9"
     xmlns:mediationUtil="xalan://com.ibm.commerce.sample.mediation.util.MediationUtil"
     xmlns:_inv="http://www.ibm.com/xmlns/prod/commerce/9/inventory"
     xmlns:_wcf="http://www.ibm.com/xmlns/prod/commerce/9/foundation"
     xmlns:_ord="http://www.ibm.com/xmlns/prod/commerce/9/order"
     xmlns:xsd="http://www.w3.org/2001/XMLSchema"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xmlns:scwc="http://www.sterlingcommerce.com/scwc/"
	 xmlns:ValueMaps="xalan://com.yantra.scwc.impl.ValueMapsData"
	 extension-element-prefixes="ValueMaps"
     exclude-result-prefixes="xalan oa _wcf _inv _ord"
     version="1.0">

	<xsl:import href="template/xsl/scwc/custom/ProcessInventoryRequirementToMultiApiHTTPInput.xsl"/>
	<xsl:output method="xml" encoding="UTF-8" indent="no"/>

	<xsl:template match="/" >
		<RequestData>
			<context>
				<xsl:if test="correlation">
					<xsl:copy-of select="correlation"/>
				</xsl:if>
			</context>
			<body>
				<xsl:variable name="ProcessInventoryRequirement"  select="/_inv:ProcessInventoryRequirement"/>
				<xsl:call-template name="ProcessInventoryRequirementToApiInput_multiApi">
					<xsl:with-param name="ProcessInventoryRequirement" select="$ProcessInventoryRequirement"/>
				</xsl:call-template>
			</body>
		</RequestData>
	</xsl:template>
</xsl:stylesheet>
