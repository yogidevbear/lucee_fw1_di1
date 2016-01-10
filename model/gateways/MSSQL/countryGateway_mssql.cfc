<cfcomponent accessors="true">
<cfdump var="::: /model/gateways/MSSQL/countryGateway_mssql.cfc :::" />
	
	<cfproperty name="dsn" />

	<cffunction name="init" returntype="any">
		<cfdump var="START: /model/gateways/MSSQL/countryGateway_mssql.cfc -> init()" />
		<cfdump var="END: /model/gateways/MSSQL/countryGateway_mssql.cfc -> init()" />
		<cfreturn this />
	</cffunction>

	<cffunction name="getCountries" access="public" returntype="query" >
		<cfargument name="countryID" type="numeric" default="0" />
<cfdump var="START: /model/gateways/MSSQL/countryGateway_mssql.cfc -> getCountries()" />
		<cfset var queries = structNew() />

		<cfquery name="queries.q1" datasource="#variables.dsn#">
			SELECT 'United Kingdom'
		</cfquery>

<cfdump var="END: /model/gateways/MSSQL/countryGateway_mssql.cfc -> getCountries()" />
		<cfreturn queries.q1 />
	</cffunction>

</cfcomponent>