package com.fahm.forest.utils;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.KeyStore;
import java.security.MessageDigest;
import java.security.KeyStore.PasswordProtection;
import java.security.KeyStore.PrivateKeyEntry;
import java.security.cert.X509Certificate;
import java.security.interfaces.RSAPrivateKey;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.StringTokenizer;

import org.apache.commons.json.JSONObject;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import com.ue.JWTCryptoProcessor;
import com.yantra.yfs.japi.YFSEnvironment;

public class CyberSourceUtils {

	public static JSONObject callAuth(YFSEnvironment arg0,String arg1) {
		JSONObject jsonauth = new JSONObject();
		
		String res = OmsUtils.getPropertyValue(arg0, "cybersource.resourceurl", "fahm");
		String resource = res;
		
		jsonauth = postRequest(arg0,arg1,resource);

		return jsonauth;

	}
	
	public static JSONObject callCapture(YFSEnvironment arg0, String arg1, String arg2) {
		JSONObject jsonauth = new JSONObject();
		
		String res = OmsUtils.getPropertyValue(arg0, "cybersource.resourceurl", "fahm");
		String resource = res + arg2 + "/captures";
		
		jsonauth = postRequest(arg0,arg1,resource);

		return jsonauth;

	}
	
	public static JSONObject callReversal(YFSEnvironment arg0, String arg1, String arg2) {
		JSONObject jsonauth = new JSONObject();
		
		String res = OmsUtils.getPropertyValue(arg0, "cybersource.resourceurl", "fahm");
		String resource = res + arg2 + "/reversals";
		
		jsonauth = postRequest(arg0,arg1,resource);

		return jsonauth;

	}
	
	private static JSONObject postRequest(YFSEnvironment arg0,String request, String resource) {
		int responseStatus = 0;
		
		String merchantId = OmsUtils.getPropertyValue(arg0, "cybersource.merchant_id", "fahm");
		String requestHost = OmsUtils.getPropertyValue(arg0, "cybersource.requesthost", "fahm");
		
		JSONObject jsonout = new JSONObject();
        URL url;
		try {
			url = new URL("https://" + requestHost + resource);

			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			
			String token = generateJWT(arg0,request, "POST");
			
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

	        if (responseCode == 200 || responseCode == 201) {
	        	BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
	            String inputLine;
	            StringBuffer response = new StringBuffer();

	            while ((inputLine = in.readLine()) != null) {
	                response.append(inputLine);
	            }
	            
	            in.close();
	         
	            jsonout = new JSONObject(response.toString());
	            
	        } else {
	        	responseStatus = -1;
	        }
		} catch (Exception e) {
			System.out.println(e.getStackTrace());
		}
		
		return jsonout;
	}
	
	private static String generateJWT(YFSEnvironment arg0,String request, String method) {
        String token = "TOKEN_PLACEHOLDER";
        String merchantId = OmsUtils.getPropertyValue(arg0, "cybersource.merchant_id", "fahm");
        try {
        	KeyStore merchantKeyStore = KeyStore.getInstance("PKCS12", new BouncyCastleProvider());
	
		//Use <MERCHANT>.p12 file here.
                //Steps to generate your P12 - https://developer.cybersource.com/api/developer-guides/dita-gettingstarted/authentication/createCert.html
  	 	FileInputStream keyFile = new FileInputStream("/var/oms/certs/fahm_tech_us.p12");
        	
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
