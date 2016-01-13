component accessors=true {

	public function init( any countryGateway, any beanFactory, numeric countryID = 0 ) {
		variables.countryGateway = countryGateway;
		variables.beanFactory = beanFactory;
		variables.countries = structNew("linked");
		
		var qCountries = variables.countryGateway.getCountries(countryID:countryID);
		// variables.countries = createObject( "java", "java.util.LinkedHashMap" ).init();
		// variables.countries = [ ];

		for (var row in qCountries) {
			variables.countries[row.countryID] = beanFactory.injectProperties( "countryBean", row );
			// variables.countries.append(beanFactory.injectProperties( "countryBean", row ));
		}

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