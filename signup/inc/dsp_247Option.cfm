<cfif NOT isDefined("session.signup.c_name")><cflocation url="/signup" addtoken="false"></cfif>
<cfoutput>
	<form class="form-horizontal" id="247Option" role="form" method="post" action="?action=#xfa.submit#">	
		<h4>Does #session.signup.c_name# permit residents to identify visitors with OPEN (UNRESTRICTED/24/7) access? 
		Generally, visitors with OPEN/UNRESTRICTED access are allowed to enter anytime until this status is revoked.</h4>
		<fieldset>
			<legend><small>Add "Open/Unrestricted" access:</small></legend>
			<!-- <p style="display:inline-block;max-width:720px;margin-bottom:25px;">24/7 guests.....</p> -->
			<div class="form-group">
				<label for="chk_247guests" class="col-sm-2 control-label"></label>
				<div class="col-sm-3">
				<ul class="list-group">
					<li class="list-group-item">
					 <input type="radio" value="1" name="chk_247guests" id="chk_247guests_yes">  Yes
					</li>
					<li class="list-group-item">
					 <input type="radio" value="0" name="chk_247guests" id="chk_247guests_no" checked="checked">  No
					</li>
				</ul>
				</div>
			</div>
			<div id="maxCountOption">
			<legend>Designate the maximum number of OPEN/UNRESTRICTED visitors each resident can add:</legend>
				
			<div class="form-group">
			 <label for="chk_247guests" class="col-sm-2 control-label">Maximum Allowed</label>
				<div class="col-sm-3">
				<select name="maxPermGuests" id="sel_max247guests" class="form-control req">
					<option value=""> - Choose - </option>
					<option>5</option>
					<option>10</option>
					<option>15</option>
					<option>20</option>
					<option>25</option>
					<option value="99">Unlimited</option>
				</select>
				</div>
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
		$('#maxCountOption').hide();
		
		$("[data-toggle='tooltip']").tooltip({
		 	placement:'top'
		 }); 
		 
		 $('input').on('change',function(){
		 $this=$(this);
		 console.log($this.val());
			 if ($this.val() == 1) {
				$('#maxCountOption').show();
			 } else {
				$('#maxCountOption').hide();
				$('.has-error').removeClass('has-error');
			}
		 });
		 
		 $('.req').blur(function() {
		 	$this = $(this);
			  if($this.val() == ''){
			  	$this.closest('.form-group').addClass('has-error');
				$this.focus();
			  } else {
			  	$this.closest('.form-group').removeClass('has-error');
			  }
		 });
		  $('.btn-primary').on('click', function(){
		 	if ( $('#chk_247guests_no').is(':checked') ) {
				$('#247Option').submit();
			} else {
				if ( $( '.has-error' ).length && $( '#sel_max247guests' ).val() == '' ) {
					console.log('first '+$('#sel_max247guests').val());
					alert('Choose the maximum number of unrestricted visitors, or choose "Unlimited."');					
				} else if ( !$( '#sel_max247guests' ).val() == '' ) {
					//alert($('#sel_max247guests').val());
					$('#247Option').submit();
				} else {
					$('#sel_max247guests').addClass('has-error');
					console.log('first '+$('#sel_max247guests').val());
					alert('Choose the maximum number of unrestricted visitors, or choose "Unlimited."');
				}
			}
		 });
	});
</script>