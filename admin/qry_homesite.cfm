<cfquery name="qHomesite" datasource="#request.dsn#">
SELECT h.*,r.r_fname,r.r_middleinitial,r.r_lname,r.r_email,r.r_altphone,r.r_id
FROM	homesite h, residents r
WHERE	 h.h_id = r.h_id
and	h.c_id = #session.user_community#
and     h.h_id = <cfqueryparam value="#url.h_id#" cfsqltype="CF_SQL_INTEGER">
ORDER BY r_id
 LIMIT 1
</cfquery>

		<cfquery datasource="cybatrol" name="qVacancyHistory">
			select hv.vacancydate, h.h_lname
			from homesitevacancy hv join homesite h on h.h_id = hv.previoushomesiteid
			where hv.homesiteid = <cfqueryparam value="#url.h_id#" cfsqltype="CF_SQL_INTEGER">
			ORDER by vacancydate desc
		</cfquery>

<!--- <cfquery name="updateAcct" datasource="#datasource#">
		UPDATE	residents
		SET		c_id = #session.user_community#,
				h_id = #form.h_id#,
				r_fname = '#form.r_fname#',
				r_lname = '#form.r_lname#',
				r_altphone = '#form.r_altphone#',
				r_email = '#form.r_email#',
				r_username = '#form.r_username#',
				r_password = '#form.r_password#'
		WHERE	r_id = #tmpId#
		</cfquery> --->