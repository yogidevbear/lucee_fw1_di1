component accessors=true {

	// property utilityService;
	property countryService;

	function default( struct rc ) {
		// writeDump("here");
		rc.countries = variables.countryService.list();
		writeDump(var = rc.countries, label = "Dump of rc.countries from default() inside /controllers/main.cfc", expand = false);
		// writeDump(variables.countryService.get( 1 ).getCountryName());
		// writeDump(variables.countryService.get( 2 ).getCountryName());
	}
}