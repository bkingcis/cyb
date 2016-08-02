
<cfset barcodelength = 8>
<div style="text-align:center;padding-top:12px;">
	<form action="guestdetails.cfm?fancyCheckin=1" method="POST" id="dashform" name="dashform">
		<div style="display:inline-block;"><cfoutput>
		<input type="text" id="inpDashPassSrch" maxlength="#barcodelength#" name="dashPass" placeholder="DashPass ##" style=" vertical-align: top;height:28px;font-size:18pt;width:140px;">
		</cfoutput>
		</div>
		<div style="display:inline-block;">
		<button type="button" id="dpCheckinBtn" style="vertical-align: top;height:34px;padding:7px 22px 7px 15px;font-size:14px;text-transform:uppercase;">Check-In</button>
		</div>
	</form>
</div>
	<script type="text/javascript">
		$(function() {
				$("#inpDashPassSrch").focus();
				$("#inpDashPassSrch").on('keyup',function(){
					if ($("#inpDashPassSrch").attr("value").length > <cfoutput>#barcodelength-1#</cfoutput>) {
						$.ajax({
							type        : "POST",
							cache       : false,
							url         : "guestdetails.cfm?checkin=1&fancyCheckin=1",
							data        : $(this).serializeArray(),
							success: function(data) {
								$.fancybox({
									'content' : data,
									'height':200,
									'width':460,
									'autoDimensions':false
								});
							}
						});

						return false;
					}
				});	
					
				$("#dpCheckinBtn").on("click",function(){
					if ($("#inpDashPassSrch").attr("value").length > <cfoutput>#barcodelength-1#</cfoutput>) {
						$("#dashform").ajaxForm({
							success: function(responseText){
								$.fancybox({
									'content' : responseText
								});
							}
						});
					}
					else alert('incorrect value for DashPass.'); 
				});
				$("#dpformbtn").click(function(){
					if ($("#inpDashPassSrch").attr("value").length > <cfoutput>#barcodelength-1#</cfoutput>) {
						<cfif getCommunity.recordLicensePlate>
						 //fancyCheckin($("#inpDashPassSrch").val(),1);
						<cfelse>
						 //$("#dashform").submit();
						 //fancyCheckin($("#inpDashPassSrch").val(),1);
						</cfif>
						
						alert('in progress');
					}
					
					else alert('incorrect value for DashPass.'); 
				});
			});	
	</script>