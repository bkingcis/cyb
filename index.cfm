<h1>new server</h1>
<a href="/residents">Residents</a>  <a href="/staff">Personnel</a>
<cfabort>
<cfquery datasource="#request.dsn#" name="qr">select * from residents
</cfquery><cfdump var="#qr#"><cfabort>


<!DOCTYPE html> 
<html>
<head>
	<title>Interactive Visitor Announcement System - Cybatrol.com</title>
	<link rel="stylesheet" type="text/css" href="css/screen.css">
	<script type="text/javascript" src="/js/swfobject.js"></script>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
	<script type="text/javascript" src="/js/jquery.fancybox-1.3.1.pack.js"></script>
    <link href="http://comingsoonpro.com/bootstrap/css/bootstrap.min.css" rel="stylesheet">

	<link rel="stylesheet" href="/css/jquery.fancybox-1.3.1.css" type="text/css">
	<script type="text/javascript" src="/js/jquery.form.js"></script>
	<script type="text/javascript">
	   $(document).ready(function(){

			$('.extlink').fancybox({
				'height':480,
				'width':710,
				'autoDimensions':false,
				'type':'iframe'
			});
			$("#residentLoginFrm").ajaxForm({
		        success: function(responseText){
		            $.fancybox({
		                'content' : responseText,
						'height':290,
						'width':500,
						'autoDimensions':false
		            });
		        }
		    }); 
			
		   $("#staffLoginFrm").ajaxForm({
		        success: function(responseText){
		            $.fancybox({
		                'content' : responseText,
						'height':220,
						'width':580,
						'autoDimensions':false
		            });
		        }
		    }); 
		});
		
    	var flashvars = {};
	var params = {
		wmode:"transparent"
	};
	var attributes = {
		id:"myMovie"
	};

	swfobject.embedSWF("/swf/cybatrol_header_v4B.swf", "herocontent", "960", "354", "9","/swf/expressInstall.swf", flashvars, params, attributes);
	
    </script>
</head>

<body class="home">
	<div id="header"><div id="phone"><!--- Call Us Today! 1-800-325-0371 ---></div></div>	
	<div id="content">
		<div id="herocontent">			
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="960" height="324">
				<param name="wmode" value="transparent" />
		      <!--[if !IE]>-->
		        <object id="heroBanner" type="application/x-shockwave-flash" data="/swf/cybatrol_header_v3_1.swf" width="960" height="354">
		        <!--<![endif]-->
		          <img src="img/cybatrol_backup_hero.jpg" />
		        <!--[if !IE]>-->
		        </object>
				<!--<![endif]-->
			</object>
		</div>
		<div id="logo"></div>
		<div style="clear:both;"></div>
		<div id="body">
			<div id="bodyleft">
			<div class="bodycontent">
			<img src="img/bodycontent.png" />
			</div>
			<img src="img/contact_us_hdr.png" style="margin: 4px 28px;" /><br />
			<cfif isDefined('contactsent')>
				<p>Your contact information has been sent.<br /><br />
				<a href="index.cfm">To send another click here</a>.</p>
			<cfelse>
			<form action="submit/contact.cfm" method="post" style="margin:0 28px;">				
				<label for="yourname" style="">Your Name:<br />
				<input type="text" name="yourname" style="width:523px" />
				</label>
				<label for="youremail">Your Email:<br />
				<input type="text" name="youremail" style="width:255px" />
				</label>
				<label for="yourphone">Your Phone:<br />
				<input type="text" name="yourphone" style="width:255px" />
				</label>
				<label for="comments">Question or Comment:<br />
				<textarea name="comments" style="width:523px" rows="8"></textarea>
				</label>
				<input type="image" src="img/submit_btn.png" />
			</form>
			</cfif>
			</div>
			<div id="bodyright">
				<!--- <div class="video">
					<strong>Resident User Demo</strong><br /> click to view:<br />
					<a href="videoembed.cfm?id=residentconsole" class="extlink"><img class="rounded" src="/img/residentconsole_thumb.jpg" style="position: absolute;clip: rect(0px 248px 100px 0px);" alt="Now Watching: Resident User Demo"></a>
				</div>
				<div class="video">
					<strong>Personnel User Demo</strong><br /> click to view:<br />
					<a href="videoembed.cfm?id=staffconsole" class="extlink"><img class="rounded" src="/img/staffconsole_thumb.jpg" style="position: absolute;clip: rect(0px 248px 100px 0px);" alt="Now Watching: Gatehouse/Front Desk User Demo"></a>
				</div>
				 --->
				<div class="quote">
					"Finally.... A dependable visitor announcement system we enjoy using."
					<div style="text-align:right;margin:0px">
					- Christine Davis<br />
					  Las Vegas, Nevada
					</div>  
				</div>
				<div class="quote">
					"Cybatrol makes my job as the concierge of a luxury condominium so much more manageable."<br />
					<div style="text-align:right;margin:0px">
					- Anonymous<br />
					  Sarasota, Florida
					</div>
				</div>
				<div class="divider">&nbsp;</div>
				<img src="img/resident_login_hdr.png" />
				<form id="residentLoginFrm" action="/residents/login.cfm" method="post">
				<label for="username">Username:<br />
				<input type="text" name="username" style="width:255px" />
				</label>
				<label for="password">Password:<br />
				<input type="password" name="password" style="width:255px" />
				</label><br />
				<input type="image" src="img/submit_btn.png" />
				</form>
				
				<div class="divider"></div>
				<img src="img/client_login_hdr.png">
				<form id="staffLoginFrm" action="/staff/login.cfm" method="post">
				<label for="username">Username:<br />
				<input type="text" name="username" style="width:255px" />
				</label>
				<label for="password">Password:<br />
				<input type="password" name="password" style="width:255px"></label>
				<input type="image" src="img/submit_btn.png">
				</form>		
			</div>
		</div>		
	</div>
	<div style="clear:both;"></div>
	<div id="footer">
		1.800.325.0371<br />
		<!--  10940 Wilshire Boulevard, Suite 1600 - Los Angeles, CA &nbsp;90024 <br />  -->
		Copyright &copy; Cybatrol 2011 <a href="/terms.cfm" class="extlink">Terms & Conditions</a> | <a class="extlink" href="/privacypolicy.cfm">Privacy Statement</a><br /><br />
		<img src="img/cybatrol_footerlogo.png" />
	</div>
	<script type="text/javascript">
	  var _gaq = _gaq || [];
	  _gaq.push(['_setAccount', 'UA-6401630-1']);
	  _gaq.push(['_trackPageview']);
	
	  (function() {
	    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
	  })();
	</script>
</body>
</html>
