component extends="testbox.system.BaseSpec" {

	// executes before all suites
	function beforeAll(){}

	// executes after all suites
	function afterAll(){}

	// All suites go in here
	function run( testResults, testBox ){

		describe("A suite to test the role bean.", function() {
			
			beforeEach(function() {
			});

			afterEach(function() {
			});

			it("can be initialised with default values", function() {
				var roleBean = new model.beans.roleBean();
				expect(roleBean.getRoleID()).toBe(0);
				expect(roleBean.getRoleName()).toBe("");
			});
			it("can set the roleID", function() {
				var roleBean = new model.beans.roleBean();
				roleBean.setRoleID(2);
				expect(roleBean.getRoleID()).toBe(2);
			});
			it("can set the roleName", function() {
				var roleBean = new model.beans.roleBean();
				roleBean.setRoleName("Guest");
				expect(roleBean.getRoleName()).toBe("Guest");
			});

		});

	}

}