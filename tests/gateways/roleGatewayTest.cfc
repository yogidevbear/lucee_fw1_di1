component extends="testbox.system.BaseSpec" {

	// executes before all suites
	function beforeAll(){
		variables.dsn = "lucee_fw1_di1";
	}

	// executes after all suites
	function afterAll(){}

	// All suites go in here
	function run( testResults, testBox ){

		describe("A suite to test the roles gateways (multiple DBs).", function() {
			
			beforeEach(function() {
				variables.roleGateway = new "model.gateways.#vendor#_roleGateway"(dsn:dsn);
				variables.result = roleGateway.getRoles();
			});

			afterEach(function() {
			});

			var vendorDBs = ["mssql","PostgreSQL"];
			for (var vendor in vendorDBs) {
				it("can get one or more roles for #vendor# database", function() {
					expect(result.recordCount).toBeGT(0);
				});
				it("will have these column headers for #vendor# database", function() {
					expect(listSort(result.columnList,"text","asc")).toBe("ROLEID,ROLENAME");
				});
			}

		});

	}

}