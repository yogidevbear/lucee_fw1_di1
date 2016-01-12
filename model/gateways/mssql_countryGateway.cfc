<cfcomponent accessors="true">
	
	<cfproperty name="dsn" />

	<cffunction name="init" returntype="any">
		<cfreturn this />
	</cffunction>

	<cffunction name="getCountries" access="public" returntype="query" >
		<cfargument name="countryID" type="numeric" default="0" />

		<cfset local.fakeQuery = QueryNew("countryID,countryName","cf_sql_integer,cf_sql_varchar") />
		<cfset local.newRow = QueryAddRow(local.fakeQuery, 5) />
		<cfset local.temp = QuerySetCell(local.fakeQuery, "countryID", 1, 1)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "countryName", "United Kingdom", 1)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "countryID", 2, 2)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "countryName", "Canada", 2)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "countryID", 3, 3)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "countryName", "USA", 3)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "countryID", 4, 4)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "countryName", "China", 4)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "countryID", 5, 5)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "countryName", "Australia", 5)>

		<cfquery name="local.q1" dbtype="query">
			SELECT *
			FROM local.fakeQuery
			ORDER BY countryName ASC
		</cfquery>

		<cfreturn local.q1 />
	</cffunction>

</cfcomponent>