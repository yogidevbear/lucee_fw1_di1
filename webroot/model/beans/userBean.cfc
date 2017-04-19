component accessors=true {
	
	property userID;
	property username;
	property password;
	property salt;
	property firstname;
	property lastname;
	property roleIDList;
	property roles;
	property activationKey;
	property activationCode;
	property activationCodeCreatedAt;
	property activatedAt;
	property createdAt;
	property updatedAt;

	function init(
		numeric userID = 0,
		string username = "",
		string password = "",
		string salt = "",
		string firstname = "",
		string lastname = "",
		string activationKey = "",
		string activationCode = "",
		string activationCodeCreatedAt = "",
		string activatedAt = "",
		string createdAt = "",
		string updatedAt = "",
		string roleIDList = "",
		any roles = ""
	) {
		variables.userID = userID;
		variables.username = username;
		variables.password = password;
		variables.salt = salt;
		variables.firstname = firstname;
		variables.lastname = lastname;
		variables.activationKey = activationKey;
		variables.activationCode = activationCode;
		variables.activationCodeCreatedAt = activationCodeCreatedAt;
		variables.activatedAt = activatedAt;
		variables.createdAt = createdAt;
		variables.updatedAt = updatedAt;
		variables.roles = roles;
		variables.roleIDList = "";
		if ( isObject( roles ) ) {
			for ( var role in roles ) {
				variables.roleIDList = listAppend( variables.roleIDList, role.getRoleID() );
			}
		}
		return this;
	}
	
}