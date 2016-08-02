THIS PAGE IN PROCESS

<!--- dates may not be removed if a checkin has occured for that date --->
<cfquery datasource="#datasource#" name="qoriginaldates">
	select visit_date from schedule
	where v_id = <cfqueryparam value="#val(form.v_id)#" cfsqltype="CF_SQL_INTEGER" />
	order by visit_date
</cfquery>

		<!--- OrderDates is the query containing newly selected dates --->
		<"Dates can not be edited where ">

<!--- dates may not be removed before today's date --->
