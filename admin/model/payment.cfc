<cfcomponent displayname="Payment">
	<cffunction name="GetHistoryByComunity" returntype="query">
		<cfargument name="c_id" required="Yes">		
		<cfquery datasource="#request.dsn#" name="get">
			select * from communityPaymentHistory 
			WHERE  c_id = #arguments.c_id#
			order by insertdate desc
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="insertPayment">		
		<cfquery datasource="#request.dsn#">
			insert into communityPaymentHistory (
				c_id,refNumber,paymentAmount
				)
			values ('#arguments.c_id#','#arguments.refNumber#',#arguments.paymentAmount#)
		</cfquery>
		<cfreturn true>
	</cffunction>
</cfcomponent>