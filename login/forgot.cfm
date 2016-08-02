
<cftry>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Password Recovery - Cybatrol</title>
		
	 <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<!-- Latest compiled and minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
	<link rel="stylesheet" type="text/css" href="/css/screen.css">
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css">
	<!-- Optional theme -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap-theme.min.css">
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
	<style>
		h1 {font-size: 28px; background-color: #efeddd; padding:42px 10px 10px;margin:0 0 20px 0}
		.hilite {
			border-bottom: 1px solid silver;
		}
		.hilite:hover {background: #efefef;}
		form {padding: 0 10px;min-height: 400px}
	</style>
  </head>
  <body class="signup">
  <!-- 
  <div class="nav" style="background-image: url('/img/logo.png');
	background-position: left 10px top 8px;background-size: 130px;background-repeat: no-repeat;">
		<div id="phone"></div></div>		
		<div id="logo"></div> -->
    <div class="container">
	<nav class="navbar navbar-default">
		<div class="container-fluid" style="background-image: url('/img/logo.png');background-position: right 70px top 8px;background-size: 130px;background-repeat: no-repeat;">
		  <div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
			  <span class="sr-only">Toggle navigation</span>
			  <span class="icon-bar"></span>
			  <span class="icon-bar"></span>
			  <span class="icon-bar"></span>
			</button>
			<a class="hidden-xs navbar-brand" href="#"><strong><!-- Community Name --></strong> 
			</a>
		  </div>
		  <div id="navbar" class="navbar-collapse collapse" aria-expanded="false" style="height: 1px;">
			<ul class="nav navbar-nav">
			 <!-- <li><a href="popup/account.cfm" data-toggle="modal" data-target=".bs-example-modal-sm"><span class="glyphicon glyphicon-user"></span> Settings</a></li> -->
			  <li><a href="javascript:window.history.back();" style="color:#f77b33;"><span class="glyphicon glyphicon-arrow-left"></span> Return</a></li>
			</ul>
		  </div><!--/.nav-collapse -->
		</div><!--/.container-fluid -->
		</nav>
	<div class="jumbotron">	
 	<cfoutput>
	<cfif structKeyExists(form,'login_type')>
		<cfquery datasource="cybatrol" name="qAccount">
			select * from residents where r_username = <cfqueryparam value="#form.username#" cfsqltype="CF_SQL_VARCHAR" />
		</cfquery>
		<cfif qAccount.recordcount>
		<cfset variables.token = createUUID()>
		
		<cfquery datasource="cybatrol" name="tokenIt">
			update <cfif login_type is 'personnel' or login_type is 'staff'> staff<cfelse> residents</cfif> 
			set password_reset_token = <cfqueryparam value="#variables.token#" cfsqltype="CF_SQL_VARCHAR" />
			where <cfif login_type is 'personnel' or login_type is 'staff'> staff_username<cfelse>r_username</cfif> = <cfqueryparam value="#form.username#" cfsqltype="CF_SQL_VARCHAR" />
		</cfquery>
		<cfset recoveryURL = 'http://secure.cybatrol.com/login/password-recovery?token=#variables.token#&username=#urlEncodedFormat(form.username)#'>
			
		<cfmail from="info@cybatrol.com" to="#form.username#" bcc="bkingcis@gmail.com" subject="Account Maintenance: Cybatrol" type="HTML">
			<p>A password reset request was initiated for this account.  To continue with the reset process follow
			<a href="#recoveryURL#" target="_blank">This Link</a>, or copy/paste the URL below into your browser's address bar.</p>   
			
			#recoveryURL#
			
			<p>If you did not request a password reset simply ignore this email.</p>
		</cfmail>
		</cfif>
		<p>If the email you entered matches our records you should receive instructions for resetting your password in just a moment.</p>
		<a href="/login?login_type=#form.login_type#"><span class="glyphicon glyphicon-arrow-left"></span> Return to Login Screen</a>
	
	<cfelse>
	<form class="form" role="form" id="LoginFrm" action="/login/forgot.cfm" method="post"><legend>#request.page_title#</legend>
 	 <input type="hidden" name="login_type" value="#login_type#"> 	
		<p></p>
		<fieldset>
		  <div class="form-group row">
			<label for="username" class="col-sm-3 control-label">Enter Email:</label>
			<div class="col-sm-5  col-md-3">
			<input type="text" class="form-control" name="username" />
			</div>
		  </div>
		<fieldset/>	
	  <div class="form-group">
		<div class="col-sm-offset-3 col-sm-4 col-md-offset-2 col-md-4">
		  <button id="btn_continue" type="submit" class="btn btn-primary">Send Reset Email</button>
		</div>
	  </div>
	</form>
	</cfif>
	</cfoutput>
	</div><!-- /.jumbotron -->
		
    </div><!-- /.container -->
	<div id="footer">
	P.O. Box 1044, Sarasota, FL &nbsp;34230-1044<br />
	Copyright &copy; Cybatrol 2011-2015 <a href="/terms.cfm" class="extlink">Terms & Conditions</a> | <a class="extlink" href="/privacypolicy.cfm">Privacy Statement</a><br /><br />
	<img src="/img/cybatrol_footerlogo.png" />
	</div>
			<script>
			$(function() {
				
				$('#btn_continue').on('click',function(){
				  
				  if (!$('input[name=username]').val().length) { 
				  	alert('Please supply an email address to reset your password.');
					 return false;
				  }
					
				});

			});
		</script>
	<div class="modal fade" id="baseModal" tabindex="-1" role="dialog" aria-labelledby="baseModal" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><span style="font-size: 0.65em">CLOSE</span> &times;</button>
				<h4 class="modal-title" id="myModalLabel">Resident Login</h4>
            </div>
            <div class="modal-body">
                <h3>Loading...</h3>
            </div>
          <!--   <div class="modal-footer">
                <button type="button" id="btnClose" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" id="btnBack" class="btn btn-default">Back</button>
                <button type="button" id="btnContinue" class="btn btn-primary">Continue</button>
        	</div> -->
			<div id="modal-previous-body" style="display:none;" data-goback="[]"></div>
    	</div>
	</div>
</div>
  </body>
</html>
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
