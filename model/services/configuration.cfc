component accessors="true" {

	property dsn;
	property encryptionKey;

	function init( propertiesFile, expectedProperties ) {
		var props = CreateObject("java","java.util.Properties").init();
		props.load( CreateObject("java","java.io.FileInputStream").init(arguments.propertiesFile) );

		if ( arrayLen(arguments.expectedProperties) > 0 ) {
			for ( var prop in arguments.expectedProperties) {
				variables["set#prop#"](props.getProperty(prop));
			}
		} else {
			for ( var prop in props ) {
				variables["set#prop#"](props.getProperty(prop));
			}
		}

		return this;
	}
}