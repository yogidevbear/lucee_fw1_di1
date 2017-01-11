component accessors=true {

	property beanFactory;
	property countryService;
	property roleService;
	property userService;
	property securityService;
	property reCaptchaService;
	property validationService;
	property base62Service;
	property framework;

	function before( struct rc ) {
		param name="rc.arrValidate" type="array" default=[];
		param name="rc.stValidate" type="struct" default={"generic":[]};
	}

	function pagenotfound( struct rc ) {
		
	}

	function default( struct rc ) {
		rc.countries = variables.countryService.list();
		rc.roles = variables.roleService.list();
		rc.users = variables.userService.list();
		rc.userEmailTestPass = variables.userService.getByEmail("test@example.com");
		rc.userEmailTestFail = variables.userService.getByEmail("no-one@example.com");
		// writeDump(SESSION.stUser);
		// rc.bSignedIn = variables.securityService.validateSignIn(email:"test@example.com",password:"password");
		// writeDump(rc.bSignedIn);
		// writeDump(SESSION.stUser);
		// variables.securityService.resetSession();
		writeDump(SESSION.stUser);
	}

	function signup( struct rc ) {
		param name="rc.firstname" type="string" default="";
		param name="rc.lastname" type="string" default="";
		param name="rc.username" type="string" default="";
		param name="rc.confirmUsername" type="string" default="";
		param name="rc.password" type="string" default="";
		param name="rc.confirmPassword" type="string" default="";
		rc.reCaptchaClientKey = variables.reCaptchaService.getClientKey();
		rc.reCaptchaServerSecret = variables.reCaptchaService.getServerSecret();
		rc.reCaptchaGoogleURL = variables.reCaptchaService.getGoogleURL();

		if ( structKeyExists(rc, "btnCreateAccount") ) {
			rules = [
				 "length>=2,firstname,Please enter your first name"
				,"length>=2,lastname,Please enter your last name"
				,"valid_email,username,Please enter a valid email address."
				,"required,password,Enter a password."
				,"required,confirmPassword,Confirm your password."
				,"same_as,password,confirmPassword,The passwords you supplied do not match."
			];
			rc.arrValidate = variables.validationService.formCheck( rc, rules );
			if (arrayLen(rc.arrValidate)) {
				rc.stValidate = variables.validationService.arrValidateToStValidate( rc.arrValidate );
			} else {
				// Process the reCAPTCHA
				/*var bPassGReCaptcha = variables.reCaptchaService.googleReCaptcha(
					 strRc : rc
					,googleUrl : rc.reCaptchaGoogleURL
					,secret : rc.reCaptchaServerSecret
					,remoteip : CGI.REMOTE_ADDR
				);
				// If reCAPTCHA failed
				if ( !bPassGReCaptcha ) {
					// Add generic error for reCaptcha
					rc.arrValidate = variables.validationService.appendArrValidateError(
						 arrValidate : rc.arrValidate
						,fieldName : "generic"
						,error : "The reCAPTCHA failed. Please try resubmitting the form."
					);
				}*/

				// If validation passed on all fields
				if ( !arrayLen( rc.arrValidate ) ) {
					var salt = variables.securityService.getNewSalt();
					var finalPassword = variables.securityService.getPasswordBasedKey(password:rc.password,salt:salt);
					var activationKey = variables.securityService.getNewActivationKey(salt);
					var activationCode = variables.securityService.getNewActivationCode();
					var user = beanFactory.injectProperties(
						"userBean",
						{
							username: rc.username,
							password: finalPassword,
							salt: salt,
							firstname: rc.firstname,
							lastname: rc.lastname,
							activationKey: activationKey,
							activationCode: activationCode,
						}
					);
					user = variables.userService.save( user );
					writeDump(user);abort;
					var user = variables.userService.get( 0 );

					user.setFirstname(rc.firstname);
					user.setLastname(rc.lastname);
					user.setUsername(rc.username);
					user.setSalt(variables.securityService.getNewSalt());
					user.setPassword(variables.securityService.getPasswordBasedKey(password:rc.password,salt:user.getSalt()));
					user.setActivationKey(variables.securityService.getNewActivationKey(user.getSalt()));
					user.setActivationCode(variables.securityService.getNewActivationCode());
					var newUser = variables.userService.save( user );
					var user = variables.userService.save(
						 userID: 0
						,username: rc.username
						,password: rc.password
						,firstname: rc.firstname
						,lastname: rc.lastname
						,salt: ""
						,password: rc.password
						,activationKey: ""
						,activationCode: ""
					);
					if ( newUser.getUserID() > 0 ) {
						variables.securityService.sendActivationEmail(
							 from : request.doNotReplyEmail
							,to : arguments.username
							,subject : request.siteName & ': Account Activation'
							,failto : request.failtoEmail
							,activationKey : newUser.getActivationKey()
							,activationCode : newUser.getActivationCode()
							//,encryptedUsername : encryptedUsername
							,name : "#arguments.firstname# #arguments.lastname#"
						);
					}
					writeDump(newUser);abort;
					// Register the user
					var bSuccess = variables.securityService.registerUser(username:rc.username,password:rc.password,firstname:rc.firstname,lastname:rc.lastname/*,encryptionKey:request.encryptionKey*/);

					if ( bSuccess ) {
						variables.fw.setview('security:register.success');
					} else {
						// Add generic error for failed registration
						rc.arrValidate = application.model.validate.appendArrValidateError(
							 arrValidate:rc.arrValidate
							,fieldName:"generic"
							,error:"The registration process failed. Please try resubmitting the form."
						);
					}
				}

				if (arrayLen(rc.arrValidate)) {
					// Create a structure of errors for highlighting form fields when validation errors occur.
					rc.stValidate = StructNew();
					for (var valError = 1; valError <= arrayLen(rc.arrValidate); valError++){
						"rc.stValidate.#rc.arrValidate[valError]['fieldname']#" = rc.arrValidate[valError]['error'];
					}
				}
			}
		}
	}

	function signin( struct rc) {
		param name="rc.username" type="string" default="";
		param name="rc.password" type="string" default="";
		rc.reCaptchaClientKey = variables.reCaptchaService.getClientKey();

		if ( structKeyExists(rc, "btnSignIn") ) {
			var rules = [
				 "required,username,Please enter your username."
				,"required,password,Please enter your password."
			];
			rc.arrValidate = variables.validationService.formCheck( rc, rules );
			if (arrayLen(rc.arrValidate)) {
				rc.stValidate = variables.validationService.arrValidateToStValidate( rc.arrValidate );
			} else {
				// Add Google reCaptcha code
				rc.bSignedIn = variables.securityService.validateSignIn(email:rc.username,password:rc.password);
				if ( rc.bSignedIn ) {
					variables.framework.redirectCustomURL( '/' );
				} else {
					arrayAppend(rc.stValidate.generic, "Invalid username or password. Please try again.");
				}
			}
		}
	}

	function signout( struct rc ) {
		variables.securityService.resetSession();
		variables.framework.redirectCustomURL( '/' );
	}

}