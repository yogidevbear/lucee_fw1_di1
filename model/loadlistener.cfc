component accessors="true" {

	// The loadlistener relies on `property configuration;` — injection — so it doesn’t need to call `getBean()`
	property configuration;

	function onLoad( di1 ) {
		// Saves the vendor value locally to avoid calling `getBean()` as well.
		var vendor = variables.configuration.getDbVendor();
		di1.addBean( "dsn", variables.configuration.getDSN() );
		di1.addBean( "dbVendor", vendor );
		di1.addBean( "encryptionKey", variables.configuration.getEncryptionKey() );
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