<cfquery name="qoverlap" datasource="#datasource#">
	SELECT s1.v_id as lv_id,s1.g_id, s2.v_id as rv_id 
	FROM schedule s1  JOIN schedule s2 on s1.g_id = s2.g_id
		and s1.visit_date = s2.visit_date
		
	WHERE s1.r_id = #session.user_id#
	AND s1.v_id <> s2.v_id
	AND s1.g_singleentry <> 'true'
	AND s1.visit_date > '#dateformat(dateadd('d',-1,now()))#'
	
	order by s1.visit_date
</cfquery>