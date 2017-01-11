<cfoutput>
	<h2>Create an account</h2>

	<p>Some blurb about the benefits of creating an account.</p>

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
	<form id="registrationForm" name="registrationForm" method="post">
		<fieldset>

			<p>Already registered? <a href="#buildCustomURL('/signin/')#">Sign in</a>.</p>

			<div class="<cfif structkeyexists(rc.stValidate, 'firstname')>has-error</cfif>">
				<input type="text" id="firstname" name="firstname" value="#rc.firstname#" placeholder="First name" />
				<cfif structkeyexists(rc.stValidate, 'firstname')>
					<div class="error">
						#rc.stValidate.firstname#
					</div>
				</cfif>
			</div>
			<div class="<cfif structkeyexists(rc.stValidate, 'lastname')>has-error</cfif>">
				<input type="text" id="lastname" name="lastname" value="#rc.lastname#" placeholder="Last name" />
				<cfif structkeyexists(rc.stValidate, 'lastname')>
					<div class="error">
						#rc.stValidate.lastname#
					</div>
				</cfif>
			</div>
			<div class="<cfif structkeyexists(rc.stValidate, 'username')>has-error</cfif>">
				<input type="text" id="username" name="username" value="#rc.username#" placeholder="Email address" />
				<cfif structkeyexists(rc.stValidate, 'username')>
					<div class="error">
						#rc.stValidate.username#
					</div>
				</cfif>
			</div>
			<div class="<cfif structkeyexists(rc.stValidate, 'username') || structKeyExists(rc.stValidate, 'confirmUsername')>has-error</cfif>">
				<input type="text" id="confirmUsername" name="confirmUsername" value="#rc.confirmUsername#" placeholder="Confirm email address" />
				<cfif structkeyexists(rc.stValidate, 'confirmUsername')>
					<div class="error">
						#rc.stValidate.confirmUsername#
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
			<div class="<cfif structkeyexists(rc.stValidate, 'password')>has-error</cfif>">
				<input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password">
				<cfif structkeyexists(rc.stValidate, 'confirmPassword')>
					<div class="error">
						#rc.stValidate.confirmPassword#
					</div>
				</cfif>
			</div>
			<!--- Google reCaptcha --->
			<!--- See https://www.google.com/recaptcha/intro/index.html for more details --->
			<div class="g-recaptcha" data-sitekey="#rc.reCaptchaClientKey#"></div>
			<p>By clicking on the "Create Account" button below, you confirm that you have read, understood and agree to the <a href="#buildCustomURL('/terms/')#" target="_blank">terms and privacy policies</a>.</p>

			<div class="form-actions">
				<button type="submit" id="btnCreateAccount" name="btnCreateAccount" class="btn btn-secondary">Create Account</button>
			</div>

		</fieldset>
	</form>
</cfoutput>