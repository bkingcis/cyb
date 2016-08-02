<cfimport prefix="security" taglib="../../admin/security">
<security:community>

<cfif isDefined('form.uplFile')>
	<cffile action="UPLOAD" filefield="uplFile" destination="#expandPath('/uploaddocuments')#" nameconflict="MAKEUNIQUE"><!--- accept="text/csv, application-xls" --->
	<cfset downloadObj.create(session.user_community,form.label,cffile.serverfile)>
	<strong  style="font: 10pt Arial bold">File Uploaded Successfully.</strong>
</cfif>
<cfif isDefined('url.deleteitem')>
	<cfset downloadObj.delete(url.deleteitem)>
	<strong  style="font: 10pt Arial bold">File Removed.</strong>
</cfif>


<cflocation url="../index.cfm##tabs-6" addtoken="no">