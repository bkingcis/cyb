<cfparam name=MarketingTitle Default="Cybatrol - Digital Guard Systems for your Gated Community">
<cfparam name=MarketingKeywords Default="cybatrol,digital guard, gated community">
<cfparam name=MarketingDescription Default="Cybatrol is the latest in digital guard systems for your gated community.">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

	<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<cfif isDefined('session.user_id') AND val(session.user_id)>
<cfquery name="GetMainPage" DATASOURCE="#DATASOURCE#">
	Select * From MainPages
	Where PageTitle = 'Residents'
</cfquery>
<cfquery name="GetResident" datasource="#datasource#">
	select residents.r_id, residents.h_id, residents.r_fname, residents.r_lname, residents.r_altphone, residents.r_email, homesite.h_id, homesite.h_lname, homesite.h_address, homesite.h_city, homesite.h_state, homesite.h_zipcode, homesite.h_phone
	from residents, homesite
	where residents.h_id = homesite.h_id AND residents.r_id = #session.user_id#
</cfquery>
<cfquery name="GetCommunity" datasource="#datasource#">
	select *
	from communities
	WHERE c_id = #session.user_community#
</cfquery>	
<CFELSE>
	<cflocation URL="../index.cfm" addtoken="no">
</cfif>	

<cfoutput>
<title>#MarketingTitle#</title>
<meta name="description" content=#MarketingKeywords#>
<meta name="keywords" content=#MarketingDescription#>

<link rel="stylesheet" href="#BaseURL#/css/site.css">
<link rel="stylesheet" href="#BaseURL#/cal.css">
</cfoutput>
<script type="text/javascript">
	<!--
		if (top.location!= self.location) {
			top.location = self.location.href
		}
	//-->
</script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script> 

<script type="text/javascript" src="/js/jquery.simpleweather.js"></script> 

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
<script type="text/javascript" src="http://inscertdev.fusiondevelopers.com/shared/javascript/jquery.fancybox-1.3.1.pack.js"></script>
<link rel="stylesheet" href="http://inscertdev.fusiondevelopers.com/shared/css/jquery.fancybox-1.3.1.css" type="text/css">
	<script type="text/javascript">
	   $(document).ready(function(){
			$('.actionlist a').fancybox({
				'height':580,
				'width':680,
				'autoDimensions':false,
				'type':'iframe'
			});
			$('.popBoxList a').fancybox({
				'height':580,
				'width':680,
				'autoDimensions':false,
				'type':'iframe'
			});
			$('.extlink').fancybox({
				'height':580,
				'width':680,
				'autoDimensions':false,
				'type':'iframe'
			});
			
			$.simpleWeather({
			<cftry><cfoutput>zipcode: '#GetCommunity.C_ZIPCODE#',</cfoutput><cfcatch type="any">zipcode: '90210',</cfcatch></cftry>
				unit: 'f',
				success: function(weather) {
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
					$("#weather").html("<p>"+error+"</p>");
				}
			});
			
		});
	</script>
</head>

<body onload="_nn4_loaded=true;" class="resident">
<!--- <div id="above">
	<cfif isDefined('session.communityName')>
	<h1><cfoutput>#session.communityName#</cfoutput></h1> 
	<div id="loginstatus">logged in as <em>Resident A</em></div>
	</cfif>
</div> --->
<cfif FIND('/residents/',cgi.PATH_INFO)>
	<div class="clr"></div>
	<div id="container">
		<div id="col1">
		<div id="utility1" class="utilityPanel">
			<div class="inner"><script>
			function submitSrch(url) {			
				 $.fancybox({
					'height':580,
					'width':680,
					'autoDimensions':false,
					'href': url+$('#searchInp').val(),
					'type':'iframe'
				});
			}
			</script>
			
			<div class="heading" style="color:#0071be;">SEARCH:</div><br />
			
			<input type="text" id="searchInp" placeholder="search" style="width:98%"><br /><!--- <img src="/images/magnifi-icon.png"> --->
			<input type="image" src="/images/icons/google.png" class="srchBtn" onclick="submitSrch('http://www.google.com/search?q=');">
			<input type="image" src="/images/icons/bing.png" class="srchBtn" onclick="submitSrch('http://www.bing.com/search?q=');">
			<input type="image" src="/images/icons/yahoo.png" class="srchBtn" onclick="submitSrch('http://search.yahoo.com/search?p=');">
			<input type="image" src="/images/icons/youtube.png" class="srchBtn" onclick="submitSrch('http://www.google.com/search?tbm=vid&q=');">
			<input type="image" src="/images/icons/amazon.png" class="srchBtn" onclick="submitSrch('http://www.amazon.com/s/ref=nb_sb_noss?field-keywords=');">
			<input type="image" src="/images/icons/ebay.png" class="srchBtn" onclick="submitSrch('http://shop.ebay.com/?_sacat=See-All-Categories&_nkw=');">
			<input type="image" src="/images/icons/meetup.png" class="srchBtn" onclick="submitSrch('http://www.meetup.com/find/?keywords=');">
			<input type="image" src="/images/icons/linkedin.png" class="srchBtn" onclick="submitSrch('http://www.linkedin.com/search/fpsearch?keywords=');">
			<!--- <input type="image" src="/images/icons/google.png" class="srchBtn">
			<input type="image" src="/images/icons/google.png" class="srchBtn">
			<input type="image" src="/images/icons/google.png" class="srchBtn"> --->
			
			</div>
		</div>
		<div id="utility2" class="utilityPanel">
			<div class="inner">
			<iframe src="http://www.facebook.com/plugins/activity.php?header=false&colorscheme=light&border_color=white&width=220&height=220&recommendations=true" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:240px; height:300px;" allowTransparency="true"></iframe>
			</div>
		</div>
		<div id="utility3" class="utilityPanel">
			<div class="inner" id="weather">			
			</div>
		</div>
		</div>
		<div id="col2">
	<div class="workspace" id="workspacea">
<cfelse>
<table border="0" cellspacing="0" cellpadding="0" align="center" class="main">
  <tr>
    <td><img src="<cfoutput>#BaseURL#</cfoutput>/images/header3.gif" width="580" height="32" alt="Cybatrol is the latest in digital guard systems for your gated community."></td>
  </tr>
   <!--- TOP NAV --->
    <cfif val(session.user_id)>
   <tr>
  	<td><br>
	&nbsp;&nbsp;&nbsp;&nbsp;<a href="index.cfm">home</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="logout/index.cfm">logout</a>
   	</td>
   </tr>
   </cfif> 
  <tr>
    <td class="maincontent">
</cfif>