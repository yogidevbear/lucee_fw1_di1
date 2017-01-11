component extends="testbox.system.BaseSpec" {

	// executes before all suites
	function beforeAll(){
		variables.dsn = "lucee_fw1_di1";
	}

	// executes after all suites
	function afterAll(){}

	// All suites go in here
	function run( testResults, testBox ){

		describe("A suite to test the user gateways (multiple DBs).", function() {
			
			var vendorDBs = ["mssql","PostgreSQL"];
			
			beforeEach(function() {
				variables.roleGateway = new "model.gateways.#vendor#_userGateway"(dsn:dsn);
				variables.qUsers = roleGateway.getUsers();
				variables.qUserRoles = roleGateway.getUserRoles(userID:1);
			});

			afterEach(function() {
			});

			for (var vendor in vendorDBs) {
				it("getUser() will have these column headers for #vendor# database", function() {
					expect(listSort(qUsers.columnList,"text","asc")).toBe("ACTIVATEDAT,ACTIVATIONCODE,ACTIVATIONCODECREATEDAT,ACTIVATIONKEY,CREATEDAT,FIRSTNAME,LASTNAME,PASSWORD,ROLEID,SALT,UPDATEDAT,USERID,USERNAME");
				});
				it("getUserRoles() will have these column headers for #vendor# database", function() {
					expect(listSort(qUserRoles.columnList,"text","asc")).toBe("ROLEID,ROLENAME,USERID");
				});
			}

		});

	}

}