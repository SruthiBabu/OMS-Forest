package com.ue;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Properties;

import org.apache.commons.json.JSONException;
import org.apache.commons.json.JSONObject;
import org.w3c.dom.Document;

import com.fahm.forest.utils.CyberSourceUtils;
import com.yantra.interop.japi.YIFCustomApi;
import com.yantra.yfc.date.YTimestamp;
import com.yantra.yfc.dom.YFCDocument;
import com.yantra.yfc.dom.YFCElement;
import com.yantra.yfc.log.YFCLogCategory;
import com.yantra.yfc.util.YFCException;
import com.yantra.yfs.japi.YFSEnvironment;

public class FAHMExecuteCollectionCreditCard implements YIFCustomApi{
	
	private Properties _properties = null;

	@Override
	public void setProperties(Properties prop) throws Exception {
		this._properties = prop;
		
	}
	private static YFCLogCategory cat = YFCLogCategory.instance(FAHMExecuteCollectionCreditCard.class.getName());
	
	public Document executeCollectionCreditCard(YFSEnvironment oEnv, Document inputDoc) throws JSONException {
		
		String sResponseCode = "";
		
		YFCDocument inDoc = YFCDocument.getDocumentFor(inputDoc);
	    YFCElement root = inDoc.getDocumentElement();
	    
	    System.out.println("indoc" + inDoc);
	    
	    	String reason = "testing";
			
			String[] dmy =  root.getAttribute("CreditCardExpirationDate").split("/");
			String sMonth = "";
			String sYear = "";
			if(dmy.length == 2){
				sMonth = dmy[0];
				sYear = dmy[1];
			} else if(dmy.length == 3){
				sMonth = dmy[0];
				sYear = dmy[2];
			}

			String payrequest = "{\n" +
                    "  \"clientReferenceInformation\": {\n" +
                    "    \"code\": \"" + root.getAttribute("OrderNo") + "\"\n" +
                    "  },\n" +
                    "  \"processingInformation\": {\n" +
                    "    \"commerceIndicator\": \"internet\"\n" +
                    "  },\n" +
                    "  \"orderInformation\": {\n" +
                    "    \"billTo\": {\n" +
                    "      \"firstName\": \"" + root.getAttribute("BillToFirstName") + "\",\n" +
                    "      \"lastName\": \"" + root.getAttribute("BillToLastName") + "\",\n" +
                    "      \"address1\": \"" + root.getAttribute("BillToAddressLine1") + "\",\n" +
                    "      \"postalCode\": \"" + root.getAttribute("BillToZipCode") + "\",\n" +
                    "      \"locality\": \"" + root.getAttribute("BillToCity") + "\",\n" +
                    "      \"administrativeArea\": \"" + root.getAttribute("BillToState") + "\",\n" +
                    "      \"country\": \"" + root.getAttribute("BillToCountry") + "\",\n" +
                    "      \"phoneNumber\": \"" + root.getAttribute("BillToDayPhone") + "\",\n" +
                    "      \"email\": \"" + root.getAttribute("BillToEmailId") + "\"\n" +
                    "    },\n" +
                    "    \"amountDetails\": {\n" +
                    "      \"totalAmount\": \"" + root.getAttribute("RequestAmount") + "\",\n" +
                    "      \"currency\": \"" + root.getAttribute("Currency") + "\"\n" +
                    "    }\n" +
                    "  },\n" +
                    "  \"paymentInformation\": {\n" +
                    "    \"card\": {\n" +
                    "      \"expirationYear\": \"" + sYear + "\",\n" +
                    "      \"number\": \"" + root.getAttribute("CreditCardNo") + "\",\n" +
                    "      \"securityCode\": \"" + root.getAttribute("SecureAuthenticationCode") + "\",\n" +
                    "      \"expirationMonth\": \"" + sMonth + "\"\n" +
                    "    }\n" +
                    "  }\n" +
                    "}";
			
			String caprequest = "{\n" +
                    "  \"clientReferenceInformation\": {\n" +
                    "    \"code\": \"" + root.getAttribute("OrderNo") + "\"\n" +
                    "  },\n" +
                    "  \"orderInformation\": {\n" +
                    "    \"amountDetails\": {\n" +
                    "      \"totalAmount\": \"" + root.getAttribute("RequestAmount") + "\",\n" +
                    "      \"currency\": \"" + root.getAttribute("Currency") + "\"\n" +
                    "    }\n" +
                    "  }\n" +
                    "}";
			
			double reqAmnt = Double.parseDouble(root.getAttribute("RequestAmount"));
			double reqAmount = Math.abs(reqAmnt);
			
			String revrequest = "{\n" +
                    "  \"clientReferenceInformation\": {\n" +
                    "    \"code\": \"" + root.getAttribute("OrderNo") + "\"\n" +
                    "  },\n" +
                    "  \"reversalInformation\": {\n" +
                    "    \"amountDetails\": {\n" +
                    "      \"totalAmount\": \"" + reqAmount + "\"\n" +
                    "    }\n" +
                    "  }\n" +
                    "}";
			
			JSONObject jsonOutput = new JSONObject();
			
			if((root.getAttribute("ChargeType").equals("AUTHORIZATION")) && (reqAmnt >= 0) ) {
				jsonOutput = CyberSourceUtils.callAuth(oEnv,payrequest);
			}else if ((root.getAttribute("ChargeType").equals("AUTHORIZATION")) && (reqAmnt < 0) ) {
				jsonOutput = CyberSourceUtils.callReversal(oEnv, revrequest, root.getAttribute("AuthorizationId"));
				System.out.println("reversal jsonOutput:" + jsonOutput);
			}else if ((root.getAttribute("ChargeType").equals("CHARGE")) && (reqAmnt >= 0) ) {
				jsonOutput = CyberSourceUtils.callCapture(oEnv,caprequest,root.getAttribute("AuthorizationId"));
				System.out.println("capture jsonOutput:" + jsonOutput);
			}else if ((root.getAttribute("ChargeType").equals("CHARGE")) && (reqAmnt < 0) ) {
				jsonOutput = CyberSourceUtils.callCaptureRefund(oEnv, caprequest, root.getAttribute("AuthorizationId"));
			}
			
				YFCDocument outDoc = constructOutputDoc(jsonOutput, inDoc, sResponseCode);
				
				System.out.println("jsonOutput:"  + jsonOutput);
			    
	    	    return outDoc.getDocument();
	}
	
