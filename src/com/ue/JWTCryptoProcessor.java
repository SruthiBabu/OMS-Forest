package com.ue;

import java.security.PrivateKey;
import java.security.cert.CertificateEncodingException;
import java.security.cert.X509Certificate;
import java.security.interfaces.RSAPrivateKey;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JOSEObject;
import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.JWSObject;
import com.nimbusds.jose.Payload;
import com.nimbusds.jose.crypto.RSASSASigner;

public class JWTCryptoProcessor {
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
