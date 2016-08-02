<cfif not val(visitid)>
	Visit ID not valid.
	<cfabort>
</cfif>

<cfquery datasource="#datasource#" name="qGuestVisit">
	select * from guestvisits gv left join schedule s on gv.v_id = s.v_id
    WHERE gv.v_id = <cfqueryparam value="#val(visitid)#" cfsqltype="CF_SQL_INTEGER" />
</cfquery>

<cfquery datasource="#datasource#" name="qGuest">
	select * from guests
    WHERE g_id = <cfqueryparam value="#val(qGuestVisit.g_id)#" cfsqltype="CF_SQL_INTEGER" />
</cfquery>

<cfquery name="qDashPassLeft" datasource="#datasource#">
    SELECT * from communitymessages
    WHERE fieldname = 'DashPassMessage'
    AND c_id =  <cfqueryparam value="#val(session.user_community)#" cfsqltype="CF_SQL_INTEGER" />
    ORDER by messagedate desc
    LIMIT 1
</cfquery>

<cfquery name="qDashPassRight" datasource="#datasource#">
    SELECT * from communitymessages
    WHERE fieldname = 'DashPassMessage2'
    AND c_id = <cfqueryparam value="#val(session.user_community)#" cfsqltype="CF_SQL_INTEGER" />
    ORDER by messagedate desc
    LIMIT 1
</cfquery>

<cfparam name="form.entrytype" default="FullDay">

<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>Cybatrol DashPass</title>
	<style>
		.maintable {border-top:thin solid ##336699;border-bottom:thin solid ##336699;border-left:thin solid ##336699;border-right:thin solid ##336699;}
		.boldunderline {font-family:Verdana,Arial;font-size:18px;font-weight:bold;}
		.bigbold {font-family:Verdana,Arial;font-size:18px;font-weight:bold;}
		.calDayBox {
			background-color: ##efefef; color: black;
		}
		.calEventBox {
			background-color: ##ee7; color: black;border:1px solid ##666;
		}
		.calGuestBox {
			background-color: ##74dd82; color: black;border:1px solid ##666;
		}
		.calBothBox {
			background-image:url('/images/cal-background.gif'); color: black; border:1px solid ##666;
		}				
		.calEventBoxHover {background-color: ##ffc; color: black;border:1px solid ##666;cursor:hand;}
		.calGuestBoxHover {background-color: ##c3d9ff; color: black;border:1px solid ##666;cursor:hand;}
	</style>
</head>

<body>
<table class="maintable" cellpadding="5" cellspacing="5" width="800" align="center">
<tr>
<td align="center" width="33%" valign="top">
<div class="boldunderline"><strong><u>Visitor:</u></strong>
	<br style="padding-top:18px;" />#ucase(qGuest.g_fname)# #ucase(qGuest.g_lname)#</div>
	<br />
	<br />
	<cftry>
	<!--- getRandString method is at the bottom of this file --->
	<cfset imageName = getRandString(15) & '.jpg'>
	<cfhttp url="http://chart.apis.google.com/chart?chs=120x120&cht=qr&chl=#qGuestVisit.g_barcode#&chld=H|0" result="qrcode" getasbinary="yes">
	<cfimage action="write" destination="#expandPath('/bc/'&imageName)#" source="#qrcode.filecontent#">
	<img src="#BaseUrl#/bc/#imageName#">					
	<cfcatch type="any">
			#qGuestVisit.g_barcode#
	</cfcatch>
	</cftry>
</td>
<td align="center" width="33%">
    <!--- <cfif NOT LEN(GetCommunity.c_crest)> --->
        <span style="font-size:24px;font-family:Georgia, 'Times New Roman', Times, serif;font-weight: bold;color: ##666">#GetCommunity.c_name#</span>
    <!--- <cfelse>
        <img src="#BaseUrl#/uploadimages/#GetCommunity.c_crest#" width="250">
    </cfif> --->
	<br /><a href="#BaseUrl#/pass.cfm?vid=#visitid#">Mobile Pass</a>
</td>
<td align="center" width="33%" valign="top">
<div class="boldunderline"><strong><u>RESIDENT:</u></strong><br style="padding-top:18px;" />
#ucase(GetResident.r_fname)# #ucase(GetResident.r_lname)#<br /><br />
<span style="font-size:15px;">#GetResident.h_address#<br />#GetResident.h_city#,#GetResident.h_state#&nbsp;#GetResident.h_zipcode#<br /><a href="#BaseUrl#/maps/resmap.cfm?res=#GetResident.h_id#">Click For Map</a></span></div></td>
</tr>
<cfif qGuestVisit.g_permanent eq 1>
<tr>
	<td colspan="3" align="center"><strong style="color:red;font-size 22px;">24 / 7 Authorized Guest</strong></td>
</tr>
<cfelse>
	 <cfif form.entrytype IS "SingleEntry">
    <tr>
        <td colspan="3" align="center"><strong style="color:red;font-size 16px;">Single Entry Pass</strong></td>
    </tr>
    </cfif>
    <tr>
       <td align="center" colspan="3">
        <table align="center"> <!--- <strong>VID:  #qGuestVisit.v_id#</strong> --->
    <cfset dateList = "">
    <cfloop query="qGuestVisit">
        <cfset dateList = listAppend(dateList,dateFormat(qGuestVisit.visit_date,"m/d/yyyy"))>
    </cfloop>
        <cfset request.dsn = datasource>
            <tr>
                <td valign="top"><cfmodule template="../emailcal.cfm" month="#month(request.timezoneadjustednow)#" hide="events" v_id="#qGuestVisit.v_id#"></td>
                <td valign="top"><cfmodule template="../emailcal.cfm" month="#month(request.timezoneadjustednow)+1#" hide="events" v_id="#qGuestVisit.v_id#"></td>	
                <td valign="top"><cfmodule template="../emailcal.cfm" month="#month(request.timezoneadjustednow)+2#" hide="events" v_id="#qGuestVisit.v_id#"></td>	
                <td valign="top"><cfmodule template="../emailcal.cfm" month="#month(request.timezoneadjustednow)+3#" hide="events" v_id="#qGuestVisit.v_id#"></td>	
            </tr>
        </table>
        	<center><strong style="color:##666;font-size 14px;">* Authorized dates are subject to change.</strong></center><br />
       </td>
    </tr>
</cfif>
<tr>
<td align="center" class="bottomleft">#qDashPassLeft.messageText#</td>
<td align="center" class="bottomcenter"><img src="#BaseUrl#/images/cybadash.png" width="185"></td>
<td align="center" class="bottomleft">#qDashPassRight.messageText#</td>
</tr>

</table>
</body>
</html></cfoutput>

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
