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
				,u.activationKey
				,u.activationCode
				,u.activationCodeCreatedAt
				,u.activatedAt
				,u.createdAt
				,u.updatedAt
				,urg.roleID
			FROM "user" u
			INNER JOIN userRoleGroup urg
				ON u.userID = urg.userID
			INNER JOIN role r
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
			FROM userRoleGroup urg
			INNER JOIN role r
				ON urg.roleID = r.roleID
			WHERE urg.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#" />
		</cfquery>

		<cfreturn local.qUserRoles />
	</cffunction>

	<cffunction name="insertUser" access="public" returntype="numeric">
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		<cfargument name="salt" type="string" required="true" />
		<cfargument name="firstname" type="string" required="true" />
		<cfargument name="lastname" type="string" required="true" />
		<cfargument name="activationKey" type="string" required="true" />
		<cfargument name="activationCode" type="string" required="true" />
		<cfargument name="roleID" type="numeric" required="true" />

		<cfset var userID = 0 />
		<cftransaction>
			<cftry>
				<cfquery name="local.q1" datasource="#variables.dsn#">
					INSERT INTO "user" (
						 username
						,password
						,salt
						,firstname
						,lastname
						,activationKey
						,activationCode
						,activationCodeCreatedAt
						,createdAt
						,updatedAt
					) VALUES (
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" />
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" />
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.salt#" />
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstname#" />
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastname#" />
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activationKey#" />
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activationCode#" />
						,now() at time zone 'utc'
						,now() at time zone 'utc'
						,now() at time zone 'utc'
					)
					RETURNING userID
				</cfquery>
				<cfset userID = local.q1.userID />
				<cfif userID LTE 0>
					<cfthrow>
				</cfif>
				<cfquery name="local.q2" datasource="#variables.dsn#">
					INSERT INTO userRoleGroup (
						 userID
						,roleID
					) VALUES (
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#" />
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.roleID#" />
					)
				</cfquery>
				<cftransaction action="commit" />
				<cfcatch>
					<cftransaction action="rollback" />
				</cfcatch>
			</cftry>
		</cftransaction>
		<cfreturn userID />
	</cffunction>

</cfcomponent>