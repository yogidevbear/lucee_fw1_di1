component extends="testbox.system.BaseSpec" {

	// executes before all suites
	function beforeAll(){}

	// executes after all suites
	function afterAll(){}

	// All suites go in here
	function run( testResults, testBox ){

		describe("A suite to test the user bean.", function() {
			
			beforeEach(function() {
			});

			afterEach(function() {
			});

			it("can be initialised with default values", function() {
				var userBean = new model.beans.userBean();
				expect(userBean.getUserID()).toBe(0);
				expect(userBean.getUserName()).toBe("");
				expect(userBean.getPassword()).toBe("");
				expect(userBean.getSalt()).toBe("");
				expect(userBean.getFirstname()).toBe("");
				expect(userBean.getLastname()).toBe("");
				expect(userBean.getActivationKey()).toBe("");
				expect(userBean.getActivationCode()).toBe("");
				expect(userBean.getActivationCodeCreatedAt()).toBe("");
				expect(userBean.getactivatedAt()).toBe("");
				expect(userBean.getCreatedAt()).toBe("");
				expect(userBean.getUpdatedAt()).toBe("");
				expect(userBean.getRoles()).toBe("");
			});
			it("can set the userID", function() {
				var userBean = new model.beans.userBean();
				userBean.setUserID(2);
				expect(userBean.getUserID()).toBe(2);
			});
			it("can set the userName", function() {
				var userBean = new model.beans.userBean();
				userBean.setUserName("test@example.com");
				expect(userBean.getUserName()).toBe("test@example.com");
			});
			it("can set the password", function() {
				var userBean = new model.beans.userBean();
				userBean.setPassword("new password");
				expect(userBean.getPassword()).toBe("new password");
			});
			it("can set the salt", function() {
				var userBean = new model.beans.userBean();
				userBean.setSalt("new salt");
				expect(userBean.getSalt()).toBe("new salt");
			});
			it("can set the firstname", function() {
				var userBean = new model.beans.userBean();
				userBean.setFirstname("John");
				expect(userBean.getFirstname()).toBe("John");
			});
			it("can set the lastname", function() {
				var userBean = new model.beans.userBean();
				userBean.setLastname("Doe");
				expect(userBean.getLastname()).toBe("Doe");
			});
			it("can set the activation key", function() {
				var userBean = new model.beans.userBean();
				userBean.setActivationKey("new activation key");
				expect(userBean.getActivationKey()).toBe("new activation key");
			});
			it("can set the activation code", function() {
				var userBean = new model.beans.userBean();
				userBean.setActivationCode("new activation code");
				expect(userBean.getActivationCode()).toBe("new activation code");
			});
			it("can set the activation code createdAt", function() {
				var userBean = new model.beans.userBean();
				userBean.setActivationCodeCreatedAt("new activation code creation time");
				expect(userBean.getActivationCodeCreatedAt()).toBe("new activation code creation time");
			});

		});

	}

}