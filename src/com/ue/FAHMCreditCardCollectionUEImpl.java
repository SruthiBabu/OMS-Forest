package com.ue;

import java.util.Properties;

import com.cybersource.authsdk.core.MerchantConfig;
import com.data.Configuration;
import com.yantra.yfc.util.YFCCommon;
import com.yantra.yfs.japi.YFSEnvironment;
import com.yantra.yfs.japi.YFSExtnPaymentCollectionInputStruct;
import com.yantra.yfs.japi.YFSExtnPaymentCollectionOutputStruct;
import com.yantra.yfs.japi.YFSUserExitException;
import com.yantra.yfs.japi.ue.YFSCollectionCreditCardUE;

import Api.PaymentsApi;
import Invokers.ApiClient;
import Model.CreatePaymentRequest;
import Model.PtsV2PaymentsPost201Response;
import Model.Ptsv2paymentsClientReferenceInformation;
import Model.Ptsv2paymentsOrderInformation;
import Model.Ptsv2paymentsOrderInformationAmountDetails;
import Model.Ptsv2paymentsOrderInformationBillTo;
import Model.Ptsv2paymentsPaymentInformation;
import Model.Ptsv2paymentsPaymentInformationCard;
import Model.Ptsv2paymentsProcessingInformation;

public class FAHMCreditCardCollectionUEImpl implements YFSCollectionCreditCardUE{
	
	private static String responseCode = null;
	private static String status = null;
	private static Properties merchantProp;
	public static boolean userCapture = false;

	@Override
	public YFSExtnPaymentCollectionOutputStruct collectionCreditCard(YFSEnvironment arg0,
			YFSExtnPaymentCollectionInputStruct arg1) throws YFSUserExitException {
		
		YFSExtnPaymentCollectionOutputStruct output = new YFSExtnPaymentCollectionOutputStruct();
		
		CreatePaymentRequest requestObj = new CreatePaymentRequest();
		

		Ptsv2paymentsClientReferenceInformation clientReferenceInformation = new Ptsv2paymentsClientReferenceInformation();
		clientReferenceInformation.code(arg1.orderNo);
		requestObj.clientReferenceInformation(clientReferenceInformation);

		Ptsv2paymentsProcessingInformation processingInformation = new Ptsv2paymentsProcessingInformation();
		processingInformation.capture(false);
		if (userCapture) {
			processingInformation.capture(true);
		}
		
		requestObj.processingInformation(processingInformation);

		Ptsv2paymentsPaymentInformation paymentInformation = new Ptsv2paymentsPaymentInformation();
		Ptsv2paymentsPaymentInformationCard paymentInformationCard = new Ptsv2paymentsPaymentInformationCard();
		paymentInformationCard.number(arg1.creditCardNo);
		
		if(!YFCCommon.isVoid(arg1.creditCardExpirationDate)){
		
			String[] dmy =  arg1.creditCardExpirationDate.split("/");
			String sMonth = "";
			String sYear = "";
			if(dmy.length == 2){
				sMonth = dmy[0];
				sYear = dmy[1];
			} else if(dmy.length == 3){
				sMonth = dmy[0];
				sYear = dmy[2];
		
		paymentInformationCard.expirationMonth(sMonth);
		paymentInformationCard.expirationYear(sYear);
		paymentInformation.card(paymentInformationCard);
			}
		}
		requestObj.paymentInformation(paymentInformation);
	

		Ptsv2paymentsOrderInformation orderInformation = new Ptsv2paymentsOrderInformation();
		Ptsv2paymentsOrderInformationAmountDetails orderInformationAmountDetails = new Ptsv2paymentsOrderInformationAmountDetails();
		orderInformationAmountDetails.totalAmount(String.valueOf(arg1.requestAmount));
		orderInformationAmountDetails.currency(arg1.currency);
		orderInformation.amountDetails(orderInformationAmountDetails);

		Ptsv2paymentsOrderInformationBillTo orderInformationBillTo = new Ptsv2paymentsOrderInformationBillTo();
		orderInformationBillTo.firstName(arg1.billToFirstName);
		orderInformationBillTo.lastName(arg1.billToLastName);
		orderInformationBillTo.address1(arg1.billToAddressLine1);
		orderInformationBillTo.locality(arg1.billToCity);
		orderInformationBillTo.administrativeArea(arg1.billToState);
		orderInformationBillTo.postalCode(arg1.billToZipCode);
		orderInformationBillTo.country(arg1.billToCountry);
		orderInformationBillTo.email(arg1.billToEmailId);
		orderInformationBillTo.phoneNumber(arg1.billToDayPhone);
		orderInformation.billTo(orderInformationBillTo);

		requestObj.orderInformation(orderInformation);
		
		PtsV2PaymentsPost201Response result = null;
		try {
			merchantProp = Configuration.getMerchantDetails();
			ApiClient apiClient = new ApiClient();
			MerchantConfig merchantConfig = new MerchantConfig(merchantProp);
			apiClient.merchantConfig = merchantConfig;

			PaymentsApi apiInstance = new PaymentsApi(apiClient);
			result = apiInstance.createPayment(requestObj);
			
			responseCode = apiClient.responseCode;
			status = apiClient.status;
			System.out.println("ResponseCode :" + responseCode);
			System.out.println("ResponseMessage :" + status);
			System.out.println(result);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		output.authorizationId = result.getId();
		output.authorizationAmount = Double.parseDouble(result.getOrderInformation().getAmountDetails().getAuthorizedAmount());
		
				return output;
		
		}
	
}
