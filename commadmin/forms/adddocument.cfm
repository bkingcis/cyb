<cfimport prefix="security" taglib="../../admin/security">
<security:community>
<h3><a href="##">Document Upload</a></h3>
<form action="processor/download.cfm" method="post" 
	enctype="multipart/form-data" name="hsForm" id="hsForm">
	Enter a File name or Label:<br />
	<input type="text" name="label"><br /><br />
	Select a Document to upload:<br />
	<input type="file" name="uplFile"> (.doc, .xls or .pdf only)	<br /><br />
	<input type="submit" style="color:green" value="Load File">
</form>