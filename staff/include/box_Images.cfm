<!---

/**********************************************************
intelliEdit 
Version:				4.0
Build:					4.0.3/July 15, 2003

Author:					Andrei Oprea
Web:					http://www.oprea.org
Support:				http://forums.oprea.org

Copyright © 2001-2003, Andrei Oprea. All rights reserved.
***********************************************************/
--->

<cfif IsDefined("URL.Action") AND URL.Action EQ "del">
	<cfset filepath = "#URL.File#">
	<cfif IsDefined("catid") AND catid NEQ "">
		<cffile file="#Session.LibraryPath#\#catid#\#URL.File#" action="DELETE">
		<cflocation url="box_images.cfm">
		<!--- <cflocation url="IED_UploadImage.cfm?catid=#catid#"> --->
	<cfelse>
		<cffile file="#Session.LibraryPath#\#URL.File#" action="DELETE">
		<cflocation url="box_images.cfm">
		<!--- <cflocation url="IED_UploadImage.cfm"> --->
	</cfif>
</cfif>


<html>
<head>
	<title>Insert/Update Image</title>
	<style>
	BODY
		{
		FONT-FAMILY: Verdana;FONT-SIZE: xx-small;
		}
	TABLE
		{
	    FONT-SIZE: xx-small;
	    FONT-FAMILY: Tahoma
		}
	INPUT
		{
		font:8pt verdana,arial,sans-serif;
		}
	select
		{
		height: 22px; 
		top:2;
		font:8pt verdana,arial,sans-serif
		}	
	.bar 
		{
		BORDER-TOP: #99ccff 1px solid; BACKGROUND: #336699; WIDTH: 100%; BORDER-BOTTOM: #000000 1px solid; HEIGHT: 20px
		}		
	</style>
</head>
<cfset strHTML = "">
<cfif IsDefined("catid") AND catid NEQ "">
	<cfdirectory name="FilesList" action="LIST" directory="#Session.LibraryPath#\#catid#">
<cfelse>
	<cfdirectory name="FilesList" action="LIST" directory="#Session.LibraryPath#\">
</cfif>

<cfset strHTML = "#strHTML#" & "<table border=0 cellpadding=3 cellspacing=0 width=240>">
<cfoutput query="FilesList">
	<cfif FilesList.Type EQ "File">
		<cfset strHTML = strHTML & "<tr bgcolor=Gainsboro>">
		<cfset strHTML = strHTML & "<tr bgcolor=Gainsboro>">
		<cfset strHTML = strHTML & "<td valign=top>" & #FilesList.Name# & "</td>">
		<cfset strHTML = strHTML & "<td valign=top>" & #NumberFormat(FilesList.Size/1000,0)# &+ " kb</td>">
		<cfset strHTML = strHTML & "<td valign=top style=""cursor:hand;"" onclick=""selectImage('" & #Name# & "')""><u><font color=blue>select</font></u></td>">
		<cfset strHTML = strHTML & "<td valign=top style=""cursor:hand;"" onclick=""deleteImage('" & #Name# & "')""><u><font color=blue>del</font></u></td></tr>">
	</cfif>
</cfoutput>	
<cfset strHTML = strHTML & "</table>">

