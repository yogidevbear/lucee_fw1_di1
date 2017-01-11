component accessors=true {

	property userService;

	public function init( any beanFactory, any userService, any pbkdfAlgorithm, any pbkdfIterations, any pbkdfKeysize ) {
		variables.beanFactory = beanFactory;
		variables.userService = userService;
		variables.pbkdfAlgorithm = pbkdfAlgorithm;
		variables.pbkdfIterations = pbkdfIterations;
		variables.pbkdfKeysize = pbkdfKeysize;
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
			,role : "none"
		};
	}

	public boolean function validateSignIn( string email, string password ) {
		var user = variables.userService.getByEmail(email);
		if ( user.getUserID() > 0 ) {
			passwordDetails = variables.userService.getHashesPassword( user.getUsername() );
			if ( structKeyExists(passwordDetails, "hashedPassword") && structKeyExists(passwordDetails, "salt") && len(passwordDetails.salt) > 0 ) {
				if ( passwordDetails.hashedPassword == getPasswordBasedKey(arguments.password, passwordDetails.salt) ) {
					SESSION.stUser = {
						 userID : user.getUserID()
						,fullname : user.getFirstname() & ' ' & user.getLastname()
						,firstname : user.getFirstname()
						,lastname : user.getLastname()
						,role : ""
					};
					for (var role in user.getRoles()) {
						listAppend(SESSION.stUser.role, role.getRoleName());
					}
					return true;
				} else {
					resetSession();
					return false;
				}
			}
		} else {
			resetSession();
			return false;
		}
	}



	public boolean function registerUser(
		 required string username
		,required string password
		,required string firstname
		,required string lastname
		//,required string encryptionKey
	) {
		
		// Trim whitespace from user input
		arguments.username = trim(arguments.username);
		arguments.password = trim(arguments.password);
		arguments.firstname = trim(arguments.firstname);
		arguments.lastname = trim(arguments.lastname);

		// Set var scoped variables
		var salt = getSha1Hash(getTickCount());
		var finalPassword = getPasswordBasedKey(arguments.password, salt);
		var activationCode = getNewActivationCode();
		// var encryptedUsername = getCfmxCompatEncrypt(stringToEncrypt:arguments.username,encryptionKey:arguments.encryptionKey);

		transaction {

			try {

				// Check for user
				local.user = variables.userService.getByEmail(arguments.userName);
				
				if ( local.user.getUserID() > 0 ) {
					if ( len( local.user.getActivatedAt() ) > 0 ) {
						// Account already activated, send email to the user to let them know
						// This is an added security step in case it isn't the actual user trying to activate the account
						sendAlreadyActivatedEmail(
							 from : request.doNotReplyEmail
							,to : arguments.username
							,subject : request.siteName & ': Account Activation'
							,failto : request.failtoEmail
							,name : "#arguments.firstname# #arguments.lastname#"
						);
					} else {
						// Account exists, but hasn't yet been activated
						// Update activation code in database
						
					}
				} else {
					// New user...
				}
				
				/*
				<!--- If they already exist... --->
				<cfif queries.q0.recordCount>
					
					<cfif Len(queries.q0.activatedAt) GT 0>
						<!--- Account already activated, send an email to the user to this effect --->
						<cfscript>
							sendAlreadyActivatedEmail(
								 from : request.doNotReplyEmail
								,to : arguments.username
								,subject : request.siteName & ': Account Activation'
								,failto : request.failtoEmail
								,name : "#arguments.firstname# #arguments.lastname#"
							);
						</cfscript>

					<cfelse>
						<!--- Account exists, but hasn't yet been activated --->
						<!--- Update activation code in database --->
						<cfquery name="queries.q1" datasource="#variables.dsn#" result="queries.r1">
							UPDATE dbo.tUser
							SET
								 activationCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#activationCode#" maxlength="15" />
								,activationCodeCreatedAt = GETUTCDATE()
						</cfquery>
						
						<!--- Resend activation email --->
						<cfscript>
							sendActivationEmail(
								 from : request.doNotReplyEmail
								,to : arguments.username
								,subject : request.siteName & ': Account Activation'
								,failto : request.failtoEmail
								,activationCode : activationCode
								,encryptedUsername : encryptedUsername
								,name : "#arguments.firstname# #arguments.lastname#"
							);
						</cfscript>
					</cfif>
					<!--- Finished 'registering' for already existing accounts --->
					
				<cfelse><!--- A new account being created --->

					<!--- Insert user into database --->
					<cfquery name="queries.q1" datasource="#variables.dsn#" result="queries.r1">
						INSERT INTO dbo.tUser (
							 username
							,password
							,salt
							,firstname
							,lastname
							,activationCode
							,activationCodeCreatedAt
							,createdAt
						) VALUES (
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="120" />
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#finalPassword#" maxlength="40" />
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#salt#" maxlength="40" />
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstname#" maxlength="30" />
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastname#" maxlength="30" />
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#activationCode#" maxlength="15" />
							,GETUTCDATE()
							,GETUTCDATE()
						)
					</cfquery>

					<!--- Get userID --->
					<cfset var userID = queries.r1.GENERATEDKEY>

					<!--- Insert user roles --->
					<cfquery name="queries.q2" datasource="#variables.dsn#">
						INSERT INTO dbo.tUserRoleGroup (
							 userID
							,roleID
						)
						SELECT
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#" />
							,r.roleID
						FROM dbo.tRole r
						WHERE r.roleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="User" />
					</cfquery>

					<cfscript>
						sendActivationEmail(
							 from : request.doNotReplyEmail
							,to : arguments.username
							,subject : request.siteName & ': Account Activation'
							,failto : request.failtoEmail
							,activationCode : activationCode
							,encryptedUsername : encryptedUsername
							,name : "#arguments.firstname# #arguments.lastname#"
						);
					</cfscript>
				</cfif>*/

				transaction action="commit";
abort;
			} catch( Any e ) {

				transaction action="rollback";
				writeDump(e);abort;
				return false;
			}
		}

		return true;
	}

	public string function getNewSalt() {
		return getSha1Hash(getTickCount());
	}

	public string function getNewActivationKey( required string salt ) {
		return getPasswordBasedKey(getNewActivationCode(), arguments.salt);
	}

	public string function getNewActivationCode() {
		var strLowerCaseAlpha = "abcdefghijklmnopqrstuvwxyz";
		var strUpperCaseAlpha = UCase( strLowerCaseAlpha );
		var alpha1 = mid(strUpperCaseAlpha,RandRange( 1, Len( strUpperCaseAlpha ) ), 1);
		var alpha2 = mid(strLowerCaseAlpha,RandRange( 1, Len( strLowerCaseAlpha ) ), 1);
		var activationCode = alpha1 & alpha2 & dateFormat(now(), 'yyyymmdd') & "0#randRange(10,99)#";
		return activationCode;
	}

	public string function getPasswordBasedKey( required string password, required string salt ) {
		return generatePBKDFKey(
			algorithm: variables.pbkdfAlgorithm,
			passphrase: arguments.password,
			salt: arguments.salt,
			iterations: variables.pbkdfIterations,
			keysize: variables.pbkdfKeysize
		);
	}

	private string function getSha1Hash( required string stringToHash ) {
		return hash( arguments.stringToHash, 'SHA-1', 'UTF-8', 1500 );
	}

}