package com.ue;

import java.util.HashMap;
import java.util.Map;

import org.omg.CORBA.StringHolder;

import com.yantra.pca.bridge.YCDFoundationBridge;
import com.yantra.pca.ycd.ue.utils.YCDPaymentUEXMLManager;
import com.yantra.pca.ycd.utils.YCDXMLUtils;
import com.yantra.shared.dbclasses.YFS_Charge_TransactionDBHome;
import com.yantra.shared.dbi.YFS_Charge_Transaction;
import com.yantra.shared.dbi.YFS_Order_Header;
import com.yantra.shared.dbi.YFS_Payment_Type;
import com.yantra.shared.ycd.YCDErrorCodes;
import com.yantra.shared.ycd.YCDServiceNames;
import com.yantra.shared.ycp.YFSContext;
import com.yantra.util.YFCUtils;
import com.yantra.yfc.core.YFCObject;
import com.yantra.yfc.dom.YFCDocument;
import com.yantra.yfc.dom.YFCElement;
import com.yantra.yfc.log.YFCLogCategory;
import com.yantra.yfc.util.YFCDataBuf;
import com.yantra.yfc.util.YFCException;
import com.yantra.yfs.japi.YFSEnvironment;
import com.yantra.yfs.japi.YFSExtnPaymentCollectionInputStruct;
import com.yantra.yfs.japi.YFSExtnPaymentCollectionOutputStruct;
import com.yantra.yfs.japi.YFSUserExitException;
import com.yantra.yfs.japi.ue.YFSCollectionCreditCardUE;

