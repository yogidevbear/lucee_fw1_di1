<cfcomponent accessors="true">
	
	<cfproperty name="dsn" />

	<cffunction name="init" returntype="any">
		<cfreturn this />
	</cffunction>

	<cffunction name="getUsers" access="public" returntype="query" >
		<cfargument name="userID" type="numeric" default="0" />

		<cfset local.fakeQuery = QueryNew("userID,userEmail,roleID","cf_sql_integer,cf_sql_varchar,cf_sql_integer") />
		<cfset local.newRow = QueryAddRow(local.fakeQuery, 2) />
		<cfset local.temp = QuerySetCell(local.fakeQuery, "userID", 1, 1)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "userEmail", "bob@example.com", 1)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "roleID", 2, 1)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "userID", 2, 2)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "userEmail", "joe@example.com", 2)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "roleID", 1, 2)>

		<cfquery name="local.q1" dbtype="query">
			SELECT *
			FROM local.fakeQuery
			ORDER BY userEmail ASC
		</cfquery>

		<cfreturn local.q1 />
	</cffunction>

</cfcomponent>