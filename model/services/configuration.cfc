component accessors="true" {
writeDump("::: /model/services/configuration.cfc :::");
writeDump("=== property dsn; ===");
writeDump("=== property dbVendor; ===");
writeDump("=== property encryptionKey; ===");

	property dsn;
	property dbVendor;
	property encryptionKey;

	function init( propertiesFile, expectedProperties ) {
		writeDump("START: /model/services/configuration.cfc -> init()");
		writeDump(">> Reading in the properties file and setting the values for the properties 'dsn', 'dbVendor' and 'encryptionKey'")
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

		writeDump("END: /model/services/configuration.cfc -> init()");
		return this;
	}
}