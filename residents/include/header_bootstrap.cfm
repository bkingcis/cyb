<cfsilent>
<cfif isDefined('session.user_id') AND val(session.user_id)>
<cfset request.dsn = datasource>
<cfquery name="GetMainPage" datasource="#request.dsn#">
	Select * From MainPages
	Where PageTitle = 'Residents'
</cfquery>
<cfquery name="GetResident" datasource="#datasource#">
	select residents.r_id, residents.h_id, residents.r_fname, residents.r_lname, residents.r_altphone, residents.r_email, homesite.h_id, homesite.h_lname, homesite.h_address, homesite.h_city, homesite.h_state, homesite.h_zipcode, homesite.h_phone
	from residents, homesite
	where residents.h_id = homesite.h_id AND residents.r_id = <cfqueryparam value="#val(session.user_id)#" cfsqltype="CF_SQL_INTEGER" />
</cfquery>
<cfquery name="GetCommunity" datasource="#request.dsn#">
	select *
	from communities
	WHERE c_id = <cfqueryparam value="#val(session.user_community)#" cfsqltype="CF_SQL_INTEGER" />
</cfquery><!---
<cfquery name="qGallery" datasource="#request.dsn#">
	select * from communitygallery
	where c_id = <cfqueryparam value="#val(session.user_community)#" cfsqltype="CF_SQL_INTEGER" />
</cfquery>--->
<cfquery name="qEventTypes" datasource="#request.dsn#">
	Select * from CommunityeventTypes
	where c_id = <cfqueryparam value="#val(session.user_community)#" cfsqltype="CF_SQL_INTEGER" />
</cfquery>
<cfquery datasource="#request.dsn#" name="qresidentSignInMessage">
	select 	*
	from	communitymessages
	where 	fieldname = 'residentSignInMessage'
	and 	c_id = <cfqueryparam value="#val(session.user_community)#" cfsqltype="CF_SQL_INTEGER" />
	order by messageDate desc
</cfquery>
<CFELSE>
	<cflocation URL="/login" addtoken="no">
</cfif>	
</cfsilent>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Cybatrol Resident Portal</title>
		
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
	<!-- Latest compiled and minified JavaScript -->
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
		<link rel="stylesheet" type="text/css" href="/css/screen.css">
	<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css">
	<!-- Optional theme -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap-theme.min.css">
	
	<!-- Toggle Libraryr from bootstraptoggle.com -->
		<link href="/css/bootstrap-switch.min.css" rel="stylesheet">
		<script src="/js/bootstrap-switch.min.js"></script>
	
	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
		<script src="//oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		<script src="//oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
	
	<!-- form validation for bootstrap 3 -->
	<script src="/js/validator.min.js"></script>
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
<link rel="stylesheet" href="/cal.css">
<style>
 .modal-title {
 	text-transform: uppercase;}
</style>
  </head>
  <body>
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
            <div class="modal-footer">
                <button type="button" id="btnClose" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" id="btnBack" class="btn btn-default">Back</button>
                <button type="button" id="btnContinue" class="btn btn-primary">Continue</button>
        	</div>
			<div id="modal-previous-body" style="display:none;" data-goback="[]"></div>
    	</div>
	</div>
</div>
<div class="modal fade header-modal-sm" id="headerModal" tabindex="-1" role="dialog" aria-labelledby="headerModal" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
		<div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><span style="font-size: 0.65em">CLOSE</span> &times;</button>
				<h4 class="modal-title" id="myModalLabel">Resident Modal</h4>
            </div>
            <div class="modal-body">
                <h3>Loading...</h3>
            </div>
            <div class="modal-footer">
                <button type="button" id="btnClose" class="btn btn-default" data-dismiss="modal">Close</button>
                 <button type="button" id="btnContinue" class="btn btn-primary">Save</button>
        	</div>
			<div id="modal-previous-body" style="display:none;" data-goback="[]"></div>
    	</div>
	</div>
  </div>
</div>