<body onload="checkImage()" link=Blue vlink=MediumSlateBlue alink=MediumSlateBlue leftmargin=5 rightmargin=5 topmargin=5 bottommargin=5 bgcolor=Gainsboro>



	<table border="0" cellpadding="0" cellspacing="0">
	<tr>
	<td valign=top>
		<!-- Content -->

		<table border=0 cellpadding=3 cellspacing=3 align=center>
		<tr>
		<td align=center style="BORDER-TOP: #336699 1px solid;BORDER-LEFT: #336699 1px solid;BORDER-RIGHT: #336699 1px solid;BORDER-BOTTOM: #336699 1px solid;" bgcolor=White>
				<div id="divImg" style="overflow:auto;width:200;height:170"></div>
		</td>  
  		<td valign=top>
				<form method=post action="IED_UploadImage.cfm" id=form2 name=form2>
						<table border=0 height=30 cellpadding=0 cellspacing=0><tr>
						<td><b>Select folder&nbsp;:&nbsp;</b></td>
						<td>
						<select id=catid name=catid onchange="form2.submit()">
							<cfdirectory name="DirectoryList" action="LIST" directory="#Session.LibraryPath#">
							<cfif IsDefined("catid") AND catid NEQ "">
								<option value="#DirectoryList.Name#">Library/<cfoutput>#catid#</cfoutput>
								<cfoutput query="DirectoryList">
								<cfif DirectoryList.Type EQ "Dir" AND DirectoryList.Name NEQ "." AND DirectoryList.Name NEQ ".." AND DirectoryList.Name NEQ "#catid#">
									<option value="#DirectoryList.Name#">Library/#DirectoryList.Name#
								</cfif>
								</cfoutput>
								<option value="">Library/
							<cfelseif Not IsDefined("catid") OR catid EQ "">
								<option value="">Library/
								<cfoutput query="DirectoryList">
								<cfif DirectoryList.Type EQ "Dir" AND DirectoryList.Name NEQ "." AND DirectoryList.Name NEQ "..">
									<option value="#DirectoryList.Name#">Library/#DirectoryList.Name#
								</cfif>
								</cfoutput>
							<cfelse>
								<cfoutput query="DirectoryList">
								<cfif DirectoryList.Type EQ "Dir" AND DirectoryList.Name NEQ "." AND DirectoryList.Name NEQ "..">
									<option value="#DirectoryList.Name#">Library/#DirectoryList.Name#
								</cfif>
								</cfoutput>
								<option value="">Library/
							</cfif>
							
						</select> 
						</td></tr></table>
				</form>
				
				<table border=0 cellpadding=0 cellspacing=0 width=260>
				<tr><td>
				<div class="bar" style="padding-left: 5px;">
				<font size="2" face="tahoma" color="white"><b>File Name</b></font>
				</div>
				</td></tr>
				</table>
				
				<div style="overflow:auto;height:120;width:260;BORDER-LEFT: #316AC5 1px solid;BORDER-RIGHT: LightSteelblue 1px solid;BORDER-BOTTOM: LightSteelblue 1px solid;">
				<cfoutput>#strHTML#</cfoutput>
				</div>

				<table class=tblCoolbar align="center" width="100%">
					<form method="post" action="IED_UploadImage.cfm?action=upload" name="ImageForm" enctype="multipart/form-data">
					<tr>
						<td>
							<input type="File" name="File" size="30">
							<cfif IsDefined("catid") AND catid NEQ "">
								<input type="hidden" name="inpcatid" value="<cfoutput>#catid#</cfoutput>">
							</cfif>
						</td>
					</tr>
					<tr>
						<td>
							<input type="submit" name="Submit" value="Upload">
						</td>
					</tr>
				</form>
				</table>	
				
		</td>						
		</tr>
		<tr>
		<td colspan=2>
				
				<hr>	
				<table border=0 width=100% cellpadding=0 cellspacing=1>
				<tr>
						<td>Image source : </td>
						<td colspan=3>
						<INPUT type="text" id="inpImgURL" name=inpImgURL size=60>
						<!--<font color=red>(you can type your own image path here)</font>-->
						</td>		
				</tr>					
				<tr>
						<td>Alternate text : </td>
						<td colspan=3><INPUT type="text" id="inpImgAlt" name=inpImgAlt size=60></td>		
				</tr>				
				<tr>
						<td>Alignment : </td>
						<td>
						<select ID="inpImgAlign" NAME="inpImgAlign">
								<option value="" selected>&lt;Not Set&gt;</option>
								<option value="absBottom">absBottom</option>
								<option value="absMiddle">absMiddle</option>
								<option value="baseline">baseline</option>
								<option value="bottom">bottom</option>
								<option value="left">left</option>
								<option value="middle">middle</option>
								<option value="right">right</option>
								<option value="textTop">textTop</option>
								<option value="top">top</option>						
						</select>
						</td>
						<td>Image border :</td>
						<td><select id=inpImgBorder name=inpImgBorder>
							<option value=0>0</option>
							<option value=1>1</option>
							<option value=2>2</option>
							<option value=3>3</option>
							<option value=4>4</option>
							<option value=5>5</option>
						</select>
						</td>					
				</tr>
				<tr>
						<td>Width :</td>
						<td><INPUT type="text" ID="inpImgWidth" NAME="inpImgWidth" size=2></td>
						<td>Horizontal Spacing :</td>
						<td><INPUT type="text" ID="inpHSpace" NAME="inpHSpace" size=2></td>
				</tr>				
				<tr>
						<td>Height :</td>
						<td><INPUT type="text" ID="inpImgHeight" NAME="inpImgHeight" size=2></td>
						<td>Vertical Spacing :</td>
						<td><INPUT type="text" ID="inpVSpace" NAME="inpVSpace" size=2></td>
				</tr>
				</table>

		</td>
		</tr>
		<tr>
		<td align=center colspan=2>
				<table cellpadding=0 cellspacing=0 align=center><tr>
				<td><INPUT type="button" value="Cancel" onclick="self.close();" style="height: 22px;font:8pt verdana,arial,sans-serif" ID="Button1" NAME="Button1"></td>
				<td>
				<span id="btnImgInsert">
				<INPUT type="button" value="Insert" onclick="InsertImage();self.close();" style="height: 22px;font:8pt verdana,arial,sans-serif" ID="Button2" NAME="Button2">
				</span>
						
				</td>
				</tr></table>
		</td>
		</tr>
		</table>

		<!-- /Content -->
		<br>
	</td>
	</tr>
	</table>



