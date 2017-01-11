component extends="testbox.system.BaseSpec" accessors=true {

	property beanFactory;
	property roleService;
	property userService;
	property securityService;

	// executes before all suites
	function beforeAll(){}

	// executes after all suites
	function afterAll(){}

	// All suites go in here
	function run( testResults, testBox ){

		describe("A suite to test the registration and sign in functionality of the site.", function() {
			
			beforeEach(function() {
			});

			afterEach(function() {
			});

			it("can list the roles", function() {
				// writeDump(variables.getUserService);abort;
			});

		});

	}

}