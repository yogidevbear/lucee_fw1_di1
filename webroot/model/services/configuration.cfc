component accessors="true" {

	property dsn;
	property dbVendor;
	property encryptionKey;
	property pbkdfAlgorithm;
	property pbkdfIterations;
	property pbkdfKeysize;
	property reCaptchaClientKey;
	property reCaptchaServerSecret;
	property reCaptchaGoogleUrl;
	property base62Alphabet;
	property siteName;
	property siteURL;
	property smtpServer;
	property smtpPort;
	property smtpUsername;
	property smtpPassword;
	property emailNoReply;

	function init( propertiesFile, expectedProperties ) {
		var props = CreateObject("java","java.util.Properties").init();
		props.load( CreateObject("java","java.io.FileInputStream").init(arguments.propertiesFile) );

		if ( arrayLen(arguments.expectedProperties) > 0 ) {
			for ( var prop in arguments.expectedProperties) {
				variables["#prop#"] = props.getProperty(prop);
			}
		} else {
			for ( var prop in props ) {
				variables["#prop#"] = props.getProperty(prop);
			}
		}

		return this;
	}
}