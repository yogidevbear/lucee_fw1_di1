component accessors=true {

	public function init( any beanFactory, any reCaptchaClientKey, any reCaptchaServerSecret, any reCaptchaGoogleUrl ) {
		variables.beanFactory = beanFactory;
		variables.clientKey = reCaptchaClientKey;
		variables.serverSecret = reCaptchaServerSecret;
		variables.googleUrl = reCaptchaGoogleUrl;
		return this;
	}

	public string function getClientKey() {
		return variables.clientKey;
	}

	public string function getServerSecret() {
		return variables.serverSecret;
	}

	public string function getGoogleUrl() {
		return variables.googleUrl;
	}

}