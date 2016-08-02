<!---<cfif not isDefined("session.new_community_email")><h1>Your session timed out.</h1><a href="/signup">Please return to signup page</a><cfabort></cfif>
--->
<div class="row">
  <div class="col-sm-10">
    <p><span class="lead">You have successfully customized an Interactive Visitor Management System for:
     <cfoutput> <br/><cftry><strong>#session.new_community_name#</strong>.
				<br/><br/>
				<strong>#session.new_community_admin#</strong> is registered as the official community administrator.<cfcatch /></cftry>
      </cfoutput></span>
			<div style="height: 320px;">
			<div style="position:absolute;z-index:1;left:200px;height:270px;width:524px;opacity:0.3;background-image:url('/img/video-bg.png');"></div>
			<div style="position:absolute;z-index:9;left:350px;padding-top:120px;">
				<!--- <a href="#vidModal" class="btn btn-lg btn-danger" data-toggle="modal"> --->
				<a class="btn btn-lg btn-danger" href="https://www.youtube.com/embed/rhW3bR0Fxk0?autoplay=1" target="_blank">VIEW WELCOME VIDEO<i class="glyphicon glyphicon-play"></i></a></div>
			</div><span class="lead">
      Shortly, you will receive a confirmation email at <cftry><cfoutput><strong>#session.new_community_email#</strong></cfoutput><cfcatch /></cftry> 
			from support@cybatrol.info.
			Please check your spam folder.
			<br /><br />
      WE LOOK FORWARD TO SERVING YOU!
			<br /><br />
      (424) 371-0047<br />
      (800) 325-0371<br />
      support@cybatrol.info</span></p><br /><br /><br />
  </div>
</div>
 <!-- Modal HTML -->
    <div id="vidModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
                    <h4 class="modal-title">COMMUNITY ADMINISTRATOR WELCOME VIDEO</h4>
                </div>
                <div class="modal-body">
                    <iframe id="theVideo" width="560" height="315" src="//www.youtube.com/embed/KTiX2OJLPEs?autolay=1" frameborder="0" allowfullscreen></iframe>
                </div>
            </div>
        </div>
    </div>


<script type="text/javascript">
$(document).ready(function(){
    /* Get iframe src attribute value i.e. YouTube video url
    and store it in a variable */
    var url = $("#theVideo").attr('src');
    
    /* Assign empty url value to the iframe src attribute when
    modal hide, which stop the video playing */
    $("#vidModal").on('hide.bs.modal', function(){
        $("#theVideo").attr('src', '');
    });
    
    /* Assign the initially stored url back to the iframe src
    attribute when modal is displayed again */
    $("#vidModal").on('show.bs.modal', function(){
        $("#theVideo").attr('src', url);
    });
});
</script>