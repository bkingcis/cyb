<cfparam name="attributes.showonly" default="announce,address,schedule,home,logout">
<cfif isdefined("caller.datasource")>
	<cfset datasource = caller.datasource>
</cfif>
<cfquery datasource="#datasource#" name="qEventTypes">
	Select * from CommunityeventTypes
	where c_id = #session.user_community#
	order by label
</cfquery>
<cfquery datasource="#datasource#" name="qCommunityOptions">
	Select permanantguests from Communities
	where c_id = #session.user_community#
</cfquery>
<style>
	.nav-pills a {
		 cursor:pointer;margin:5px;
	}
</style>

<div class="row">
   <div class="">
	<ul class="nav nav-pills nav-justified">	
	  <li class="active" role="presentation"><a data-toggle="modal" data-target="#baseModal" data-action="announce2">Add <cfoutput>#labels.Visitor#</cfoutput></a></li>
	  <li class="active" role="presentation"><a data-toggle="modal" data-target="#baseModal" data-action="permguest"><cfoutput>#labels.permanent_visitor#</cfoutput></a></li>
	 <cfif qEventTypes.recordcount><li class="active" role="presentation"><a data-toggle="modal" data-target="#baseModal" data-action="specialevent_announce1"><cfoutput>#labels.special_event#</cfoutput>s</a></li></cfif>		
	  <li class="active" role="presentation"><a data-toggle="modal" data-target="#baseModal" data-action="downloads"><cfoutput>#labels.downloads#</cfoutput></a></li>
<!--- 	  <li class="active" role="presentation"><a data-toggle="modal" data-target="#baseModal" data-action="opinions">Opinions</a></li>
	  <li class="active" role="presentation"><a data-toggle="modal" data-target="#baseModal" data-action="marketplace">MarketPlace</a></li> --->
	</ul>
   </div> 
</div>