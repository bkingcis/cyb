<!DOCTYPE html> 

<cfimport prefix="security" taglib="../admin/security">
<security:community>
<cfset qCommunity = CommunityObj.read(session.user_community)>
<cfset qHomesites = homeSiteObj.read(session.user_community)>
<cfset qMessage = adminMessageObj.getMostRecentCommunityMessage(session.user_community)>
<cfset qStaffList = StaffObj.read(session.user_community)>
<cfset qMessage = adminMessageObj.getMostRecentCommunityMessage(session.user_community)>
<cfset qGallery = galleryObj.read(session.user_community)>
<cfset qDownloads = downloadObj.read(session.user_community)>
<cfset xfa.resetStaffPass="resetStaffPass">
<cfset request.self = "index.cfm">

<html> 
	<head> 
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /> 
		<title>Manage Community</title> 
		<link href="css/styles.css" type="text/css" rel="stylesheet"> 
		
		<link type="text/css" href="/admin/js/jquery-ui-1.7.2.custom/css/start/jquery-ui-1.7.2.custom.css" rel="stylesheet" />
		<link type="text/css" href="/admin/js/jquery.wysiwyg.css" rel="stylesheet" />
		<script type="text/javascript" src="/admin/js/jquery-ui-1.7.2.custom/js/jquery-1.3.2.min.js"></script> 
		<script type="text/javascript" src="/admin/js/jquery-ui-1.7.2.custom/js/jquery-ui-1.7.2.custom.min.js"></script>
		<script type="text/javascript" src="/admin/js/jquery.jeditable.mini.js"></script> 
		
		<!-- NEW 
		<link href="/css/styles.css" type="text/css" rel="stylesheet"> 
		
		<link type="text/css" href="/commadmin/js/jquery-ui-1.10.4.custom/css/smoothness/jquery-ui-1.10.4.custom.min.css" rel="stylesheet" />
		<link type="text/css" href="/admin/js/jquery.wysiwyg.css" rel="stylesheet" />
		<script type="text/javascript" src="/commadmin/js/jquery-ui-1.10.4.custom/js/jquery-1.10.2"></script> 
		<script type="text/javascript" src="/commadmin/js/jquery-ui-1.10.4.custom/js/jquery-ui-1.10.4.custom.min.js"></script>
		<script type="text/javascript" src="/commadmin/js/jquery.jeditable.mini.js"></script> -->
		<script type="text/javascript">
			<!--
				if (top.location!= self.location) {
					top.location = self.location.href
				}
			//-->
		</script>
		<style>
			h2 {
			 text-align: center;
			}
		</style>
		<link rel="stylesheet" type="text/css" href="/jquery.thickbox/thickbox.css" />
		<script type="text/javascript" src="/jquery.thickbox/thickbox.js"></script><script type="text/javascript"> 
			$(function(){
				// Accordion
				$(".accordion").accordion({ header: "h3" });	
				// Tabs
				$('.tabs').tabs();				
				// Dialog			
				$('#dialogX').dialog({
					autoOpen: false,
					width: 600,
					buttons: {
						"Ok": function() { 
							$(this).dialog("close"); 
						}, 
						"Cancel": function() { 
							$(this).dialog("close"); 
						} 
					}
				});
				
				// Dialog Link
				$('#dialog_link').click(function(){
					$('#dialog').dialog('open');
					return false;
				});
 
				// Datepicker
				$('#datepicker').datepicker({
					inline: true
				});				
				// Slider
				$('#slider').slider({
					range: true,
					values: [17, 67]
				});				
				// Progressbar
				$("#progressbar").progressbar({
					value: 20 
				});
				
								
				//hover states on the static widgets
				$('#dialog_link, ul#icons li').hover(
					function() { $(this).addClass('ui-state-hover'); }, 
					function() { $(this).removeClass('ui-state-hover'); }
				);
				
			     $('.wysiwyg').editable('processor/banner.cfm', { 
			         type      : 'textarea',
					 loadurl  : 'processor/blank.htm',
			         cancel    : 'Cancel',
			         submit    : 'Save Changes',
			         indicator : '<img src="/images/indicator.gif">',
			         tooltip   : 'Click to edit...'
			     });
			});
		</script> 
		<style type="text/css"> 
			/*demo page css*/
			body{ font: 62.5% "Trebuchet MS", sans-serif; margin: 0 10px;}
			.wysiwyg {height:200px;width:500px;margin-bottom: 24px;}
			.demoHeaders { margin-top: 2em; }
			.dialog_link {padding: .4em 1em .4em 20px;text-decoration: none;position: relative;}
			.dialog_link span.ui-icon {margin: 0 5px 0 0;position: absolute;left: .2em;top: 50%;margin-top: -8px;}
			#dialog_link {padding: .4em 1em .4em 20px;text-decoration: none;position: relative;}
			#dialog_link span.ui-icon {margin: 0 5px 0 0;position: absolute;left: .2em;top: 50%;margin-top: -8px;}
			ul#icons {margin: 0; padding: 0;}
			ul#icons li {margin: 2px; position: relative; padding: 4px 0; cursor: pointer; float: left;  list-style: none;}
			ul#icons span.ui-icon {float: left; margin: 0 4px;}
			.dataA {background-color:#eee;}
			.dataB {background-color:#ad6;}
			.rowHover {background-color:#ab9;}
			.bannerForm {height:250px;}
			td {font: 90% "Trebuchet MS", sans-serif; padding:4px; color:#336}
			td a {font: 90% "Trebuchet MS", sans-serif; color:#669}
		</style>	
<link rel="STYLESHEET" type="text/css" href="../admin/js/fancybox/jquery.fancybox-1.2.6.css">	</head> 
	<body><script type='text/javascript' data-cfasync='false'>window.purechatApi = { l: [], t: [], on: function () { this.l.push(arguments); } }; (function () { var done = false; var script = document.createElement('script'); script.async = true; script.type = 'text/javascript'; script.src = 'https://app.purechat.com/VisitorWidget/WidgetScript'; document.getElementsByTagName('HEAD').item(0).appendChild(script); script.onreadystatechange = script.onload = function (e) { if (!done && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) { var w = new PCWidget({c: '64733768-a2d0-402d-9931-878a7c090a9a', f: true }); done = true; } }; })();</script>
<cfswitch expression="#qCommunity.timezone#">
	<cfcase value="Pacific">
		<cfset timeadjuster = -3>
	</cfcase>
	<cfcase value="Mountain">
		<cfset timeadjuster = -2>
	</cfcase>
	<cfcase value="Central">
		<cfset timeadjuster = -1>
	</cfcase>
	<cfcase value="Eastern">
		<cfset timeadjuster = 0>
	</cfcase>
	<cfcase value="EasternPlus3">
		<cfset timeadjuster = 3>
	</cfcase>
	<cfdefaultcase>
		<cfset timeadjuster = -3>
	</cfdefaultcase>
</cfswitch>
<cfoutput>
<cftry>
<div style="color:black;float:left;padding-top:10px;">
<strong style="font-size: 16px;">
#qCommunity.c_name# Administrative Console</strong><br>
<span style="font-size: 13px">#GetAuthUser()#, Community Administrator</span>
<!--
#timeFormat(dateAdd("h",timeadjuster,now()))# #qCommunity.timezone# time -->

</div>

<div style="text-align:right;width:200px;float:right;padding-right:10px;padding-top:10px;">
<img src="http://www.cybatrol.com/uploads/7/1/7/8/7178896/1427841630.png" width="120">
<!---<img src="/admin/img/CybatrolLogwurl.gif" >---><br />
<a href="/admin/index.cfm">log out</a>
</div>
	<cfcatch>
	<cfdump var="#qCommunity#">
	<cfdump var="#cfcatch#">
	<cfabort>
	</cfcatch>
</cftry>
</cfoutput>

<div style="clear:both;"></div>
<div class="tabs">
	<ul>
		<li><a href="#home">Welcome</a></li>
		<cfif val(qCommunity.dashpass)>	<li><a href="#messages">DashPass</a></li></cfif>
		<li><a href="#documents">Documents</a></li>
		<li><a href="#residents">Residents</a></li>	
		<li><a href="#personnel">Personnel</a></li>
	</ul>
	<div id="home">
		<cfinclude template="inc/home.cfm">
		<cfinclude template="inc/banners.cfm">
		<!--- <cfinclude template="inc/messages.cfm"> --->
	</div>
	<cfif val(qCommunity.dashpass)>	
		<div id="messages">
			<cfinclude template="inc/dashpass_banners.cfm">
		</div>
	</cfif>
	<div id="documents">
		<cfinclude template="inc/documents.cfm">
	</div>
	<div id="residents">
		<cfinclude template="inc/homesites.cfm">
	</div>
	<div id="personnel">
		<cfinclude template="inc/users.cfm">
	</div>
	<!--- <div id="tabs-5">
		<cfinclude template="inc/gallery.cfm">
	</div> --->
	
	<!--- <div id="dialog" title="Dialog Title">
		<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
	</div> --->
</body>
</html>
