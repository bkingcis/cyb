<p style="font-size: 14px;">
<a href="#" style="color:red">Watch this tutorial video to get started.</a>
<!---
<strong>Welcome to the Administrative Control Panel.</strong>  

From here you are able to manage all resident and personnel user accounts, post messages, and upload important community documents.</p>
 <p>The shortcuts below give you quick access to specific, frequently used action.  Click the appropriate link below.</p>
---></p>
	<style>
		.well {
		padding: 24px; border-radius: 6px;
		min-height: 20px;
		padding: 19px;
		margin-top: 20px;
		margin-bottom: 20px;
		background-color: #f5f5f5;
		border: 1px solid #e3e3e3;
		border-radius: 4px;
		-webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
		box-shadow: inset 0 1px 1px rgba(0,0,0,.05);
		}
		.icon {width: 140px; float:left;}
	</style>
		<!--- <div class="well">
			<div class="icon">
			<a href="#messages" class="open-tab dialog_link ui-state-default ui-corner-all">
			<span class="ui-icon ui-icon-pin-s"></span>MESSAGE</a>
			</div> 
			<strong>Message to residents</strong>  - Post messages, instantly, to all resident users.
		</div>
		
		<div class="well">
			<div class="icon">
			<a href="#messages" class="open-tab dialog_link ui-state-default ui-corner-all">
			<span class="ui-icon ui-icon-pin-s"></span>MESSAGE</a>
			</div> <strong>Message to personnel</strong>  - Post messages, instantly, to all personnel users.
		</div>
		
		<div class="well">
			<div class="icon">		
			<a href="#documents" class="open-tab dialog_link ui-state-default ui-corner-all">
			<span class="ui-icon ui-icon-document"></span>DOCUMENTS</a>
			</div> <strong>Documents</strong>  - Upload documents which are viewable to all resident users.
		</div>
		
		<div class="well">
			<div class="icon">	
			<a href="#residents" class="open-tab dialog_link ui-state-default ui-corner-all" data-tab="3">
			<span class="ui-icon ui-icon-locked"></span>RESIDENTS</a>
			</div> 
			<strong>Manage residents</strong>  - View, edit, or delete resident users.  Reset passwords.
		</div>
		
		<div class="well">
			<div class="icon">		
			<a href="#personnel" class="open-tab dialog_link ui-state-default ui-corner-all" data-tab="3">
			<span class="ui-icon ui-icon-person"></span>PERSONNEL</a>
			</div> 
			<strong>Manage personnel</strong>  - View, edit, or delete personnel users.  Reset passwords, and View login reports.
		</div> --->
		
	<script>
		$(function(){
			$('.open-tab').click(function (e) {
				var tabid = $(this).attr('href');
				var tablink = $(tabid);
				var tab = tablink.parent();
				console.log(tab);
				tab.parent('li').addClass('ui-tabs-selected').addClass('ui-state-active').addClass('ui-state-focus');
				e.preventDefault();
			});
		});
	</script>