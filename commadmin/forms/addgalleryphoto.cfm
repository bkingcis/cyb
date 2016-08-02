
<h3><a href="##">Gallery Photo Upload</a></h3>
<form action="processor/galleryphoto.cfm" method="post" 
	enctype="multipart/form-data" name="hsForm" id="hsForm">
	Enter a photo caption:<br />
	<input type="text" name="caption" style="width:240px;"><br /><br />
	Select a Photo File to upload:<br />
	<input type="file" name="uplFile"> (.jpg, .gif or .png only)	<br /><br />
	<input type="submit" style="color:green" value="Load File">
</form>