<!---

/**********************************************************
intelliEdit 
Version:				4.0
Build:					4.0.3/July 15, 2003

Author:					Andrei Oprea
Web:					http://www.oprea.org
Support:				http://forums.oprea.org

Copyright � 2001-2003, Andrei Oprea. All rights reserved.
***********************************************************/
--->

<style>
	select{height: 22px; top:2;	font:8pt verdana,arial,sans-serif}	
	body {border:lightgrey 0px solid;background: #ece9d8;filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=white, endColorstr=#e3e3e3);}
	.bar{padding-left: 5px;border-top: #99ccff 1px solid; background: #004684;filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#004684, endColorstr=#7189b7); WIDTH: 100%; border-bottom: #004684 1px solid;height: 20px}
	.bar2{border-top: #99ccff 1px solid; background: #004684;filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#004684, endColorstr=#7189b7); WIDTH: 100%; border-bottom: #004684 1px solid;height: 20px}
	td {	font:8pt verdana,arial,sans-serif}
	div	{	"font:10pt" tahoma,arial,sans-serif}
</style>
<style>
.cellSymbol
	{
	border:#f0f4fb 1 solid;
  	padding:0 2pt 0 2pt
	font-size:10pt;
	font-family:"Tahoma";  	
	}
</style>
<script>
function writeSymbol()
	{
	var s1 = new Array("&quot; ", "&amp; ", "&lt; ", "&gt; ", "&euro; ", "&iexcl; ", "&cent; ", "&pound; ", "&curren; ", "&yen; ")
	var s2 = new Array("&brvbar; ", "&sect; ", "&uml; ", "&copy; ", "&ordf; ", "&laquo; ", "&not; ", "&shy; ", "&reg; ", "&macr; ")
	var s3 = new Array("&deg; ", "&plusmn; ", "&sup2; ", "&sup3; ", "&acute; ", "&micro; ", "&para; ", "&middot; ", "&cedil; ", "&sup1; ")
	var s4 = new Array("&ordm; ", "&raquo; ", "&frac14; ", "&frac12; ", "&frac34; ", "&iquest; ", "&Agrave; ", "&Aacute; ", "&Acirc; ", "&Atilde; ")
	var s5 = new Array("&Auml; ", "&Aring; ", "&AElig; ", "&Ccedil; ", "&Egrave; ", "&Eacute; ", "&Ecirc; ", "&Euml; ", "&Igrave; ", "&Iacute; ")
	var s6 = new Array("&Icirc; ", "&Iuml; ", "&ETH; ", "&Ntilde; ", "&Ograve; ", "&Oacute; ", "&Ocirc; ", "&Otilde; ", "&Ouml; ", "&times; ")
	var s7 = new Array("&Oslash; ", "&Ugrave; ", "&Uacute; ", "&Ucirc; ", "&Uuml; ", "&Yacute; ", "&THORN; ", "&szlig; ", "&agrave; ", "&aacute; ")
	var s8 = new Array("&acirc; ", "&atilde; ", "&auml; ", "&aring; ", "&aelig; ", "&ccedil; ", "&egrave; ", "&eacute; ", "&ecirc; ", "&euml; ")
	var s9 = new Array("&igrave; ", "&iacute; ", "&icirc; ", "&iuml; ", "&eth; ", "&ntilde; ", "&ograve; ", "&oacute; ", "&ocirc; ", "&otilde; ")
	var s10 = new Array("&ouml; ", "&divide; ", "&oslash; ", "&ugrave; ", "&uacute; ", "&ucirc; ", "&uuml; ", "&yacute; ", "&thorn; ", "&yuml; ")

	var sHTML="";
	sHTML += "<table border=0 bgcolor=white cellspacing=0 cellpadding=0 style=\"border:#a9a9a9 1 solid;\">"
	for(var i=1;i<=10;i++)
		{
		sHTML += "<tr>"
		for(var j=0;j<9;j++)
			{
			sHTML += "<td class=cellSymbol align=center onclick=\"Format(this.innerText);\" onmouseover=\"this.style.border='#a9a9a9 1 solid';this.style.background='gainsboro'\" onmouseout=\"this.style.border='#f0f4fb 1 solid';this.style.background=''\" style=\"cursor:hand\">" + eval("s"+i)[j] + "</td>"
			}
		sHTML += "</tr>"
		}
	sHTML += "</table>"
	document.write(sHTML)
	//divPopupContent.innerHTML=sHTML;
	}
function Format(Symbol)
	{
	eval("parent.idContent"+inpActiveEditor.value).focus();

	var oSel	= eval("parent."+inpActiveEditor.value).Sel;
	oSel = parent.fixSel(inpActiveEditor.value,oSel)//a must

	oSel.select()//tambahan
	if(oSel.parentElement) oSel.pasteHTML(Symbol)			
	}
</script>

<body topmargin=0 leftmargin=0 rightmargin=0 bottommargin=0 onselectstart="return event.srcElement.tagName=='INPUT'" oncontextmenu="return false">
<table border="0" cellpadding="0" cellspacing="0" style="table-layout: fixed" ID="tblPopup">
<col width=220><col width=13>
<tr>
<td>
	<!-- popup_BarArea -->
	<div id="popup_BarArea" class="bar">
	<font size=2 face=tahoma color=white><b>Symbol</b></font>
	</div>
</td>
<td style="cursor:hand" onclick="eval('parent.'+inpActiveEditor.value).boxHide()">
	<div id="popup_BarArea_close" class="bar2">
	<font size=2 face=tahoma color=white><b>X</b></font>
	</div>
</td>
</tr>
<tr>
<!-- popup_ContentBorder -->
<td id="popup_ContentBorder" colspan=2 style="border-left: #336699 1px solid;border-right: #336699 1px solid;border-bottom: #336699 1px solid;" valign=top>
	<br>
	<div id="divPopup" align=center>
	<div id="divPopupContent"></div>
	<script>writeSymbol()</script>
	</div>
	<br>
</td>
</tr>
</table>
<input type=text style="display:none;" id="inpActiveEditor" name="inpActiveEditor" contentEditable=true>
</body>