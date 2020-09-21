<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:lxslt="http://xml.apache.org/xslt"
                version="1.0">

<xsl:template match="/">
<HTML>
<xsl:comment>RECIPIENTS=<xsl:value-of select="/Returns/Return/CustomerInfo/@EmailID"/></xsl:comment>
<xsl:comment>CC_RECIPIENTS=returns@yourcompany.com</xsl:comment>
<xsl:comment>FROM=returns@yourcompany.com</xsl:comment>
<xsl:comment>SUBJECT=Create Return: Sample email (TranID: YRET_CREATE_RETURN; Event: NOTIFY_MAIL) using XMLand XSL</xsl:comment>
<xsl:comment>CONTENT_TYPE=text/html</xsl:comment>
<HEAD>
	<title>Return Confirmation</title>
</HEAD>

<BODY topmargin="0" leftmargin="0">
	<BR/><BR/><font>Dear <xsl:value-of select="/Returns/Return/CustomerInfo/@FirstName"/>&#160;<xsl:value-of select="/Returns/Return/CustomerInfo/@LastName"/>,</font><BR/><BR/>
	<font>We have received your request to return the following items:</font>
	<xsl:apply-templates select="Returns"/>
</BODY>
</HTML>
</xsl:template>

<xsl:template match="Returns">
	<xsl:for-each select="Return">
		<BR/><BR/><BR/><P><font><B>Return Number : <xsl:value-of select="@ReturnNo"/></B></font></P>
<TABLE class="listTable" BORDER="1" WIDTH="50%" CELLSPACING="0" CELLPADDING="3" borderColor="#336699">
	<TR>
		<TD width="50%">
		<div class="listhead">
			<b>Ship items to</b>
		</div>
		<div class="Address">
			<xsl:value-of select="ShipTo/@FirstName"/>&#160;<xsl:value-of select="ShipTo/@LastName"/><BR/>
			<xsl:value-of select="ShipTo/@AddressLine1"/><BR/>
			<xsl:value-of select="ShipTo/@AddressLine2"/><BR/>
			<xsl:value-of select="ShipTo/@City"/>, <xsl:value-of select="ShipTo/@State"/>&#160;<xsl:value-of select="ShipTo/@ZipCode"/><BR/>
			<xsl:value-of select="ShipTo/@Country"/>
		</div>
		</TD>
	</TR>
</TABLE><BR/>
		<TABLE BORDER="2" WIDTH="50%" CELLSPACING="0"  CELLPADDING="3" borderColor="#e0e0e0">
			<TR>
			<TH BGCOLOR="#cccccc"><b><font size="2">Return Type</font></b></TH>
			<TH BGCOLOR="#cccccc"><b><font size="-1">Reason</font></b></TH>		
			<TH BGCOLOR="#cccccc"><b><font size="-1">Item</font></b></TH>		
			<TH BGCOLOR="#cccccc"><b><font size="2">Description</font></b></TH>		
			<TH BGCOLOR="#cccccc"><b><font size="2">Quantity</font></b></TH>		
			</TR>
			<xsl:for-each select="ReturnLines/ReturnLine">
				<TR class="ReturnReleaseHeader">
				<TD align="center"><b><font size="-2"><xsl:value-of select="@ReturnType"/></font></b></TD>
				<TD align="center"><b><font size="-2"><xsl:value-of select="@ReturnReason"/></font></b></TD>		
				<TD align="center"><b><font size="-2"><xsl:value-of select="Item/@ItemID"/></font></b></TD>		
				<TD align="center"><b><font size="-2"><xsl:value-of select="Item/@ItemDesc"/></font></b></TD>		
				<TD align="center"><b><font size="-2"><xsl:value-of select="@Quantity"/></font></b></TD>		
				</TR>
			</xsl:for-each>
		</TABLE>
	</xsl:for-each>

<P></P>

Thank you for shopping with us and hope you visit our site soon.<BR/><BR/>

Sincerely,<BR/>
Customer Service Manager.<BR/><BR/>

</xsl:template>		
</xsl:stylesheet>
