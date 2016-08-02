<cfimport prefix="security" taglib="../../admin/security">
<security:community>

<cfif isDefined('form.uplFile')>
	<cffile action="UPLOAD" filefield="uplFile" destination="#expandPath('/uploadimages/gallery')#" nameconflict="MAKEUNIQUE"><!--- accept="text/csv, application-xls" --->
	<cfset galleryObj.create(session.user_community,form.caption,cffile.serverfile)>
	<strong  style="font: 10pt Arial bold">File Uploaded Successfully.</strong>
</cfif>
<cfif isDefined('url.deleteitem')>
	<cfset galleryObj.delete(url.deleteitem)>
	<strong  style="font: 10pt Arial bold">File Removed.</strong>
</cfif>


<cflocation url="../index.cfm##tabs-5" addtoken="no">