component accessors="true" {

	// The loadlistener relies on `property configuration;` — injection — so it doesn’t need to call `getBean()`
	property configuration;

	function onLoad( di1 ) {
		// Saves the vendor value locally to avoid calling `getBean()` as well.
		var vendor = variables.configuration.getDbVendor();
		di1.addBean( "dsn", variables.configuration.getDSN() );
		di1.addBean( "dbVendor", vendor );
		di1.addBean( "encryptionKey", variables.configuration.getEncryptionKey() );
		di1.addBean( "pbkdfAlgorithm", variables.configuration.getPbkdfAlgorithm() );
		di1.addBean( "pbkdfIterations", variables.configuration.getPbkdfIterations() );
		di1.addBean( "pbkdfKeysize", variables.configuration.getPbkdfKeysize() );
		di1.addBean( "reCaptchaClientKey", variables.configuration.getReCaptchaClientKey() );
		di1.addBean( "reCaptchaServerSecret", variables.configuration.getReCaptchaServerSecret() );
		di1.addBean( "reCaptchaGoogleUrl", variables.configuration.getReCaptchaGoogleUrl() );
		di1.addBean( "base62Alphabet", variables.configuration.getBase62Alphabet() );
		di1.addBean( "siteName", variables.configuration.getSiteName() );
		di1.addBean( "siteURL", variables.configuration.getSiteURL() );
		di1.addBean( "smtpServer", variables.configuration.getSmtpServer() );
		di1.addBean( "smtpPort", variables.configuration.getSmtpPort() );
		di1.addBean( "smtpUsername", variables.configuration.getSmtpUsername() );
		di1.addBean( "smtpPassword", variables.configuration.getSmtpPassword() );
		di1.addBean( "emailNoReply", variables.configuration.getEmailNoReply() );
		var found = 0;
		
		// Using `getBeanInfo()` with a (case-insensitive) regex to find the gateways — since they are in the bean factory — rather than looking on the filesystem
		for ( var gw in di1.getBeanInfo( regex = "(?i)" & vendor & "_" ).beanInfo ) {
			// Assume that if any `vendor_foogateway` beans are found that the `vendor` is supported
			di1.addAlias( gw.replaceNoCase( vendor & "_", ""), gw );
			++found;
		}

		if ( !found ) {
			throw(type="InvalidConfigException", message="DBVendor #vendor# is not currently supported.");
		}
	}

}