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
				,u.activatedAt at time zone 'utc' as activatedAt
				,u.createdAt at time zone 'utc' as createdAt
				,u.updatedAt at time zone 'utc' as updatedAt
			FROM "user" u
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
		<cfargument name="roleIDList" type="string" required="true" />

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
				<cfloop list="#arguments.roleIDList#" item="roleID">
					<cfquery name="local.q2" datasource="#variables.dsn#">
						INSERT INTO userRoleGroup (
							 userID
							,roleID
						) VALUES (
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#" />
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#roleID#" />
						)
					</cfquery>
				</cfloop>
				<cftransaction action="commit" />
				<cfcatch>
					<cftransaction action="rollback" />
				</cfcatch>
			</cftry>
		</cftransaction>
		<cfreturn userID />
	</cffunction>

	<cffunction name="updateUser" access="public" returntype="boolean">
		<cfargument name="userID" type="numeric" required="true" />
		<cfargument name="username" type="string" required="true" />
		<cfargument name="password" type="string" required="true" />
		<cfargument name="salt" type="string" required="true" />
		<cfargument name="firstname" type="string" required="true" />
		<cfargument name="lastname" type="string" required="true" />
		<cfargument name="activationKey" type="string" required="true" />
		<cfargument name="activationCode" type="string" required="true" />
		<cfargument name="activatedAt" type="string" required="true" />
		<cfargument name="roleIDList" type="string" required="true" />

		<cftransaction>
			<cftry>
				<cfquery name="local.q1" datasource="#variables.dsn#">
					UPDATE "user"
					SET	 username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" />
						,password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" />
						,salt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.salt#" />
						,firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstname#" />
						,lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastname#" />
						,activationKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activationKey#" />
						,activationCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activationCode#" />
						,activationCodeCreatedAt = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.activationCodeCreatedAt#" />
						,activatedAt = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.activatedAt#" />
						,updatedAt = now() at time zone 'utc'
					WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#" />
				</cfquery>
				<cfquery name="local.q2" datasource="#variables.dsn#">
					DELETE FROM userRoleGroup
					WHERE userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userID#" />
				</cfquery>
				<cfloop list="#arguments.roleIDList#" item="roleID">
					<cfquery name="local.q3" datasource="#variables.dsn#">
						INSERT INTO userRoleGroup (
							 userID
							,roleID
						) VALUES (
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#" />
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#roleID#" />
						)
					</cfquery>
				</cfloop>
				<cftransaction action="commit" />
				<cfcatch>
					<cftransaction action="rollback" />
					<cfreturn false />
				</cfcatch>
			</cftry>
		</cftransaction>
		<cfreturn true />
	</cffunction>

</cfcomponent>