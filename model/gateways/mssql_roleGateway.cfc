<cfcomponent accessors="true">
	
	<cfproperty name="dsn" />

	<cffunction name="init" returntype="any">
		<cfreturn this />
	</cffunction>

	<cffunction name="getRoles" access="public" returntype="query" >
		<cfargument name="roleID" type="numeric" default="0" />

		<cfset local.fakeQuery = QueryNew("roleID,roleName","cf_sql_integer,cf_sql_varchar") />
		<cfset local.newRow = QueryAddRow(local.fakeQuery, 3) />
		<cfset local.temp = QuerySetCell(local.fakeQuery, "roleID", 1, 1)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "roleName", "Admin", 1)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "roleID", 2, 2)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "roleName", "User", 2)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "roleID", 3, 3)>
		<cfset local.temp = QuerySetCell(local.fakeQuery, "roleName", "Guest", 3)>

		<cfquery name="local.q1" dbtype="query">
			SELECT *
			FROM local.fakeQuery
			ORDER BY roleName ASC
		</cfquery>

		<cfreturn local.q1 />
	</cffunction>

</cfcomponent>