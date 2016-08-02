<cfoutput>
<form id="step1" class="form-horizontal" role="form" method="post" action="?action=#xfa.submit#">
  <fieldset>
	<p><span class="lead">
 
Design a customized Interactive Visitor Management System (IVMS) for your gated community or condominium.
This revolutionary system is personalized and automatically designed as you answer the following questions.
In less than five minutes you will produce the ideal solution for all your visitor management needs.<br /><br />

If you have any questions during this process, please click on the green LIVE CHAT below.<br />
	</span>	</p>
  <!---		<ul>
      <li>Customize Services</li>
      <li>Add Community/Condominium Details</li>
      <li>Upload Residents and Personnel Information</li>
		
		</ul>
 	<br />
 --->
		 <fieldset>
			<legend>Let's Get Started:</legend>
		    <div class="form-group">
					<label for="inputC_NAME" class="col-sm-2 control-label">Community Name</label>
					<div class="col-sm-10">
						<input type="text" class="form-control req" id="inputC_NAME" placeholder="example: Platinum Estates Country Club" name="c_name" value="">
					</div>
		    </div>
	  <fieldset/>		
	   <div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		 <!-- <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-left"></span> BACK</button>
		  <button type="submit" class="btn btn-primary">MANUAL SET-UP</button> -->
		  <button type="button" class="btn btn-primary">Continue</button>
		</div>
	  </div>
	</form>
</cfoutput>
<style>
.stepheading {
	font-weight: 600;
	font-size: 1.2em;
	
}
</style>

<script>
	$(function(){
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
				$('#step1').submit();
			}
		 });
	});
</script>