<cfif not structKeyExists(session,"NEW_COMMUNITY_NAME")>
	
	<div class="row">
		<div class="col-sm-10">
			<p><span class="lead">Your session has expired.  Please return to the <a href="/signup">welcome page</a> and reenter your community details.</p>
			</span></p>
		</div>
	</div>
<cfelse>
<cfoutput>
	<div class="row">
		<div class="col-sm-10">
			<p><span class="lead">
				You have successfully customized an Interactive Visitor Management System for:
				<br/><strong>#session.new_community_name#</strong>.
				<br/><br/>
				<strong>#session.new_community_admin#</strong> is registered as the official community administrator.
The final step before activating service is to add the resident and personnel users' information into the system.
			</span></p>
		</div>
	</div>

	<form method="post" action="?action=#xfa.submit#">
	<div class="row well">
		<div class="col-sm-10">
			<p class="message">
				Use the templates below to create two (2) spreadsheet documents and choose your delivery method.</p>
				<div class="form-group">
			<div class="col-sm-offset-4 col-sm-6">
				<a href="residentTemplate.xlsx" target="_blank" class="btn btn-sm btn-default">Resident Template</a>  
				<a href="personellTemplate.xlsx" target="_blank" class="btn btn-sm btn-default">Personnel Template</a>
			</div>
		</div>
		</div>
	</div>
	
  <div class="panel panel-default">			
		<!---  <div class="row">
		   <div class="col-sm-3">
				<h3 class="pull-right"><input type="radio" value="opt1" name="delivery_option" /> Option 1</h3>
			 </div>
			 <div class="col-sm-6"><h3>Upload Files Now</h3>
				 <div id="upload_directions" class="hidden">
					<input type="file" /><input class="btn btn-sm btn-default" type="submit"  />
				 </div>
			 </div>
		  </div> --->
		
		  <div class="row">
		   <div class="col-sm-3">
				<h3 class="pull-right"><input type="radio" value="opt2" name="delivery_option" class="hidden-xs" /> Option 1</h3><!---
				<p>Be sure to include your community name in the subject line</p> --->
			 </div>
			 <div class="col-sm-6"> <h3>Email Files</h3>
				 <div id="email_directions" class="hidden-sm hidden-md hidden-lg">
					<ul>
					 <li>Attach files to an email.</li>
					 <li>Subject Line:  <strong>#session.new_community_name#</strong></li>
					 <li><a href="mailto:dataentry@cybatrol.com">dataentry@cybatrol.com</a></li>
					</ul>
			   </div>
			 </div>
		  </div>	
		
			<div class="row">
		   <div class="col-sm-3">
				<h3 class="pull-right"><input type="radio" value="opt3" name="delivery_option" class="hidden-xs" /> Option 2</h3><!--- <p>Please, send hard media, such as a memory stick or CD/DVD</p> --->
			 </div>
			 <div class="col-sm-6">
			  <h3>Mail Files</h3>
				 <div id="postal_mail_directions" class="hidden-sm hidden-md hidden-lg">
					Mail the personnel and resident documents to:
					<blockquote>Cybatrol, LLC<br />
					ATTN: Data Entry<br />
					PO Box 1044<br />
					Sarasota, FL  34230-1044 </blockquote>
					For your protection, we recommend USPS (Priority Mail)<br />
					SIGNATURE REQUIRED
				</div>
			 </div>
		  </div>	
		 <div class="row"><p>  </p>
		 </div>
		 </div><!-- // end of panel -->
		 <div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		 <!--- <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-left"></span> BACK</button> --->
		  <button type="submit" id="btn_continue" class="btn btn-primary">CONTINUE</button>
		</div>
	  </div>
		</form><div class="row"><p>  </p>
		 </div>
	</div>	
</cfoutput>

<script>
  $(function(){
	   //$('.hidden').hide();
		 
		 $( "input[type='radio']" ).on('change',function(){
		  
		 		$('#upload_directions').addClass('hidden-sm hidden-md hidden-lg');
				$('#email_directions').addClass('hidden-sm hidden-md hidden-lg');
				$('#postal_mail_directions').addClass('hidden-sm hidden-md hidden-lg');
			 
			 $this=$(this);
			 console.log($this.val());
			 if($this.val()==='opt1'){
					$('#upload_directions').removeClass('hidden-sm hidden-md hidden-lg');
			 }
			 if($this.val()==='opt2'){
					$('#email_directions').removeClass('hidden-sm hidden-md hidden-lg');
			 }
			 if($this.val()==='opt3'){
					$('#postal_mail_directions').removeClass('hidden-sm hidden-md hidden-lg');
			 }
		 });
	});
</script>
</cfif>