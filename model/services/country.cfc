component accessors=true {

	property dsn;

	public function init( any countryGateway, any beanFactory, numeric countryID = 0 ) {
		variables.countryGateway = countryGateway;
		variables.beanFactory = beanFactory;
		var qCountries = variables.countryGateway.getCountries(countryID:countryID);
		variables.countries = { };
		for (var row in qCountries) {
			var country = variables.beanFactory.getBean( "countryBean" );
			country.setCountryID(row.countryID);
			country.setCountryName(row.countryName);

			variables.countries[country.getCountryID()] = country;
		}

		writeDump(var = variables.countries, label = "Dump of variables.countries from init() inside /model/services/country.cfc", expand = false);

		return this;
	}

	function get( string id ) {
		var result = 0;
		if ( len( id ) && structKeyExists( variables.countries, id ) ) {
			result = variables.countries[ id ];
		} else {
			result = variables.beanFactory.getBean( "countryBean" );
		}
		return result;
	}

	function list() {
		return variables.countries;
	}

}