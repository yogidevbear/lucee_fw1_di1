component accessors=true {
	
	// property utilityService;
	// property countryGateway;
	property countryService;

	function default( struct rc ) {
		// writeDump(variables.countryGateway);abort;
		writeDump(variables.countryService.get( 1 ));
		abort;
	}
}