<cflocation url="residentsearch.cfm">

<cfinclude template="../header5.cfm">

<table align="center" style="font-size:11px;background-color:#f5f5f5;border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;border-left:thin solid black;margin-top:25px;padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;" cellpadding="0" cellspacing="3" border="0">
<tr>
<td colspan="4" align="center" style="background-color:White;font-weight:bold;">RESIDENT SEARCH</td>
</tr>
<form action="searchprocess3.cfm" method="POST" name="annouce">
<input type="hidden" name="whichsearch" value="resident">
<tr>
<td align="right" style="padding-right:5px;"><strong>RESIDENT</strong></td>
<td><input type="text" required="YES" size="10" name="r_lname" onclick="return overlib(OLiframeContent('addressbook.cfm', 250, 400, 'if1', 1), WRAP, TEXTPADDING,0, BORDER,1, STICKY,NOCLOSE, SCROLL,CAPTIONPADDING,4, CAPTION,'Resident Address Book',MIDX,-300, RELY,50, STATUS,'Example with iframe content, a caption and a Close link');" onmouseout="nd(200);" style="color:Black;"> Last Name</td>
<td><input type="text" size="10" name="r_fname"> First Name</td>
<td><input type="submit" value="go"></td>
</tr>
</form>
</table>

<BR><BR><cfinclude template="actionlist.cfm">
<cfinclude template="../footer.cfm">