component accessors=true {

	public function init( any roleGateway, any beanFactory, numeric roleID = 0 ) {
		variables.roleGateway = roleGateway;
		variables.beanFactory = beanFactory;
		variables.roles = structNew("linked");

		var qRoles = variables.roleGateway.getRoles(roleID:roleID);
		
		for (var row in qRoles) {
			variables.roles[row.roleID] = beanFactory.injectProperties( "roleBean", row );
		}

		return this;
	}

	function get( string id ) {
		var result = 0;
		if ( len( id ) && structKeyExists( variables.roles, id ) ) {
			result = variables.roles[ id ];
		} else {
			result = variables.beanFactory.getBean( "roleBean" );
		}
		return result;
	}

	function list() {
		return variables.roles;
	}
	
}