component accessors=true {
writeDump("::: /model/services/country.cfc :::");
writeDump("INJECT: property dsn;");
	property dsn;
writeDump("INJECT: property countryGateway;");
	property countryGateway;

	public function init( numeric countryID = 0 ) {
		writeDump("START: /model/services/country.cfc -> init()");
		writeDump(">> Running variables.countryGateway.getCountries(countryID:countryID)");
		writeDump(variables);
		var qCountries = variables.countryGateway.getCountries(countryID:countryID);
		variables.countries = { };
		writeDump(countries);abort;
		for (var row in qCountries) {
			// var country = 
		}

		writeDump("END: /model/services/country.cfc -> init()");
		return this;
	}

}