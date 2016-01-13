component accessors=true {
	
	property userID;
	property userEmail;
	property role;
	property roleID;

	// function init( numeric userID = 0, string userEmail = "", numeric roleID = 0, any roleName = "" ) {
	function init( numeric userID = 0, string userEmail = "", any role = "" ) {
		variables.userID = userID;
		variables.userEmail = userEmail;
		// variables.roleID = roleID;
		variables.role = role;
		if ( isObject( role ) ) {
			variables.roleID = role.getRoleID();
		} else {
			variables.roleID = 2; // default role id is user
		}
		return this;
	}
	
}