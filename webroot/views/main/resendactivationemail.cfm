<cfoutput>
	<h2>Resend activation email</h2>

	<p>Please enter your email address in the form below and click "Resend Activation Email" to request another activation email.</p>

	<cfif structKeyExists(rc,'arrValidate') AND arrayLen(rc.arrValidate)  >
		<div class="alert alert-error">
			Please fix the following issues to continue:
			<ul>
				<cfloop array="#rc.arrValidate#" index="arrError" >
					<li>#arrError.error#</li>
				</cfloop>
			</ul>
		</div>
	</cfif>
	<form id="resendActivationEmailForm" name="resendActivationEmailForm" method="post">
		<fieldset>

			<p>Already activated? <a href="#buildCustomURL('/signin/')#">Sign in</a>.</p>

			<div class="<cfif structkeyexists(rc.stValidate, 'email')>has-error</cfif>">
				<input type="text" id="email" name="email" value="#rc.email#" placeholder="Email address" />
				<cfif structkeyexists(rc.stValidate, 'email')>
					<div class="error">
						#rc.stValidate.email#
					</div>
				</cfif>
			</div>
			<!--- Google reCaptcha --->
			<!--- See https://www.google.com/recaptcha/intro/index.html for more details --->
			<div class="g-recaptcha" data-sitekey="#rc.reCaptchaClientKey#"></div>
			
			<div class="form-actions">
				<button type="submit" id="btnResendActivationEmail" name="btnResendActivationEmail" class="btn btn-secondary">Resend Activation Email</button>
			</div>

		</fieldset>
	</form>
</cfoutput>