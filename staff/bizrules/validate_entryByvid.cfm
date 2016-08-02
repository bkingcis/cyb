	<cfquery datasource="#datasource#" name="qSchedule">
		select *,to_char(g_cancelled,'HH12:MI:SS') as canceldate,s.visit_date as schedule_date  from 
		guestvisits GV left join schedule S on GV.v_id = S.v_id
		where GV.v_id = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#attributes.v_id#" />
	</cfquery>
	<cfset cancel = qSchedule.g_cancelled>

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
			

	<cfif NOT qSchedule.recordcount>
		<cfset returncode = "Visit Record Not Found" />
		<cfexit method="exittemplate" />
	</cfif>
	<cfif LEN(qSchedule.canceldate)>
		<cfset returncode = "Canceled" />
		<cfexit method="exittemplate" />
	</cfif>
	
	<cfif val(qSchedule.g_permanent)>
		<!--- <cfif dateCompare(createDate(year(qSchedule.g_initialvisit),month(qSchedule.g_initialvisit),day(qSchedule.g_initialvisit)),createDate(year(request.timezoneadjustednow),month(request.timezoneadjustednow),day(request.timezoneadjustednow))) gte 0>
			<cfset returncode = "Premature Access" />
			<cfexit method="exittemplate" />		
		<cfelse> --->
			<cfset returncode = "Allow Access" />
			<cfset validentry = true>
			<cfexit method="exittemplate" />	
		<!--- </cfif>	 --->
	</cfif>
	
	<cfif val(qSchedule.g_singleentry)>
		<cfquery datasource="#datasource#" name="qVisits">
			SELECT g_checkedin 
			FROM visits 
			WHERE v_id = #qSchedule.v_id#
		</cfquery>
		<cfif qVisits.recordcount>
			<cfset returncode = "Single Entry Used - No Access" />
			<cfexit method="exittemplate" />
		<cfelse>
			<cfif dateCompare(qSchedule.schedule_date,startdate) gte 0
				AND dateCompare(qSchedule.schedule_date,enddate) lt 0>
				<cfset returncode = "Allow Access" />
				<cfset validentry = true>
				<cfexit method="exittemplate" />	
			<cfelse>	
				<cfset returncode = "Date Not Scheduled For Access" />
				<cfexit method="exittemplate" />
			</cfif>
		</cfif>
	<cfelse>
		<cfloop query="qSchedule"><!--- The loop only applies here because the full-day type guest may have multiple records, all others would only have one date scheduled --->
			<cfif dateCompare(qSchedule.schedule_date,startdate) gte 0
				AND dateCompare(qSchedule.schedule_date,enddate) lt 0>
				<cfset returncode = "Allow Access" />
				<cfset validentry = true>
				<cfexit method="exittemplate" />	
			</cfif>
		</cfloop>
		<cfset returncode = "Date Not Scheduled For Access" />
		<cfexit method="exittemplate" />
	</cfif>
		