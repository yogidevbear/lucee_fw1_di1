<cfcomponent accessors="true">
	
	<!--- <cfproperty name="dsn" /> --->

	<cffunction name="init" returntype="any">
		<cfargument name="dsn" type="any" />
		<cfset variables.dsn = dsn />
		<cfreturn this />
	</cffunction>

	<cffunction name="getRoles" access="public" returntype="query" >
		<cfargument name="roleID" type="numeric" default="0" />

		<cfquery name="local.q1" datasource="#variables.dsn#">
			SELECT
				 r.roleID
				,r.roleName
			FROM role r
			ORDER BY r.roleName ASC
		</cfquery>

		<cfreturn local.q1 />
	</cffunction>

</cfcomponent>