component accessors="true" {

	property configuration;

	function onLoad( di1 ) {
		// writeDump(di1.getBean( "framework" ).getConfig());
		// writeDump(di1.getBean( "fw" ).getConfig());
		// writeDump(di1.getBeanInfo());
		
		di1.factoryBean( "dsn", "configuration", "getDSN" );
		di1.factoryBean( "encryptionKey", "configuration", "getEncryptionKey" );
	}
}