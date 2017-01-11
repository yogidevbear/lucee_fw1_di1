<cfcomponent accessors="true">
	
	<cffunction name="init" returntype="any">
		<cfargument name="dsn" type="any" />
		<cfset variables.dsn = dsn />
		<cfreturn this />
	</cffunction>

	<cffunction name="getCountries" access="public" returntype="query" >
		<cfargument name="countryID" type="numeric" default="0" />

		<cfquery name="local.q1" datasource="#variables.dsn#">
			SELECT
				 c.countryID
				,c.countryName
				,c.countryCode2
				,c.countryCode3
				,c.IanaInternet
				,c.ItuCalling
			FROM country c
			ORDER BY c.countryName ASC
		</cfquery>

		<cfreturn local.q1 />
	</cffunction>

</cfcomponent>