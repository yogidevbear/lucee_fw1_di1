component accessors=true {

	property dsn;
	property countryGateway;

	public function init( numeric countryID = 0 ) {
		writeDump("START: /model/services/country.cfc -> init()");
		writeDump(">> Running variables.countryGateway.getCountries(countryID:countryID)");
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