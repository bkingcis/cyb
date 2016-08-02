<cfparam name=MarketingTitle Default="Cybatrol - Digital Guard Systems for your Gated Community">
<cfparam name=MarketingKeywords Default="cybatrol,digital guard, gated community">
<cfparam name=MarketingDescription Default="Cybatrol is the latest in digital guard systems for your gated community.">
<!DOCTYPE HTML>
<html lang="en">
<head>
<cfoutput>
<title>#MarketingTitle#</title>
<meta name="description" content=#MarketingKeywords#>
<meta name="keywords" content=#MarketingDescription#>
<link rel=stylesheet href=#BaseURL#/site.css>
<link rel=stylesheet href=#BaseURL#/cal.css>
<script type="text/javascript">
	<!--
		if (top.location!= self.location) {
			top.location = self.location.href
		}
	//-->
</script>
<cfif isDefined("metarefresh")>
<cfparam name="refreshtime" default="6" />
<script type="text/javascript">
    window.onload = function(){
        var timer = null,
            time=1000*#refreshtime#, // 60 minutes
            checker = function(){
                if(timer){clearTimeout(timer);} // cancels the countdown.
                timer=setTimeout(function(){
                    document.location="index.cfm";
                },time); // reinitiates the countdown.
            };
			checkerLong = function(){
				if(timer){clearTimeout(timer);} // cancels the countdown.
			}
        checker(); // initiates the countdown.
        // requires jQuery... (you could roll your own jQueryless version pretty easily though)
        $(document).ready(function(){
            // bind the checker function to quickbar click event because I don't want the page to refresh again.
            $('.jumpBtn').bind("click", checkerLong());
        });
    };
</script>
<script type="text/javascript">
	<!--
		if (parent.location!= self.location) {
			parent.location = self.location.href
		}
	//-->
</script>
<noscript>
    <meta name="Refresh" http-equiv="Refresh" content="#refreshtime#;URL=index.cfm">
</noscript>

</cfif>

</cfoutput>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function fAddListItem(strDate,caller) {
	// caller is the reference to the iframe engine which init the call, ie. gfFlat_1 or gfFlat_2
	var dl=document.testForm.dateList;
	dl.options[dl.options.length]=new Option(strDate,strDate);
}
function fRemoveListItem(strDate,caller) {
	// caller is the reference to the iframe engine which init the call, ie. gfFlat_1 or gfFlat_2
	var dl=document.testForm.dateList;
	for (var i=0;i<dl.options.length;i++)
		if (strDate==dl.options[i].value) break;
	dl.options[i]=null;
}
// The above 2 functions are called from within the plugins2.js when adding dates into the selected ranges. We use them to add dates explicitly to the <select> list.
// These 2 have to be defined in the same page with the <select> tag, otherwise a bug of IE5.0 will prevent the list from getting new options. IE5.5+ doesn't have this bug.
// param strDate has a format of yyyy/mm/dd, you may modify this format in function fDateString in the plugins2.js

function submitByDates(fm) {	// construct the selected dates in the hidden form field allSelected
	fm.allSelected.value="";
	for (var i=0; i<fm.dateList.length; i++) {
		if (i>0) fm.allSelected.value+=",";
		fm.allSelected.value+=fm.dateList.options[i].value;
	}
	// fm.action="ByDate.php";
	fm.submit(); //alert(fm.allSelected.value); // in your app you should call fm.submit() instead so that the allSelected.value can be submitted.
}

function submitByRanges(fm) {	// construct the selected date ranges in the hidden form field allSelected
	fm.allSelected.value="";
	var _cxp_pds=gfFlat_1.fGetPDS();
	for (var i=0; i<_cxp_pds.length; i++) {
		var d0=new Date(_cxp_pds[i][0]);
		var d1=new Date(_cxp_pds[i][1]);
		fm.allSelected.value+="["+d0.getUTCFullYear()+"/"+(d0.getUTCMonth()+1)+"/"+d0.getUTCDate()
			+","
			+d1.getUTCFullYear()+"/"+(d1.getUTCMonth()+1)+"/"+d1.getUTCDate()+"]";
	}
	// fm.action="ByRange.php";
	alert(fm.allSelected.value); // in your app you should call fm.submit() instead so that the allSelected.value can be submitted.
}
</script>
<script language="JavaScript">
		function goURL( selectCtrl ) {		
			if (selectCtrl.options[ selectCtrl.selectedIndex ].value != "" )
				window.open( selectCtrl.options[ selectCtrl.selectedIndex ].value, '_top' );		
		}
</script>
 
<script type="text/javascript" src="overlibmws/overlibmws.js"></script>
<script type="text/javascript" src="overlibmws/iframecontentmws.js"></script>
<script type="text/javascript" src="overlibmws/overlibmws_overtwo.js"></script>
<script type="text/javascript" src="overlibmws/overlibmws_scroll.js"></script>
<script type="text/javascript" src="overlibmws/overlibmws_draggable.js"></script>
<script type="text/javascript" src="overlibmws/overlibmws_filter.js"></script>
<script type="text/javascript" src="overlibmws/overlibmws_bubble.js"></script>
<script type="text/javascript" src="overlibmws/overlibmws_shadow.js"></script>	
<link rel="stylesheet" type="text/css" href="/jquery.thickbox/thickbox.css" />
<!-- <script type="text/javascript" src="/jquery.thickbox/thickbox.js"></script>--> 
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script> 
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js"></script>

