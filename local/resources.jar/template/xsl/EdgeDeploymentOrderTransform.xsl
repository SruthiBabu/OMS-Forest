<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Licensed Materials - Property of IBM
IBM Sterling Selling and Fulfillment Suite
(C) Copyright IBM Corp. 2014 All Rights Reserved.
US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output indent="yes" />
	<xsl:strip-space elements="*" />
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*" />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="OrderAuditList">
		<OrderAudits>
			<xsl:apply-templates select="node()" />
		</OrderAudits>
	</xsl:template>
	<xsl:template match="PaymentMethod">
		<PaymentMethod>
			<xsl:copy-of select="@*[name()!='PaymentKey' and name()!='BillToKey' and name()!='TotalAuthorized' and name()!='TotalRefundedAmount' and name()!='TotalCharged' and name()!='AwaitingAuthInterfaceAmount' and name()!='AwaitingChargeInterfaceAmount' and name()!='FundsAvailable' and name()!='GetFundsAvailableUserExitInvoked' and name()!='IncompletePaymentType' and name()!='PaymentTemplateType' and name()!='PaymentTypeGroup' and name()!='PrimaryAccountNo' and name()!='RequestedAuthAmount' and name()!='RequestedChargeAmount' and name()!='RequestedRefundAmount' and name()!='TotalAltRefundedAmount' and name()!='DisplayPrimaryAccountNo']"></xsl:copy-of>
			<PaymentDetailsList>
				<xsl:apply-templates
					select="../../ChargeTransactionDetails/ChargeTransactionDetail[@ChargeType='CHARGE' or @ChargeType='AUTHORIZATION']">
					<xsl:with-param name="PaymentMethodPaymentKey" select="@PaymentKey"></xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="PersonInfoBillTo"/>
			</PaymentDetailsList>
		</PaymentMethod>
	</xsl:template>
	<xsl:template match="ChargeTransactionDetails/ChargeTransactionDetail[@ChargeType='CHARGE' or @ChargeType='AUTHORIZATION']">
		<xsl:param name="PaymentMethodPaymentKey" />
		<xsl:variable name="ChargePaymentKey" select="@PaymentKey"></xsl:variable>
		<xsl:if test="$PaymentMethodPaymentKey  = $ChargePaymentKey">
			<PaymentDetails>
				<xsl:attribute name="ProcessedAmount">
				    <xsl:if test="@ChargeType='CHARGE'"><xsl:value-of select="@CreditAmount" /></xsl:if>
				    <xsl:if test="@ChargeType='AUTHORIZATION'"><xsl:value-of select="@OpenAuthorizedAmount" /></xsl:if>
				</xsl:attribute>
				<xsl:attribute name="RequestProcessed">         
				    <xsl:if test="@Status = 'CLOSED'">Y</xsl:if>      
				    <xsl:if test="@Status = 'CHECKED'">Y</xsl:if>
				    <xsl:if test="@Status = 'OPEN'">N</xsl:if>             
				</xsl:attribute>
				<xsl:copy-of
					select="@AuditTransactionId|@AuthorizationExpirationDate|@AuthorizationID|@CallForAuthorizationStatus|@CashBackAmount|@ChargeType|@CollectionDate|@HoldAgainstBook|@InPerson|@RequestAmount|@VoidTransaction|@ProcessedAmount|@OfflineStatus|@RequestProcessed|@PaymentEntryType|@ChargeTransactionKey">
				</xsl:copy-of>
				<xsl:copy-of
					select="CreditCardTransactions/CreditCardTransaction/@AuthAvs|CreditCardTransactions/CreditCardTransaction/@AuthCode|CreditCardTransactions/CreditCardTransaction/@AuthReturnCode|CreditCardTransactions/CreditCardTransaction/@AuthReturnFlag|CreditCardTransactions/CreditCardTransaction/@AuthReturnMessage|CreditCardTransactions/CreditCardTransaction/@AuthTime|CreditCardTransactions/CreditCardTransaction/@CVVAuthCode|CreditCardTransactions/CreditCardTransaction/@InternalReturnCode|CreditCardTransactions/CreditCardTransaction/@InternalReturnFlag|CreditCardTransactions/CreditCardTransaction/@InternalReturnMessage|CreditCardTransactions/CreditCardTransaction/@ Reference1|CreditCardTransactions/CreditCardTransaction/@Reference2|CreditCardTransactions/CreditCardTransaction/@RequestId|CreditCardTransactions/CreditCardTransaction/@TranRequestTime|CreditCardTransactions/CreditCardTransaction/@TranReturnCode|CreditCardTransactions/CreditCardTransaction/@TranReturnFlag|CreditCardTransactions/CreditCardTransaction/@TranReturnMessage|CreditCardTransactions/CreditCardTransaction/@TranType">
				</xsl:copy-of>
			</PaymentDetails>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Awards/Award[@PromotionId='']">
	</xsl:template>
	<xsl:template
		match="ExchangeOrders|CapacityAllocations|ServiceAssociations|ProductAssociations|DeliveryAssociations|WorkOrders|AllowedModifications|LineOverallTotals|LineInvoicedTotals|LineRemainingTotals|OrderStatuses|ChargeTransactionDetails|OverallTotals|InvoicedTotals|RemainingTotals|Schedules|OrderLineSerialNumberList|RemainingFinancialTotals" />
	<xsl:template
		match="@TotalNumberOfRecords|@PromotionKey|@ChargeNameKey|@PersonInfoKey|@BillToKey|@ShipToKey|@SoldToKey|@AwardKey|@AnswerSetTranKey|@AnswerTranKey|@OpportunityKey|@FileAttachmentKey|@OrderSearchConditionKey|@OrderLineOptionKey|@OrderHoldTypeLogKey"/>
</xsl:stylesheet>
