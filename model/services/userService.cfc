component accessors=true {

	public function init( any userGateway, any roleService, any beanFactory, numeric userID = 0 ) {
		variables.userGateway = userGateway;
		variables.roleService = roleService;
		variables.beanFactory = beanFactory;
		variables.users = structNew("linked");

		var qUsers = variables.userGateway.getUsers(userID:userID);
		
		for (var row in qUsers) {
			row.role = variables.roleService.list().get(qUsers.currentRow);
			variables.users[row.userID] = beanFactory.injectProperties( "userBean", row );
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
				if ( !comparenocase( email, user.getUserEmail() ) ) {
					result = user;
				}
			}
		}
		if ( !isStruct( result ) ) {
			result = variables.beanFactory.getBean( "userBean" );
		}
		return result;
	}

	function list() {
		return variables.users;
	}

}