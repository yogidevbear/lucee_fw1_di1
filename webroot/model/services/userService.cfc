component accessors=true {

	public function init( any userGateway, any roleService, any beanFactory, numeric userID = 0 ) {
		variables.userGateway = userGateway;
		variables.roleService = roleService;
		variables.beanFactory = beanFactory;
		variables.users = structNew("linked");

		var qUsers = variables.userGateway.getUsers(userID:userID);
		for (var user in qUsers) {
			var qUserRoles = variables.userGateway.getUserRoles(userID:user.userID);
			user.roles = [];
			for (var role in qUserRoles) {
				arrayAppend( user.roles, variables.roleService.list().get(role.roleID) );
			}
			variables.users[user.userID] = beanFactory.injectProperties( "userBean", user );
		}
		
		return this;
	}

	function get( string id ) {
		var result = 0;
		if ( len( id ) && structKeyExists( variables.users, id ) ) {
			result = variables.users[ id ];
		} else {
			result = variables.beanFactory.getBean( "userBean" );
		}
		return result;
	}

	function getByEmail( string email ) {
		var result = "";
		if ( len( email ) ) {
			for ( var userID in variables.users ) {
				var user = variables.users[ userID ];
				if ( comparenocase( email, user.getUsername() ) == 0 ) {
					result = user;
				}
			}
		}
		if ( getMetadata(result).name != "model.beans.userBean" ) {
			result = variables.beanFactory.getBean( "userBean" );
		}
		return result;
	}

	function getByActivationKeyAndActivationCode( required string activationKey, required string activationCode ) {
		var result = "";
		if ( len( activationKey ) && len(activationCode) ) {
			for ( var userID in variables.users ) {
				var user = variables.users[ userID ];
				if (
					comparenocase( activationKey, user.getActivationKey() ) == 0 &&
					comparenocase( activationCode, user.getActivationCode() ) == 0
				) {
					result = user;
				}
			}
		}
		if ( getMetadata(result).name != "model.beans.userBean" ) {
			result = variables.beanFactory.getBean( "userBean" );
		}
		return result;
	}

	function list() {
		return variables.users;
	}

	function getHashesPassword( string email ) {
		var userBean = getByEmail( email );
		return {
			"hashedPassword" : userBean.getPassword(),
			"salt" : userBean.getSalt()
		};
	}

	function save( required component user ) {
		if ( arguments.user.getUserID() == 0 ) {
			var newUserID = variables.userGateway.insertUser(
				 username: arguments.user.getUsername()
				,password: arguments.user.getPassword()
				,salt: arguments.user.getSalt()
				,firstname: arguments.user.getFirstname()
				,lastname: arguments.user.getLastname()
				,activationKey: arguments.user.getActivationKey()
				,activationCode: arguments.user.getActivationCode()
				,roleID: arguments.user.getRoleID()
			);
			if ( newUserID > 0 ) {
				var qUser = variables.userGateway.getUsers(userID:newUserID);
				for (var user in qUser) {
					var qUserRoles = variables.userGateway.getUserRoles(userID:user.userID);
					user.roles = [];
					for (var role in qUserRoles) {
						arrayAppend( user.roles, variables.roleService.list().get(role.roleID) );
					}
					variables.users[user.userID] = beanFactory.injectProperties( "userBean", user );
					return get( user.userID );
				}
			} else {
				return get( 0 );
			}
		} else {
			writeDump("UPDATE");abort;
		}
	}

}