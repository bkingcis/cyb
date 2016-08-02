<cfimport prefix="security" taglib="../../admin/security">
<security:community>

<cfif isDefined('form.uplFile')>
	<cffile action="UPLOAD" filefield="uplFile" 
	destination="#expandPath('/commadmin/temp')#" nameconflict="OVERWRITE" ><!--- accept="text/csv, application-xls" --->
	<strong  style="font: 10pt Arial bold">File Uploaded Successfully.</strong>
	<cfset qData = queryNew('fname,lname,address1,address2,city,state,zip,phone1,phone2,email,unitnumber')>
	<cfset queryAddRow(qData,1)>
		
	<p style="font: 10pt Arial">To complete the import select the field name that most closely matches the column you would like to map your data to:</p>
	<cfset fieldlist = "First Name,Last Name,Mobile Phone,Alternate Phone,Address, Unit/APt Name,Email Address">
	<cfoutput><form action="forms/homesiteBulk.cfm" method="post">
	<table border="1" style="font:9pt Arial;color: ##444; border-collapse:collapse">
		<tr><cfloop from="1" to="#ListLen(qData.columnlist)#" index="i"><td><select style="font: 8pt Arial;" name="Field#i#"><option>Skip</option><cfloop list="#fieldlist#" index="ii"><option>#ii#</option></cfloop></select></td></cfloop></tr>
		<tr><td colspan="#len(qData.columnList)#" style="background-color:##669;color:white;">Your Data Preview:</td></tr>
		<tr>
			<cfloop list="#qData.columnList#" index="columnName"><th>#columnName#</th></cfloop>
		</tr>
		<cfloop query="qData" endrow="4">
		<tr>
			<cfloop list="#qData.columnList#" index="columnName"><td>#Evaluate('qData.'&columnName)#</td></cfloop>
		</tr>
		</cfloop>
	</table>
	<input type="button" value="Save Selections">
	</form>
	</cfoutput>
<cfelse>
<h3><a href="##">Homesite Bulk Upload</a></h3>
<form action="forms/homesiteBulk.cfm" method="post" 
	enctype="multipart/form-data" name="hsForm" id="hsForm">
	Select a File to upload:
	<br>
	<input type="file" name="uplFile"> (.csv or .xls, only)	<br><br>
	<input type="submit" style="color:green" value="Load File">
</form>

<br>
<br>
<p><a href="">Download Template</a></p>
</cfif>