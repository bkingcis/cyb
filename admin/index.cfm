<cflocation url="login.cfm" addtoken="false" >
<cfimport prefix="v" taglib="/admin/view">

<v:headeradmin>
	<div style="text-align:center;margin:30px;"><img src="http://www.cybatrol.com/uploads/7/1/7/8/7178896/1427841630.png"></div><br />
	<br />
	<p style="font-size:16pt;">Administrative Access</p>
	
<cfif isDefined("session.message") AND LEN(session.message)><div class="alert"><cfoutput>#session.message#</cfoutput></div><cfset session.message = ""></cfif>	
	<div style="width: 258px;float-left: auto; float-right:auto; border: 1px solid #333; background-color: #c0c0c0;">
		<form action="admin.cfm?fa=login" method="post">
			<table>
				<tr><td><input type="Text" name="username" /></td> <td><strong>User Name</strong></td></tr>
			<tr><td><input type="Password" name="Password" /></td> <td><strong>Password</strong></td></tr>	
			<tr><th colspan="2"><input type="Submit" value="  : login :  " /></th></tr></table>
		</form>
	</div><br>
	<br>
	<br>
	<br>
	<br>	
	
	<script type="text/javascript">
			<!--
				if (top.location!= self.location) {
					top.location = self.location.href
				}
			//-->
		</script>
<v:footeradmin>