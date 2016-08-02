<cfif NOT isDefined("session.signup.c_name")><cflocation url="/signup" addtoken="false"></cfif>
<cfoutput>
	<form class="form-horizontal" role="form" method="post" action="?action=#xfa.submit#">	
		<h4> 
		Do visitors arriving at #session.signup.c_name# receive a guest pass upon entry into the community?  DashPass<sup style="font-size: 0.6em">TM</sup>
		is our exclusive, bar-coded access pass feature.  It can be printed at the gatehouse or emailed to every announced visitor.  
		DashPass<sup style="font-size: 0.6em">TM</sup> makes an excellent dashboard display for neighborhood patrol and can be displayed on 
		most mobile devices.</h4>
		<fieldset>
			<legend><small>Offer DashPass<sup style="font-size: 0.6em">TM</sup> Feature:</small></legend>
			 <p style="display:inline-block;max-width:720px;margin-bottom:25px;"></p> 
			<div class="form-group">
				<label for="chk_247guests" class="col-sm-2 control-label"></label>
				<div class="col-sm-3">
					<ul class="list-group">
						<li class="list-group-item">
						 <input type="radio" value="1" name="chk_dashpass" id="chk_dashpass_yes">  Yes
						</li>
						<li class="list-group-item">
						 <input type="radio" value="0" name="chk_dashpass" id="chk_dashpass_no" checked="checked">  No
						 </li>
					</ul>
				</div>
			</div>
		  <fieldset/>		
	  <div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		  <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-left"></span> BACK</button>
		  <button type="submit" class="btn btn-primary">CONTINUE</button>
		</div>
	  </div>
	</form>
</cfoutput>