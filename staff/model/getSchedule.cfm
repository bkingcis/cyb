<cfquery name="caller.GetSchedule" datasource="#request.dsn#">
		select g.g_id,g.r_id,g.g_lname,g.g_fname,gv.g_checkedin,<!--- v.g_checkedin, --->
		gv.v_id,gv.dashpass,gv.g_permanent,s.g_singleentry,s.visit_date as schedule_date,
		gv.g_cancelled,gv.g_initialvisit,r.r_id,r.h_id,h.c_id,
		r.r_fname,r.r_lname,h.h_id,h.h_address,h.h_phone 
		from guests g 
		join guestvisits gv on gv.g_id = g.g_id
		join residents r on g.r_id = r.r_id
		join homesite h on r.h_id = h.h_id
		join barcodes on gv.g_barcode = barcodes.barcode
		join schedule s on gv.v_id = s.v_id 
		<!--- LEFT JOIN visits v on v.v_id = gv.v_id	
		  (bill king - I decided to move this logic into the display area because of the conflict between 24/7 and single entry types)	 --->
		WHERE h.c_id = #session.user_community#
		AND  barcodes.DATE_CANCELLED is null
		AND gv.G_CANCELLED is null
		
		<!--- <cfif isDefined('url.viewhour')> --->
		AND (gv.g_initialvisit BETWEEN '#dateFormat(attributes.begintime)# #timeFormat(attributes.begintime,'hh:mm tt')#' AND '#dateFormat(attributes.endtime)# #timeFormat(attributes.endtime,'hh:mm tt')#')		 
		<!--- <cfelse> 
		AND (s.visit_date BETWEEN '#dateFormat(begintime)# #timeFormat(begintime,'hh:mm tt')#' AND '#dateFormat(endtime)# #timeFormat(endtime,'hh:mm tt')#')
		</cfif>	--->
			<!--- AND gv.g_checkedin IS NULL Taken out to move to larger scrolling results. --->	
		ORDER BY g_lname, g_fname
</cfquery>