<script type="text/javascript" src="/js/jquery.simpleweather.js"></script>
<link rel="stylesheet" type="text/css" href="//ajax.googleapis.com/ajax/libs/jqueryui/1/themes/smoothness/jquery-ui.css">

<script type='text/javascript' src='/js/jquery.form.js'></script> 
<script type="text/javascript" src="/js/jquery.fancybox-1.3.1.pack.js"></script>
<link rel="stylesheet" href="/css/jquery.fancybox-1.3.1.css" type="text/css">
	
	<script type="text/javascript">
		$(document).ready(function(){
			$('.extlink').fancybox({
				'height':480,
				'width':760,
				'autoDimensions':false,
				'type':'iframe',
  			onClosed: function() {
					location.reload();
				}
			});
			
			$.simpleWeather({
			<cftry><cfoutput>zipcode: '#GetCommunity.C_ZIPCODE#',</cfoutput><cfcatch type="any">zipcode: '90210',</cfcatch></cftry>
				unit: 'f',
				success: function(weather) {
					$("#weather").html("");
					$("#weather").append('<div class="heading" style="color:#0071be;">'+weather.city+', '+weather.region+' '+weather.country+'</div>');
					$("#weather").append("<p><strong>Today's High</strong>: "+weather.high+"&deg; "+weather.units.temp+" <br /> <strong>Today's Low</strong>: "+weather.low+"&deg; "+weather.units.temp+"</p>");
					$("#weather").append("<p><strong>Current Temp</strong>: "+weather.temp+"&deg; "+weather.units.temp+"</p>");
					$("#weather").append("<p><strong>Wind</strong>: "+weather.wind.direction+" "+weather.wind.speed+" "+weather.units.speed+"</p>");
					$("#weather").append("<p><strong>Currently</strong>: "+weather.currently); 
					//+" - <strong>Forecast</strong>: "+weather.forecast+"</p>"
					$("#weather").css('background-image','url('+weather.image+')').css('background-repeat','no-repeat');
					$("#weather").append("<p><strong>Sunrise</strong>: "+weather.sunrise+" <br /> <strong>Sunset</strong>: "+weather.sunset+"</p>");
					//$("#weather").append("<p><strong>Last updated</strong>: "+weather.updated+"</p>");
					//$("#weather").append('<p><a href="'+weather.link+'">View forecast at Yahoo! Weather</a></p>');
				},
				error: function(error) {
					$("#weather").html("<p>Weather Widget Response: "+error+"</p>");
				}
			});
		});
		
		
		function initialize() {
		  var myLatlng = new google.maps.LatLng(47.60616304386874, -122.3876953125);
		  var myOptions = {
		    zoom:9,
		    center: myLatlng,
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		  }
		  var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
		}
		function loadScript() {
		  var script = document.createElement("script");
		  script.type = "text/javascript";
		  script.src = "http://maps.google.com/maps/api/js?sensor=false&callback=initialize";
		  document.body.appendChild(script);
		}
		  
		window.onload = loadScript;
	</script>
</head>

<body>
<div id="container" style="margin: 0 auto;">
<div id="col1" style="display:none">
	<cfif getCommunity.dashpass>	
		<div id="dashpassUtility" class="utilityPanel"><div class="inner">
			<!---<cfinclude template="../frmdashpass.cfm">	 quick dash-pass entry form --->
			</div>
		</div>
	<cfelse>
	<div id="dashpassUtility" class="utilityPanel">
		<div class="inner">
			<br /><br />
		<div style="text-align:center"><img src="/images/cybadash.jpg" height="120"></div>
			<br /><br />
		</div>
	</div>
	</cfif>
	<div id="utility1" class="utilityPanel">
		<div class="inner" id="map_canvas"></div>
	</div>
	
	<div id="utility3" class="utilityPanel">
		<div class="inner" id="weather">&nbsp;&nbsp;Loading...&nbsp;&nbsp;</div>
	</div>
	 <!--- end col1 --->	
</div>
<div id="col2"><cfquery name="qEntryPoint" datasource="#datasource#">
        select *
        FROM communityentrypoints
        WHERE entrypointid = #val(session.entrypointid)#
    </cfquery>
	<cfquery name="GetStaff" datasource="#datasource#">
		select staff.staff_id, staff.c_id, staff.staff_fname, staff.staff_lname
		from staff
		where staff_id = #session.staff_id#
	</cfquery>
<div id="mainPanel">
<div style="background-image: url('/img/personnel-logo.png');
	background-position: left 20px top 12px;background-size: 90px;background-repeat: no-repeat;cursor:pointer;" onclick="self.location='/staff'">
	
  <div style="height:50px;float:right;width:20px;padding:20px 27px 0 0;"><a href="logout/index.cfm" style="color:red">logout</a></div>	
  <div style="height:50px;float:right;width:280px;padding-top:20px;">
	<cfoutput>		
		<!---	<strong style="color:##336699;font-size:14px;">STAFF MEMBER:</strong> --->
			<strong style="font-size: 1.4em;color:##4e4e4e;">#ucase(GetStaff.staff_fname)# #ucase(GetStaff.staff_lname)#</strong> <a href="logout/index.cfm" style="color:silver">not you?</a><!--- #timeFormat(session.logintime)# --->
		<br />
		<strong style="color:##336699;font-size:14px;">LOCATION:</strong>
		<strong style=" color:##4e4e4e;font-weight:bold;">#ucase(qEntryPoint.label)#</strong>
		</cfoutput>	
  </div>
	<div style="clear:both;height:44px"></div>
</div>
<div class="maincontent">