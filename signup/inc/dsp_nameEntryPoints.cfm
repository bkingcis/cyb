<cfparam name="session.signup.sel_entrypoints" default="1">
<cfparam name="session.signup.entrypoint_1" default="">
<cfparam name="session.signup.entrypoint_2" default="">
<cfparam name="session.signup.entrypoint_3" default="">
<cfparam name="session.signup.entrypoint_4" default="">
<cfparam name="session.signup.entrypoint_5" default="">
<cfoutput>
	<form class="form-horizontal" id="nameentrypoints" role="form" method="post" action="?action=#xfa.submit#">	
		<h4><!-- We need a name (nickname) for each entrance point. --></h4>
	<fieldset>
			<legend><small>Name the visitor entry points:</small></legend>
			<cfloop from="1" to="#session.signup.sel_entrypoints#" index="i">
			  <div class="form-group">
				<label for="inputF_NAME" class="col-sm-2 control-label">Entry Point #i#</label>
				<div class="col-sm-3"><!-- req -->
				 <input type="text" class="form-control req" id="input_entrypoint_#i#" name="entrypoint_#i#" value="#evaluate("session.signup.entrypoint_"&i)#" placeholder="Entry Point Name">
				</div>
			  </div>
			</cfloop>
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
		 $("[data-toggle='tooltip']").tooltip({
		 	placement:'top'
		 }); 
		 
		 $('input').first().focus();
		 
		 $('.req').blur(function() {
		 	$this = $(this);
			  if($this.val() == ''){
			  	$this.closest('.form-group').addClass('has-error');
				if ( $this.attr('placeholder').indexOf('required') == -1 ){
					$this.attr('placeholder',$this.attr('placeholder')+' required');
				}
				//$this.focus();
			  } else {
			  	$this.closest('.form-group').removeClass('has-error');
			  }
		 });
		 	
		$('.btn-primary').on('click', function(){
		 	if ( $( '.has-error' ).length ) {
				alert('Please complete all required fields');
			} else {
					$('#nameentrypoints').submit();
			}
		 });
	});
</script>