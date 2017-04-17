<cfoutput>
	<h2>Activate Account</h2>

	<cfif structKeyExists(rc,'arrValidate') AND arrayLen(rc.arrValidate)  >
		<div class="alert alert-error">
			<cfloop array="#rc.arrValidate#" index="arrError" >
				<p>#arrError.error#</p>
			</cfloop>
		</div>
	</cfif>
</cfoutput>