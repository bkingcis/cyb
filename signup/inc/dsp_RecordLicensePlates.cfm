<cfif NOT isDefined("session.signup.c_name")><cflocation url="/signup" addtoken="false"></cfif>
<cfparam name="session.signup.PackageDropoff" default="">
<cfoutput>
	<form class="form-horizontal" id="RecordLicensePlates" role="form" method="post" action="?action=#xfa.submit#">	
		<h4>When visitors arrive at #session.signup.c_name#, do you record the vehicle's license plate information?</h4>
		<fieldset>
			<legend><small>Record license plate information:</small></legend>
			 <p style="display:inline-block;max-width:720px;margin-bottom:25px;"></p> 
			<div class="form-group">
				<label for="recordLicensePlate" class="col-sm-2 control-label"></label>
				<div class="col-sm-3">
					<ul class="list-group">
					<li class="list-group-item">
					 <input type="radio" value="1" name="recordLicensePlate" id="chk_RecordLP_yes" onclick="$('##allvisitsdiv').css('display','block')">  Yes
					</li>
					<li class="list-group-item">
					 <input type="radio" value="0" checked="checked" name="recordLicensePlate" id="chk_RecordLP_no" onclick="$('##allvisitsdiv').css('display','none')">  No
					 </li>
					</ul>
				</div>
			</div>
			<div class="form-group" id="allvisitsdiv" style="display: none;">
				<label for="recordlicenseplateonallvisits" class="col-sm-2 control-label">Frequency</label>
				<div class="col-sm-3">
					<ul class="list-group">
					<li class="list-group-item">
					 <input type="radio" value="1" name="recordlicenseplateonallvisits" id="chk_RecordLP_all">  Record Every Visit
					</li>
					<li class="list-group-item">
					 <input type="radio" value="0" name="recordlicenseplateonallvisits" id="chk_RecordLP_first">  Only Record First Visit
					 </li>
					</ul>
				</div>
			</div>
		  <fieldset/>		
	  <div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		  <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-left"></span> BACK</button>
		  <button type="button" class="btn btn-primary">CONTINUE</button>
		</div>
	  </div>
	</form>
</cfoutput>
<script>
	$(function(){
	 $('.btn-primary').on('click', function(){
		if ( $('#chk_RecordLP_no').is(':checked') ) {
			$('#RecordLicensePlates').submit();
		} else {
			if ( $( '#chk_RecordLP_all' ).is(':checked') || $( '#chk_RecordLP_first' ).is(':checked')  ) {
				$('#RecordLicensePlates').submit();					
			} else {
				$('#chk_RecordLP_all').addClass('has-error');
				alert('Choose "Record Every Visit", or choose "Only Record First Visit."');
			}
		}
	  });	
	});
</script>