<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:lxslt="http://xml.apache.org/xslt"
                version="1.0">
<xsl:template match="/">
<HTML>
<xsl:comment>RECIPIENTS=<xsl:value-of select="/Order/PersonInfoBillTo/@EMailID"/></xsl:comment>
<xsl:comment>FROM=sales@yourcompany.com</xsl:comment>
<xsl:comment>SUBJECT=Your Order Has Been Placed</xsl:comment>
<xsl:comment>CONTENT_TYPE=text/html</xsl:comment>
<HEAD>
	<title>Order Confirmation</title>
</HEAD>

<BODY topmargin="0" leftmargin="0">
	<BR/><BR/><font>Dear <xsl:value-of select="/Order/PersonInfoBillTo/@FirstName"/>&#160;<xsl:value-of select="/Order/PersonInfoBillTo/@LastName"/>,</font><BR/><BR/>
	<font>Your order # <xsl:value-of select="/Order/@OrderNo"/> for the amount of <xsl:value-of select="/Order/OverallTotals/@GrandTotal"/> has been placed.<BR/>
	Your items should be arriving shortly.<BR/><BR/>
	</font>
	<xsl:apply-templates select="Order"/>
</BODY>
</HTML>
</xsl:template>

<xsl:template match="Order">
<BR/><BR/><BR/><P><font><B>Order Number : <xsl:value-of select="@OrderNo"/></B></font></P>
<TABLE class="listTable" BORDER="1" WIDTH="50%" CELLSPACING="0" CELLPADDING="3" borderColor="#336699">
	<TR>
		<TD width="50%">
		<div class="listhead">
			<b>Ship Items To:</b>
		</div>
		<div class="Address">
			<xsl:value-of select="PersonInfoShipTo/@FirstName"/>&#160;<xsl:value-of select="PersonInfoShipTo/@LastName"/><BR/>
			<xsl:value-of select="PersonInfoShipTo/@AddressLine1"/><BR/>
			<xsl:value-of select="PersonInfoShipTo/@AddressLine2"/><BR/>
			<xsl:value-of select="PersonInfoShipTo/@City"/>,<xsl:value-of select="PersonInfoShipTo/@State"/>&#160;<xsl:value-of select="PersonInfoShipTo/@ZipCode"/><BR/>
			<xsl:value-of select="PersonInfoShipTo/@Country"/>
		</div>
		</TD>
	</TR>
</TABLE><BR/>
		<TABLE BORDER="2" WIDTH="50%" CELLSPACING="0"  CELLPADDING="3" borderColor="#e0e0e0">
			<TR>
			<TH BGCOLOR="#cccccc"><b><font size="2">Item ID</font></b></TH>
<TH BGCOLOR="#cccccc"><b><font size="2">Description</font></b></TH>
<TH BGCOLOR="#cccccc"><b><font size="2">Ordered Quantity</font></b></TH>
<TH BGCOLOR="#cccccc"><b><font size="2">Unit Cost</font></b></TH>
			</TR>
			<xsl:for-each select="OrderLines/OrderLine">
				<TR class="Items">
				<TD align="center"><b><font size="-2"><xsl:value-of select="Item/@ItemID"/></font></b></TD>		
				<TD align="center"><b><font size="-2"><xsl:value-of select="Item/@ItemDesc"/></font></b></TD>		
				<TD align="center"><b><font size="-2"><xsl:value-of select="@OrderedQty"/></font></b></TD>		
				<TD align="center"><b><font size="-2"><xsl:value-of select="Item/@UnitCost"/></font></b></TD>		
				</TR>

			</xsl:for-each>
		</TABLE>

<P></P>

<BR/><BR/>Thank you for shopping with us and hope you visit our site soon.<BR/><BR/>

Sincerely,<BR/>
Customer Service Manager.<BR/><BR/>

</xsl:template>		
</xsl:stylesheet>
