<cfset timezoneadj = session.timezoneadj>
<cfset request.dsn = datasource>
<cfparam name="attributes.v_id" default="0">
<cfparam name="url.r_id" default="0">
<cfset attributes.r_id = url.r_id>
<cfquery datasource="#datasource#" name="GetGV">
	select * from guestvisits where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.v_id#" />
</cfquery>
<!--- <cfdump var="#GetGV#"> --->
<cfset attributes.g_id = val(getGV.g_id)>
<cfquery datasource="#datasource#" name="qStaff">
	select staff_fname,staff_lname from staff 
	where staff_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.staff_id#" />
</cfquery>
<cfquery datasource="#datasource#" name="GetSchedule">
	select * from schedule where v_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#attributes.v_id#" />
</cfquery>
<cfquery datasource="#datasource#" name="GetGuest">
	select * from guests 
	where g_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(GetGV.g_id)#" />
</cfquery>
<cfquery datasource="#datasource#" name="GetResident">
	select residents.r_id, residents.h_id, residents.c_id, residents.r_fname, 
	residents.r_lname, residents.r_altphone, residents.r_email, homesite.h_id, 
	homesite.h_lname, homesite.h_address, homesite.h_UNITNUMBER, homesite.h_city, 
	homesite.h_state, homesite.h_zipcode, homesite.h_phone
		from residents, homesite
		where residents.h_id = homesite.h_id 
		AND <cfif val(GetGuest.r_id)>residents.r_id  = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(GetGuest.r_id)#" />
		<cfelseif val(attributes.r_id)>residents.r_id  = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#val(attributes.r_id)#" />
		<cfelse>
		residents.r_id  = 0
		</cfif>
</cfquery>
<cfquery datasource="#datasource#" name="GetCommunity">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfquery datasource="#datasource#" name="qDashPassMessage">
		select 	*
		from	communitymessages
		where 	fieldname = 'DashPassMessage'
		and 	c_id = #session.user_community#
		order by messageDate desc,message_id desc
		limit 1
</cfquery>
<cfquery datasource="#datasource#" name="qDashPassMessage2">
		select 	*
		from	communitymessages
		where 	fieldname = 'DashPassMessage2'
		and 	c_id = #session.user_community#
		order by messageDate desc,message_id desc
		limit 1
	</cfquery>
