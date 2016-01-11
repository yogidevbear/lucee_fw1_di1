<cfoutput>
	<h1>List of countries:</h1>
	<ul>
		<cfloop collection="#rc.countries#" item="rc.countries.countryID">
			<cfset local.country = rc.countries[rc.countries.countryID] />
			<li>#local.country.getCountryName()# (ID = #local.country.getCountryID()#)</li>
		</cfloop>
	</ul>
</cfoutput>