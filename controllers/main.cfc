component accessors=true {
	
	property utilityService;

	function default( struct rc ) {
		writeDump(variables.utilityService.getCountries(1));
		abort;
	}
}