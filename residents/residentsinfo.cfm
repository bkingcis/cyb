<!--- <cfquery name="test" datasource="cybatrol">
	select * from residents order by r_id desc
	limit 20
</cfquery><cfdump var="#test#"><cfabort> --->

<cfquery name="GetCommunity" datasource="#datasource#">
		select *
		from communities
		WHERE c_id = #session.user_community#
	</cfquery>
	<cfquery name="GetResident" datasource="#datasource#">
		select residents.r_id, residents.h_id, residents.r_fname, residents.r_lname, 
		residents.r_altphone, residents.r_email, homesite.h_id, homesite.h_lname, 
		homesite.h_address,homesite.h_unitnumber, homesite.h_city, homesite.h_state, homesite.h_zipcode, homesite.h_phone
		from residents, homesite
		where residents.h_id = homesite.h_id AND residents.r_id = #session.user_id#
	</cfquery>
	
	<div style="border-bottom: 1px solid #0071BE;">
	<cfoutput><strong>#ucase(GetResident.r_fname)# #ucase(GetResident.r_lname)#</strong> 
	<a href="logout/index.cfm" style="color:red;">logout</a></cfoutput>
	<br /><cfoutput>primary phone: #GetResident.r_altphone#</cfoutput>
	</div>