package com.data;

import java.util.Properties;

public class Configuration {
	public static Properties getMerchantDetails() {
		Properties props = new Properties();

		// HTTP_Signature = http_signature and JWT = jwt
		props.setProperty("authenticationType", "http_Signature");
		props.setProperty("merchantID", "fahm_tech_us");
		props.setProperty("runEnvironment", "CyberSource.Environment.SANDBOX");
		props.setProperty("requestJsonPath", "src/resources/request.json");

		// JWT Parameters
		props.setProperty("keyAlias", "testrest");
		props.setProperty("keyPass", "testrest");
		props.setProperty("keyFileName", "testrest");

		// P12 key path. Enter the folder path where the .p12 file is located.

		props.setProperty("keysDirectory", "src/resources");
		// HTTP Parameters
		props.setProperty("merchantKeyId", "4912641a-ff94-4ffb-b3bf-76f9a89cf14c");
		props.setProperty("merchantsecretKey", "eYB+VxNi4OCmjgwTR+cnAcEqV+fdd48EIOACGCi5jPM=");
		// Logging to be enabled or not.
		props.setProperty("enableLog", "true");
		// Log directory Path
		props.setProperty("logDirectory", "log");
		props.setProperty("logFilename", "cybs");

		// Log file size in KB
		props.setProperty("logMaximumSize", "5M");

		return props;

	}
	
	public static Properties getAlternativeMerchantDetails() {
		Properties props = new Properties();

		// HTTP_Signature = http_signature and JWT = jwt
		props.setProperty("authenticationType", "http_Signature");
		props.setProperty("merchantID", "fahm_tech_us");
		props.setProperty("runEnvironment", "CyberSource.Environment.SANDBOX");
		props.setProperty("requestJsonPath", "src/resources/request.json");

		// JWT Parameters
		props.setProperty("keyAlias", "testrest_cpctv");
		props.setProperty("keyPass", "testrest_cpctv");
		props.setProperty("keyFileName", "testrest_cpctv");

		// P12 key path. Enter the folder path where the .p12 file is located.

		props.setProperty("keysDirectory", "src/resources");
		// HTTP Parameters
		props.setProperty("merchantKeyId", "ef7bdda3-3df7-4d53-a729-88997dfdbcbe");
		props.setProperty("merchantsecretKey", "gD5Qksy+bL8zavy4CMS1SN6t7O4Zkri4vGNXCs+UfzE=");
		// Logging to be enabled or not.
		props.setProperty("enableLog", "true");
		// Log directory Path
		props.setProperty("logDirectory", "log");
		props.setProperty("logFilename", "cybs");

		// Log file size in KB
		props.setProperty("logMaximumSize", "5M");

		return props;

	}

}