	public YFCDocument constructOutputDoc(JSONObject obj, YFCDocument inDoc, String sResponseCode) throws JSONException{
	    YFCDocument outDoc = YFCDocument.createDocument();
	    
	    YFCElement root = inDoc.getDocumentElement();
	    
	    YFCElement paymentRoot = outDoc.createElement("Payment");
	    
	    try {
	    	System.out.println("status:" + obj.getString("status"));
	    	String responseCode = "";
	    	
	    	if((root.getAttribute("ChargeType").equals("AUTHORIZATION")) && (obj.getString("status").equals("AUTHORIZED"))) {  //status from CyberSource response payload
	    		responseCode = "APPROVED";
		    	paymentRoot.setAttribute("AuthReturnFlag", "T");
		        paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
		        paymentRoot.setAttribute("HoldReason", "");
		        paymentRoot.setAttribute("AsynchRequestProcess", "false");	    	
		    	paymentRoot.setAttribute("ResponseCode", responseCode); 
				JSONObject processorInformation = new JSONObject(obj.getString("processorInformation"));
		    	JSONObject avs = new JSONObject(processorInformation.getString("avs"));
		    	String avsCode = avs.getString("code");
		    	String authcode = processorInformation.getString("approvalCode");
		    	paymentRoot.setAttribute("AuthAVS", avsCode);   //code within avs from CyberSource response payload
		    	paymentRoot.setAttribute("AuthCode", authcode);  //approvalCode from CyberSource response payload		    	
		    	JSONObject orderInformation = new JSONObject(obj.getString("orderInformation"));
		    	JSONObject amountDetails = new JSONObject(orderInformation.getString("amountDetails"));
		    	String authorizedAmount = amountDetails.getString("authorizedAmount");
		    	paymentRoot.setAttribute("AuthorizationAmount", authorizedAmount );		    	
		    	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
				GregorianCalendar now = new GregorianCalendar();
				now.setTime(new Date());
				now.add(Calendar.DAY_OF_MONTH, 5);
		    	paymentRoot.setAttribute("AuthorizationExpirationDate", dateFormat.format(now.getTime()));		      
		    	String authID = obj.getString("id");
		    	paymentRoot.setAttribute("AuthorizationId", authID);		    	
		    	String respcode = processorInformation.getString("responseCode");
		    	paymentRoot.setAttribute("AuthReturnCode", respcode);		    	
		        paymentRoot.setAttribute("AuthReturnMessage", obj.getString("status"));
		        paymentRoot.setAttribute("AuthTime", YTimestamp.newMutableTimestamp().getString("yyyyMMdd'T'HH:mm:ss"));	
		        paymentRoot.setAttribute("TranAmount", root.getDoubleAttribute("RequestAmount"));
		        paymentRoot.setAttribute("TranType", root.getAttribute("ChargeType"));
	    	
	    	}else if((root.getAttribute("ChargeType").equals("AUTHORIZATION")) && (obj.getString("status").equals("DECLINED"))) {
	    		responseCode = "HARD_DECLINED";
	    		paymentRoot.setAttribute("AuthReturnFlag", "F");
	    		paymentRoot.setAttribute("ResponseCode", responseCode); 
	    		paymentRoot.setAttribute("AsynchRequestProcess", "false");
	    		paymentRoot.setAttribute("AuthReturnMessage", obj.getString("reason"));
	    		paymentRoot.setDoubleAttribute("AuthorizationAmount", 0.0D);
	    		paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
	  	        paymentRoot.setAttribute("HoldReason", " ");
	  	        paymentRoot.setDoubleAttribute("TranAmount", 0.0D);
	  	        paymentRoot.setAttribute("TranType", root.getAttribute("ChargeType"));
	  	        
	    	}else if((root.getAttribute("ChargeType").equals("AUTHORIZATION")) && (obj.getString("status").equals("INVALID_REQUEST"))) {
	    		responseCode = "SOFT_DECLINED";
	    		paymentRoot.setAttribute("AuthReturnFlag", "F");
	    		paymentRoot.setAttribute("ResponseCode", responseCode); 
	    		paymentRoot.setAttribute("AsynchRequestProcess", "false");
	    		paymentRoot.setAttribute("AuthReturnMessage", obj.getString("reason"));
	    		paymentRoot.setDoubleAttribute("AuthorizationAmount", 0.0D);
	    		paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
	  	        paymentRoot.setAttribute("HoldReason", " ");
	  	        paymentRoot.setDoubleAttribute("TranAmount", 0.0D);
	  	        paymentRoot.setAttribute("TranType", root.getAttribute("ChargeType"));
	  	        
	    	}else if((root.getAttribute("ChargeType").equals("AUTHORIZATION")) && (obj.getString("status").equals("SERVER_ERROR"))) {
	    		responseCode = "SERVICE_UNAVAILABLE";
	    		paymentRoot.setAttribute("AuthReturnFlag", "F");
	    		paymentRoot.setAttribute("ResponseCode", responseCode); 
	    		paymentRoot.setAttribute("AsynchRequestProcess", "false");
	    		paymentRoot.setAttribute("AuthReturnMessage", obj.getString("reason"));
	    		paymentRoot.setDoubleAttribute("AuthorizationAmount", 0.0D);
	    		paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
	  	        paymentRoot.setAttribute("HoldReason", " ");
	  	        paymentRoot.setDoubleAttribute("TranAmount", 0.0D);
	  	        paymentRoot.setAttribute("TranType", root.getAttribute("ChargeType"));
	  	        
	    	}else if((root.getAttribute("ChargeType").equals("AUTHORIZATION")) && (obj.getString("status").equals("REVERSED"))) {
	    		responseCode = "APPROVED";
	    		paymentRoot.setAttribute("AuthReturnFlag", "T");
		        paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
		        paymentRoot.setAttribute("HoldReason", "");
		        paymentRoot.setAttribute("AsynchRequestProcess", "false");	    	
		    	paymentRoot.setAttribute("ResponseCode", responseCode); 
		    	JSONObject reversalAmountDetails = new JSONObject(obj.getString("reversalAmountDetails"));
		    	String authorizationAmount = reversalAmountDetails.getString("reversedAmount");
		    	paymentRoot.setAttribute("AuthorizationAmount", authorizationAmount );
		    	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
				GregorianCalendar now = new GregorianCalendar();
				now.setTime(new Date());
				now.add(Calendar.DAY_OF_MONTH, 5);
		    	paymentRoot.setAttribute("AuthorizationExpirationDate", dateFormat.format(now.getTime()));
		    	paymentRoot.setAttribute("AuthTime", YTimestamp.newMutableTimestamp().getString("yyyyMMdd'T'HH:mm:ss"));
		    	paymentRoot.setAttribute("TranAmount", root.getDoubleAttribute("RequestAmount"));
	    		
	    	}else if((root.getAttribute("ChargeType").equals("CHARGE")) && (obj.getString("status").equals("INVALID_REQUEST"))) {
	    		responseCode = "SOFT_DECLINED";
	    		paymentRoot.setAttribute("AuthReturnFlag", "F");
	    		paymentRoot.setAttribute("ResponseCode", responseCode); 
	    		paymentRoot.setAttribute("AsynchRequestProcess", "false");
	    		paymentRoot.setAttribute("AuthReturnMessage", obj.getString("reason"));
	    		paymentRoot.setDoubleAttribute("AuthorizationAmount", 0.0D);
	    		paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
	  	        paymentRoot.setAttribute("HoldReason", " ");
	  	        paymentRoot.setDoubleAttribute("TranAmount", 0.0D);
	  	        paymentRoot.setAttribute("TranType", root.getAttribute("ChargeType"));

	    		
	    	}else if((root.getAttribute("ChargeType").equals("CHARGE")) && (obj.getString("status").equals("PENDING"))) {
	    		if(obj.has("refundAmountDetails")) {
	    			JSONObject refundAmountDetails = new JSONObject(obj.getString("refundAmountDetails"));
			    	String refundAmount = refundAmountDetails.getString("refundAmount");
			    	paymentRoot.setAttribute("AuthorizationAmount", refundAmount );	
			    	JSONObject orderInformation = new JSONObject(obj.getString("orderInformation"));
			    	JSONObject amountDetails = new JSONObject(orderInformation.getString("amountDetails"));
			    	String currency = amountDetails.getString("currency");
			    	paymentRoot.setAttribute("Currency", currency );
	    		}else {
	    			JSONObject orderInformation = new JSONObject(obj.getString("orderInformation"));
			    	JSONObject amountDetails = new JSONObject(orderInformation.getString("amountDetails"));
			    	String totalAmount = amountDetails.getString("totalAmount");
			    	paymentRoot.setAttribute("AuthorizationAmount", totalAmount );
	    		}
	    		responseCode = "APPROVED";
	    		paymentRoot.setAttribute("AuthReturnFlag", "T");
		        paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
		        paymentRoot.setAttribute("HoldReason", "");
		        paymentRoot.setAttribute("AsynchRequestProcess", "false");	    	
		    	paymentRoot.setAttribute("ResponseCode", responseCode); 
		    	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
				GregorianCalendar now = new GregorianCalendar();
				now.setTime(new Date());
				now.add(Calendar.DAY_OF_MONTH, 5);
		    	paymentRoot.setAttribute("AuthorizationExpirationDate", dateFormat.format(now.getTime()));
		    	paymentRoot.setAttribute("AuthTime", YTimestamp.newMutableTimestamp().getString("yyyyMMdd'T'HH:mm:ss"));
		    	paymentRoot.setAttribute("TranAmount", root.getDoubleAttribute("RequestAmount"));
	    		
	    	}else {
	    		responseCode = "SERVICE_UNAVAILABLE";
	    		paymentRoot.setAttribute("AuthReturnFlag", "F");
	    		paymentRoot.setAttribute("ResponseCode", responseCode); 
	    		paymentRoot.setAttribute("AsynchRequestProcess", "false");
	    		paymentRoot.setAttribute("AuthReturnMessage", obj.getString("reason"));
	    		paymentRoot.setDoubleAttribute("AuthorizationAmount", 0.0D);
	    		paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
	  	        paymentRoot.setAttribute("HoldReason", " ");
	  	        paymentRoot.setDoubleAttribute("TranAmount", 0.0D);
	  	        paymentRoot.setAttribute("TranType", root.getAttribute("ChargeType"));
	    	}
	    	
	    } catch (JSONException e) {
	    	System.out.println(e.getStackTrace());
	    	throw e;
		}
	    outDoc.appendChild(paymentRoot);
	    return outDoc;
	    
	  }
	
}
