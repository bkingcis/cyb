<cfset results = ''><cfset alertList = ''>

<cfloop from="1" to="5" index="i">
	<cfif isDefined('form.LName#i#') AND LEN(evaluate('form.LName#i#'))>	
		<cfif len(evaluate('allSelected'&i)) and Len(evaluate('form.hour'&i))>	
			<cfset FIRSTNAME = UCase(Evaluate('form.fname'&i))>
			<cfset FIRSTNAME = Replace(FIRSTNAME,chr(34),"","ALL")>
			<cfset LASTNAME = UCase(Evaluate('form.lname'&i))>
			<cfset LASTNAME = Replace(LASTNAME,chr(34),"","ALL")>
			<cfset EMAILADDRESS = Evaluate('form.email'&i)>
			<cfset DatesListed = QueryNew("DATELIST")>
			<cfloop list="#evaluate('allSelected'&i)#" index="listItem">
				<cfset thisdate = listItem>			    
			    <cfset QueryAddRow(DatesListed, 1)>			    
			    <cfset QuerySetCell(DatesListed, "DATELIST", thisdate)>
			</cfloop>
			<cfquery name="OrderDates" DBTYPE="query">
				SELECT * from DatesListed
				ORDER BY DATELIST
			</cfquery>
			<!--- Create ODBC Ready Date and Time for Initial Visit--->			
			<cfset InitialVisit = CreateDateTime(DateFormat(OrderDates.DATELIST,"YYYY"),  DateFormat(OrderDates.DATELIST,"MM"),  DateFormat(OrderDates.DATELIST,"DD"),Listfirst(evaluate('form.hour'&i),":"), ListLast(evaluate('form.hour'&i),":"), 00)>
			<cfset emailAddress = Replace(emailaddress,chr(34),"","ALL")>			
			<cfif isDefined("form.punchpassNumber#i#")>
				<cfset MOBILENUMBER = Evaluate('DE(form.punchpassNumber#i#)')>
				<cfset MOBILENUMBER = ReReplace(MOBILENUMBER,'^[0-9]',"","ALL")>
			<cfelse>
				<cfset MOBILENUMBER = ''>
			</cfif>
			<cfif isDefined("form.dashpass#i#")>
				<cfset DASHPASS = Evaluate('DE(form.dashpass#i#)')>
				<cfset DASHPASS = Replace(DASHPASS,chr(34),"","ALL")>
			<cfelse>
				<cfset DASHPASS = ''>
			</cfif>
			<cfif isDefined('form.guestcompanioncount#i#')>
				<cfset guestcompanioncount = evaluate('form.guestcompanioncount#i#')>
			<cfelse>
				<cfset guestcompanioncount = 0>
			</cfif>
			<cfset g_id = createObject('component','guests').create(lastname,firstname,emailaddress,mobilenumber,form.r_id)>
	
			<cfset barcode = createObject('component','barcode').create(g_id)>
			
			<!--- check guest or enter new guest --->
			<cfquery name="insertGuestVisit" datasource="#datasource#">
				INSERT INTO	guestvisits
				(g_initialvisit,dashpass,map_email,g_id,entry_notification,g_barcode,
				insertedby_staff_id,guestcompanioncount)
				VALUES
				(#CreateODBCDateTime(InitialVisit)#,'#DASHPASS#','',#g_id#,'','#barcode#',
				#session.staff_id#,	#val(guestcompanioncount)#				
				)
			</cfquery>	

			<cfquery name="getLast" datasource="#datasource#">
				select max(v_id) as lastid from guestvisits
			</cfquery>
			<cfquery name="getVID" datasource="#datasource#">
				select g_id,v_id,g_barcode
				from guestvisits
				Where v_id = #getlast.lastid#		
			</cfquery>
			<cfquery name="GetResident" datasource="#datasource#">
				select h_id,r_id
				from residents
				Where r_id = #form.r_id#		
			</cfquery>
			<cfset visitid = getVID.v_id>
			<cfloop query="OrderDates">
				<cfquery name="insertSchedule" datasource="#datasource#">
					insert into schedule
					(c_id,h_id,r_id,g_id,
						g_barcode,visit_date
						<cfif ListLen(evaluate('form.allSelected'&i)) IS 1>,g_singleentry</cfif>,
						v_id)				
					values(#session.user_community#,#GetResident.h_id#,	#form.r_id#, #val(g_id)#,'#barcode#', 
						#CreateODBCDate(DATELIST)#<cfif ListLen(evaluate('form.allSelected'&i)) IS 1><cfif isDefined('form.singleEntry'&i)>,TRUE<cfelse>,FALSE</cfif></cfif>,#val(visitid)#)
				</cfquery>
			</cfloop>
			<cfsavecontent variable="message">
			<cfoutput><li>Guest Annoucment Added For #ucase(evaluate('form.lname'&i))#, #ucase(evaluate('form.fname'&i))#</li>
			</cfoutput></cfsavecontent>
			<cfset results = results & message>
		<cfelse>
			<cfsavecontent variable="message">
			<cfset reason ="">
			<cfif NOT Len(evaluate('form.hour'&i))>
				<cfset reason ="Please select an initial Arrival Time.">
			<cfelse>
				<cfset reason ="Please choose the date(s) for this announcement.">
			</cfif>
			
			<cfoutput><li><strong style="color:red;">Alert!</strong> Guest #i# (<strong>#ucase(evaluate('form.lname'&i))#, #ucase(evaluate('form.fname'&i))#</strong>) could not be announced - #reason#</li>
			</cfoutput></cfsavecontent>
			<cfset results = results & message>
			<cfset alertList = listAppend(AlertList,i)>
		</cfif>
	</cfif>
</cfloop>