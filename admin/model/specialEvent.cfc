<cfcomponent displayname="specialevents">
	<cffunction name="getEventTypes" returntype="query">
		<cfargument name="c_id" required="Yes">		
		<cfquery datasource="#request.dsn#" name="get">
			Select * FROM CommunityeventTypes 
			where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
			order by label
		</cfquery>
		<cfreturn get>
	</cffunction>
	
	<cffunction name="saveEventTypes">		
		<cfargument name="c_id" required="Yes">
		<cfif NOT isDefined("arguments.c_specialevents")>
			<cfquery datasource="#request.dsn#" name="del">
				delete FROM CommunityeventTypes 
				where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
			</cfquery>
		<cfelse>
			<cfif isDefined("arguments.chkeventBox1")>		
				<cfquery datasource="#request.dsn#" name="qOH">
				select * FROM CommunityeventTypes 
				where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
				and abbreviation = 'OH'
				</cfquery>
				<cfif NOT qOH.recordcount>
				<cfquery datasource="#request.dsn#">
					insert into CommunityeventTypes (etid,c_id,abbreviation,label)
					values (nextval('ai_seq'),'#arguments.c_id#','OH','Open House')
				</cfquery>
				</cfif>
			<cfelse>
				<cfquery datasource="#request.dsn#" name="del">
				Delete FROM CommunityeventTypes 
				where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
				and abbreviation = 'OH'
				</cfquery>
			</cfif>
			<cfif isDefined("arguments.chkeventBox2")>
			<cfquery datasource="#request.dsn#" name="qGS">
				select * FROM CommunityeventTypes 
				where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
				and abbreviation = 'GS'
				</cfquery>
				<cfif NOT qGS.recordcount>
					<cfquery datasource="#request.dsn#">
						insert into CommunityeventTypes (etid,c_id,abbreviation,label)
						values (nextval('ai_seq'),'#arguments.c_id#','GS','Garage Sale')
					</cfquery>
				</cfif>
			<cfelse>
				<cfquery datasource="#request.dsn#" name="del">
				Delete FROM CommunityeventTypes 
				where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
				and abbreviation = 'GS'
				</cfquery>
			</cfif>
			<cfif isDefined("arguments.chkeventBox3")>
			<cfquery datasource="#request.dsn#" name="del">
				Delete FROM CommunityeventTypes 
				where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.c_id#" />
				and abbreviation <> 'GS' AND abbreviation <> 'OH'
				</cfquery>
			<cfquery datasource="#request.dsn#">
				insert into CommunityeventTypes (etid,c_id,abbreviation,label)
				values (nextval('ai_seq'),'#arguments.c_id#','#eventOptInitial3#','#eventOptLabel3#')
			</cfquery>
			</cfif>
			<cfif isDefined("arguments.chkeventBox4")>
			<cfquery datasource="#request.dsn#">
				insert into CommunityeventTypes (etid,c_id,abbreviation,label)
				values (nextval('ai_seq'),'#arguments.c_id#','#eventOptInitial4#','#eventOptLabel4#')
			</cfquery>
			</cfif>
			<cfif isDefined("arguments.chkeventBox5")>
			<cfquery datasource="#request.dsn#">
				insert into CommunityeventTypes (etid,c_id,abbreviation,label)
				values (nextval('ai_seq'),'#arguments.c_id#','#eventOptInitial5#','#eventOptLabel5#')
			</cfquery>
			</cfif>
		</cfif>
		<cfreturn true>
	</cffunction>
</cfcomponent>