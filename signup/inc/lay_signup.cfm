<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0" />
    <title>Get Started</title>
		
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
		h1 {background-image: url('/img/logo.png');background-position: left 5px top 28px;background-size: 200px;
		background-repeat: no-repeat;text-align:right;font-size: 25px; border-bottom: 1px solid orange; padding:30px 60px;}
		//background-color: #efeddd;
		.hilite {
			border-bottom: 1px solid silver;
		}
		.hilite:hover {background: #efefef;}
		
	  .container { background-color: white; }
		.container form {padding: 0 10px;min-height: 400px}
		
		div .has-error ::after {content: " *";color:red;}

	</style>
		<!--- GA --->
	<script>
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

		ga('create', 'UA-72560956-2', 'auto');
		ga('send', 'pageview');
	</script>
  </head>
  <body class="signup">
  <div id="header"><!--- <div id="phone">Call Us Today! 1-800-325-0371</div> ---></div>		
		<div id="logo"></div>
    <div class="container" style="margin-top:40px;">
	<div style="clear:both;"></div>
	
	<cfoutput>
	<h1 class="hidden-xs">#H1pagetitle#</h1>
	<cfparam name="h2PageTitle" default="#h1PageTitle#">
	<h2 class="visible-xs-*">#H2pagetitle#</h2>
	#content_var#</cfoutput><!--- <cfdump var="#session.signup#">--->
		
    </div><!-- /.container -->

		
	<div id="footer">
	P.O. Box 1044, Sarasota, FL &nbsp;34230-1044<br />
	Copyright &copy; Cybatrol 2011-<cfoutput>#year(now())#</cfoutput> <a href="/terms.cfm" class="extlink">Terms & Conditions</a> | <a class="extlink" href="/privacypolicy.cfm">Privacy Statement</a><br /><br />
	<img src="/img/cybatrol_footerlogo.png" />
	</div>
		<script>
			$(function() {
				$('#btn_back').on( "click", function() {
				  window.history.back();
				});
				$( window ).resize(function() {
					// location.reload();
				});
			});
		</script>

			<script type='text/javascript' data-cfasync='false'>window.purechatApi = { l: [], t: [], on: function () { this.l.push(arguments); } }; (function () { var done = false; var script = document.createElement('script'); script.async = true; script.type = 'text/javascript'; script.src = 'https://app.purechat.com/VisitorWidget/WidgetScript'; document.getElementsByTagName('HEAD').item(0).appendChild(script); script.onreadystatechange = script.onload = function (e) { if (!done && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) { var w = new PCWidget({c: '95cb67ef-e20d-43e1-a569-6ae5b1a05a1e', f: true }); done = true; } }; })();</script>

  </body>
</html>	
