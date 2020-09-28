package com.ue;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.KeyStore;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.KeyStore.PasswordProtection;
import java.security.KeyStore.PrivateKeyEntry;
import java.security.cert.CertificateEncodingException;
import java.security.cert.X509Certificate;
import java.security.interfaces.RSAPrivateKey;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;

import org.apache.commons.json.JSONException;
import org.apache.commons.json.JSONObject;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.jose4j.json.internal.json_simple.parser.ParseException;

import com.fahm.forest.utils.OmsUtils;
import com.ibm.disthub2.impl.formats.OldEnvelop.payload.normal.body.jms.properties;
import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JOSEObject;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.JWSObject;
import com.nimbusds.jose.Payload;
import com.nimbusds.jose.crypto.RSASSASigner;
import com.yantra.yfs.japi.YFSEnvironment;
import com.yantra.yfs.japi.YFSExtnPaymentCollectionInputStruct;
import com.yantra.yfs.japi.YFSExtnPaymentCollectionOutputStruct;
import com.yantra.yfs.japi.YFSUserExitException;
import com.yantra.yfs.japi.ue.YFSCollectionCreditCardUE;

class FAHMCreditCardCollectionUEImpl implements YFSCollectionCreditCardUE{
	
	private static String merchantId = "fahm_tech_us";
    private static String requestHost = "apitest.cybersource.com";
  
    public static void main(String[] args) {
		FAHMCreditCardCollectionUEImpl temp = new FAHMCreditCardCollectionUEImpl();
		
		try {
			temp.collectionCreditCard(null, new YFSExtnPaymentCollectionInputStruct());
		} catch (YFSUserExitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public YFSExtnPaymentCollectionOutputStruct collectionCreditCard(YFSEnvironment arg0,
			YFSExtnPaymentCollectionInputStruct arg1) throws YFSUserExitException {
		
		System.out.println(merchantId);
			
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
		arg1.secureAuthenticationCode = "123";
		arg1.requestAmount = 10.20;
		
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
		
		try {
			System.out.println(request);
			int postStatusCode = postRequest(request);
			if (postStatusCode != 0) {
            	System.out.println("STATUS : ERROR (HTTP Status = " + postStatusCode + ")");
            } else {
            	System.out.println("STATUS : SUCCESS (HTTP Status = " + postStatusCode + ")");
            }
		} catch (Exception e) {
			System.out.println("ERROR : " + e.getMessage());
			e.printStackTrace();
		}
		output.tranAmount = arg1.requestAmount;
		output.authorizationAmount = arg1.requestAmount;
		
		return output;
		
	}
	private static int postRequest(String request) {
		int responseStatus = 0;
		
		String resource = "/pts/v2/payments";
		
		/* HTTP connection */
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
	            
	            System.out.println("\tResponse Payload :\n" + response.toString());
	        } else {
	        	responseStatus = -1;
	        }
		} catch (Exception e) {
			System.out.println(e.getStackTrace());
		}
		
		return responseStatus;
	}
	
	private static String generateJWT(String request, String method) {
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
			HashMap<String, Object> customHeaders = new HashMap<String, Object>();
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
    }
    
    /**
	 * @param array
	 *            -list of keyAlias.
	 * @param merchantID
	 *            -Id of merchant.
	 * @return merchantKeyalias for merchant.
	 */
	private static String keyAliasValidator(ArrayList<String> array, String merchantID) {
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
	}
	
}

class JWTCryptoProcessor {
	public static String MERCHANT_ID = "v-c-merchant-id";
	
	public String sign(String content, PrivateKey privateKey, X509Certificate x509Certificate,
			Map<String, Object> customHeaders) {
		return serializeToken(signPayload(content, privateKey, x509Certificate, customHeaders));
	}
	
	private String serializeToken(JOSEObject joseObject) {
		return joseObject.serialize();
	}
	
	private JOSEObject signPayload(String content, PrivateKey privateKey, X509Certificate x509Certificate,
			Map<String, Object> customHeaders) {
		if ((content == null) || (content.trim().length() == 0) || (x509Certificate == null) || (privateKey == null)) {
			return null;
		}
		String serialNumber = null;
		String serialNumberPrefix = "SERIALNUMBER=";
		String principal = x509Certificate.getSubjectDN().getName().toUpperCase();
		int beg = principal.indexOf(serialNumberPrefix);
		if (beg >= 0) {
			int end = principal.indexOf(",", beg);
			if (end == -1) {
				end = principal.length();
			}
			serialNumber = principal.substring(beg + serialNumberPrefix.length(), end);
		} else {
			serialNumber = x509Certificate.getSerialNumber().toString();
		}
		List<com.nimbusds.jose.util.Base64> x5cBase64List = new ArrayList<>();
		try {
			x5cBase64List.add(com.nimbusds.jose.util.Base64.encode(x509Certificate.getEncoded()));
		} catch (CertificateEncodingException e) {
			return null;
		}
		RSAPrivateKey rsaPrivateKey = (RSAPrivateKey) privateKey;
		Payload payload = new Payload(content);

		JWSHeader jwsHeader = new JWSHeader.Builder(JWSAlgorithm.RS256)
										   .customParams(customHeaders).keyID(serialNumber)
										   .x509CertChain(x5cBase64List).build();
		JWSObject jwsObject = new JWSObject(jwsHeader, payload);
		try {
			RSASSASigner signer = new RSASSASigner(rsaPrivateKey);
			jwsObject.sign(signer);
			if (!jwsObject.getState().equals(JWSObject.State.SIGNED)) {
				return null;
			}
		} catch (JOSEException joseException) {
			return null;
		}
		return jwsObject;
	}
}