<cfoutput>
<style>			
td {font-family: Arial, sans serif;}
.maintable {border-top:3px solid ##333;border-bottom:3px solid ##333;border-left:3px solid ##333;border-right:3px solid ##333;}
.boldunderline {font-family:Verdana,Arial;font-size:18px;font-weight:bold;}
.bigbold {font-family:Verdana,Arial;font-size:18px;font-weight:bold;}
.bottomleft {font-family:Verdana,Arial;border-top:4px solid ##336699;border-bottom:4px solid ##336699;border-left:4px solid ##336699;border-right:4px solid ##336699;font-size:16px;font-weight:bold;}
.bottomcenter {font-family:Verdana,Arial;border-top:1px solid ##336699;border-bottom:1px solid ##336699;border-left:1px solid ##336699;border-right:1px solid ##336699;font-size:18px;font-weight:bold;}
</style>

<table class="maintable" cellpadding="5" cellspacing="5" width="800" align="center">
	<tr>
		<td colspan="3" style="text-align:center;"><strong style="font-size: 1.8em">#UCASE(GetCommunity.c_name)#</strong></td>
	</tr>
	<tr>
		<td align="center" width="33%" <cfif val(attributes.v_id)>valign="top"</cfif>><br />
			<cfif val(attributes.v_id)>
				<strong><u>VISITOR:</u></strong><br />
				<strong style="font-size: 1.8em">#ucase(GetGuest.g_fname)# #ucase(GetGuest.g_lname)#</strong><br /><br />
			<cfelse>
				<span style="font-weight:600;font-size: 1.4em;font-family:Tahoma">QuickPass</span> <br />
				<strong style="color:red;font-family:Tahoma">Single Entry<br />No Return Access</strong>
			</cfif>
		</td>
		<td align="center" width="34%">
			<cfif val(attributes.v_id) and isNumeric(GetGV.g_barcode)>
				<cfset imageName = getRandString(15) & '.jpg'>
				<cfhttp url="http://chart.apis.google.com/chart?chs=120x120&cht=qr&chl=#getGV.g_barcode#&chld=H|0" result="qrcode" getasbinary="yes">
				<cfimage action="write" destination="#expandPath('/bc/'&imageName)#" source="#qrcode.filecontent#">
				<img src="#BaseUrl#/bc/#imageName#">	<div style="margin-top:0px;padding-top: -25px;font-size:0.85em;">#GetGV.g_barcode#</div>
			</cfif>	
		</td>
		<td align="center" width="33%" <cfif val(attributes.v_id)>valign="top"</cfif>><br />
			<cfif val(attributes.v_id)>
				<strong><u>RESIDENT:</u></strong><br />
				<strong style="font-size: 1.8em">#ucase(GetResident.r_fname)# #ucase(GetResident.r_lname)#</strong>
				<!--- <a href="http://maps.cybatrol.com/maps/resmap.cfm?res=#GetResident.h_id#">Click For Map</a> --->
			<cfelse>
				<span style="font-weight:600;font-size: 1.4em;">QuickPass</span> <br />
				<h1 style="color:red;">Single Entry</h1>
			</cfif>					
		</td>
	</tr>
	<!--- <!--- <cfif NOT val(attributes.v_id)>
	<tr>
		<td colspan="3" align="center"><strong style="font-size:1.3em;font-family:Tahoma">Issued By: #qstaff.staff_lname#, #qstaff.staff_fname#</strong></td>
	</tr>
	</cfif> ---> --->
	<tr>
		<td align="center" colspan="3">
			<strong style="font-size: 1.4em">#GetResident.h_address# 
			<cfif len(GetResident.h_unitnumber)><br />unit: #GetResident.h_unitnumber#</cfif><br /> 
			#GetResident.h_city#,#GetResident.h_state#&nbsp;#GetResident.h_zipcode#
			</strong>
		</td>
	</tr>
	<cfif getschedule.g_singleentry eq 1>
	<tr>
		<td align="center" colspan="3" style="color:black;font-family:arial;font-size:14px;font-weight:600;">
			<h1 style="color: red">SINGLE ENTRY ACCESS</h1>
			<h2 style="color: red">VALID:  #ucase(dateFormat(request.timezoneadjustednow,"full"))#</h2>
		</td>
	</tr>
	<cfelseif GetGV.g_permanent eq 1>
	<tr>
		<td align="center" colspan="3"><br><br>
			<h1 style="color: green;font-size: 2.5em">#label.permanent_visitor# Authorized #label.Visitor#</h1>
			<span>ISSUED:  #ucase(dateFormat(getGV.G_INITIALVISIT,"full"))#</span>
		</td>
	</tr>
	<cfelseif GetSchedule.recordcount eq 1><!--- single day pass --->
	<tr>
		<td align="center" colspan="3"><br><br>
			<h1 style="color: green">FULL DAY ACCESS</h1>
			<h2 style="color: red">VALID:  #ucase(dateFormat(request.timezoneadjustednow,"full"))#</h2>
		</td>
	</tr>
	<cfelse>
	<tr>
		<td align="center" colspan="3">
			<table border="1" bordercolor="##000000">
              	<tr>
                   	<td valign="top"><cf_emailcal month="#month(request.timezoneadjustednow)#" g_id="#attributes.g_id#" v_id="#url.v_id#" hide="events"></td>	
		            <td valign="top"><cf_emailcal month="#month(dateAdd("m",1,request.timezoneadjustednow))#" g_id="#attributes.g_id#" v_id="#attributes.v_id#"></td>	
		            <td valign="top"><cf_emailcal month="#month(dateAdd("m",2,request.timezoneadjustednow))#" g_id="#attributes.g_id#" v_id="#attributes.v_id#"></td>	
		            <td valign="top"><cf_emailcal month="#month(dateAdd("m",3,request.timezoneadjustednow))#" g_id="#attributes.g_id#" v_id="#attributes.v_id#"></td>	
                </tr>
            </table>
		</td>
	</tr>
	</cfif> 
	<tr>
		<td style="font-family:Arial;" align="center">#qDashPassMessage.messageText#</td>
		<td align="center"><img src="http://secure.cybatrol.com/images/cybadash.png" width="100" style="margin:4px;"><br />
		</td>
		<td style="font-family:Arial;" align="center">#qDashPassMessage2.messageText#</td>
	</tr>
</table>
</cfoutput>
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
</cfscript>
