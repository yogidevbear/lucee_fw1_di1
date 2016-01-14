component accessors=true {

	property countryService;
	property roleService;
	property userService;

	function default( struct rc ) {
		rc.countries = variables.countryService.list();
		rc.roles = variables.roleService.list();
		rc.users = variables.userService.list();
		// rc.userEmailTestPass = variables.userService.getByEmail("bob@example.com");
		// rc.userEmailTestFail = variables.userService.getByEmail("no-one@example.com");
	}
}