component accessors=true {
	writeDump("::: controllers/main :::")
	// property utilityService;
	// property countryGateway;
	writeDump("INJECT: property countryService;");
	property countryService;

	function default( struct rc ) {
		writeDump("::: controllers/main/default() :::");
		// writeDump(variables.countryGateway);abort;
		writeDump(variables.countryService.get( 1 ));
		abort;
	}
}