<cfinclude template="include/header_bootstrap.cfm">
<div class="container">
<cfinclude template="include/residentsinfo.cfm">
<style>
	.cal>tbody>tr>td {
	 padding-right:10px;
	 vertical-align: text-top;
	}
</style>
	<div class="jumbotron">
	  <div class="container">
		<cfoutput>
	  <h3>#getCommunity.c_name#</h3>
		<span><!-- Managing: --> #getResident.h_address# <small><!-- <a href="chooseLocation.cfm">change</a>--></small> 
		(#GetResident.r_fname# #GetResident.r_lname#)</span>
		<cfif !Len(getResident.h_address)>
			<cfdump var="#getResident#">
			<cfabort>
		</cfif>
		
		</cfoutput>
		<!-- <p>IVAS: Interactive Visitor Announcement System</p> -->
		<cfinclude template="include/communityMessage.cfm">	
		<cfinclude template="include/overlapMessage.cfm">
		<cfinclude template="include/parcelAlert.cfm">
		<hr />
		<cfinclude template="include/visitorJumpTo.cfm">
		<div class="row">
			<div class="col-sm-10 col-md-offset-1 col-md-10 col-lg-9 col-lg-offset-2" style="overflow:auto;">
			<cftry>
				<table class="cal">
					<tr>
						<td style="padding-left:8px;"><cf_cal month="#month(request.timezoneadjustednow)#" r_id="#session.user_id#"></td>
						<td><cf_cal month="#month(request.timezoneadjustednow)+1#" r_id="#session.user_id#"></td>	
						<td><cf_cal month="#month(request.timezoneadjustednow)+2#" r_id="#session.user_id#"></td>	
						<td><cf_cal month="#month(request.timezoneadjustednow)+3#" r_id="#session.user_id#"></td>
					</tr>
				</table>
			<cfcatch><cfdump var="#cfcatch#"></cfcatch></cftry>
			</div>
		</div>
		
		<p class="text-center">
			<span style="font-size: 10pt">	<b class="calGuestBox " style="font-size:11pt;">&nbsp; &nbsp; </b> &nbsp; <cfoutput>#labels.visitor#</cfoutput> Expected  &nbsp; 
				<cfif qEventTypes.recordcount>
					<b class="calEventBox" style="font-size:11pt;">&nbsp; &nbsp; </b> &nbsp; <cfoutput>#labels.special_event#</cfoutput>
				</cfif>
			</small>
		</p>
			
		<cfinclude template="actionlist.cfm">
		<!--- <cfinclude template="actionlist2.cfm"> --->
		</div>
	</div> <!-- // end jumbotron // -->
	<!---<cfoutput>
	
		<div class="row">
			<div class="col-sm-6 col-md-4">
			   <div class="panel panel-primary">
				  <div class="panel-heading"><i class="glyphicon glyphicon-info-sign"></i> Resident Opinions: </div>
				  <div class="panel-body">
					<cfif qBB.recordcount>
						<cfloop query="qBB">
							#qBB.label#
							<p>
								<cftry>#qBB.r_fname# #left(qBB.r_lname,1)#<cfcatch><cfdump var="#cfcatch#"></cfcatch></cftry>
								<cfif dateCompare(dateAdd('d',-1,now()),qBB.insertdate) eq 0>
									<em>#timeFormat(qBB.insertdate)#</em>
								<cfelse>
									<em>#dateFormat(qBB.insertdate,'m/d/yyyy')#</em>
								</cfif>
							</p>
						</cfloop>
					<cfelse>
						<strong>** No Comments Posted **</strong>
					</cfif>
				   </div>
				</div>
			</div>
			<div class="col-sm-6 col-md-4">
			  <div class="panel panel-primary">
				  <div class="panel-heading">Market Place:</div>
				  <div class="panel-body">
					<ul>
						<li>All Classifieds (#getPostingCount()#)</li>
						<li>Real Estate (#getPostingCount(1)#)</li>
						<li>Vehicles (#getPostingCount(2)#)</li>
						<li>Pets (#getPostingCount(3)#)</li>
						<li>Services (#getPostingCount(5)#)</li>
						<li>Jobs/Empolyment (#getPostingCount(6)#)</li>
						<li>Other (#getPostingCount(4)#)</li>
					</ul>
				 </div>
			  </div>
			</div>
		</div>
</cfoutput>--->
<cfinclude template="include/footer.cfm">

<cffunction name="getPostingCount" output="false">
	<cfargument name="category_id" required="no" />
	<cfquery datasource="#request.dsn#" name="qBB">
		select count(bb.bbid) as counter
		from residentBB bb join residents r on bb.r_id = r.r_id
		join communities c on c.c_id = r.c_id
		where 	
		<cfif isDefined('arguments.category_id')>category_id = <cfqueryparam value="#val(arguments.category_id)#" cfsqltype="CF_SQL_INTEGER" /><cfelse>category_id <> 99</cfif>
	</cfquery>
	<cfreturn qBB.counter />
</cffunction>

<script>
$(function(){
//to improve performance baseModal selector is set to a variable
var $baseModal = $('#baseModal');
var $headerModal = $('#headerModal');
	
	$baseModal.on('hidden.bs.modal', function () {	  
	  location.reload();
	});
	$headerModal.on('hidden.bs.modal', function () {	  
	  location.reload();
	});
	
	$('#headerModal').on('show.bs.modal', function (event) {
	  var button = $(event.relatedTarget) // Button that triggered the modal
	  var action = button.data('action') // Extract info from data-* attributes  
	  var modal = $(this)
	  var myTitle = '';
	  var myContent = 'Not loaded';
	  
	   switch(action) {
		case 'settings':
			modal.find('.modal-title').text('<cfoutput>#labels.other_users#</cfoutput>');
			$.get("popup/account.cfm", function(data, status){
				modal.find('.modal-body').html(data);
				modal.find('#btnContinue').hide(); 	  
			},"html");
			break;
		case 'maintenance':
			modal.find('.modal-title').text('<cfoutput>#labels.communications#</cfoutput>');
			$.get("popup/maintenance.cfm", function(data, status){
				modal.find('.modal-body').html(data);
				modal.find('#btnContinue').hide(); 	  
			},"html");
			break;
		case 'notifications':
			modal.find('.modal-title').text('Notifications');
			//hideSubmitBtn(modal);
			//hideBackBtn(modal);
			$.get("popup/notifications.cfm", function(data, status){
				modal.find('.modal-body').html(data);
			},"html");
			break;
		default:
		   modal.find('.modal-title').text('Other Action:' + action);
		   alert('action not found');
		   hideBackBtn(modal);
		   //console.log(button.html());
		}
		$('#headerModal').on('click','#btnContinue',function(){
			$this = $(this);
			var frm = $this.closest('.modal').find('form:visible')  //.submit();
			var formData = frm.serializeObject();
			console.log(formData);
			
			//show back button in most cases
			//showBackBtn($('#headerModal'));
			
			var jqxhr = $.post( frm.attr('action'), formData, function( results ) {
				  $modalbody= $('#headerModal').find('.modal-body:visible');

				  //start by making a new modal body container for holding the form results
				  $nextPage = $('<div/>', {class: 'modal-body'});

				  //hide the previous page for later access if needed and then append/insert in the new page
				  $modalbody.hide();				  
				  $nextPage.html(results).insertAfter($modalbody);
			  
			  
			}).fail(function(e) {
				alert( "Page not loaded." + e );
			  })
			 .always(function() {
				//alert( "finished" );
			 });
		})
	  });

	$baseModal.on('show.bs.modal', function (event) {
	  var button = $(event.relatedTarget) // Button that triggered the modal
	  var action = button.data('action') // Extract info from data-* attributes  
	  var modal = $(this)
	  var myTitle = '';
	  var myContent = 'Not loaded';
	  
	  switch(action) {
		case 'parcelHistory':
			modal.find('.modal-title').text('Parcel/Mail');
			hideSubmitBtn(modal);
			hideBackBtn(modal);
			$.get("popup/parcelHistory.cfm", function(data, status){
				modal.find('.modal-body').html(data);
			},"html");
			break;
		case 'announce2':
			modal.find('.modal-title').text('Add <cfoutput>#labels.visitor#</cfoutput>');
			hideBackBtn(modal);
			var loc = "popup/announce2.cfm";
			$.get(loc, function(data, status){
				modal.find('.modal-body').html(data);
				modal.find('.email-form-grp').hide();
				modal.find("form").on('change','#dashpass1a',function(){
					if ( this.value === 'email'){
						modal.find('.email-form-grp').show();
					} else {
						modal.find('.email-form-grp').hide();
					}
				});
				$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
					 try {
						 if (e.target.outerText.indexOf('New') != -1){
							showSubmitBtn(modal);
						} else {
							hideSubmitBtn(modal);
						}
					 } catch (event) {
						 console.log(e) 
					 }
					 
					});
			},"html");
			break;
		case 'permguest':
			modal.find('.modal-title').text('Express Pass');
			hideBackBtn(modal);
			hideSubmitBtn(modal);
			$.get("popup/permguest.cfm", function(data, status){
				modal.find('.modal-body').html(data);
				modal.find('.email-form-grp').hide();
				$('.alert').hide();
				modal.find("form").on('change','#dashpass1a',function(){
					if ( this.value === 'email'){
						modal.find('.email-form-grp').show();
					} else {
						modal.find('.email-form-grp').hide();
					}
				});
				$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
					 try {
						 if (e.target.outerText.indexOf('New') != -1){
							showSubmitBtn(modal);
						} else {
							hideSubmitBtn(modal);
						}
					 } catch (event) {
						 console.log(e) 
					 } 
				});
				$('input[name="active_chk"]').on('switchChange.bootstrapSwitch', function(event, state) {
					var $this=$(this);
					var url = 'bizrules/pause_permguest.cfm';
					var data = {
						vid : $this.data('vid'),
						active: state
					}

					var jqxhr = $.ajax({
						type: "POST",
						url: url,
						data: data
					}).done(function(html) {
						$( ".alert" ).addClass( 'alert-success' );
					})
					.fail(function() {
							$( ".alert" ).addClass( 'alert-warning' );
						})
					.always(function(html) {
							$( ".alert" ).fadeIn(400).html( html ).delay( 3000 ).fadeOut( 400 );
					});
				
				});
			},"html");
			break;
		case 'addressbook2':	
			modal.find('.modal-title').text('Guest Book');
			hideSubmitBtn(modal);
			hideBackBtn(modal);
			$.get("popup/addressbook2.cfm", function(data, status){
				modal.find('.modal-body').html(data);
			},"html");
			break;
		case 'specialevent_announce1': //'ohgs_announce1':
			modal.find('.modal-title').text('Schedule <cfoutput>#labels.special_event#</cfoutput>');
			hideBackBtn(modal);
			$.get("popup/specialevent_announce1.cfm", function(data, status){
				modal.find('.modal-body').html(data);
			},"html");
			break;
		case 'downloads':
			modal.find('.modal-title').text('<cfoutput>#labels.downloads#</cfoutput>:');
			hideSubmitBtn(modal);
			hideBackBtn(modal);
			$.get("popup/downloads.cfm", function(data, status){
				modal.find('.modal-body').html(data);
			},"html");
			break;
		case 'opinions':
			modal.find('.modal-title').text('Opinions:');
			modal.find('#btnContinue')
				.show()
				.text('Post Your Comment')
				.on("click",function(){
					$('#postform').css('display','block');
				});
			
			hideBackBtn(modal);
			$.get("popup/BBComments.cfm", function(data, status){
				modal.find('.modal-body').html(data);
			},"html");
			break;
		case 'marketplace':
			modal.find('.modal-title').text('Marketplace:');
			modal.find('#btnContinue').show().text('Post Your Ad');
			hideBackBtn(modal);
			$.get("popup/BBItems.cfm", function(data, status){
				modal.find('.modal-body').html(data);
			},"html");
			break;
		case 'modspecialevent':
			modal.find('.modal-title').text('Schedule <cfoutput>#labels.special_event#</cfoutput>');
			hideBackBtn(modal);
			//moved away from going directly to the edit page in favor of a 'consistent' event selection page first 
			//var theUrl = "popup/modspecialevent.cfm?SPECIALEVENT_ID="+button.data('id');
			var theUrl = "popup/modifyschedule2.cfm?calDate="+button.data('date');
			$.get(theUrl, function(data, status){
				modal.find('.modal-body').html(data);
			},"html");
			break;
		case 'modifyschedule2':
			modal.find('.modal-title').text('Modify Scheduled Visit');
			hideBackBtn(modal);
			var theUrl = "popup/modifyschedule2.cfm?calDate="+button.data('date');
			$.get(theUrl, function(data, status){
				modal.find('.modal-body').html(data);
			},"html");
			break;
		case 'overlap':
			modal.find('.modal-title').text('Duplicate <cfoutput>#labels.visitor#</cfoutput> Announcements Found');
			hideSubmitBtn(modal);
			hideBackBtn(modal);
			var theUrl = "popup/overlap-announcements.cfm?v_id="+button.data('vid')+"&g_id="+button.data('gid');
			$.get(theUrl,function(data, status){
				modal.find('.modal-body').html(data);
			},"html");
			break;
		default:
		   modal.find('.modal-title').text('Other Action:' + action);
		   alert('action not found');
		   hideBackBtn(modal);
		   console.log(button.html());
		}
		function hideSubmitBtn(modal){
			modal.find('#btnContinue').hide();
		}
		function showSubmitBtn(modal){
			modal.find('#btnContinue').show();
		}
		function hideCloseBtn(modal){
			modal.find('#btnClose').hide();
		}
		function hideBackBtn(modal){
			modal.find('#btnBack').hide();
		}
		function showBackBtn(modal){
			modal.find('#btnClose').hide();
			modal.find('#btnBack').show().text('Back');
		}
		function slidBack(count){
			
		}
		
		$('#baseModal').on('click','#btnContinue',function(){
			$this = $(this);
			var frm = $this.closest('.modal').find('form:visible')  //.submit();
			var formData = frm.serializeObject();
			console.log(formData);
			
			//show back button in most cases
			showBackBtn($('#baseModal'));
			var loc = frm.attr('action');
			if($('#permguest_chk').is(':checked')){
				loc = '/residents/popup/permguest3.cfm';
			}
			var jqxhr = $.post( loc, formData, function( results ) {
				  $modalbody= $('#baseModal').find('.modal-body:visible');

				  //start by making a new modal body container for holding the form results
				  $nextPage = $('<div/>', {class: 'modal-body'});

				  //hide the previous page for later access if needed and then append/insert in the new page
				  $modalbody.hide();				  
				  $nextPage.html(results).insertAfter($modalbody);
			  
			  
			}).fail(function(e) {
				alert( "Page not loaded." + e );
			  })
			 .always(function() {
				//alert( "finished" );
			 });
		})
		
		
		
	}); //end of baseModal open call
	
	$.fn.serializeObject = function(){
         var o = {};
         var a = this.serializeArray();
         $.each(a, function() {
             if (o[this.name]) {
                 if (!o[this.name].push) {
                     o[this.name] = [o[this.name]];
                 }
                 o[this.name].push(this.value || '');
             } else {
                 o[this.name] = this.value || '';
             }
         });
         return o;
      };
	
	$baseModal.find('#btnBack').on('click',function(){
			var modal=$('#baseModal');
			modal.find('#btnBack').hide();
			modal.find('#btnContinue').show();
			modal.find('#btnClose').show();
			$('.modal-body').hide(); //hide all to clean house
			$('.modal-body').not(':first').remove(); //remove all but first.  TODO: allow for single step back rather than Always back to start.
			$('.modal-body').first().show();
		});
	  
	//Existing Visitor New-Visit
	$baseModal.on(
		'click','.new-visit-btn',
		function(){
			var gid = $(this).data('gid');
			$.get("popup/announce3.cfm?g_id="+gid, function(data, status){
				var modal=$('#baseModal');
				$modalbody=modal.find('.modal-body:visible');

				//start by making a new modal body container for holding the form results
				$nextPage = $('<div/>', {class: 'modal-body'});
				//hide the previous page for later access if needed and then append/insert in the new page
				$modalbody.hide();				  
				$nextPage.html(data).insertAfter($modalbody);
				modal.find('#btnBack').show();
				modal.find('#btnContinue').show();
				modal.find('#btnClose').hide();
			},"html");
		}
	);
	//Existing Visitor history
	$baseModal.on(
		'click','.guest-history-btn',
		function(){
			var gid = $(this).data('gid');
			$.get("popup/guesthistory.cfm?g_id="+gid, function(data, status){
				var modal=$('#baseModal');
				$modalbody=modal.find('.modal-body:visible');
				//start by making a new modal body container for holding the form results
				$nextPage = $('<div/>', {class: 'modal-body'});
				//hide the previous page for later access if needed and then append/insert in the new page
				$modalbody.hide();				  
				$nextPage.html(data).insertAfter($modalbody);
				
				modal.find('.modal-title').text('Access History');
				modal.find('#btnClose').hide();
				modal.find('#btnBack').show();
				modal.find('#btnContinue').hide();
			},"html");
		}
	);
	//Cancle Guest (Announcement)
	$baseModal.on(
		'click','.visit-cancel-btn',
		function(){
			var vid = $(this).data('vid');
			$.get("popup/deletecheck.cfm?v_id="+vid, function(data, status){
				var modal=$('#baseModal');
				$modalbody=modal.find('.modal-body:visible');
				//start by making a new modal body container for holding the form results
				$nextPage = $('<div/>', {class: 'modal-body'});
				//hide the previous page for later access if needed and then append/insert in the new page
				$modalbody.hide();				  
				$nextPage.html(data).insertAfter($modalbody);
				modal.find('#btnClose').hide();
				modal.find('#btnBack').show().text('No - Go Back');
				modal.find('#btnContinue').show().text('Yes - Delete This Announcement');
			},"html");
		}
	);
	
	//Cancle Guest (24/7)
	$baseModal.on(
		'click','.guest-cancel-btn',
		function(){
			var gid = $(this).data('gid');
			$.get("popup/deletecheck3.cfm?g_id="+gid, function(data, status){
				var modal=$('#baseModal');
				$modalbody=modal.find('.modal-body:visible');
				//start by making a new modal body container for holding the form results
				$nextPage = $('<div/>', {class: 'modal-body'});
				//hide the previous page for later access if needed and then append/insert in the new page
				$modalbody.hide();				  
				$nextPage.html(data).insertAfter($modalbody);
				modal.find('#btnClose').hide();
				modal.find('#btnBack').show().text('No - Go Back');
				modal.find('#btnContinue').show().text('Yes - Delete This <cfoutput>#labels.visitor#</cfoutput>');
			},"html");
		}
	);
	//Re-issue Dashpass 
	$baseModal.on(
		'click','.reissue-dashpass-btn',
		function(){
			var vid = $(this).data('vid');
			$.get("popup/reissuedashpass.cfm?v_id="+vid, function(data, status){
				var modal=$('#baseModal');
				$modalbody=modal.find('.modal-body:visible');
				//start by making a new modal body container for holding the form results
				$nextPage = $('<div/>', {class: 'modal-body'});
				//hide the previous page for later access if needed and then append/insert in the new page
				$modalbody.hide();				  
				$nextPage.html(data).insertAfter($modalbody);
				modal.find('.modal-title').text('<cfoutput>#labels.permanent_visitor# #labels.visitor#s</cfoutput>');
				modal.find('#btnClose').hide();
				modal.find('#btnBack').show();
				modal.find('#btnContinue').show();
			},"html");
		}
	);
	
	//Add new permanent guest/visitor 
	$baseModal.on(
		'click','.new-perm-guest',
		function(){
			var spid = $(this).data('spid');
			$.get("popup/announce2.cfm", function(data, status){
				var modal=$('#baseModal');
				$modalbody=modal.find('.modal-body:visible');
				//start by making a new modal body container for holding the form results
				$nextPage = $('<div/>', {class: 'modal-body'});
				//hide the previous page for later access if needed and then append/insert in the new page
				$modalbody.hide();				  
				$nextPage.html(data).insertAfter($modalbody);
				modal.find('#permguest_chk').prop("checked", true);
				modal.find('#btnClose').show();
				modal.find('#btnBack').hide();
				modal.find('#btnContinue').show().text('Continue');
			},"html");
		}
	);
	
	//Cancel Special Event 
	$baseModal.on(
		'click','.event-cancel-btn',
		function(){
			var spid = $(this).data('spid');
			$.get("popup/deletecheck4.cfm?specialevent_id="+spid, function(data, status){
				var modal=$('#baseModal');
				$modalbody=modal.find('.modal-body:visible');
				//start by making a new modal body container for holding the form results
				$nextPage = $('<div/>', {class: 'modal-body'});
				//hide the previous page for later access if needed and then append/insert in the new page
				$modalbody.hide();				  
				$nextPage.html(data).insertAfter($modalbody);
				modal.find('#btnClose').hide();
				modal.find('#btnBack').show().text('No - Go Back');
				modal.find('#btnContinue').show().text('Yes - Cancel This Event');
			},"html");
		}
	);
});

function loadModal(page){
	$.get(page,function(data, status){
		$('#baseModal').find('.modal-body').html(data);
	},"html");
}
</script>
<!--- 	
<cfif cgi.HTTP_USER_AGENT contains "ipad"><cfelse>
<script type="text/javascript" data-cfasync="false">(function () { var done = false;var script = document.createElement("script");script.async = true;script.type = "text/javascript";script.src = "https://app.purechat.com/VisitorWidget/WidgetScript";document.getElementsByTagName("HEAD").item(0).appendChild(script);script.onreadystatechange = script.onload = function (e) {if (!done && (!this.readyState || this.readyState == "loaded" || this.readyState == "complete")) {var w = new PCWidget({ c: "95cb67ef-e20d-43e1-a569-6ae5b1a05a1e", f: true });done = true;}};})();</script>
</cfif>
--->