<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Returning Personnel</title>
		
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
			  <li><a href="http://www.cybatrol.com" style="color:#f77b33;"><span class="glyphicon glyphicon-arrow-left"></span> Return</a></li>

			</ul>
		  </div><!--/.nav-collapse -->
		</div><!--/.container-fluid -->
		</nav>
	<div class="jumbotron">	 
	<form class="form" role="form" id="personellLoginFrm" action="/staff/login.cfm" method="post">
		<p></p>
		<fieldset>
		<legend>Personnel User Secured Access:</legend>
		  <div class="form-group row">
			<label for="username" class="col-sm-2 control-label">Username:</label>
			<div class="col-sm-3  col-md-3">
			<input type="text" class="form-control" name="username" />
			</div>
		  </div>
		  <div class="form-group row">
			<label for="password" class="col-sm-2 control-label">Password:</label>
			<div class="col-sm-3 col-md-3">
			<input type="password" class="form-control" name="password" />
			<br />
			Forgot your password?
			</div>
		  </div>
		<fieldset/>	
	  <div class="form-group">
		<div class="col-sm-offset-2 col-sm-4 col-md-offset-2 col-md-4">
		  <button id="btn_continue" type="button" class="btn btn-primary" data-toggle="modal" data-target="#baseModal" data-action="announce2">LOGIN</button>
		</div>
	  </div>
	</form>
	</div><!-- /.jumbotron -->
		
    </div><!-- /.container -->
	<div id="footer">
	P.O. Box 1044, Sarasota, FL &nbsp;34230-1044<br />
	Copyright &copy; Cybatrol 2011-2015 <a href="/terms.cfm" class="extlink">Terms & Conditions</a> | <a class="extlink" href="/privacypolicy.cfm">Privacy Statement</a><br /><br />
	<img src="/img/cybatrol_footerlogo.png" />
	</div>
		<script>
			$(function() {
				$('#btn_back').on( "click", function() {
				  window.history.back();
				});
				$('#baseModal').on('show.bs.modal', function (event) {
				  var button = $(event.relatedTarget); // Button that triggered the modal
				  var action = button.data('action'); // Extract info from data-* attributes  
				  var modal = $(this);
				  
				  if (!$('input[name=username]').val().length) { 
				  	alert('Please supply an email address for your username.');
					 return false;
				  }
				  var formdata = {
				  	username: $('input[name=username]').val(),
					password: $('input[name=password]').val()
				  }

					var theUrl = "/staff/login.cfm";
					  $.ajax({
						  method: "POST",
						  url: theUrl,
						  data: formdata
						})
						.done(function( result ) {	
						  modal.find('.modal-body').html(result);
						  modal.find('.modal-title').text('Personnel Login');
						})
					   .fail(function() {
						 alert( "Could not connect." );
					  });
				});
			});
		</script>
	<div class="modal fade" id="baseModal" tabindex="-1" role="dialog" aria-labelledby="baseModal" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><span style="font-size: 0.65em">CLOSE</span> &times;</button>
				<h4 class="modal-title" id="myModalLabel">Resident Modal</h4>
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

