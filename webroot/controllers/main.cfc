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
		param name="rc.arrSuccess" type="array" default=[];
		param name="rc.arrValidate" type="array" default=[];
		param name="rc.stValidate" type="struct" default={"generic":[]};
	}

	function default( struct rc ) {
		rc.countries = variables.countryService.list();
		rc.roles = variables.roleService.list();
		rc.users = variables.userService.list();
		rc.userEmailTestPass = variables.userService.getByEmail("test@example.com");
		rc.userEmailTestFail = variables.userService.getByEmail("no-one@example.com");
		// writeDump(SESSION.stUser);
		// rc.nSignedIn = variables.securityService.validateSignIn(email:"test@example.com",password:"password");
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
				,"valid_email,confirmUsername,Please enter a valid email address."
				,"same_as,username,confirmUsername,The email addresses you supplied do not match."
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
					var finalPassword = variables.securityService.getPasswordBasedKey(passphrase:rc.password,salt:salt);
					var activationCode = variables.securityService.getNewActivationCode();
					var activationKey = variables.securityService.getNewActivationKey(passphrase:activationCode,salt:salt);
					var user = beanFactory.injectProperties(
						"userBean",
						{
							 username: rc.username
							,password: finalPassword
							,salt: salt
							,firstname: rc.firstname
							,lastname: rc.lastname
							,activationKey: activationKey
							,activationCode: activationCode
						}
					);
					user = variables.userService.save( user );
					if ( user.getUserID() > 0 ) {
						variables.securityService.sendActivationEmail(
							 firstname : user.getFirstname()
							,email : user.getUsername()
							,activationKey : user.getActivationKey()
							,activationCode : user.getActivationCode()
						);
					} else {
						// Add generic error for failed registration
						rc.arrValidate = variables.validationService.appendArrValidateError(
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

	function activate( struct rc ) {
		param name="rc.activationKey" type="string" default="";
		param name="rc.activationCode" type="string" default="";

		var user = variables.userService.getByActivationKeyAndActivationCode( activationKey: rc.activationKey, activationCode: rc.activationCode );

		if ( user.getUserID() > 0 ) {
			if ( len( user.getActivatedAt() ) > 0 ) {
				arrayAppend( rc.arrSuccess, { fieldName: "success", message: "Your account has been activated, please login." } );
				variables.framework.redirectCustomURL( uri:'/signin/', preserve:'arrSuccess' );
			} else {
				user.setActivatedAt( dateConvert('local2Utc', now()) );
				user = variables.userService.save( user );
				if ( len(user.getActivatedAt()) > 0 ) {
					arrayAppend( rc.arrSuccess, { fieldName: "success", message: "Your account has been activated, please login." } );
					variables.framework.redirectCustomURL( uri:'/signin/', preserve:'arrSuccess' );
				} else {
					// Add generic error for failed registration
					rc.arrValidate = variables.validationService.appendArrValidateError(
						 arrValidate:rc.arrValidate
						,fieldName:"generic"
						,error:'The activation link you used appears to be incorrect. <a href="/resend-activation-email/">Request a new activation email?</a>.'
					);
				}
			}
		} else {
			// Add generic error for failed registration
			rc.arrValidate = variables.validationService.appendArrValidateError(
				 arrValidate:rc.arrValidate
				,fieldName:"generic"
				,error:'The activation link you used appears to be incorrect. <a href="/resend-activation-email/">Request a new activation email?</a>.'
			);
		}

		if (arrayLen(rc.arrValidate)) {
			// Create a structure of errors for highlighting form fields when validation errors occur.
			rc.stValidate = StructNew();
			for (var valError = 1; valError <= arrayLen(rc.arrValidate); valError++){
				"rc.stValidate.#rc.arrValidate[valError]['fieldname']#" = rc.arrValidate[valError]['error'];
			}
		}
	}

	function resendactivationemail( struct rc ) {
		param name="rc.email" type="string" default="";
		rc.reCaptchaClientKey = variables.reCaptchaService.getClientKey();
		rc.reCaptchaServerSecret = variables.reCaptchaService.getServerSecret();
		rc.reCaptchaGoogleURL = variables.reCaptchaService.getGoogleURL();

		if ( structKeyExists(rc, "btnResendActivationEmail") ) {
			rules = [
				 "valid_email,email,Please enter a valid email address."
			];
			rc.arrValidate = variables.validationService.formCheck( rc, rules );
			if (arrayLen(rc.arrValidate)) {
				rc.stValidate = variables.validationService.arrValidateToStValidate( rc.arrValidate );
			} else {
				// TODO: Add Google reCaptcha code

				// If validation passed on all fields
				if ( !arrayLen( rc.arrValidate ) ) {
					// Get user by email address
					var user = variables.userService.getByEmail(email:rc.email);
					// If the user exists
					if ( user.getUserID() > 0 ) {
						if ( len( user.getActivatedAt() ) > 0 ) {
							// TODO: If their account has already been activated, we need to show a success message to avoid hackers sniffing the site to see which emails do/don't exist in the system.
						} else {
							// If the account hasn't been activated yet, resend activation email
							variables.securityService.sendActivationEmail(
								 firstname : user.getFirstname()
								,email : user.getUsername()
								,activationKey : user.getActivationKey()
								,activationCode : user.getActivationCode()
							);
						}
					} else {
						// If the user is not found, we need to show a success message to avoid hackers sniffing the site to see which emails do/don't exist in the system.
						// TODO: Send email to email address for security reasons
						// TODO: Generate "success" message for security through obscurity
						abort;
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

	function signin( struct rc ) {
		param name="rc.username" type="string" default="";
		param name="rc.password" type="string" default="";
		
		rc.reCaptchaClientKey = variables.reCaptchaService.getClientKey();
		rc.reCaptchaServerSecret = variables.reCaptchaService.getServerSecret();
		rc.reCaptchaGoogleURL = variables.reCaptchaService.getGoogleURL();

		if ( structKeyExists(rc, "btnSignIn") ) {
			var rules = [
				 "required,username,Please enter your username."
				,"required,password,Please enter your password."
			];
			rc.arrValidate = variables.validationService.formCheck( rc, rules );
			if (arrayLen(rc.arrValidate)) {
				rc.stValidate = variables.validationService.arrValidateToStValidate( rc.arrValidate );
			} else {
				// TODO: Add Google reCaptcha code
				rc.nSignin = variables.securityService.validateSignIn(email:rc.username,password:rc.password);
				if ( rc.nSignin == 1 ) {
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