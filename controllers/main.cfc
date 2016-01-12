component accessors=true {

	// property utilityService;
	property countryService;

	function default( struct rc ) {
		rc.countries = variables.countryService.list();
	}
}