<script language="JavaScript">
function deleteImage(sURL)
	{
	if (confirm("Delete this document ?") == true) 
		{
		<cfif IsDefined("catid") AND catid NEQ "">
			window.navigate("box_images.cfm?action=del&file="+sURL+"&catid=<cfoutput>#catid#</cfoutput>");
		<cfelse>
			window.navigate("box_images.cfm?action=del&file="+sURL);
		</cfif>
		}
	}
function selectImage(sURL)
	{
	<cfif IsDefined("catid") AND catid NEQ "">
		inpImgURL.value = '<cfoutput>#Session.LibraryURL#/#catid#</cfoutput>/' + sURL;
	<cfelse>
		inpImgURL.value = '<cfoutput>#Session.LibraryURL#</cfoutput>/' + sURL;
	</cfif>
	divImg.style.visibility = "hidden"
	<cfif isDefined("catid") AND catid NEQ "">
		divImg.innerHTML = "<img id='idImg' src='" + sURL + "'>";
	<cfelse>
		divImg.innerHTML = "<img id='idImg' src='" + sURL + "'>";
	</cfif>

	var width = idImg.width
	var height = idImg.height 
	var resizedWidth = 200;
	var resizedHeight = 170;

	var Ratio1 = resizedWidth/resizedHeight;
	var Ratio2 = width/height;

	if(Ratio2 > Ratio1)
		{
		if(width*1>resizedWidth*1)
			idImg.width=resizedWidth;
		else
			idImg.width=width;
		}
	else
		{
		if(height*1>resizedHeight*1)
			idImg.height=resizedHeight;
		else
			idImg.height=height;
		}
	
	divImg.style.visibility = "visible"
	}
	
function checkImage()
	{
	oName=window.opener.oUtil.oName
	obj = eval("window.opener."+oName)
	
	if (obj.imgSrc()!="") selectImage(obj.imgSrc())//preview image
	inpImgURL.value = obj.imgSrc()
	inpImgAlt.value = obj.imgAlt()
	inpImgAlign.value = obj.imgAlign()
	inpImgBorder.value = obj.imgBorder()
	inpImgWidth.value = obj.imgWidth()
	inpImgHeight.value = obj.imgHeight()
	inpHSpace.value = obj.imgHspace()
	inpVSpace.value = obj.imgVspace()

	if (obj.imgSrc()!="") //If image is selected 
		btnImgInsert.style.display="block";
	else
		btnImgInsert.style.display="block";
	}
function UpdateImage()
	{
	oName=window.opener.oUtil.oName
	eval("window.opener."+oName).UpdateImage(inpImgURL.value,inpImgAlt.value,inpImgAlign.value,inpImgBorder.value,inpImgWidth.value,inpImgHeight.value,inpHSpace.value,inpVSpace.value);	
	}
function InsertImage()
	{
	oName=window.opener.oUtil.oName
	eval("window.opener."+oName).InsertImage(inpImgURL.value,inpImgAlt.value,inpImgAlign.value,inpImgBorder.value,inpImgWidth.value,inpImgHeight.value,inpHSpace.value,inpVSpace.value);
	}	
</script>
</body>
</html>