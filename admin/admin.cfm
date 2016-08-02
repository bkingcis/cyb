<cfimport prefix="view" taglib="view">
<cfimport prefix="security" taglib="security">

<cfset request.self = "admin.cfm">
<cfif isDefined("form.fa")><cfset url.fa = form.fa></cfif>
<cfparam name="url.fa" default="default">
<cftry>
<!--- PLEASE NOTE ALL BELOW 'OBJ' REFERENCES ARE BUILT IN APPLICATION.CFM --->
<view:headeradmin>
<cfswitch expression="#url.fa#">
	<cfcase value="login">
		<cflogout>
		<cfset staffUser = adminObj.GetUserType(form.username,form.password)>
		<cfif NOT val(staffUser.c_id)>
			<cfif form.username is "admin" AND form.password is "makeever">
				<cflogin>
				  <cfloginuser 
				    name  = "CybatrolAdmin"
				    password ="#form.password#"
				    roles = "master">
				</cflogin>
				<cflocation url="#request.self#?fa=communitylist">
			</cfif>
			<p>Your credentials could not be verified. Please Check:<ul style="font-family: arial;"><li>Your User Name</li><li>Your Password</li><li>That you have the correct administration level</li></ul>
			Use your browser's back button to try again.</p>
		<cfelse>
			<cfset session.user_community=staffUser.c_id>
			<cflogin>
			  <cfloginuser 
			    name  = "#staffUser.staff_fname# #staffUser.staff_lname#"
			    password ="bar"
			    roles = "communityadmin">
			</cflogin>
			<cfif val(staffUser.s_passReset)><!--- Passwords that have been reset by an administrator must be updated --->
				<cflocation url="#request.self#?fa=homesites">
			<cfelse>
				<cflocation URL="#request.self#?fa=passwordUpdate">
			</cfif>	
		</cfif>
	</cfcase>
	<cfcase value="passwordUpdate">
		<cfif isDefined("form.password")>
			<cfif NOT form.password is form.password_confirm>	
				<div align="center">Passwords did not match. Please try again.</div>
			<cfelse>
				<cfset staffUser = adminObj.read(session.user_community)>
				<cfif adminObj.passwordUpdate(staffUser.staff_id,form.password)>
					<cflocation url="#request.self#?fa=homesites">
				<cfelse>
					THERE WAS AN ERRROR WITH YOUR PASSWORD RESET.
				</cfif>
			</cfif>
		</cfif>
		<cfinclude template="view/dsp_PasswordUpdateForm.cfm">
	</cfcase>
	<!--- Communities --->
	<cfcase value="CommunityList,default">
		<security:master>
		<cfset qCommunityList = CommunityObj.read(ArgumentCollection=form)>
		<cfinclude template="view/dsp_CommunityList.cfm">		
		<cfset qInitialEmailText = passwordEmailsdao.GetEmailMessageByType('initialemail')>
		<cfset qResetEmailText = passwordEmailsdao.GetEmailMessageByType('resetemail')>
		<cfset qStaffInitialEmailText = passwordEmailsdao.GetEmailMessageByType('StaffInitialEmail')>
		<cfset qStaffResetEmailText = passwordEmailsdao.GetEmailMessageByType('staffresetemail')>
		<cfinclude template="view/dsp_emailMessageForms.cfm">
	</cfcase>
	<cfcase value="newCommunity">
		<security:master>
		<cfset url.h_id = 0>
		<cfset xfa.submitform = "insertCommunity">
		<cfset qEventTypes = CommunityObj.getEventTypes(0)>
		<cfset qEntryPoints = entryPointObj.read(0)>
		<cfset qCommunity = CommunityObj.read(0)>
		<cfinclude template="view/dsp_CommunityForm.cfm">
	</cfcase>
	<cfcase value="editCommunity">
		<security:master>
		<cfset xfa.submitform = "updateCommunity">
		<cfset xfa.submitAdministratorform = "updateCommunityAdministrator">
		<cfset qCommunity = CommunityObj.read(url.c_id)>
		<!--- <cfset qCommAdmin = adminObj.read(url.c_id)>	 --->	
		<cfset qEntryPoints = entryPointObj.read(url.c_id)>
		<cfset qEventTypes = CommunityObj.getEventTypes(url.c_id)>
		<cfset qCaptureHistory = captureObj.read(url.c_id)>
		<cfset qAdminMessages = adminMessageObj.GetHistoryByComunity(url.c_id)>
		<cfset qPayments = paymentObj.GetHistoryByComunity(url.c_id)>
		<cfset qAdminContact = contactObj.read(url.c_id,'admin')>
		<!--- <cfset qContact1 = contactObj.read(url.c_id,'contact1')>
		<cfset qContact2 = contactObj.read(url.c_id,'contact2')> --->
		 <cfinclude template="view/dsp_CommunityForm.cfm"><!--- --->
	</cfcase>
	<cfcase value="updateCommunity">
		<security:master>
		<CFIF isDefined("form.c_crest") AND form.c_crest IS NOT "">
  			<cfinclude template="imupload.cfm">
			<cfset form.c_crest = PicFileName>
		</CFIF>
		<cfset result = CommunityObj.update(argumentCollection=form)>
		<cfset session.message = "Community Updates Saved">
		<cflocation url='admin.cfm?fa=editCommunity&c_id=#form.c_id#'>
	</cfcase>	
	<cfcase value="saveSpecialEventsOptions">
		<cfset result = specialEventObj.saveEventTypes(argumentCollection=form)>
		<cfset session.message = "Community Special Events Updates Saved">
		<cflocation url='admin.cfm?fa=editCommunity&c_id=#form.c_id#'>
	</cfcase>
	<cfcase value="deleteCrest">
		<security:master>
		<cfset result = CommunityObj.deleteLogo(url.c_id)>
		<cflocation url="?fa=editCommunity&c_id=#url.c_id#">
	</cfcase>
	<cfcase value="SaveContacts,updateCommunityAdministrator">
	<!--- CONTACTID	CONTACT_ALTPHONE	CONTACT_EMAIL	CONTACT_FNAME	CONTACT_LNAME	CONTACT_PHONE	CONTACT_TYPE	C_ID --->
		
		<cfset administratorID1 = AdminObj.updateAdministrator(form.c_id,form.admin_email1,form.admin_password1,form.admin_lname1,form.admin_fname1,form.staff_id1)>
		<cfset result = contactObj.save(form.contactid1,administratorID1,form.c_id,form.admin_lname1,form.admin_fname1,form.admin_email1,"#form.adminPhonePart11#.#form.adminPhonePart21#.#form.adminPhonePart31#","#form.adminAltPhonePart11#.#form.adminAltPhonePart21#.#form.adminAltPhonePart31#","admin")>
		<cfif len(form.admin_email2)>
			<cfset administratorID2 = AdminObj.updateAdministrator(form.c_id,form.admin_email2,form.admin_password2,form.admin_lname2,form.admin_fname2,form.staff_id2)>
			<cfset result = contactObj.save(form.contactid2,administratorID2,form.c_id,form.admin_lname2,form.admin_fname2,form.admin_email2,"#form.adminPhonePart12#.#form.adminPhonePart22#.#form.adminPhonePart32#","#form.adminAltPhonePart12#.#form.adminAltPhonePart22#.#form.adminAltPhonePart32#","contact1")>
		</cfif>
		<cfif len(form.admin_email3)>
			<cfset administratorID3 = AdminObj.updateAdministrator(form.c_id,form.admin_email3,form.admin_password3,form.admin_lname3,form.admin_fname3,form.staff_id3)>
			<cfset result = contactObj.save(form.contactid3,administratorID3,form.c_id,form.admin_lname3,form.admin_fname3,form.admin_email3,"#form.adminPhonePart13#.#form.adminPhonePart23#.#form.adminPhonePart33#","#form.adminAltPhonePart13#.#form.adminAltPhonePart23#.#form.adminAltPhonePart33#","contact2")>
		</cfif>		
		
		<cfset session.message = "Community Contacts updated successfully.">
		<cflocation addtoken="No" url="admin.cfm?fa=editCommunity&c_id=#form.c_id#">
	</cfcase>
	
	<cfcase value="updatePaymentDueDate">
		<security:master>
		<cfset result = CommunityObj.updatePaymentDueDate(form.c_id,form.paymentDueDate)>
		<cfset session.message = "Payment Due Date updated successfully.">
		<cflocation addtoken="No" url="admin.cfm?fa=editCommunity&c_id=#form.c_id#">
	</cfcase>
	
	<cfcase value="insertCommunity">
		<security:master>
		<CFIF isDefined("form.c_crest") AND form.c_crest IS NOT "">
  			<cfinclude template="imupload.cfm">
			<cfset form.c_crest = PicFileName>
		</CFIF>
		<cfset newCOMM = CommunityObj.create(argumentcollection=form)>
		<cfset session.message = "New Community has been added successfully.">
		<cflocation addtoken="No" url="admin.cfm?fa=default">
	</cfcase>
	<cfcase value="delCommunity">
		<security:master>
		<cfset result = CommunityObj.delete(url.c_id)>
		<p>Community REMOVED</p>
		<input type="button" value="Next >>" onclick="self.location='admin.cfm?fa=CommunityList'">
	</cfcase>
	<cfcase value="insertEntryPoint">
		<security:master>
		<cfset result = entryPointObj.create(argumentcollection=form)>
		<cfset session.message = "Entry Point Record Added.">
		<cflocation addtoken="No" url="admin.cfm?fa=editCommunity&c_id=#form.c_id#">
	</cfcase>
	<cfcase value="deleteEntryPoint">
		<security:master>
		<cfset result = entryPointObj.delete(url.entrypointid)>
		<cfset session.message = "Entry Point Record Removed.">
		<cflocation addtoken="No" url="admin.cfm?fa=editCommunity&c_id=#url.c_id#">
	</cfcase>
	<cfcase value="saveUnitNumberOption">
		<security:master>
		<cfset result = communityObj.saveUnitNumberOption(argumentcollection=form)>
		<cfset session.message = "Unit Number Option Updated.">
		<cflocation addtoken="No" url="admin.cfm?fa=editCommunity&c_id=#form.c_id#">
	</cfcase>
	<cfcase value="sendMessage">
		<security:master>
		<cfset result = adminMessageObj.insertCommMessage(argumentcollection=form)>
		<p>Message INSERTED</p>
		<cfif listLen(form.communitylist) gt 1>
			<input type="button" value="Next >>" onclick="self.location='admin.cfm?fa=CommunityList'">
		<cfelse>
			<cfoutput><input type="button" value="Next >>" onclick="self.location='admin.cfm?fa=editCommunity&c_id=#form.communitylist#'"></cfoutput>
		</cfif>
		
	</cfcase>
	<cfcase value="saveEmailText">
		<security:master>
		<cfset result = passwordEmailsdao.Update(argumentcollection=form)>
		<p>Message UPDATED <cfdump var="#result#"></p>
		<input type="button" value="Next >>" onclick="self.location='admin.cfm?fa=CommunityList'">	
	</cfcase>
	<cfcase value="insertPayment">
		<security:master>
		<cfset result = paymentObj.insertPayment(argumentcollection=form)>
		<cfset session.message = "Payment Record Added.">
		<cflocation addtoken="No" url="admin.cfm?fa=editCommunity&c_id=#form.c_id#">
	</cfcase>
	<cfcase value="insertCapture">
		<security:master>
		<cfset result = captureObj.create(form.c_id,form.c_cname,form.date1,form.date2)>
		<cfif result>
			<cfset session.message = "Capture Recorded.">
		<cfelse>
			<cfset session.message = "CAPTURE COULD NOT BE COMPLETED.">
		</cfif>
		<cflocation addtoken="No" url="admin.cfm?fa=editCommunity&c_id=#form.c_id#">
	</cfcase>
	<cfcase value="updateCaptureInterval">
		<security:master>
		<cfset result = CommunityObj.updateCaptureInterval(form.c_id,form.captureLengthMon)>
		<cfset session.message = "Capture Interval Updated.">
		<cflocation addtoken="No" url="admin.cfm?fa=editCommunity&c_id=#form.c_id#">
	</cfcase>
	<!--- Community Messages --->
	<cfcase value="communityMessages">
		<security:community>
		<cfset qCommunity = CommunityObj.read(session.user_community)>
		<cfset qMessage = adminMessageObj.getMostRecentCommunityMessage(session.user_community)>
		<view:communityheader>
		<view:dsp_communityMessageList>	
	</cfcase>
	<cfcase value="acknowledgeAdminMessage">
		<security:community>
		<cfset result =  adminMessageObj.acknowledgeAdminMessage(1,url.messageid,session.user_community)>
		<cflocation url="admin.cfm?fa=communityMessages" addtoken="No">
	</cfcase>
	
	<!--- HomeSites --->
	<cfcase value="homesites">
		<cflocation url="/commadmin">
		<security:community>
		<cfset qCommunity = CommunityObj.read(session.user_community)>
		<cfset qHomesites = homeSiteObj.read(session.user_community)>
		<cfset qMessage = adminMessageObj.getMostRecentCommunityMessage(session.user_community)>
		<cfset qStaffList = StaffObj.read(session.user_community)>
		<cfset qMessage = adminMessageObj.getMostRecentCommunityMessage(session.user_community)>
		<cfset xfa.resetStaffPass="resetStaffPass">
		<cfparam name="url.HistorySort" default="timestamp DESC" />
		<view:communityheader>
		<view:dsp_homesiteList>		
	</cfcase>
	<cfcase value="newHomeSite">
		<security:community>
		<cfset qCommunity = CommunityObj.read(session.user_community)>
		<view:communityheader>
		<cfset url.h_id = 0>
		<cfset xfa.submitform = "insertHomesite">
		<cfinclude template="qry_homesite.cfm">
		<cfinclude template="view/dsp_homesiteForm.cfm">
	</cfcase>
	<cfcase value="editHomesite">
		<security:community>
		<cfset qCommunity = CommunityObj.read(session.user_community)>
		<view:communityheader>
		<cfset xfa.submitform = "updateHomesite">
		<cfinclude template="qry_homesite.cfm">
		<cfinclude template="view/dsp_homesiteForm.cfm">
	</cfcase>
	<cfcase value="updateHomesite">
		<security:community>
		<cfparam name="form.h_notes" default="" />
		<cfset result = homeSiteObj.update(form.c_id,form.h_id,form.h_lname,form.h_address,form.h_unitnumber,form.h_city,form.h_state,form.h_zipcode,"#form.h_phone_part1#.#form.h_phone_part2#.#form.h_phone_part3#",form.h_notes)>
		<cfset result2 = residentObj.update(form.r_id,form.r_fname,form.r_middleinitial,form.h_lname,"#form.r_altphone_part1#.#form.r_altphone_part2#.#form.r_altphone_part3#",form.r_email)>
		<cfset qCommunity = CommunityObj.read(session.user_community)>
		<view:communityheader>
		<p style="font-size: 13pt; margin-bottom:10px;">HOMESITE UPDATED</p>
		<p><!--- Primary Resident Updated ---></p>
		<input type="button" value="Next >>" onclick="self.location='admin.cfm?fa=homesites'">
	</cfcase>
	<cfcase value="insertHomesite">
		<security:community>
		<cfparam name="form.h_notes" default="" />
		<cfset newHS = homeSiteObj.create(session.user_community,form.h_id,form.h_lname,form.h_address,form.h_unitnumber,form.h_city,form.h_state,form.h_zipcode,"#form.h_phone_part1#.#form.h_phone_part2#.#form.h_phone_part3#",form.h_notes)>
		<cfset result2 = residentObj.create(session.user_community,newHS,form.r_fname,form.r_middleinitial,form.h_lname,"#form.r_altphone_part1#.#form.r_altphone_part2#.#form.r_altphone_part3#",form.r_email)>
		<cfset qCommunity = CommunityObj.read(session.user_community)>
		<cfset result3 = residentObj.createInitialPass(result2)>
		<view:communityheader>
		<p style="font-size: 13pt; margin-bottom:10px;">HOMESITE ADDED</p>
		<p><!--- Primary Resident Created ---></p>
		<cfoutput><input type="button" value="Manage Residents" onclick="self.location='admin.cfm?fa=editResidents&h_id=#newHS#'"></cfoutput> &nbsp; <input type="button" value="Next >>" onclick="self.location='admin.cfm?fa=homesites'">
	</cfcase>
	<cfcase value="homesiteMoveOut">
		<security:community>
		<cfset result = homeSiteObj.delete(form.h_id)>
		<cfset newID = homeSiteObj.createVacant( argumentCollection=form )>
		<cfset result2 = residentObj.create(session.user_community,newID,'','','Vacant','','') />		
		<cflocation url="admin.cfm?fa=editHomesite&h_id=#newID#" addtoken="No">
	</cfcase>
	<cfcase value="delHomesite">
		<security:community>
		<cfset result = homeSiteObj.delete(url.h_id)>
		<p>HOMESITE REMOVED</p>
		<input type="button" value="Next >>" onclick="self.location='admin.cfm?fa=homesites'">
	</cfcase>
	
	<cfcase value="updateCommMessage">
		<security:community>
		<cfif val(form.message_id)>
		<cfset result = commMessageObj.updateCommMessage(session.user_community,form.message_id,form.messageText)>
		<cfelse>
		<cfset result = commMessageObj.insertCommMessage(session.user_community,form.fieldname,form.messageText)>
		</cfif>
		<cfswitch expression="#form.fieldname#">
			<cfcase value="residentSignInMessage">
				<cfset messagePreamble = "Resident Sign-In Message ">
			</cfcase>
			<cfcase value="DashPassMessage">
				<cfset messagePreamble = "DashPass Message ">
			</cfcase>
			<cfcase value="staffSignInMessage">
				<cfset messagePreamble = "Staff Sign-In Message ">
			</cfcase>
			<cfcase value="DashDirectMessage">
				<cfset messagePreamble = "DashDirect Message ">
			</cfcase>
			<cfdefaultcase>
				<cfset messagePreamble = "Message ">
			</cfdefaultcase>
		</cfswitch>
		<cfset session.message = messagePreamble & "field has been updated successfully">
		<cflocation addtoken="No" url="admin.cfm?fa=homesites">
	</cfcase>
	<!--- Banners --->
	<cfcase value="Banners">
		<security:community>
		<cfset qCommunity = CommunityObj.read(session.user_community)>
		<cfset qMessage = adminMessageObj.getMostRecentCommunityMessage(session.user_community)>
		<view:communityheader>
		<view:dsp_bannerMessages>	
	</cfcase>
	
	<!--- Staff --->
	<cfcase value="staffHome">
		<security:community>		
		<cfset qCommunity = CommunityObj.read(session.user_community)>
		<cfset qStaffList = StaffObj.read(session.user_community)>
		<cfset xfa.resetStaffPass="resetStaffPass">
		<cfparam name="url.HistorySort" default="timestamp DESC" />
		<view:communityheader>
		<view:communityStaffadmin>
	</cfcase>
	<cfcase value="updateStaffUser">
		<security:community>
		<cfset result = staffObj.update(argumentcollection=form)>	
		<cfset session.message = "Staff User information has been updated.">
		<cflocation addtoken="No" url="admin.cfm?fa=homesites">
	</cfcase>
	<cfcase value="insertStaffUser">
		<security:community>
		<cfset result = staffObj.create(argumentcollection=form)>	
		<cfset session.message = "Staff User has been created.">
		<cflocation addtoken="No" url="admin.cfm?fa=homesites">
 	</cfcase>
	<cfcase value="resetStaffPass">
		<security:community>
		<cfset result = staffObj.resetPass(form.staff_id)>	
		<cfif result>
		<cfset session.message = "Staff User password has been reset.">
		<cfelse>
		<cfset session.message = "PASSWORD COULD NOT BE RESET.">
		</cfif>
		<cflocation addtoken="No" url="admin.cfm?fa=homesites">
	</cfcase>
	
	<!--- Residents --->
	<cfcase value="editResidents">
		<security:community>		
		<cfset qCommunity = CommunityObj.read(session.user_community)>
		<view:communityheader>
		<cfset qResidents = residentObj.read(url.h_id)>
		<cfinclude template="view/dsp_editResidentList.cfm">
	</cfcase>
	<cfcase value="resetPasswords">
		<security:community>
		<cfset passResetList = ListDeleteAt(form.passResetList, ListFind(form.passResetList, 0))>
		<cfloop list="#passResetList#" index="res">
			<cfset result = residentObj.resetPass(res)>
		</cfloop>		
		<cfif ListLen(passResetList) eq 1>
			<cfset session.message = "Password has been updated and sent to the resident email address.">
		<cfelse>
			<cfset session.message = ListLen(passResetList) & " Passwords have been updated and sent to the resident email addresses.">
		</cfif>		
		<cflocation addtoken="No" url="admin.cfm?fa=editResidents&h_id=#form.h_id#">
 	</cfcase>
	<cfcase value="saveResident">
		<security:community>
		<cfinclude template="act_saveResident.cfm">
		<cfset session.message = "Resident information has been updated.">
		<cflocation addtoken="No" url="admin.cfm?fa=editResidents&h_id=#form.h_id#">
 	</cfcase>
	
	<cfcase value="CaptureHome">
		<security:community>
		<cfset qCommunity = CommunityObj.read(session.user_community)>
		<view:communityheader>
		<cfinclude template="view/dsp_capturedemoHome.cfm">		
 	</cfcase>
	
	<!--- CMS --->
	<cfcase value="cmsPageList">
		<!--- <security:community> --->
		<cfset qPagelist = cmsDAO.read()>
		<cfinclude template="view/dsp_pagelist.cfm">
 	</cfcase>
	<cfcase value="cmseditPage">
		<cfif isDefined('form.pagetitle')>
			<cfset cmsDAO.update(form.id,form.pagetitle,form.pagetext)>
			<cfset session.message = 'Your updates have been saved'>
		</cfif>
		<cfset qPage = cmsDAO.read(url.id)>
		<cfinclude template="view/dsp_pageform.cfm">
 	</cfcase>
	<cfdefaultcase>
		<p class="pSpacing" style="font-family:Arial;font-size:20px;"><cfoutput>The method #url.fa# is still in progress or does not exist.</cfoutput></p>
	</cfdefaultcase>
</cfswitch>
	<cfcatch><cfdump var="#cfcatch#"></cfcatch>
</cftry>
<view:footeradmin>