component accessors="true" {
writeDump("::: /model/loadlistener.cfc :::");
writeDump("SET: property configuration;");
	property configuration;

	function onLoad( di1 ) {
		writeDump("START: /model/loadlistener.cfc -> onLoad()");
		writeDump(">> di1.addBean()'s with di1.getBean(config).getXXX()'s");
		di1.addBean( "dsn", di1.getBean("configuration").getDSN() );
		di1.addBean( "dbVendor", di1.getBean("configuration").getDbVendor() );
		di1.addBean( "getEncryptionKey", di1.getBean("configuration").getEncryptionKey() );

		writeDump(">> Switch over 'di1.getBean('dbVendor')'");
		switch ( di1.getBean("dbVendor") ) {
			case "MSSQL":
				setupGatewaysForDBVendor( di1, di1.getBean("dbVendor") );
				break;
			default:
				throw(type="InvalidConfigException", message="DBVendor #variables.defaultAppConfig.dbVendor# is not currently supported.");
				break;
		}
		writeDump("END: /model/loadlistener.cfc -> onLoad()");
	}

	private function setupGatewaysForDBVendor (di1, dbVendor) {
		writeDump("START: /model/loadlistener.cfc -> setupGatewaysForDBVendor()");
		var gatewaysDir = expandPath('/model/gateways/' & dbVendor & '/');
		var gateways = directoryList(gatewaysDir);
		for (var filename in gateways) {
			filename = filename.replace(gatewaysDir, '', 'all').replaceNoCase('.cfc', '');
			// di1.addBean(filename);
			// writeDump("di1.getBean(filename)");
			// writeDump(di1.getBean(filename));

			if ( filename.findNoCase('Gateway') && filename.findNoCase('_' & dbVendor) ) {
				writeDump("replaceNoCase(filename, '_' & dbVendor, '') = #replaceNoCase(filename, '_' & dbVendor, '')#");
				writeDump(">> di1.addAlias(replaceNoCase(filename, '_' & dbVendor, ''), filename);")
				di1.addAlias(replaceNoCase(filename, '_' & dbVendor, ''), filename);
				writeDump("TEST: getBean with alias");
				writeDump(">> di1.getBean(replaceNoCase(filename, '_' & dbVendor, ''))");
				writeDump(di1.getBean(replaceNoCase(filename, '_' & dbVendor, '')));
				// writeDump(di1.getBean(replaceNoCase(filename, '_' & dbVendor, '')).getDsn());
				// writeDump(di1.getBean(replaceNoCase(filename, '_' & dbVendor, '')).getCountries());
				writeDump("AFTER TEST");
			}
		}
		writeDump("END: /model/loadlistener.cfc -> setupGatewaysForDBVendor()");
	}
}