package com.ue;

import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.apache.commons.json.JSONException;
import org.apache.commons.json.JSONObject;
import com.fahm.forest.utils.CyberSourceUtils;
import com.yantra.pca.ycd.ue.utils.YCDPaymentUEXMLManager;
import com.yantra.yfc.dom.YFCDocument;
import com.yantra.yfs.japi.YFSEnvironment;
import com.yantra.yfs.japi.YFSExtnPaymentCollectionInputStruct;
import com.yantra.yfs.japi.YFSExtnPaymentCollectionOutputStruct;
import com.yantra.yfs.japi.YFSUserExitException;
import com.yantra.yfs.japi.ue.YFSCollectionCreditCardUE;

public class FAHMCreditCardCollectionUEImpl implements YFSCollectionCreditCardUE{
  
    public static void main(String[] args) {
		FAHMCreditCardCollectionUEImpl temp = new FAHMCreditCardCollectionUEImpl();
		
		try {
			System.out.println(temp.collectionCreditCard(null, new YFSExtnPaymentCollectionInputStruct()));
		} catch (YFSUserExitException e) {
			
			e.printStackTrace();
		}
	}

	@Override
	public YFSExtnPaymentCollectionOutputStruct collectionCreditCard(YFSEnvironment arg0,
			YFSExtnPaymentCollectionInputStruct arg1) throws YFSUserExitException {
			
		arg1.orderNo = "TC50171_3";
		arg1.billToFirstName="John";
		arg1.billToLastName="Doe";
		arg1.billToAddressLine1="1 Market St";
		arg1.billToCity="san francisco";
		arg1.billToState="CA";
		arg1.billToZipCode="94105";
		arg1.billToCountry="US";
		arg1.billToEmailId="test@cybs.com";
		arg1.billToDayPhone="4158880000";
		arg1.creditCardNo="5555555555554444";
		arg1.creditCardExpirationDate="12/2031";
		arg1.currency = "USD";
		
		arg1.requestAmount = 10.20;
		arg1.chargeType = "AUTHORIZATION";
		//arg1.authorizationId = "6016137121056270204002";
		
		//arg1.secureAuthenticationCode = "123";
		
		String[] dmy =  arg1.creditCardExpirationDate.split("/");
		String sMonth = "";
		String sYear = "";
		if(dmy.length == 2){
			sMonth = dmy[0];
			sYear = dmy[1];
		} else if(dmy.length == 3){
			sMonth = dmy[0];
			sYear = dmy[2];
		}
				
		YFSExtnPaymentCollectionOutputStruct output = new YFSExtnPaymentCollectionOutputStruct();
		
		if(isValid(arg1)){
			if(isSystemDown(arg1)){
				YFSUserExitException ue = new YFSUserExitException();
				ue.setErrorCode("YFS023");
				ue.setErrorDescription("Payment_System_Down");
				throw ue;
			}

			String request = "{\n" +
                    "  \"clientReferenceInformation\": {\n" +
                    "    \"code\": \"" + arg1.orderNo + "\"\n" +
                    "  },\n" +
                    "  \"processingInformation\": {\n" +
                    "    \"commerceIndicator\": \"internet\"\n" +
                    "  },\n" +
                    "  \"orderInformation\": {\n" +
                    "    \"billTo\": {\n" +
                    "      \"firstName\": \"" + arg1.billToFirstName + "\",\n" +
                    "      \"lastName\": \"" + arg1.billToLastName + "\",\n" +
                    "      \"address1\": \"" + arg1.billToAddressLine1 + "\",\n" +
                    "      \"postalCode\": \"" + arg1.billToZipCode + "\",\n" +
                    "      \"locality\": \"" + arg1.billToCity + "\",\n" +
                    "      \"administrativeArea\": \"" + arg1.billToState + "\",\n" +
                    "      \"country\": \"" + arg1.billToCountry + "\",\n" +
                    "      \"phoneNumber\": \"" + arg1.billToDayPhone + "\",\n" +
                    "      \"email\": \"" + arg1.billToEmailId + "\"\n" +
                    "    },\n" +
                    "    \"amountDetails\": {\n" +
                    "      \"totalAmount\": \"" + arg1.requestAmount + "\",\n" +
                    "      \"currency\": \"" + arg1.currency + "\"\n" +
                    "    }\n" +
                    "  },\n" +
                    "  \"paymentInformation\": {\n" +
                    "    \"card\": {\n" +
                    "      \"expirationYear\": \"" + sYear + "\",\n" +
                    "      \"number\": \"" + arg1.creditCardNo + "\",\n" +
                    "      \"securityCode\": \"" + arg1.secureAuthenticationCode + "\",\n" +
                    "      \"expirationMonth\": \"" + sMonth + "\"\n" +
                    "    }\n" +
                    "  }\n" +
                    "}";
			
			JSONObject jsonOutput = new JSONObject();
			System.out.println(request);
			
			if(arg1.chargeType.equals("AUTHORIZATION")) {
				jsonOutput = CyberSourceUtils.callAuth(arg0,request);
			}else if (arg1.chargeType.equals("CHARGE")) {
				jsonOutput = CyberSourceUtils.callCapture(arg0,request,arg1.authorizationId);
			} /*else if (arg1.chargeType.equals("REVERSAL")) {
				jsonOutput = CyberSourceUtils.callReversal(arg0,request, arg1.authorizationId);
			}*/

				try {
				output.tranAmount = arg1.requestAmount;
				output.authorizationAmount = arg1.requestAmount;
				output.authorizationId = jsonOutput.getString("id");
				
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
				GregorianCalendar now = new GregorianCalendar();
				now.setTime(new Date());
				now.add(Calendar.DAY_OF_MONTH, 5);
				output.authorizationExpirationDate = dateFormat.format(now.getTime());
				
				output.authReturnMessage = jsonOutput.getString("status");
				
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		} 
		return output;
		
	}
	
	private boolean isSystemDown(YFSExtnPaymentCollectionInputStruct input){
		if(!isEncrypted(input)){
			if(input.creditCardNo.startsWith("12")){
				return true;
			}
		}
		return false;
	}
	
	private boolean isValid(YFSExtnPaymentCollectionInputStruct input){
		if(isEncrypted(input)){
			return true;
		} else {
			return true;
		}
	}
	
	private boolean isEncrypted(YFSExtnPaymentCollectionInputStruct input){
		if(input.creditCardNo.startsWith("IDES")){
			return true;
		} else if(input.creditCardNo.startsWith("E")){
			return true;
		}
		return false;
	}

}
