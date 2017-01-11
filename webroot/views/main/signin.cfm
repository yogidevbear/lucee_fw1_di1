<cfoutput>
	<h2>Sign in</h2>

	<p>Some blurb about signing in to your account.</p>

	<cfif structKeyExists(rc.stValidate,'generic') && arrayLen(rc.stValidate.generic)>
		<div class="alert alert-error">
			Error:
			<ul>
				<cfloop array="#rc.stValidate.generic#" index="error" >
					<li>#error#</li>
				</cfloop>
			</ul>
		</div>
	</cfif>
	<form id="signInForm" name="signInForm" method="post">
		<fieldset>

			<p>Don't have an account? <a href="#buildCustomURL('/signup/')#">Sign up</a>.</p>

			<div class="<cfif structkeyexists(rc.stValidate, 'username')>has-error</cfif>">
				<input type="text" id="username" name="username" value="#rc.username#" placeholder="Email address" />
				<cfif structkeyexists(rc.stValidate, 'username')>
					<div class="error">
						#rc.stValidate.username#
					</div>
				</cfif>
			</div>
			<div class="<cfif structkeyexists(rc.stValidate, 'password')>has-error</cfif>">
				<input type="password" id="password" name="password" placeholder="Password" />
				<cfif structkeyexists(rc.stValidate, 'password')>
					<div class="error">
						#rc.stValidate.password#
					</div>
				</cfif>
			</div>
			<!--- Google reCaptcha --->
			<!--- See https://www.google.com/recaptcha/intro/index.html for more details --->
			<div class="g-recaptcha" data-sitekey="#rc.reCaptchaClientKey#"></div>
			
			<div class="form-actions">
				<button type="submit" id="btnSignIn" name="btnSignIn" class="btn btn-secondary">Sign In</button>
			</div>

		</fieldset>
	</form>
</cfoutput>