public class YCDCollectionCreditCardUEImpl
  implements YFSCollectionCreditCardUE, YCDErrorCodes, YCDServiceNames
{
  public static YFCLogCategory cat = YFCLogCategory.instance(YCDCollectionCreditCardUEImpl.class);
  private static YCDFoundationBridge bridge = YCDFoundationBridge.getInstance();
  
  public YCDCollectionCreditCardUEImpl() { cat.debug("Entering YCDCollectionCreditCardUEImpl"); }

  public YFSExtnPaymentCollectionOutputStruct collectionCreditCard(YFSEnvironment oEnv, YFSExtnPaymentCollectionInputStruct paymentInputStruct) throws YFSUserExitException {
    cat.beginTimer("YCDCollectionCreditCardUEImpl");
    
    
    paymentInputStruct.orderNo = "TC50171_3";
    paymentInputStruct.billToFirstName="John";
    paymentInputStruct.billToLastName="Doe";
    paymentInputStruct.billToAddressLine1="1 Market St";
    paymentInputStruct.billToCity="san francisco";
    paymentInputStruct.billToState="CA";
    paymentInputStruct.billToZipCode="94105";
    paymentInputStruct.billToCountry="US";
    paymentInputStruct.billToEmailId="test@cybs.com";
    paymentInputStruct.billToDayPhone="4158880000";
    paymentInputStruct.creditCardNo="5555555555554444";
    paymentInputStruct.creditCardExpirationDate="12/2031";
    paymentInputStruct.currency = "USD";

    paymentInputStruct.requestAmount = 10.20;
    paymentInputStruct.chargeType = "AUTHORIZATION";
    
    
    YFSContext oCtx = (YFSContext)oEnv;
    
    YFSExtnPaymentCollectionOutputStruct paymentOutputStruct = new YFSExtnPaymentCollectionOutputStruct();
    
    try {
      YFCDocument paymentInputDoc = YCDPaymentUEXMLManager.convertPaymentInputStructToXML(paymentInputStruct);
      
      cat.debug("convertPaymentInputStructToXML :" + paymentInputDoc.getString());
      
      YFCDocument collectionOutputDoc = executeCreditCardService(oCtx, "YCD_ExecuteCollectionCreditCard_Proxy_1.0", paymentInputDoc);
      
      cat.debug("Collection Output XML = " + collectionOutputDoc.getString());
      
      if (collectionOutputDoc != null)
      {
        YFCElement root = collectionOutputDoc.getDocumentElement();
        
        String sOrderHeaderKey = paymentInputDoc.getDocumentElement().getAttribute("OrderHeaderKey");
        
        YFS_Order_Header oOrder = bridge.getOrderHeader(oCtx, sOrderHeaderKey, null, null, null, "WAIT", false);

        
        String sTranID = bridge.getFulfillmentTransactionId(oCtx, "PAYMENT_EXECUTION", oOrder.getDocument_Type());
        
        String sResponseCode = root.getAttribute("ResponseCode");
        
        if (!YFCObject.equals(sResponseCode, "APPROVED") && 
          !YFCObject.equals(sResponseCode, "HARD_DECLINED") && 
          !YFCObject.equals(sResponseCode, "SOFT_DECLINED") && 
          !YFCObject.equals(sResponseCode, "BANK_HOLD") && 
          !YFCObject.equals(sResponseCode, "SERVICE_UNAVAILABLE")) {
          
          YFCException ex = new YFCException("YCD00001");
          ex.setAttribute("ResponseCode", sResponseCode);
          throw ex;
        } 
        
        paymentOutputStruct = constructBasicCollectionCreditCardOutput(collectionOutputDoc);
        
        if (YFCObject.equals(sResponseCode, "HARD_DECLINED"))
        {
          boolean bAuthStrikeLimitReached = processAuthStrikes(oCtx, collectionOutputDoc, oOrder);
          
          paymentOutputStruct.authorizationAmount = 0.0D;
          if (!YFCObject.isVoid(collectionOutputDoc.getDocumentElement().getAttribute("retryFlag"))) {
            paymentOutputStruct.retryFlag = collectionOutputDoc.getDocumentElement().getAttribute("retryFlag");
          } else {
            paymentOutputStruct.retryFlag = "N";
          } 
          
          if (!YFCObject.isVoid(collectionOutputDoc.getDocumentElement().getAttribute("suspendPayment"))) {
            paymentOutputStruct.suspendPayment = collectionOutputDoc.getDocumentElement().getAttribute("suspendPayment");
          } else {
            paymentOutputStruct.suspendPayment = "Y";
          } 

          
          YFCDocument eventDoc = prepareEventDoc(oCtx, oOrder, paymentInputStruct, paymentOutputStruct, sResponseCode, sTranID);
          
          if (bAuthStrikeLimitReached) {
            YFCElement eventRoot = eventDoc.getDocumentElement();
            YFCElement failureElem = eventRoot.getChildElement("CollectionFailureDetails");
            failureElem.setAttribute("FailureReasonCode", "YCD_AUTH_RETRY_LIMIT");
          } 
          raiseEvent(oCtx, oOrder, paymentInputStruct, paymentOutputStruct, eventDoc, sTranID);
        }
        else if (YFCObject.equals(sResponseCode, "SOFT_DECLINED") || 
          YFCObject.equals(sResponseCode, "BANK_HOLD"))
        {
          paymentOutputStruct.authorizationAmount = 0.0D;
          if (!YFCObject.isVoid(collectionOutputDoc.getDocumentElement().getAttribute("retryFlag"))) {
            paymentOutputStruct.retryFlag = collectionOutputDoc.getDocumentElement().getAttribute("retryFlag");
          } else {
            paymentOutputStruct.retryFlag = "N";
          } 
          
          if (!YFCObject.isVoid(collectionOutputDoc.getDocumentElement().getAttribute("suspendPayment"))) {
            paymentOutputStruct.suspendPayment = collectionOutputDoc.getDocumentElement().getAttribute("suspendPayment");
          } else {
            paymentOutputStruct.suspendPayment = "Y";
          } 
          
          YFCDocument eventDoc = prepareEventDoc(oCtx, oOrder, paymentInputStruct, paymentOutputStruct, sResponseCode, sTranID);
          raiseEvent(oCtx, oOrder, paymentInputStruct, paymentOutputStruct, eventDoc, sTranID);
        }
        else if (YFCObject.equals(sResponseCode, "SERVICE_UNAVAILABLE"))
        {
          paymentOutputStruct.authorizationAmount = 0.0D;
          if (!YFCObject.isVoid(collectionOutputDoc.getDocumentElement().getAttribute("retryFlag"))) {
            paymentOutputStruct.retryFlag = collectionOutputDoc.getDocumentElement().getAttribute("retryFlag");
          } else {
            paymentOutputStruct.retryFlag = "Y";
          } 
          
          if (!YFCObject.isVoid(collectionOutputDoc.getDocumentElement().getAttribute("suspendPayment"))) {
            paymentOutputStruct.suspendPayment = collectionOutputDoc.getDocumentElement().getAttribute("suspendPayment");
          } else {
            paymentOutputStruct.suspendPayment = "N";
          } 
          
          YFCDocument eventDoc = prepareEventDoc(oCtx, oOrder, paymentInputStruct, paymentOutputStruct, sResponseCode, sTranID);
          raiseEvent(oCtx, oOrder, paymentInputStruct, paymentOutputStruct, eventDoc, sTranID);
        }
        else if (YFCObject.equals(sResponseCode, "APPROVED"))
        {
          paymentOutputStruct.authorizationAmount = collectionOutputDoc.getDocumentElement().getDoubleAttribute("AuthorizationAmount");
          paymentOutputStruct.authorizationExpirationDate = collectionOutputDoc.getDocumentElement().getAttribute("AuthorizationExpirationDate");
          paymentOutputStruct.authTime = collectionOutputDoc.getDocumentElement().getAttribute("AuthTime");
          if (!YFCObject.isVoid(collectionOutputDoc.getDocumentElement().getAttribute("retryFlag"))) {
            paymentOutputStruct.retryFlag = collectionOutputDoc.getDocumentElement().getAttribute("retryFlag");
          } else {
            paymentOutputStruct.retryFlag = "N";
          } 
          
          if (!YFCObject.isVoid(collectionOutputDoc.getDocumentElement().getAttribute("suspendPayment"))) {
            paymentOutputStruct.suspendPayment = collectionOutputDoc.getDocumentElement().getAttribute("suspendPayment");
          } else {
            paymentOutputStruct.suspendPayment = "N";
          } 
          
          paymentOutputStruct.tranAmount = Double.parseDouble(collectionOutputDoc.getDocumentElement().getAttribute("TranAmount"));
          paymentOutputStruct.sCVVAuthCode = collectionOutputDoc.getDocumentElement().getAttribute("SCVVAuthCode");
        }
      
      }
    
    }
    catch (YFCException e) {
      throw e;
    } catch (Exception e) {
      YFSUserExitException ex = new YFSUserExitException(e.getMessage());
      throw ex;
    } finally {
      cat.endTimer("YCDCollectionCreditCardUEImpl");
      cat.debug("Exiting YCDCollectionCreditCardUEImpl");
    } 
    
    return paymentOutputStruct;
  }

  
  private void raiseEvent(YFSContext oCtx, YFS_Order_Header oOrder, YFSExtnPaymentCollectionInputStruct paymentInputStruct, YFSExtnPaymentCollectionOutputStruct paymentOutputStruct, YFCDocument eventDoc, String sTranID) {
    boolean bEventReqd = bridge.isRaiseEventRequired(oCtx, sTranID, "COLLECTION_FAILED");
    if (bEventReqd) {
      YFCDataBuf sKeyData = oOrder.getOrderHeaderBuf(oCtx);
      
      bridge.raiseEvent(oCtx, sKeyData, eventDoc, sTranID, "COLLECTION_FAILED");
    } 
  }

  
  private YFCDocument getTemplate(YFSContext oCtx, YFS_Order_Header oOrder, String sTranID) {
    Map bufParams = new HashMap();
    bufParams.put("EnterpriseCode", oOrder.getEnterprise_Key());
    bufParams.put("DocumentType", oOrder.getDocument_Type());
    
    return bridge.getEventTemplate(oCtx, sTranID, "COLLECTION_FAILED", oOrder.getEnterprise_Key(), oOrder.getDocument_Type());
  }




  
  private YFCDocument prepareEventDoc(YFSContext oCtx, YFS_Order_Header oOrder, YFSExtnPaymentCollectionInputStruct paymentInputStruct, YFSExtnPaymentCollectionOutputStruct paymentOutputStruct, String sResponseCode, String sTranID) {
    YFCDocument templateDoc = getTemplate(oCtx, oOrder, sTranID);
    YFCDocument eventDoc = bridge.getOrderDetails(oCtx, oOrder, templateDoc);
    
    YFCElement root = eventDoc.getDocumentElement();
    if (root != null) {
      YFCElement failureDetails = root.createChild("CollectionFailureDetails");
      failureDetails.setAttribute("FailureReasonCode", sResponseCode);
      failureDetails.setAttribute("AuthReturnCode", paymentOutputStruct.authReturnCode);
      failureDetails.setAttribute("AuthReturnFlag", paymentOutputStruct.authReturnFlag);
      failureDetails.setAttribute("AuthReturnMessage", paymentOutputStruct.authReturnMessage);
      failureDetails.setAttribute("ChargeType", paymentOutputStruct.tranType);
      failureDetails.setAttribute("CreditCardExpirationDate", paymentInputStruct.creditCardExpirationDate);
      failureDetails.setAttribute("CreditCardName", paymentInputStruct.creditCardName);
      failureDetails.setAttribute("CreditCardNo", paymentInputStruct.creditCardNo);
      failureDetails.setAttribute("CreditCardType", paymentInputStruct.creditCardType);
      failureDetails.setAttribute("DisplaySvcNo", paymentOutputStruct.DisplaySvcNo);
      failureDetails.setAttribute("HoldOrderAndRaiseEvent", paymentOutputStruct.holdOrderAndRaiseEvent);
      failureDetails.setAttribute("HoldReason", paymentOutputStruct.holdReason);
      failureDetails.setAttribute("InternalReturnCode", paymentOutputStruct.internalReturnCode);
      failureDetails.setAttribute("InternalReturnFlag", paymentOutputStruct.internalReturnFlag);
      failureDetails.setAttribute("InternalReturnMessage", paymentOutputStruct.internalReturnMessage);
      failureDetails.setAttribute("PaymentReference1", paymentOutputStruct.PaymentReference1);
      failureDetails.setAttribute("PaymentReference2", paymentOutputStruct.PaymentReference2);
      failureDetails.setAttribute("PaymentReference3", paymentOutputStruct.PaymentReference3);
      failureDetails.setAttribute("PaymentReference4", paymentOutputStruct.PaymentReference4);
      failureDetails.setAttribute("PaymentReference5", paymentOutputStruct.PaymentReference5);
      failureDetails.setAttribute("PaymentReference6", paymentOutputStruct.PaymentReference6);
      failureDetails.setAttribute("PaymentReference7", paymentOutputStruct.PaymentReference7);
      failureDetails.setAttribute("PaymentReference8", paymentOutputStruct.PaymentReference8);
      failureDetails.setAttribute("PaymentReference9", paymentOutputStruct.PaymentReference9);
      failureDetails.setAttribute("PaymentType", paymentInputStruct.paymentType);
      failureDetails.setAttribute("RequestAmount", paymentInputStruct.requestAmount);
      failureDetails.setAttribute("SvcNo", paymentInputStruct.svcNo);
      failureDetails.setAttribute("TranAmount", paymentOutputStruct.tranAmount);
      failureDetails.setAttribute("TranRequestTime", paymentOutputStruct.tranRequestTime);
      failureDetails.setAttribute("TranReturnCode", paymentOutputStruct.tranReturnCode);
      failureDetails.setAttribute("TranReturnFlag", paymentOutputStruct.tranReturnFlag);
      failureDetails.setAttribute("TranReturnMessage", paymentOutputStruct.tranReturnMessage);
      failureDetails.setAttribute("TranType", paymentOutputStruct.tranType);
      failureDetails.setAttribute("AuthTime", paymentOutputStruct.authTime);
      failureDetails.setAttribute("AuthAVS", paymentOutputStruct.authAVS);
      failureDetails.setAttribute("CVVAuthCode", paymentOutputStruct.sCVVAuthCode);

      
      if (!YFCObject.isVoid(paymentOutputStruct.eleExtendedFields)) {
        YFCDocument doc = YFCDocument.getDocumentFor(paymentOutputStruct.eleExtendedFields);
        YCDXMLUtils.mergeElements(failureDetails.createChild(paymentOutputStruct.eleExtendedFields.getDocumentElement().getTagName()), doc.getDocumentElement());
      } 
      
      YFS_Charge_Transaction oChgTran = YFS_Charge_TransactionDBHome.getInstance().selectWithPK(oCtx, paymentInputStruct.chargeTransactionKey);
      
      if (oChgTran != null) {
        YFS_Payment_Type oType = oChgTran.getPayment().getPaymentType();
        if (oType != null) {
          failureDetails.setAttribute("PaymentTypeGroup", oType.getPayment_Type_Group());
        }
        failureDetails.setAttribute("DisplayCreditCardNo", "************" + oChgTran.getPayment().getDisplay_Credit_Card_No());
      } 
    } 
    
    cat.debug("event doc created : " + eventDoc.getString());
    return eventDoc;
  }
  
  private YFCDocument executeCreditCardService(YFSContext oCtx, String sServiceName, YFCDocument serviceInputDoc) throws Exception {
	  
  return bridge.executeService(oCtx, sServiceName, serviceInputDoc); }
  
  private boolean processAuthStrikes(YFSContext oCtx, YFCDocument collectionOutputDoc, YFS_Order_Header oOrder) {
    long lAuthStrikesCount = oOrder.getNo_Of_Auth_Strikes().longValue();
    lAuthStrikesCount++;
    oOrder.setNo_Of_Auth_Strikes(lAuthStrikesCount);
    
    long lAuthStrikesLimit = getAuthStrikesLimit(oCtx, oOrder);
    
    boolean bAuthStrikeLimitReached = false;
    
    if (lAuthStrikesCount >= lAuthStrikesLimit) {
      bAuthStrikeLimitReached = true;
    }
    
    return bAuthStrikeLimitReached;
  }

  
  private long getAuthStrikesLimit(YFSContext oCtx, YFS_Order_Header oOrder) {
    YFCDataBuf dataBuf = new YFCDataBuf();
    dataBuf.append("EnterpriseCode", oOrder.getEnterprise_Key());
    dataBuf.append("DocumentType", oOrder.getDocument_Type());
    
    StringHolder sAuthStrikes = new StringHolder();
    bridge.getSystemRules(oCtx, dataBuf, null, "YCD_AUTH_RETRY_LIMIT", sAuthStrikes);
    
    long lAuthStrikes = 0L;
    if (!YFCObject.isVoid(sAuthStrikes.value)) {
      lAuthStrikes = YFCUtils.longfromString(sAuthStrikes.value);
    }
    
    return lAuthStrikes;
  }

  
  private YFSExtnPaymentCollectionOutputStruct constructBasicCollectionCreditCardOutput(YFCDocument paymentOutputDoc) {
    YFSExtnPaymentCollectionOutputStruct paymentOutputStruct = new YFSExtnPaymentCollectionOutputStruct();

    
    try {
      YCDPaymentUEXMLManager.populatePaymentOutputStructFromXML(paymentOutputStruct, paymentOutputDoc);
    } catch (Exception e) {
      e.printStackTrace();
    } 
    
    return paymentOutputStruct;
  }
  
  public static void main(String[] args) {
		YCDCollectionCreditCardUEImpl ueimp = new YCDCollectionCreditCardUEImpl();
		
		try {
			System.out.println(ueimp.collectionCreditCard(null, new YFSExtnPaymentCollectionInputStruct()));
		} catch (YFSUserExitException e) {
			
			e.printStackTrace();
		}
	}
}
