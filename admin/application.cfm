<cfapplication
	name="Admin"
	sessionmanagement="Yes"
	sessiontimeout="#CreateTimeSpan(0,0,45,0)#"
	clientmanagement="Yes"><!--- 45 --->
	<!--- loginstorage="session" --->
	
<cfset request.dsn = "cybatrol">
<cfset request.self = "error">

<cfset application.appInitialized = 0><!--- remove this when we go live --->

<cfif NOT isDefined("application.appInitialized") OR NOT application.appInitialized>
	<cfscript>
		application.adminObj = createObject( 'component', 'admin.model.admin' );
		application.CommunityObj = createObject( 'component', 'admin.model.community' );
		application.adminMessageObj = createObject( 'component', 'admin.model.adminMessage' );
		application.homeSiteObj = createObject( 'component', 'admin.model.homesite' );
		application.residentObj = createObject( 'component', 'admin.model.resident' );
		application.commMessageObj = createObject( 'component', 'admin.model.commMessage' );
		application.paymentObj = createObject( 'component', 'admin.model.payment' );
		application.captureObj = createObject( 'component', 'admin.model.capture' );
		application.contactObj = createObject( 'component', 'admin.model.contact' );
		application.specialEventObj = createObject( 'component', 'admin.model.specialEvent' ); 
		application.CommunityObj = createObject( 'component', 'admin.model.community' );
		application.entryPointObj = createObject( 'component', 'admin.model.entrypoint' );
		application.passwordEmailsdao = createObject( 'component', 'admin.model.passwordEmails' );
		application.staffObj = createObject( 'component', 'admin.model.staff' );//this must be after the passwordEmailsDao
		application.cmsDAO = createObject( 'component', 'admin.model.pages' );
		application.appInitialized = true;		
	</cfscript>
</cfif> 
<cfscript>
	adminObj = application.adminObj;
	CommunityObj = application.CommunityObj;
	adminMessageObj = application.adminMessageObj;
	homeSiteObj = application.homeSiteObj;
	residentObj = application.residentObj;
	commMessageObj = application.commMessageObj;
	paymentObj = application.paymentObj;
	staffObj = application.staffObj;
	captureObj = application.captureObj;
	contactObj = application.contactObj;
	specialEventObj = application.specialEventObj;
	entryPointObj = application.entryPointObj;
	passwordEmailsdao = application.passwordEmailsdao;
	cmsDAO = application.cmsDAO;
</cfscript>

<cfif isDefined("form.fuseaction")><cfset url.fa = form.fuseaction></cfif>