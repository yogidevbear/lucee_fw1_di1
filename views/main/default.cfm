<cfoutput>
	<!--- <h1>List of countries:</h1>
	<ul>
		<cfloop collection="#rc.countries#" item="rc.countries.countryID">
			<cfset local.country = rc.countries[rc.countries.countryID] />
			<li>#local.country.getCountryName()# (ID = #local.country.getCountryID()#)</li>
		</cfloop>
	</ul> --->

	<h1>List of roles:</h1>
	<ul>
		<cfloop collection="#rc.roles#" item="rc.roles.roleID">
			<cfset local.role = rc.roles[rc.roles.roleID] />
			<li>#local.role.getRoleName()# (ID = #local.role.getRoleID()#)</li>
		</cfloop>
	</ul>

	<h1>List of users:</h1>
	<ul>
		<cfloop collection="#rc.users#" item="rc.users.userID">
			<cfset local.user = rc.users[rc.users.userID] />
			<li>
				#local.user.getUsername()# (ID = #local.user.getUserID()#)
				<ul>
					<cfloop array="#local.user.getRoles()#" index="role">
						<li>
							#role.getRoleName()# (Role ID = #role.getRoleID()#)
						</li>
					</cfloop>
				</ul>
			</li>
		</cfloop>
	</ul>

	<h1>User email test:</h1>
	<h4>Pass:</h4>
	<p>#rc.userEmailTestPass.getUsername()# (UserID = #rc.userEmailTestPass.getUserID()#)</p>
	<cfdump var="#rc.userEmailTestPass#" expand="false" />
	<h4>Fail:</h4>
	<p>#rc.userEmailTestFail.getUsername()# (UserID = #rc.userEmailTestFail.getUserID()#)</p>
	<cfdump var="#rc.userEmailTestFail#" expand="false" />
</cfoutput>