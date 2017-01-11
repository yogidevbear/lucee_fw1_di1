<cfcomponent accessors="true">

	<cffunction name="init" returntype="any">
		<cfargument name="dsn" type="any" />
		<cfset variables.dsn = dsn />
		<cfreturn this />
	</cffunction>

	<cffunction name="getUsers" access="public" returntype="query">
		<cfargument name="userID" type="numeric" default="0" />

		<cfquery name="local.qUsers" datasource="#variables.dsn#">
			SELECT
				 u.userID
				,u.username
				,u.password
				,u.salt
				,u.firstname
				,u.lastname
				,u.activationCode
				,u.activationCodeCreatedAt
				,u.activatedAt
				,u.createdAt
				,u.updatedAt
				,urg.roleID
			FROM dbo.[user] u
			INNER JOIN dbo.userRoleGroup urg
				ON u.userID = urg.userID
			INNER JOIN dbo.role r
				ON urg.roleID = r.roleID
			WHERE u.removedAt IS NULL
			<cfif userID GT 0>
			  AND u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#" />
			</cfif>
			ORDER BY u.username ASC
		</cfquery>

		<cfreturn local.qUsers />
	</cffunction>

	<cffunction name="getUserRoles" access="public" returntype="query">
		<cfargument name="userID" type="numeric" required="true" />

		<cfquery name="local.qUserRoles" datasource="#variables.dsn#">
			SELECT
				 urg.userID
				,urg.roleID
				,r.roleName
			FROM dbo.userRoleGroup urg
			INNER JOIN dbo.role r
				ON urg.roleID = r.roleID
			WHERE urg.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#" />
		</cfquery>

		<cfreturn local.qUserRoles />
	</cffunction>

</cfcomponent>