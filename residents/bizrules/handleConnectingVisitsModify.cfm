<cfset breaksRule = False>
<cfparam name="lastITTDate" default="" />
<cfparam name="session.message" default="" />

<!--- OrderDates:  Incoming Query Object - Lists all new requested dates 
######  RULE:  IF New Dates Exceed (or proceed) the existing dates by more 
that a day (ie..are not connecting dates) the Rule will not be met. ###### --->

<!--- query original dates --->
<cfquery datasource="#datasource#" name="qoriginaldates">
	select visit_date from schedule
	where v_id = <cfqueryparam value="#val(form.v_id)#" cfsqltype="CF_SQL_INTEGER" />
	order by visit_date
</cfquery>
<cfset originalstartdate = qoriginaldates.visit_date[1]>
<cfset originalenddate = qoriginaldates.visit_date[qoriginaldates.recordcount]>
<cfset breaksRule = false>
<cfif DateDiff("d",orderdates.datelist[1],originalstartdate) gt 1>
	<cfset prevdate = orderdates.datelist[1]>
	<cfloop query="orderdates" startrow="2">
		<cfif DateDiff("d",prevdate,orderdates.datelist) gt 1>
			<cfset breaksrule = true>
			<cfbreak />
		<cfelse>
			<cfset prevdate = orderdates.datelist>
		</cfif>	
	</cfloop>
	<cfif breaksRule>
		<cfsavecontent variable="session.message">
			<cfoutput>#session.message#<br>
			<strong>Please Avoid Breaks Between Preexisting and Added Date(s)</strong><br><br>
			<br />(To help maintain our community security, please schedule this guest in a new announcement)</cfoutput>
		</cfsavecontent>
	</cfif>
</cfif>

<cfif NOT breaksRule and DateDiff("d",originalenddate,orderdates.datelist[orderdates.recordcount]) gt 1>
	<cfset newend = dateformat(orderdates.datelist[orderdates.recordcount])>
	<cfloop from="#dateDiff('d',newend,originalenddate)#" to="0" step="1" index="ind">
		<cfset found = 0>
		<cfloop query="orderdates">
			<cfif dateCompare(orderdates.datelist,dateAdd('d',ind,newend)) eq 0><!--- a match was found --->
				<cfset found = 1>
			</cfif>
		</cfloop>
		<cfif NOT found>
			<cfset breaksRule = true>
			<cfbreak />			
		</cfif>
	</cfloop>
	<cfif breaksRule>
		<cfsavecontent variable="session.message">
			<cfoutput>#session.message#<br>
			<!--- any previous notes --->
			<strong>Please Avoid Breaks Between Preexisting and Added Date(s)</strong><br><br>
			<br />(To help maintain our community security, please schedule this guest in a new announcement)</cfoutput>
		</cfsavecontent>
	</cfif>	
</cfif>

