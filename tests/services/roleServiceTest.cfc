component extends="testbox.system.BaseSpec" {

	// executes before all suites
	function beforeAll(){}

	// executes after all suites
	function afterAll(){}

	// All suites go in here
	function run( testResults, testBox ){

		describe("A suite to test the roles services.", function() {

			var vendorDBs = ["mssql","PostgreSQL"];
			
			for (var vendor in vendorDBs) {
				
				beforeEach(function() {
					// create an instance and decorate it with mocking capabilities
					var beanFactory = createMock("framework.ioc").init(folders:"");
					var roleBean = new model.beans.roleBean();
					var roleGateway = createMock("model.gateways.#vendor#_roleGateway");
					beanFactory.addBean("roleBean",roleBean);
					roleGateway.$("getRoles").$results(
						queryNew(
							"roleID, roleName",
							"integer, varchar",
							[
								{"roleID": 1, "roleName": "One"}
							]
						)
					);
					variables.service = new model.services.roleService(roleGateway, beanFactory, 0);
				});

				afterEach(function() {
				});

				it("can list roles as struct for #vendor#_roleGateway", function() {
					var sut = service.list();
					// writeDump(sut);abort;
					expect(sut).toBeStruct();
				});

			}

		});

	}

}