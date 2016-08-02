<cfparam name="form.dashpass" default="" />
<cfset barcode = form.dashpass>
<cfif not isDefined("datasource")>
	<cfset datasource = caller.datasource>
</cfif>

<cfset timezoneadj = session.timezoneadj>

<!--- FIRST WE'LL CLEAN OUT ANY RIF-RAFF (BAD CODES OR CANCELED CODES) --->
<cfquery datasource="#datasource#" name="validatecode">
	select *,to_char(DATE_CANCELLED,'HH12:MI:SS') as canceldate  from barcodes 
	where barcode = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#barcode#" />
	and c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfset cancel = validatecode.DATE_CANCELLED>
<cfif not validatecode.recordcount>
	<cfset returncode = "invalid barcode" />	
	<cfexit method="exittemplate" />
</cfif>
<cfif NOT validatecode.canceldate is ''>
	<cfset returncode = "canceled barcode" />
	<cfexit method="exittemplate" />
</cfif>	

<!--- NOW THAT WE GOT THAT OUT OF THE WAY - LET'S VERIFY THAT THE BARCODE MATCHES OUR ENTRY TIME/DATE --->
	<cfquery datasource="#datasource#" name="qSchedule">
		select GV.*,S.*,g.g_paused,to_char(g_cancelled,'HH12:MI:SS') as canceldate  from 
		guestvisits GV left join schedule S on GV.v_id = S.v_id
		join guests g on g.g_id = GV.g_id
		<!--- left join visits v on gv.v_id = v.v_id --->
		where GV.g_barcode = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#barcode#" />
		and ( s.g_barcode = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#barcode#" />
		 OR s.g_barcode is null)
	</cfquery>
	<cfset cancel = qSchedule.g_cancelled>

	<cfif NOT qSchedule.recordcount>
		<cfset returncode = "DashPass Does Not Match" />	
		<cfexit method="exittemplate" />
	</cfif>
	<cfif LEN(qSchedule.canceldate)>
		<cfset returncode = "canceled barcode" />
		<cfexit method="exittemplate" />
	</cfif>
	<!--- new logic needed to expand 3 hours before and after this 24 period.  SO if 
			the current date/time is 3 hours (or less) away from the adjacent date we need to
			allow those times as well.  Ex. If it is 10PM we need to allow up to 4AM tomorrow, 
			or if it is 2AM we need to allow guests from 8PM the previous day --->
	<cfif hour(request.timezoneadjustednow) gt 21>
		<cfset BEGINTIME = createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>
		<cfset ENDTIME = dateAdd('h',27,BEGINTIME)>
	<cfelseif hour(request.timezoneadjustednow) lt 3>
		<cfset tempvar = createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>
		<cfset ENDTIME = dateAdd('d',1,tempvar)>
		<cfset BEGINTIME =  dateAdd('h',-27,ENDTIME)>
	<cfelse>
		<cfset BEGINTIME = createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))>
		<cfset ENDTIME = dateAdd('d',1,BEGINTIME)>
	</cfif>
	
	<cfset startdate = begintime>
	<cfset enddate = endtime>
	
		<!--- SINGLE ENTRY --->
		<cfif val(qSchedule.g_singleentry)>
			<!--- 1.check for schedule date --->
			
			<cfif dateCompare(qSchedule.g_initialvisit,startdate) lt 0
				OR dateCompare(qSchedule.g_initialvisit,enddate) gt 0>
				<cfset returncode = "single entry Not Scheduled" />	
				<cfoutput>startdate: #startdate# <br />enddate: #enddate#</cfoutput>
				<cfabort >
				<cfexit method="exittemplate" />
			</cfif>
			
			<!--- 2. check that activation has not already happened --->
			<cfquery datasource="#datasource#" name="qVisits">
				select * from visits 
				where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#qSchedule.v_id#" />
			</cfquery>
			<cfif qVisits.recordcount>
				<cfset returncode = "single entry already activated" />	
				<cfexit method="exittemplate" />
			</cfif>
			
			<!--- otherwise single entry is valid --->
				<cfset returncode = "allow single entry" />	
				<cfexit method="exittemplate" />
			
			
		<cfelseif val(qSchedule.g_permanent)>
			
			<!--- 1. check for schedule date (must be after initial schedule date.) --->
			<cfif dateCompare(qSchedule.g_initialvisit,startdate) lt 0
				OR dateCompare(qSchedule.g_initialvisit,enddate) gt 0>
				<cfset returncode = "permanent early" />	
				<cfexit method="exittemplate" />
			<cfelseif qSchedule.g_paused>
				<cfset returncode = "permanent paused" />	
				<cfexit method="exittemplate" />
			<cfelse>
				<cfset returncode = "allow permanent" />	
				<cfexit method="exittemplate" />
			</cfif>
		<cfelse>
			<!--- 7. VALID FULL DAY - --->
			<cfloop query="qSchedule">
				<cfif currentrow is 1>
					<cfset use_initialvisit = true>
					<cfset ITTdate = qSchedule.g_initialvisit>	
				<cfelse>
					<cfset use_initialvisit = false>
					<cfset ITTdate = qSchedule.visit_date>	
				</cfif>
				<cfif isDate(ITTdate)>		
					<cfif dateCompare(ITTdate,startdate) gte 0 AND dateCompare(ITTdate,enddate) lt 0>    
						<cfset returncode = "allow fullday">
						<cfexit method="exittemplate" />
					</cfif>
				</cfif>
			</cfloop>
			<cfset returncode = "fullday Not Scheduled">
			<cfexit method="exittemplate" />
		</cfif>
	
<cfabort>