<cfif NOT isDefined("session.signup.c_name")><cflocation url="/signup" addtoken="false"></cfif>
<cfoutput>
		<form class="form-horizontal" id="eventtypesentry" role="form" method="post" action="?action=#xfa.submit#">	
		<h4>Does #session.signup.c_name# permit residents to host special events (garage sales, open houses...) at their residence or unit?</h4>
		<fieldset>
			<legend><small>Add Special Event Scheduling:</small></legend>
			<div class="form-group">
				<label for="chk_SpecialEvents" class="col-sm-2 control-label"></label>
				<div class="col-sm-3">
				<ul class="list-group">
					<li class="list-group-item">
					 <input type="radio" value="1" name="chk_SpecialEvents" id="chk_SpecialEvents_yes">  Yes
					</li>
					<li class="list-group-item">
					 <input type="radio" value="0" name="chk_SpecialEvents" id="chk_SpecialEvents_no" checked="checked">  No
					</li>
				</ul>
				</div>
			</div>
			<div id="eventSelections" class="form-group">
				<label for="chk_specialevent" class="col-sm-2 control-label">Select each type permitted:</label>				
				<div class="col-sm-3">
				 <ul class="list-group">
					<li class="list-group-item"><input type="checkbox" value="oh" name="chk_specialevent" id="chk_specialevent_oh"> Open House</li>
				 	<li class="list-group-item"><input type="checkbox" value="gs" name="chk_specialevent" id="chk_specialevent_gs"> Garage Sale</li>
				 	<li class="list-group-item"><input type="checkbox" value="pt" name="chk_specialevent" id="chk_specialevent_pt"> Party</li>
				<!---	<li class="list-group-item"><input type="checkbox" value="c1" name="chk_specialevent" id="chk_specialevent_c1"> <input name="custEvent1" data-toggle="tooltip" data-placement="right" placeholder="Add Your Own" title="Add your own"></li>
				 	<li class="list-group-item"><input type="checkbox" value="c2" name="chk_specialevent" id="chk_specialevent_c2"> <input name="custEvent2" data-toggle="tooltip" data-placement="right" placeholder="Add Your Own" title="Add your own"></li>
				---> </ul>
					<div>* We can customize special event names unique to your community.</div>
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
		$('#eventSelections').hide();
		
		 $("[data-toggle='tooltip']").tooltip({
		 	placement:'top'
		 }); 
		  
		 $( "input[name='chk_SpecialEvents']" ).on('change',function(){
		 $this=$(this);
		 console.log($this.val());
			 if ($this.val() == 1) {
				$('#eventSelections').show();
			 } else {
				$('#eventSelections').hide();
				$('.has-error').removeClass('has-error');
			}
		 });
		 $('.btn-primary').on('click', function(){
		 	if ( $( "input[name='chk_SpecialEvents']:checked" ).val() == 1 ) {
				atLeastOneEventChecked = false;
				 $( "input[name='chk_specialevent']" ).each(function() {
					var $this = $(this);
					if ($this.prop("checked")) {
						atLeastOneEventChecked = true;
					}
				});
				
				if ( atLeastOneEventChecked == true ) {
					$('#eventtypesentry').submit();
				} else {
					$this.closest('.form-group').addClass('has-error');
					alert('Please select events that you would like to enable for your residents.');
				}
			} else {
				$('#eventtypesentry').submit();
			}
		 });
	});
</script>