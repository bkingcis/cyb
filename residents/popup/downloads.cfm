<cfquery name="qDownloads" datasource="#datasource#">
	select * from communitydownload
	where c_id = <cfqueryparam value="#val(session.user_community)#" cfsqltype="CF_SQL_INTEGER" />
</cfquery>
<cfinclude template="header.cfm">	

	<cfif isDefined('qDownloads.recordcount') AND qDownloads.recordcount>
	<div class="row-fluid">
		<ul class="list-group">
		<cfoutput query="qDownloads">
		<li class="list-group-item">
		<a href="/uploaddocuments/#filename#">
		<cfif listLast(filename,'.') is 'pdf'>
		<img src="/images/icons/page_white_acrobat.png" border="0">
		<cfelseif listLast(filename,'.') is 'doc' or  listLast(filename,'.') is 'docx'>
		<img src="/images/icons/page_white_word.png" border="0">
		<cfelseif listLast(filename,'.') is 'xls' or  listLast(filename,'.') is 'xlsx'>
		<img src="/images/icons/page_white_excel.png" border="0">
		<cfelseif listLast(filename,'.') is 'ppt' or  listLast(filename,'.') is 'pptx'>
		<img src="/images/icons/page_white_powerpoint.png" border="0">
		<cfelse>
		<img src="/images/icons/page_white.png" border="0">
		</cfif>
		 #label#</a></li>
		</cfoutput>
		</ul>
	</div>
	<cfelse>
		<div class="well">No documents found.</div>
	</cfif>

