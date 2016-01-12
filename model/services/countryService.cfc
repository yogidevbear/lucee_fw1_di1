component accessors=true {

	public function init( any countryGateway, any beanFactory, numeric countryID = 0 ) {
		variables.countryGateway = countryGateway;
		variables.beanFactory = beanFactory;
		var qCountries = variables.countryGateway.getCountries(countryID:countryID);
		variables.countries = structNew("linked");
		// variables.countries = createObject( "java", "java.util.LinkedHashMap" ).init();
		// variables.countries = [ ];

		for (var row in qCountries) {
            variables.countries[row.countryID] = beanFactory.injectProperties( "countryBean", row );
            // variables.countries.append(beanFactory.injectProperties( "countryBean", row ));
        }

		/* for (var row in qCountries) {
			var country = variables.beanFactory.getBean( "countryBean" );
			country.setCountryID(row.countryID);
			country.setCountryName(row.countryName);

			variables.countries[country.getCountryID()] = country;
		} */

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