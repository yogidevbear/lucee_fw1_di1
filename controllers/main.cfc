component accessors=true {

	property countryService;
	property roleService;
	property userService;

	function default( struct rc ) {
		rc.countries = variables.countryService.list();
		rc.roles = variables.roleService.list();
		rc.users = variables.userService.list();
	}
}