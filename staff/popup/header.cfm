<cfif NOT isDefined('session.user_community')><cflocation url="/staff.cfm" addtoken="false"></cfif>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<cfsilent>
<cfquery name="getCommunity" datasource="#datasource#">
	select * from communities 
	where c_id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#session.user_community#" />
</cfquery>
<cfquery datasource="#datasource#" name="qEventTypes">
	Select * from CommunityeventTypes
	where c_id = #session.user_community#
	order by label
</cfquery>
</cfsilent>
<html>
<head>
	<title>Cybatrol - Modal Window</title>
	<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script> 
	<link rel=stylesheet href="//secure.cybatrol.com/fancy.css">
	<link rel=stylesheet href="//secure.cybatrol.com/cal.css">
	<style>
		.action-btn {
    border: 1px solid #888;
    padding: 2px 4px;
    display: inline-block;
    background-color: white;
    text-decoration: none;
    color: black;
    font-size: 10px;
    cursor: pointer;
}
	.form-control, input[type="text"], select {
    display: block;
    width: 100%;
    /*height: 34px;*/
    padding: 6px 12px;
    /*font-size: 14px;*/
    line-height: 1.42857143;
    color: #555;
    background-color: #fff;
    background-image: none;
    border: 1px solid #ccc;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    -webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
    -o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
    transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
}
	.btn, button, input[type="submit"] {
    display: inline-block;
    padding: 6px 12px;
    margin-bottom: 0;
    font-size: 14px;
    font-weight: 400;
    line-height: 1.42857143;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    -ms-touch-action: manipulation;
    touch-action: manipulation;
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    background-image: none;
    border: 1px solid transparent;
    border-radius: 4px;
		text-shadow: 0 1px 0 #fff;
    background-image: -webkit-linear-gradient(top,#fff 0,#e0e0e0 100%);
    background-image: -o-linear-gradient(top,#fff 0,#e0e0e0 100%);
    background-image: -webkit-gradient(linear,left top,left bottom,from(#fff),to(#e0e0e0));
    background-image: linear-gradient(to bottom,#fff 0,#e0e0e0 100%);
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffffff', endColorstr='#ffe0e0e0', GradientType=0);
    filter: progid:DXImageTransform.Microsoft.gradient(enabled=false);
    background-repeat: repeat-x;
    border-color: #dbdbdb;
    border-color: #ccc;
}
	</style>
	<script>
	function GuestCheckin(v_id,g_id,recordPlate,checkin) {
			if(!checkin)var checkin = 0
			jThickboxNewLink="/staff/lpform.cfm?v_id="+v_id+"&g_id="+g_id+"&checkin="+checkin+"&height=500&width=700";
			<cfif getCommunity.recordLicensePlate>
				$.ajax({
							type        : "POST",
							cache       : false,
							url         : "guestdetails.cfm?checkin=1",
							data        : $(this).serializeArray(),
							success: function(data) {
								$.fancybox({
									'content' : data,
									'height':200,
									'width':460,
									'autoDimensions':false
								});
							}
						});
				
				//tb_open_new(jThickboxNewLink);
				if (recordPlate){
				jThickboxNewLink = jThickboxNewLink + '&fancyCheckin=1';
				tb_show('Record License Plate',jThickboxNewLink,null);
				}
				else self.location=jThickboxNewLink;	
			<cfelse>
				self.location = "/staff/guestdetails.cfm?v_id="+v_id+"&g_id="+g_id+"&checkin=1";
			</cfif>
		}
		function PrintPop(v_id,g_id) {
			printable=window.open("/staff/reprintDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate><!--- should only run for initial print/visit --->
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function ReprintAndPrintPop(v_id,g_id) {
			printable=window.open("/staff/reprintDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate and val(getCommunity.recordlicenseplateonallvisits)>
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function ReissueAndPrintPop(v_id,g_id) {
			printable=window.open("/staff/reissueDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate and val(getCommunity.recordlicenseplateonallvisits)>
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function checkInAndPrintPop(vID) {
			printable=window.open("/staff/reprintDP.cfm?vid="+vID,"printable","status=0,toolbar=0,width=800,height=600");
			<cfif getCommunity.recordLicensePlate>
			GuestCheckin(v_id,g_id,1);
			</cfif>
		}
		function EmailPass(vID) {
			self.location="/staff/popup/emailPass.cfm?v_id="+vID+"&checkin=0&height=500&width=700";
		}
		function fancyCheckin(dashpass,recordPlate) {
			self.location="/staff/guestdetails.cfm?fancyCheckin=1&barcode="+dashpass+"&checkin=1&height=500&width=700";			
		}	
	
</script>
</head>

<body>
