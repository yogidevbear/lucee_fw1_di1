component accessors=true {

	public string function ordinalSuffix( numeric theNumber ) {
		var suffix = "";
		if ( theNumber >= 10 && mid( theNumber, len(theNumber)-1, 1) == "1" ) {
			suffix = "th";
		} else if ( theNumber > 0 ) {
			switch ( right( theNumber, 1 ) ) {
				case "1":
					suffix = "st";
					break;
				case "2":
					suffix = "nd";
					break;
				case "3":
					suffix = "rd";
					break;
				default:
					suffix = "th";
					break;
			}
		}
		return suffix;
	}

	public string function hexToRgba( required string hex, numeric opacity = 1 ) {
		var cleanHex = Replace( arguments.hex, "##", "", "all" );
		var rgba = ArrayNew(1);
		ArrayAppend( rgba, mid( cleanHex, 1, 2 ) );
		ArrayAppend( rgba, mid( cleanHex, 3, 2 ) );
		ArrayAppend( rgba, mid( cleanHex, 5, 2 ) );
		return "rgba(#InputBaseN(rgba[1],16)#,#InputBaseN(rgba[2],16)#,#InputBaseN(rgba[3],16)#,#arguments.opacity#)";
	}

	public string function ellipse( required string originalString, required numeric newLength ) {
		if ( arguments.newLength <= 0 ) || ( len(arguments.originalString) <= arguments.newLength ) {
			return arguments.originalString;
		}
		return left( trim( arguments.originalString ), arguments.newLength ) & "...";
	}

	public numberic function daysCountDown( required string dateTo, string dateFrom = "#Now()#" ) {
		var nResult = DateDiff(
			"d",
			CreateDate( DatePart('yyyy',arguments.dateFrom), DatePart('m',arguments.dateFrom), DatePart('d',arguments.dateFrom) ),
			CreateDate( DatePart('yyyy',arguments.dateTo), DatePart("m",arguments.dateTo), DatePart("d",arguments.dateTo) )
		);
		return nResult;
	}

	public struct function cfzip( required string directoryToZip, required string destination, boolean overwrite = true ) {
		var stResult = { status : false, error : "" };

		try {
			cfzip( action = "zip", source = directoryToZip, file = destination, overwrite = overwrite );
			stResult.status = true;
		} catch(any e) {
			stResult.error = e;
		}

		return stResult;
	}

	/* Converts a specific row in a query result set object into a structure (Courtesy of Neiland - http://www.neiland.net/blog/article/converting-a-query-row-into-a-structure/) */
	public struct function rowToStruct( required query queryObj, required numeric row ) {
		var stResult = {};
		var colname = "";

		for ( var colname in queryObj.columnList ) {
			stResult[colname] = queryObj[colname][row];
		}

		return stResult;
	}

	/* Converts a query result set object into an array of structures (Courtesy of Neiland - http://www.neiland.net/blog/article/converting-a-query-row-into-a-structure/) */
	public array function rowToStructArray( required query queryObj ) {
		var aResult = [];
		var colname = "";

		for ( var row in queryObj ) {
			var rowStruct = {};
			for ( var colname in queryObj.columnList ) {
				rowStruct[colname] = queryObj[colname][queryObj.currentRow];
			}
			arrayAppend( aResult, rowStruct );
		}

		return aResult;
	}

}
/*
<cfcomponent accessors="true">

	<cffunction name="ordinalSuffix" access="public" output="false" returntype="string">
		<cfargument name="theNumber" type="numeric" required="true">

		<cfset var suffix = "">

		<cfif theNumber GTE 10 AND mid(theNumber,len(theNumber)-1,1) EQ "1">
			<cfset suffix = "th">
		<cfelseif theNumber GT 0>
			<cfswitch expression="#right(theNumber,1)#">
				<cfcase value="1">
					<cfset suffix = "st">
				</cfcase>
				<cfcase value="2">
					<cfset suffix = "nd">
				</cfcase>
				<cfcase value="3">
					<cfset suffix = "rd">
				</cfcase>
				<cfdefaultcase>
					<cfset suffix = "th">
				</cfdefaultcase>
			</cfswitch>
		</cfif>

		<cfreturn suffix>
	</cffunction>

	<cffunction name="hexToRgba" access="public" output="false" returntype="String">
		<cfargument name="hex" required="true" />
		<cfargument name="opacity" type="numeric" default="1" />
		<cfset var cleanHex = Replace(arguments.hex,"##","","all")>
		<cfset var rgba = ArrayNew(1)>
		<cfset ArrayAppend(rgba,mid(cleanHex,1,2))>
		<cfset ArrayAppend(rgba,mid(cleanHex,3,2))>
		<cfset ArrayAppend(rgba,mid(cleanHex,5,2))>
		<cfreturn "rgba(#InputBaseN(rgba[1],16)#,#InputBaseN(rgba[2],16)#,#InputBaseN(rgba[3],16)#,#arguments.opacity#)">
	</cffunction>

	<cffunction name="cfzip" access="public" output="false" returntype="Struct">
		<cfargument name="directoryToZip" required="true" type="string" />
		<cfargument name="destination" required="true" type="string" />

		<cfset var strStatus = StructNew() />
		<cfset strStatus.status = false />
		<cfset strStatus.error = "" />

		<cftry>
			<cfzip action="zip" source="#arguments.directoryToZip#" file="#arguments.destination#" overwrite="true" />
			<cfset strStatus.status = true />
			<cfcatch>
				<cfset strStatus.error = cfcatch />
			</cfcatch>
		</cftry>

		<cfreturn strStatus />
	</cffunction>

	<cffunction name="ellipse" access="public" output="false" returntype="string">
		<cfargument name="originalString" type="string" required="true" />
		<cfargument name="newLength" type="numeric" required="true" />
		<cfif ( arguments.newLength LTE 0 ) OR ( len(arguments.originalString) LTE arguments.newLength ) >
			<cfreturn arguments.originalString />
		</cfif>
		<cfreturn left(trim(arguments.originalString), arguments.newLength) & "..." />
	</cffunction>

	<cffunction name="rowToStruct" access="public" returntype="struct" output="false" hint="Converts a specific row in a query result set object into a structure (Courtesy of Neiland - http://www.neiland.net/blog/article/converting-a-query-row-into-a-structure/">
		<cfargument name="queryObj" type="query" required="true" />
		<cfargument name="row" type="numeric" required="true" />

		<cfset var returnStruct = structNew()>
		<cfset var colname = "">

		<cfloop list="#arguments.queryObj.columnList#" index="colname">
			<cfset "returnStruct.#colname#" = arguments.queryObj[colname][arguments.row]>
		</cfloop>

		<cfreturn returnStruct/>
	</cffunction>

	<cffunction name="rowToStructArray" access="public" returntype="array" output="false" hint="Converts a query result set object into an array of structures (Courtesy of Neiland - http://www.neiland.net/blog/article/converting-a-query-row-into-a-structure/)">
		<cfargument name="queryObj" type="query" required="true" />

		<cfset var returnArray = arrayNew(1)>
		<cfset var rowStruct = structNew()>
		<cfset var colname = "">

		<cfloop query="arguments.queryObj">
			<cfset rowStruct = structNew()>
			<cfloop list="#arguments.queryObj.columnList#" index="colname">   
				<cfset "rowStruct.#colname#" = arguments.queryObj[colname][arguments.queryObj.currentRow]>
			</cfloop>
			<cfset arrayAppend(returnArray,rowStruct)>
		</cfloop>

		<cfreturn returnArray/>
	</cffunction>

	<cffunction name="daysCountDown" access="public" returntype="numeric" output="false">
		<cfargument name="dateFrom" type="string" required="false" default="#Now()#" />
		<cfargument name="dateTo" type="string" required="true"  />

		<cfset var dayCountdown = DateDiff(
              "d",
              CreateDate( DatePart('yyyy',arguments.dateFrom), DatePart('m',arguments.dateFrom), DatePart('d',arguments.dateFrom) ),
              CreateDate( DatePart('yyyy',arguments.dateTo), DatePart("m",arguments.dateTo), DatePart("d",arguments.dateTo) )
             )>
		<cfreturn dayCountdown/>
	</cffunction>

</cfcomponent>*/