component extends=framework.one {

	// you can provide a specific application name if you want:
	this.name = hash( getBaseTemplatePath() );

	// any other application settings:
	this.sessionManagement = true;
	this.sessiontimeout = createTimeSpan(0,2,0,0);

	variables.framework = {
		diConfig : { loadListener : "loadlistener" },
		environments : {
			local : {
				diConfig : {
					constants : {
						propertiesFile : "#ReplaceNoCase(GetDirectoryFromPath(ReplaceNoCase(ExpandPath("*.*"),'\','/','all')),'\','/','all')#config.local.properties", expectedProperties : ["dsn", "encryptionKey"]
					}
				},
				reloadApplicationOnEveryRequest = true, 
				error = "main.detailederror"
			},
			dev : {
				diConfig : {
					constants : {
						propertiesFile : "config.local.properties", expectedProperties : ["dsn", "encryptionKey"]
					}
				},
				reloadApplicationOnEveryRequest = false
			},
			prod : {
				diConfig : {
					constants : {
						propertiesFile : "config.local.properties", expectedProperties : ["dsn", "encryptionKey"]
					}
				},
				password = "supersecret"
			}
		}
	}

	function getEnvironment() {
		if (listFindNoCase("www.your-production-url.com", CGI.SERVER_NAME)) { return "prod"; }
		if (listFindNoCase("dev.your-production-url.com", CGI.SERVER_NAME)) { return "dev"; }
		if (listFindNoCase("127.0.0.1,localhost.your-production-url.com", CGI.SERVER_NAME)) { return "local"; }
		// else
		return "";
	}

	function setupApplication() {}

	function setupSession() {}

	function setupRequest() {
		// If you have some logic that is meant to be run on every request,
		// that does not need to reference the request context,
		// the best way is generally to queue up the desired controller method by name here,
		// like this:
		// controller( 'security.checkAuthorization' );
	}

	function before( struct rc ) {
		// set up your RC values
	}

	function setupView( struct rc ) {
		// pre-rendering logic
	}

	function after( struct rc ) {}

	function setupResponse( struct rc ) {
		// end of request processing
	}


}