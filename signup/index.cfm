<cftry>
<cfparam name="action" default="instruction">
<cfset request.dsn = 'cybatrol'>
<cfsavecontent variable="content_var">
<cfif NOT structKeyExists(session,"signup")><cfset session.signup = structNew()></cfif>
<cfinclude template="inc/act_saveFormToSession.cfm">
<cfset H1pagetitle = "Set Up Account:">
<style>
	::-webkit-input-placeholder {
   font-style: italic;
}
:-moz-placeholder {
   font-style: italic;  
}
::-moz-placeholder {
   font-style: italic;  
}
:-ms-input-placeholder {  
   font-style: italic; 
}
</style>

<cfswitch expression="#action#">
	<cfcase value="instruction">
		<cfset H2pagetitle = "Interactive Visitor Management System">
		<cfset h1pageTitle = "New Client Set-up - Free 30 day trial">
		<cfset xfa.submit = 'property_type_form'><!--- step1_view --->
		<cfinclude template="inc/dsp_instruction.cfm">
	</cfcase>
	<cfcase value="commDetails_view">
		<cfset H1pagetitle = "Account Details">
		<cfset xfa.submit = 'step9_view'><!--- property_type_form --->
		<cfinclude template="inc/dsp_commDetails.cfm">
	</cfcase>
	<cfcase value="property_type_form">
		<cfset H1pagetitle = "Community Details <small>(PROPERTY TYPE)</small>">
		<cfset xfa.submit = 'step2_view'>
		<cfinclude template="inc/dsp_propertytype_form.cfm">
	</cfcase>
	<cfcase value="timezone_form">
		<cfset H1pagetitle = "Verify Community Timezone:">
		<cfset xfa.submit = 'step2_view'>
		<cfinclude template="inc/dsp_timezone_form.cfm">
	</cfcase>
	<cfcase value="step2_view">
		<cfinclude template="inc/act_mailBillSession.cfm">
		<cfset H1pagetitle = 'Community Details <small>(ENTRY ACCESS POINTS)</small>'>
		<cfset xfa.submit = 'step3_view'>
		<cfinclude template="inc/dsp_numOfEntryPoints.cfm">
	</cfcase>
	<cfcase value="step3_view">
		<cfset H1pagetitle = "Community Details <small>(ENTRY ACCESS POINTS)</small>">
		<cfset xfa.submit = 'step4_view'>
		<cfinclude template="inc/dsp_nameEntryPoints.cfm">
	</cfcase>
	<cfcase value="step4_view">
		<cfset H1pagetitle = "Customize Services <small>(OPEN/UNRESTRICTED ACCESS)</small>">
		<cfset xfa.submit = 'step5_view'>
		<cfinclude template="inc/dsp_247Option.cfm">
	</cfcase>
	<cfcase value="step5_view">
		<cfset H1pagetitle = "Customize Services <small>(SPECIAL EVENTS)</small>">
		<cfset xfa.submit = 'step6_view'>
		<cfinclude template="inc/dsp_EventTypesEntry.cfm">
	</cfcase>
	<cfcase value="step6_view"><!--- parcel/package dropoff --->
		<cfset H1pagetitle = "Customize Services <small>(PACKAGE DELIVERY)</small>">
		<cfset xfa.submit = 'maintenance_view'>
		<cfinclude template="inc/dsp_ParcelDropOption.cfm">
	</cfcase>
	<cfcase value="maintenance_view"><!--- Maintenance Requests --->
		<cfset H1pagetitle = "Customize Services <small>(MAINTENANCE REQUESTS)</small>">
		<cfset xfa.submit = 'step7_view'>
		<cfinclude template="inc/dsp_MaintRequestsOption.cfm">
	</cfcase>
	<cfcase value="step7_view">
		<cfset H1pagetitle = "Customize Services <small>(RECORD LICENSE PLATES)</small>">
		<cfset xfa.submit = 'step8_view'>
		<cfinclude template="inc/dsp_RecordLicensePlates.cfm">
	</cfcase>
	<cfcase value="step8_view">
		<cfset H1pagetitle = "Customize Services <small>(DASHPASS)</small>">
		<cfset xfa.submit = 'commDetails_view'>
		<cfinclude template="inc/dsp_DashPassOption.cfm">
	</cfcase>
	<cfcase value="step9_view"><!--- payment, terms and privacy --->
		<cfset H1pagetitle = "Customize Services <small>(Payment)</small>">
		<cfset xfa.submit = 'createCommunity'>
		<cfinclude template="inc/dsp_paymentAndTerms.cfm">
	</cfcase>
	<cfcase value="createCommunity"><!--- create --->
		<cfset xfa.submit = "step11A_view">
		<cfinclude template="inc/act_createCommunity.cfm">
		<cfinclude template="inc/act_createStaffAdmin.cfm">
		<cfinclude template="inc/act_newSignupNotification.cfm">
		
		<cfset session.new_community_name = session.signup.c_name>
		<cfset session.new_community_admin = session.signup.F_NAME & ' ' & session.signup.L_NAME>
		<cfset session.new_community_id = session.c_id>
		<cfset session.new_community_email = session.signup.email>
		
		<cfset session.signup = structNew()>
		<cflocation url="index.cfm?action=congrats" addtoken="false">
	</cfcase>
	<cfcase value="step11_view">
		<cfset h1pagetitle = 'Resident/Personnel Information'>
		<cfset xfa.submit = 'congrats'>
		<cfinclude template="inc/dsp_step10.cfm">
	</cfcase>
	<cfcase value="congrats">
		<cfset h1pagetitle = 'Congratulations'>
		<cfset h2pagetitle = 'Congratulations!!'>
		<cfinclude template="inc/dsp_congrats.cfm">
	</cfcase>
	<cfcase value="addResidents_view">
		<cfset H1pagetitle = "Set Up Your Account - Upload Your Residents With a File:">
		<cfset xfa.submit = 'saveUpload'>
		<cfinclude template="inc/dsp_resUploadForm.cfm">
	</cfcase>
	<cfcase value="saveUpload">
		<cfset H1pagetitle = "Set Up Your Account - Upload Your Residents With a File:">
		<cfset xfa.submit = 'processUpload'>
		<cfinclude template="inc/act_uploadResList.cfm">
		<cfif doProcess is 'xls'>
			<cfinclude template="inc/act_XLS2Query.cfm">
		<cfinclude template="inc/dsp_viewUpload.cfm">
		<cfelseif doProcess is 'csv'>
			<cfinclude template="inc/act_CSV2Query.cfm">
		<cfinclude template="inc/dsp_viewUpload.cfm">
		</cfif>
	</cfcase>
	<cfcase value="processUpload">
		<cfset H1pagetitle = "Set Up Your Account - THIS STEP STILL In Progress...:">
		<cfinclude template="inc/act_processBulkResUpload.cfm">
	</cfcase>
	<cfcase value="step12A_view"><!--- Assisted --->
		<cfset xfa.submit = 'step11A_view'>
		<cfinclude template="inc/dsp_AssistedResidentUpload.cfm">
	</cfcase>
	<cfcase value="step11B_view"><!--- Manual --->
		<cfset xfa.submit = 'step11A_view'>
		<cfinclude template="inc/dsp_ManualResidentUpload.cfm">
	</cfcase>
	<cfdefaultcase>
		<cfoutput><p>Action #action# not found.</p></cfoutput>
	</cfdefaultcase>
</cfswitch>
<!--- <cfdump var="#session.signup#"> --->
</cfsavecontent>
<cfinclude template="inc/lay_signup.cfm">
<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>