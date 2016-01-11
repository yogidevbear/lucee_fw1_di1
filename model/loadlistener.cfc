component accessors="true" {

	property configuration;

	function onLoad( di1 ) {
		di1.addBean( "dsn", di1.getBean("configuration").getDSN() );
		di1.addBean( "dbVendor", di1.getBean("configuration").getDbVendor() );
		di1.addBean( "getEncryptionKey", di1.getBean("configuration").getEncryptionKey() );

		switch ( di1.getBean("dbVendor") ) {
			case "MSSQL":
				setupGatewaysForDBVendor( di1, di1.getBean("dbVendor") );
				break;
			default:
				throw(type="InvalidConfigException", message="DBVendor #variables.defaultAppConfig.dbVendor# is not currently supported.");
				break;
		}
	}

	private function setupGatewaysForDBVendor (di1, dbVendor) {
		var gatewaysDir = expandPath('/model/gateways/' & dbVendor & '/');
		var gateways = directoryList(gatewaysDir);
		for (var filename in gateways) {
			filename = filename.replace(gatewaysDir, '', 'all').replaceNoCase('.cfc', '');
	
			if ( filename.findNoCase('Gateway') && filename.findNoCase('_' & dbVendor) ) {
				di1.addAlias(replaceNoCase(filename, '_' & dbVendor, ''), filename);
				di1.getBean(replaceNoCase(filename, '_' & dbVendor, ''));
			}
		}
	}
}