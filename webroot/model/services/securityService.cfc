component accessors=true {

	property userService;

	public function init( any beanFactory, any userService, any pbkdfAlgorithm, any pbkdfIterations, any pbkdfKeysize, any siteName, any siteURL, any smtpServer, any smtpPort, any smtpUsername, any smtpPassword, any emailNoReply ) {
		variables.beanFactory = beanFactory;
		variables.userService = userService;
		variables.pbkdfAlgorithm = pbkdfAlgorithm;
		variables.pbkdfIterations = pbkdfIterations;
		variables.pbkdfKeysize = pbkdfKeysize;
		variables.siteName = siteName;
		variables.siteURL = siteURL;
		variables.smtpServer = smtpServer;
		variables.smtpPort = smtpPort;
		variables.smtpUsername = smtpUsername;
		variables.smtpPassword = smtpPassword;
		variables.emailNoReply = emailNoReply;
		if ( !structKeyExists(SESSION,"stUser") ) {
			resetSession();
		}
		return this;
	}

	public void function resetSession() {
		structDelete(SESSION, "stUser");
		SESSION.stUser = {
			 userID : 0
			,fullname : "Guest"
			,firstname : ""
			,lastname : ""
			,roleIDList : ""
			,roleNameList : ""
		};
	}

	public numeric function validateSignIn( string email, string password ) {
		/* return codes:
			0: No user
			1: Active user with correct password
			2: Active user with incorrect password
			3: User still needs activation
		*/
		var user = variables.userService.getByEmail(email);
		if ( user.getUserID() > 0 ) {
			passwordDetails = variables.userService.getHashesPassword( user.getUsername() );
			if ( structKeyExists(passwordDetails, "hashedPassword") && structKeyExists(passwordDetails, "salt") && len(passwordDetails.salt) > 0 ) {
				if ( len(user.getActivatedAt()) > 0 ) {
					if ( passwordDetails.hashedPassword == getPasswordBasedKey(arguments.password, passwordDetails.salt) ) {
						SESSION.stUser = {
							 userID : user.getUserID()
							,fullname : user.getFirstname() & ' ' & user.getLastname()
							,firstname : user.getFirstname()
							,lastname : user.getLastname()
							,roleIDList : ""
							,roleNameList : ""
						};
						for (var role in user.getRoles()) {
							SESSION.stUser.roleIDList = listAppend(SESSION.stUser.roleIDList, role.getRoleID());
							SESSION.stUser.roleNameList = listAppend(SESSION.stUser.roleNameList, role.getRoleName());
						}
						return 1;
					} else {
						resetSession();
						return 2;
					}
				} else {
					resetSession();
					return 3;
				}
			}
		} else {
			resetSession();
			return 0;
		}
	}

	public boolean function sendActivationEmail(
		required string firstname,
		required string email,
		required string activationKey,
		required string activationCode
	) {
		try {
			cfmail(
				to = arguments.email,
				from = variables.emailNoReply,
				subject = "Welcome to #variables.siteName#",
				server = variables.smtpServer,
				port = variables.smtpPort,
				username = variables.smtpUsername,
				password = variables.smtpPassword
			) {
				writeOutput('Hello #arguments.firstname#<br/>Thank you for creating an account on #variables.siteName#. Please activate your account here: <a href="#variables.siteURL#/activate/#encodeForURL(arguments.activationKey)#/#encodeForURL(arguments.activationCode)#/"');
			}
			return true;
		} catch (any e) {
			writeDump(e);abort;
			return false;
		}
	}

	public string function getNewSalt() {
		return getSha1Hash(getTickCount());
	}

	public string function getNewActivationKey( required string passphrase, required string salt ) {
		return getPasswordBasedKey( passphrase: passphrase, salt: salt);
	}

	public string function getNewActivationCode() {
		var strLowerCaseAlpha = "abcdefghijklmnopqrstuvwxyz";
		var strUpperCaseAlpha = UCase( strLowerCaseAlpha );
		var alpha1 = mid(strUpperCaseAlpha,RandRange( 1, Len( strUpperCaseAlpha ) ), 1);
		var alpha2 = mid(strLowerCaseAlpha,RandRange( 1, Len( strLowerCaseAlpha ) ), 1);
		var activationCode = alpha1 & alpha2 & dateFormat(now(), 'yyyymmdd') & "0#randRange(10,99)#";
		return activationCode;
	}

	public string function getPasswordBasedKey( required string passphrase, required string salt ) {
		return generatePBKDFKey(
			algorithm: variables.pbkdfAlgorithm,
			passphrase: passphrase,
			salt: salt,
			iterations: variables.pbkdfIterations,
			keysize: variables.pbkdfKeysize
		);
	}

	private string function getSha1Hash( required string stringToHash ) {
		return hash( arguments.stringToHash, 'SHA-1', 'UTF-8', 1500 );
	}

}