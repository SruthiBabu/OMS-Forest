package com.ue;

import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import org.apache.commons.json.JSONException;
import org.apache.commons.json.JSONObject;
import com.fahm.forest.utils.CyberSourceUtils;
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
			
		/*arg1.orderNo = "TC50171_3";
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
		arg1.secureAuthenticationCode = "123";
		arg1.requestAmount = 10.20;
		arg1.chargeType = "CAPTURE";
		arg1.authorizationId = "6016137121056270204002";*/
		
		
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

	/*private static JSONObject postRequest(String request, String resource) {
		int responseStatus = 0;
		
		//String resource = "/pts/v2/payments";
	
		JSONObject jsonout = new JSONObject();
        URL url;
		try {
			url = new URL("https://" + requestHost + resource);

			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			
			System.out.println("\n -- RequestURL -- ");
	        System.out.println("\tURL : " + url);
	        System.out.println("\n -- HTTP Headers -- ");
	        System.out.println("\tContent-Type : " + "application/json");
	        System.out.println("\tv-c-merchant-id : " + merchantId);
	        System.out.println("\tHost : " + requestHost);
			
			String token = generateJWT(request, "POST");
			
	        System.out.println("\n -- TOKEN -- ");
	        System.out.println(token);
	        
	        con.setRequestMethod("POST");
	        con.setDoOutput(true);
	        con.setRequestProperty("Authorization", token);
	        con.setRequestProperty("Accept", "application/hal+json;charset=utf-8");
	        con.setRequestProperty("Content-Type", "application/json;charset=utf-8");
	        con.setRequestProperty("Host", requestHost);
	        
	        System.out.println("Connection ok");
	        
	        try(OutputStream outputStream = con.getOutputStream()) {
	        	byte[] input = request.getBytes("utf-8");
	        	outputStream.write(input, 0, input.length);
	        }
	        
	        int responseCode = con.getResponseCode();
	        String responseHeader = con.getHeaderField("v-c-correlation-id");

	        System.out.println("\n -- Response Message -- " );
	        System.out.println("\tResponse Code :" + responseCode);
	        System.out.println("\tv-c-correlation-id :" + responseHeader);
	        
	        if (responseCode == 200 || responseCode == 201) {
	        	BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
	            String inputLine;
	            StringBuffer response = new StringBuffer();

	            while ((inputLine = in.readLine()) != null) {
	                response.append(inputLine);
	            }
	            
	            in.close();
	         
	            jsonout = new JSONObject(response.toString());
	            
	            System.out.println("\tResponse Payload :\n" + jsonout.toString(4));
	            
	            
	        } else {
	        	responseStatus = -1;
	        }
		} catch (Exception e) {
			System.out.println(e.getStackTrace());
		}
		
		return jsonout;
	}*/
	
	/*private static JSONObject callAuth(String arg1) {
		JSONObject jsonauth = new JSONObject();
		
		String resource = "/pts/v2/payments";
		
		jsonauth = postRequest(arg1,resource);

		return jsonauth;

	}
	
	private static JSONObject callCapture(String arg1, String arg2) {
		JSONObject jsonauth = new JSONObject();

		String resource = "/pts/v2/payments/" + arg2 + "/captures";
		
		jsonauth = postRequest(arg1,resource);

		return jsonauth;

	}
	
	private static JSONObject callReversal(String arg1, String arg2) {
		JSONObject jsonauth = new JSONObject();

		String resource = "/pts/v2/payments/" + arg2 + "/reversals";
		
		jsonauth = postRequest(arg1,resource);

		return jsonauth;

	}*/
	
	/*private static String generateJWT(String request, String method) {
        String token = "TOKEN_PLACEHOLDER";
        System.out.println("\tMethod : " + method);

        try {
        	KeyStore merchantKeyStore = KeyStore.getInstance("PKCS12", new BouncyCastleProvider());
	
		//Replace below testrest.p12 file with your <MERCHANT>.p12 file.
                //Steps to generate your P12 - https://developer.cybersource.com/api/developer-guides/dita-gettingstarted/authentication/createCert.html
  	 	FileInputStream keyFile = new FileInputStream("src/resources/fahm_tech_us.p12");
        	
			merchantKeyStore.load(keyFile, merchantId.toCharArray());
			
			String merchantKeyAlias = null;
			Enumeration<String> enumKeyStore = merchantKeyStore.aliases();
			ArrayList<String> array = new ArrayList<String>();
			
			while (enumKeyStore.hasMoreElements()) {
				merchantKeyAlias = (String) enumKeyStore.nextElement();
				array.add(merchantKeyAlias);
				if (merchantKeyAlias.contains(merchantId)) {
					break;
				}
			}
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// Initialize private key from certificate        	
			PrivateKeyEntry e = (PrivateKeyEntry) merchantKeyStore.getEntry(merchantKeyAlias,
					new PasswordProtection(merchantId.toCharArray()));
			
			RSAPrivateKey rsaPrivateKey = (RSAPrivateKey) e.getPrivateKey();
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// Initialize certificate
			merchantKeyAlias = keyAliasValidator(array, merchantId);
			
			e = (PrivateKeyEntry) merchantKeyStore.getEntry(merchantKeyAlias,
					new PasswordProtection(merchantId.toCharArray()));
			
			X509Certificate certificate = (X509Certificate) e.getCertificate();
			
			String encryptedSigMessage = "";

			if (request != null && !request.isEmpty()) {
				MessageDigest jwtBody = MessageDigest.getInstance("SHA-256");
				byte[] jwtClaimSetBody = jwtBody.digest(request.getBytes());
				encryptedSigMessage = Base64.getEncoder().encodeToString(jwtClaimSetBody);
			}
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			// Get JWT
			String claimSet = null;
			if (method.equalsIgnoreCase("GET")) {
				claimSet = "{\n            \"iat\":\"" + ZonedDateTime.now().format(DateTimeFormatter.ISO_INSTANT)
						+ "\"\n} \n\n";
			} else if (method.equalsIgnoreCase("POST")) {
				claimSet = "{\n            \"digest\":\"" + encryptedSigMessage
						+ "\",\n            \"digestAlgorithm\":\"SHA-256\",\n            \"iat\":\""
						+ ZonedDateTime.now().format(DateTimeFormatter.ISO_INSTANT) + "\"\n} \n\n";
			}
			
			/* Preparing the Signature Header. */
			/*HashMap<String, Object> customHeaders = new HashMap<String, Object>();
			if (merchantId != null) {
				customHeaders.put(JWTCryptoProcessor.MERCHANT_ID, merchantId);
			}

			if (merchantId != null) {
				customHeaders.put("v-c-partner-id", merchantId);
			}

			JWTCryptoProcessor jwtCryptoProcessor = new JWTCryptoProcessor();

	        System.out.println("\t JWT Body : " + claimSet);
			
			token = jwtCryptoProcessor.sign(claimSet, rsaPrivateKey, certificate, customHeaders);
        }
        catch (Exception ex)
        {
            System.out.println("ERROR : " + ex.toString());
        }

        return "Bearer " + token;
    }*/
    
    /**
	 * @param array
	 *            -list of keyAlias.
	 * @param merchantID
	 *            -Id of merchant.
	 * @return merchantKeyalias for merchant.
	 */
	/*private static String keyAliasValidator(ArrayList<String> array, String merchantID) {
		int size = array.size();
		String tempKeyAlias, merchantKeyAlias, result;
		StringTokenizer str;
		for (int i = 0; i < size; i++) {
			merchantKeyAlias = array.get(i).toString();
			str = new StringTokenizer(merchantKeyAlias, ",");
			while (str.hasMoreTokens()) {
				tempKeyAlias = str.nextToken();
				if (tempKeyAlias.contains("CN")) {
					str = new StringTokenizer(tempKeyAlias, "=");
					while (str.hasMoreElements()) {
						result = str.nextToken();
						if (result.equalsIgnoreCase(merchantID)) {
							return merchantKeyAlias;
						}
					}
				}
			}
		}
		
		return null;
	}*/
	
}
