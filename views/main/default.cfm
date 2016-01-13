<cfoutput>
	<h1>List of countries:</h1>
	<ul>
		<cfloop collection="#rc.countries#" item="rc.countries.countryID">
			<cfset local.country = rc.countries[rc.countries.countryID] />
			<li>#local.country.getCountryName()# (ID = #local.country.getCountryID()#)</li>
		</cfloop>
	</ul>

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
			<li>#local.user.getUserEmail()# (ID = #local.user.getUserID()#; roleID = #local.user.getRoleID()#; roleName = #local.user.getRole().getRoleName(local.user.getRoleID())#)</li>
		</cfloop>
	</ul>
</cfoutput>