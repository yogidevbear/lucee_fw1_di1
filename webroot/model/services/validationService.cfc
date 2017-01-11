component accessors=true {

	public array function formCheck( required struct form, required array rules ) {
		var lstError = "";
		var arrValidate = [];

		if ( arrayLen(arguments.rules) && !structIsEmpty(arguments.form) ) {
		
			var completeRulesList = arrayToList( arguments.rules, ";" );

			for ( var rule in arguments.rules ) {
				/* reset the match boolean to false */
				bMatch = false;

				ruleType =  listFirst( rule );
	
				// writedump(ruletype);

				if ( ruletype == "required" ) {
					
					bMatch = true;

					variables.fieldName = listGetAt( rule, 2 );
					if ( structKeyExists( arguments.form, variables.fieldName ) ) {
						if ( !len( arguments.form[variables.fieldName] ) ) {
							lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );
						}
					} else {
						lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );
					}

				}
				
				if ( ruletype == "digits_only" ) {
					
					bMatch = true;
					
					variables.fieldName = listGetAt( rule, 2 );
					if (structKeyExists( arguments.form, variables.fieldName) ) {
						if ( !isNumeric(arguments.form[variables.fieldName]) ) {
							lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );
						}
					} else {
						lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );
					}
				}

				if ( ruletype == "same_as" ) {
					// this tests to see if field 1 and field 2 are the same when a user confirms a password
					bMatch = true;

					variables.fieldName1 = listGetAt( rule, 2 );
					variables.fieldName2 = listGetAt( rule, 3 );
					if ( structKeyExists(arguments.form, variables.fieldName1) && structKeyExists( arguments.form, variables.fieldName2 ) ) {
						if (arguments.form[variables.fieldName1] != arguments.form[variables.fieldName2] ) {	
							lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );
						}
					} else {
						lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );			
					}
				}

				if ( ruletype == "valid_email" ) {
					bMatch = true;
					variables.fieldName = listGetAt( rule, 2 );
					if (structKeyExists( arguments.form, variables.fieldName) ){
						if (NOT isValid('email', arguments.form[variables.fieldName] )) {
							lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );			
						}
					}
				}

				if ( ruletype == "valid_uuid" ) {
					bMatch = true;
					if (structKeyExists( arguments.form, variables.fieldName) ){
						if (NOT isValid('uuid', arguments.form[variables.fieldName] )) {
							lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );			
						}
					}
				}

				if ( left(ruletype, 6) == "length" ) {
					// this tests to see if the length of the field is within the limits of the 
					bMatch = true;

					variables.fieldName = listGetAt( rule, 2 );
					
					if ( findNoCase('-', ruletype) ) {
					// if in here, field must be is between lengths
					
						sRuleType 	= replaceNoCase(ruletype, 'length', '', 'all');
						sRuleType 	= replaceNoCase(ruletype, '=', '', 'all');
					
						nLeftValue 	= listFirst( sRuleType, '-' );
						nRightValue = listGetAt(sRuleType, 2, '-');
					
						if ( len(arguments.form[variables.fieldName]) >= nLeftValue && len(arguments.form[variables.fieldName]) <= nRightValue ) { 
							lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) ); 
						}

					} else { 
					
						if ( !isNumeric( mid(ruletype, 8, 1) ) ) {
							sComp = mid( ruletype, 7, 2);  
							nLength = mid( ruletype, 9, len(ruletype) );
						} else {
							sComp = mid( ruletype, 7, 1);
							nLength = mid( ruletype, 8, len(ruletype) );
						}
					
						//writedump(sComp);
						//writedump(arguments.form[variables.fieldName]);
						
						if ( structKeyExists( arguments.form, variables.fieldName ) ) {
							
							switch(sComp) {

								case ">":
									if ( len(arguments.form[variables.fieldName]) <= nLength ) {
										lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );
									}
								break;
		
								case "<":
									if ( len(arguments.form[variables.fieldName]) >= nLength ) {
										lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );
									}
								break;
	
								case ">=":
									if ( len(arguments.form[variables.fieldName]) < nLength ) {
										lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );
									}
								break;
		
								case "<=":
									if ( len(arguments.form[variables.fieldName]) > nLength ) {
										lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );
									}
								break;
		
								case "=":
									if ( len(arguments.form[variables.fieldName]) != nLength ) {
										lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );
									}
								break;
							}
						}
					}
				}

				if ( left( ruletype, 5 ) == "range" ) {
				// this tests to see if the value of the field is within the limits of the range provided
					bMatch = true;

					variables.fieldName = listGetAt( rule, 2 );
				
					if ( findNoCase('-', ruletype ) ) {
					// if in here, field must be is between lengths
						sRuleType = replaceNoCase( ruletype, 'range', '', 'all' );
						sRuleType = replaceNoCase( sRuleType, '=', '', 'all' );
					
						nLeftValue = listFirst( sRuleType, '-' );
						nRightValue = listGetAt( sRuleType, 2, '-' );
						
						if ( arguments.form[variables.fieldName] < nLeftValue || arguments.form[variables.fieldName] > nRightValue ) {
							lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) );
						}

					} else {

						if ( !isNumeric( mid(ruletype, 7, 1) ) ) {
							sComp = mid( ruletype, 6, 2 );  
							nValue = mid( ruletype, 8, len(ruletype) );
						} else {
							sComp = mid( ruletype, 6, 1 );
							nValue = mid( ruletype, 7, len(ruletype) );
						}
						
						/* writedump(sComp); 
						   writedump(arguments.form[variables.fieldName]); */
					
						if ( structKeyExists( arguments.form, variables.fieldName ) ) {
							
							switch(sComp) {
															
								case ">":
									if ( arguments.form[variables.fieldName] <= nValue ) { lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) ); 
									}
								break;	
		
								case "<":
									if ( arguments.form[variables.fieldName] >= nValue ) { lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) ); }
								break;	
	
								case ">=":
									if (arguments.form[variables.fieldName] < nValue ) { lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) ); }
								break;	
		
								case "<=":
									if (arguments.form[variables.fieldName] > nValue ) { lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) ); }
								break;
		
								case "=":
									if ( arguments.form[variables.fieldName] != nValue ) { lstError = listAppend( lstError, listFindNoCase( completeRulesList, rule, ";" ) ); }
								break;	
							} 

						}	

					} 
					
				}	
				
				
				/* In case the rule entered is not a rule we need to advise the user */
				if ( !bMatch ) {
					arrayAppend(arrValidate, structNew());
					arrValidate[arrayLen(arrValidate)].fieldName = ruleType; 
					arrValidate[arrayLen(arrValidate)].error = 'The rule type you submitted in your rules does not exist';
				}
			}

			if ( listLen(lstError,",") ) {
				for ( var error in lstError ) {
					arrayAppend( arrValidate, structNew() );
					arrValidate[arrayLen(arrValidate)].fieldName = listGetAt( arguments.rules[error], 2, "," );
					arrValidate[arrayLen(arrValidate)].error = listLast( arguments.rules[error], "," );
				}
			}
			
		} else {
			arrayAppend( arrValidate, structNew() );
			arrValidate[arrayLen(arrValidate)].fieldName = 'noRules';
			arrValidate[arrayLen(arrValidate)].error = 'There were no validation rules sent to the form validation function';
		}
		
		return arrValidate;

	}

	public array function appendArrValidateError(
		required array arrValidate,
		required string fieldName,
		required string error
	) {
		var errorToAppend = {fieldName=arguments.fieldName,error=arguments.error};
		arrayAppend(arguments.arrValidate, errorToAppend);
		return arguments.arrValidate;
	}

	/* Create a structure of errors from arrValidate for highlighting form fields when validation errors occur. */
	public struct function arrValidateToStValidate ( required array arrValidate ) {
		var stValidate = StructNew();
		for (var valError = 1; valError <= arrayLen(arguments.arrValidate); valError++){
			"stValidate.#arguments.arrValidate[valError]['fieldname']#" = arguments.arrValidate[valError]['error'];
		}
		return stValidate;
	}

}