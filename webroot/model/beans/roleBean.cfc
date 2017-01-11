component accessors=true {
	
	property roleID;
	property roleName;

	function init( numeric roleID = 0, string roleName = "" ) {
		variables.roleID = roleID;
		variables.roleName = roleName;
		return this;
	}
	
}