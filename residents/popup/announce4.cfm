<cfset timezoneadj = session.timezoneadj>
<cfparam name="number_of_guests" default="3">
<!--- clean up dates --->
<cfif left(form.allSelected,1) is ","><cfset form.allSelected = mid(form.allSelected,2,len(form.allSelected)-1)></cfif>

<cfinclude template="header.cfm">
<cftry>
<cfsavecontent variable="bodycontent">

<cfif ListLen(form.allSelected) IS 1 AND NOT isDefined('form.entrytype')>
		<p class="lead">Please verify the following:</p>
		<form name="passinspect" action="/residents/popup/announce4.cfm" method="post">
		<ul class="list-group">
			<li class="list-group-item"><input type="radio" name="entrytype" value="SingleEntry">&nbsp;<strong>SINGLE ENTRY</strong> (<cfoutput>#labels.visitor#</cfoutput> allowed ONLY one entry)</li>
			<li class="list-group-item"><input type="radio" name="entrytype" value="FullDay" checked>&nbsp;<strong>FULL DAY</strong> (<cfoutput>#labels.visitor#</cfoutput> allow unlimited access on selected date)</li>
		</ul>
		<input type="hidden" name="passed_inspection" value="YES">
		
			<cfoutput>
			<cfloop collection="#form#" item="i">
				<input type="hidden" name="#i#" value="#Evaluate('form.' & i)#">
			</cfloop>
			</cfoutput>
			<!--- <cfoutput><input type="hidden" name="allSelected" value="#form.allSelected#"></cfoutput>
			<br><input type="submit" value=" schedule guest " style="color:Green;"> --->
		</form>
<cfelse>
	<cfif listLen(form.allSelected)> 
		<CFSET DatesListed = QueryNew("DATELIST")>
		<cfloop list="#allSelected#" index="i">
				<cfset thisdate = i>			    
			    <cfset temp = QueryAddRow(DatesListed, 1)>			    
			    <cfset temp = QuerySetCell(DatesListed, "DATELIST", thisdate)>
		</cfloop>
		<cfquery name="OrderDates" DBTYPE="query">
			SELECT * from DatesListed
				ORDER BY DATELIST
		</cfquery>
	
		<!--- Create ODBC Ready Date and Time for Initial Visit--->			
		<cfset InitialVisit = CreateDateTime(DateFormat(OrderDates.DATELIST,"YYYY"),  DateFormat(OrderDates.DATELIST,"MM"),  DateFormat(OrderDates.DATELIST,"DD"),Listfirst(form.hour,":"), ListLast(form.hour,":"), 00)>
		
		<cfif NOT isDefined("g_id")>
		<!--- End of ODBC Create DATE Time Preperation--->		
		<cfloop from="1" to="#number_of_guests#" index="i">
			<cfset FIRSTNAME = UCase(Evaluate('DE(form.FNAME#i#)'))>
			<cfset FIRSTNAME = Replace(FIRSTNAME,chr(34),"","ALL")>
			<cfset LASTNAME = UCase(Evaluate('DE(form.LNAME#i#)'))>
			<cfset LASTNAME = Replace(LASTNAME,chr(34),"","ALL")>
			<cfset EMAILADDRESS = Evaluate('DE(form.EMAIL#i#)')>
			<cfset EMAILADDRESS = Replace(EMAILADDRESS,chr(34),"","ALL")>			
			<cfif isDefined("form.punchpassNumber#i#")>
				<cfset MOBILENUMBER = Evaluate('DE(form.punchpassNumber#i#)')>
				<cfset MOBILENUMBER = ReReplace(MOBILENUMBER,'^[0-9]',"","ALL")>
			<cfelse>
				<cfset MOBILENUMBER = ''>
			</cfif>
			<cfset g_id = createObject('component','guests').create(lastname,firstname,emailaddress,mobilenumber,session.user_id)>
			
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
			<cfset barcode = createObject('component','/residents/barcode').create(g_id)>
			
			<!--- check guest or enter new guest --->
			<cfquery name="insertGuestVisit" datasource="#datasource#">
				INSERT INTO	guestvisits
				(g_initialvisit,dashpass,map_email,g_id,entry_notification,g_barcode,insertedby_staff_id,guestcompanioncount)
				VALUES
				(#CreateODBCDateTime(InitialVisit)#,'#DASHPASS#','',#g_id#,'','#barcode#',
				<cfif isDefined('session.impersonatedby')>#session.impersonatedby#<cfelse>0</cfif>,
				#guestcompanioncount#				
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
			<cfset visitid = getVID.v_id>
			<cfloop query="OrderDates">
				<cfquery name="insertSchedule" datasource="#datasource#">
					insert into schedule
					(c_id,h_id,r_id,g_id,
						g_barcode,visit_date<cfif ListLen(form.allSelected) IS 1>,g_singleentry</cfif>,
						v_id)				
					values(#session.user_community#,#session.h_id#,
						#session.user_id#, #val(g_id)#,'#barcode#', 
						#CreateODBCDate(DATELIST)#<cfif ListLen(form.allSelected) IS 1><cfif form.entrytype IS "SingleEntry">,TRUE<cfelse>,FALSE</cfif></cfif>,#val(visitid)#)
				</cfquery>
			</cfloop>
			<cfif DASHPASS IS "email">
			<!--- <cfquery name="getVID" datasource="#datasource#">
					select v_id,g_barcode,g_id from guestvisits
					Where g_id = #GetNewGuest.g_id#
					ORDER BY v_id DESC
				</cfquery> --->
				<cfset gid = barcode>
				<cfif isDefined("form.dashpass1")>
				<cfinclude template="../emailpass.cfm">
				</cfif>					
			</cfif>
		</cfloop>
		<cfelse><!--- g_id isDefined --->
			<cfif isDefined("form.punchpassNumber1")>
				<cfset MOBILENUMBER = Evaluate('DE(form.punchpassNumber1)')>
				<cfset MOBILENUMBER = ReReplace(MOBILENUMBER,'^[0-9]',"","ALL")>
			<cfelse>
				<cfset MOBILENUMBER = ''>
			</cfif>
			<cfif isDefined("form.dashpass1")>
				<cfset DASHPASS = Evaluate('DE(form.dashpass1)')>
				<cfset DASHPASS = Replace(DASHPASS,chr(34),"","ALL")>
			<cfelse>
				<cfset DASHPASS = ''>
			</cfif>
			<cfif isDefined('form.guestcompanioncount1')>
				<cfset guestcompanioncount = evaluate('form.guestcompanioncount1')>
			<cfelse>
				<cfset guestcompanioncount = 0>
			</cfif>
			
			<cfset barcode = createObject('component','/residents/barcode').create(g_id)>
			
			<!--- check guest or enter new guest --->
			<cfquery name="insertGuestVisit" datasource="#datasource#">
				INSERT INTO	guestvisits
				(g_initialvisit,dashpass,map_email,g_id,entry_notification,g_barcode,insertedby_staff_id,guestcompanioncount)
				VALUES
				(#CreateODBCDateTime(InitialVisit)#,'#DASHPASS#','',#g_id#,'','#barcode#',
				<cfif isDefined('session.impersonatedby')>#session.impersonatedby#<cfelse>0</cfif>,
				#guestcompanioncount#				
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
			<cfset visitid = getVID.v_id>
			<cfloop query="OrderDates">
				<cfquery name="insertSchedule" datasource="#datasource#">
					insert into schedule
					(c_id,h_id,r_id,g_id,
						g_barcode,visit_date<cfif ListLen(form.allSelected) IS 1>,g_singleentry</cfif>,
						v_id)				
					values(#session.user_community#,#GetResident.h_id#,
						#session.user_id#, #val(g_id)#,'#barcode#', 
						#CreateODBCDate(DATELIST)#<cfif ListLen(form.allSelected) IS 1><cfif form.entrytype IS "SingleEntry">,TRUE<cfelse>,FALSE</cfif></cfif>,#val(visitid)#)
				</cfquery>
			</cfloop>
			<cfif DASHPASS IS "email">
			<!--- <cfquery name="getVID" datasource="#datasource#">
					select v_id,g_barcode,g_id from guestvisits
					Where g_id = #GetNewGuest.g_id#
					ORDER BY v_id DESC
				</cfquery> --->
				<cfset gid = barcode>
				<cfif isDefined("form.dashpass1")>
				<cfinclude template="../emailpass.cfm">
				</cfif>					
			</cfif>
		</cfif>	
		<script>
			$('#btnContinue').hide();//.text('Add another'); 
	  	$('#btnBack').hide();
	  	$('#btnClose').hide();
		</script>
		<div class="alert alert-success">Successfully Added <cfoutput>#labels.visitor#</cfoutput>.</div>
		<form action="/residents/popup/announce2.cfm" method="post">
		</form>
	<cfelse>
		<div class="alert alert-warning"><p>You MUST select, at least, one date to continue.</p></div>
		<script>
			$('#btnContinue').hide();
	  		$('#btnClose').hide();
		</script>
	</cfif>
</cfif>	
</cfsavecontent><cfcatch><cfdump var="#cfcatch#"><cfabort></cfcatch></cftry>
	<!-- <h1>Announce Guests</h1> -->
	<cfoutput>#bodycontent#</cfoutput></div>
<!--- 	<div class="modal-footer">
		<button class="btn btn-primary" data-dismiss="modal" aria-hidden="true">Close</button>
	</div>


<cfscript>
/**
* Returns a random alphanumeric string of a user-specified length.
* 
* @param stringLenth      Length of random string to generate. (Required)
* @return Returns a string. 
* @author Kenneth Rainey (kip.rainey@incapital.com) 
* @version 1, February 3, 2004 
*/
function getRandString(stringLength) {
    var tempAlphaList = "a|b|c|d|e|g|h|i|k|L|m|n|o|p|q|r|s|t|u|v|w|x|y|z";
    var tempNumList = "1|2|3|4|5|6|7|8|9|0";
    var tempCompositeList = tempAlphaList&"|"&tempNumList;
    var tempCharsInList = listLen(tempCompositeList,"|");
    var tempCounter = 1;
    var tempWorkingString = "";
    
    //loop from 1 to stringLength to generate string
    while (tempCounter LTE stringLength) {
        tempWorkingString = tempWorkingString&listGetAt(tempCompositeList,randRange(1,tempCharsInList),"|");
        tempCounter = tempCounter + 1;
    }
    
    return tempWorkingString;
}
</cfscript> --->