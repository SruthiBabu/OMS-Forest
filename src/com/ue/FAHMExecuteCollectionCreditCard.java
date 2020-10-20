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
import com.yantra.yfs.japi.YFSEnvironment;

public class FAHMExecuteCollectionCreditCard implements YIFCustomApi{
	
	private Properties _properties = null;

	@Override
	public void setProperties(Properties prop) throws Exception {
		this._properties = prop;
		
	}
	private static YFCLogCategory cat = YFCLogCategory.instance(FAHMExecuteCollectionCreditCard.class.getName());
	
	public Document executeCollectionCreditCard(YFSEnvironment oEnv, Document inputDoc) {
		
		String sResponseCode = "";
		
		YFCDocument inDoc = YFCDocument.getDocumentFor(inputDoc);
	    YFCElement root = inDoc.getDocumentElement();
			
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

			String request = "{\n" +
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
			
			JSONObject jsonOutput = new JSONObject();
			
			if(root.getAttribute("ChargeType").equals("AUTHORIZATION")) {
				jsonOutput = CyberSourceUtils.callAuth(oEnv,request);
			}else if (root.getAttribute("ChargeType").equals("CHARGE")) {
				jsonOutput = CyberSourceUtils.callCapture(oEnv,request,root.getAttribute("AuthorizationId"));
			} 
			
				YFCDocument outDoc = constructOutputDoc(jsonOutput, inDoc, sResponseCode);
			    
	    	    return outDoc.getDocument();
	}
	
	public YFCDocument constructOutputDoc(JSONObject obj, YFCDocument inDoc, String sResponseCode) {
	    YFCDocument outDoc = YFCDocument.createDocument();
	    
	    YFCElement root = inDoc.getDocumentElement();
	    
	    YFCElement paymentRoot = outDoc.createElement("Payment");
	    
	    try {
	    	
	    	String resposeCode = "";
	    	
	    	if(obj.getString("status").equals("AUTHORIZED")) {  //status from CyberSource response payload
	    		resposeCode = "APPROVED";
		    	paymentRoot.setAttribute("AuthReturnFlag", "T");
		        paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
		        paymentRoot.setAttribute("HoldReason", "");
		        paymentRoot.setAttribute("AsynchRequestProcess", "false");	    	
		    	paymentRoot.setAttribute("ResponseCode", resposeCode); 
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
	    	
	    	}else if(obj.getString("status").equals("DECLINED")) {
	    		resposeCode = "HARD_DECLINED";
	    		paymentRoot.setAttribute("AuthReturnFlag", "F");
	    		paymentRoot.setAttribute("ResponseCode", resposeCode); 
	    		paymentRoot.setAttribute("AsynchRequestProcess", "false");
	    		paymentRoot.setAttribute("AuthReturnMessage", obj.getString("reason"));
	    		paymentRoot.setDoubleAttribute("AuthorizationAmount", 0.0D);
	    		paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
	  	        paymentRoot.setAttribute("HoldReason", " ");
	  	        paymentRoot.setDoubleAttribute("TranAmount", 0.0D);
	  	        paymentRoot.setAttribute("TranType", root.getAttribute("ChargeType"));
	  	        
	    	}else if(obj.getString("status").equals("INVALID_REQUEST")) {
	    		resposeCode = "SOFT_DECLINED";
	    		paymentRoot.setAttribute("AuthReturnFlag", "F");
	    		paymentRoot.setAttribute("ResponseCode", resposeCode); 
	    		paymentRoot.setAttribute("AsynchRequestProcess", "false");
	    		paymentRoot.setAttribute("AuthReturnMessage", obj.getString("reason"));
	    		paymentRoot.setDoubleAttribute("AuthorizationAmount", 0.0D);
	    		paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
	  	        paymentRoot.setAttribute("HoldReason", " ");
	  	        paymentRoot.setDoubleAttribute("TranAmount", 0.0D);
	  	        paymentRoot.setAttribute("TranType", root.getAttribute("ChargeType"));
	  	        
	    	}else if(obj.getString("status").equals("SERVER_ERROR")) {
	    		resposeCode = "SERVICE_UNAVAILABLE";
	    		paymentRoot.setAttribute("AuthReturnFlag", "F");
	    		paymentRoot.setAttribute("ResponseCode", resposeCode); 
	    		paymentRoot.setAttribute("AsynchRequestProcess", "false");
	    		paymentRoot.setAttribute("AuthReturnMessage", obj.getString("reason"));
	    		paymentRoot.setDoubleAttribute("AuthorizationAmount", 0.0D);
	    		paymentRoot.setAttribute("HoldOrderAndRaiseEvent", "N");
	  	        paymentRoot.setAttribute("HoldReason", " ");
	  	        paymentRoot.setDoubleAttribute("TranAmount", 0.0D);
	  	        paymentRoot.setAttribute("TranType", root.getAttribute("ChargeType"));
	    	}
	        
	    } catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    outDoc.appendChild(paymentRoot);
	    return outDoc;
	    
	  }
	
}