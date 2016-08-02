function GuestCheckin(v_id,g_id,recordPlate,checkin) {
			if(!checkin)var checkin = 0
			jThickboxNewLink="lpform.cfm?v_id="+v_id+"&g_id="+g_id+"&checkin="+checkin+"&height=500&width=700";
			<cfif getCommunity.recordLicensePlate>
				$.ajax({
							type        : "POST",
							cache       : false,
							url         : "guestdetails.cfm?checkin=1",
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
				
				//tb_open_new(jThickboxNewLink);
				if (recordPlate){
				jThickboxNewLink = jThickboxNewLink + '&fancyCheckin=1';
				tb_show('Record License Plate',jThickboxNewLink,null);
				}
				else self.location=jThickboxNewLink;	
			<cfelse>
				$.ajax({
					type        : "GET",
					cache       : false,
					url         : "guestdetails.cfm?v_id="+v_id+"&g_id="+g_id+"&checkin=1",
					success: function(data) {
						$.fancybox({
							'content' : data,
							'height':200,
							'width':460,
							'autoDimensions':false
						});
					}
				});			
			</cfif>
		}
		function PrintPop(v_id,g_id) {
			printable=window.open("reprintDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate><!--- should only run for initial print/visit --->
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function ReprintAndPrintPop(v_id,g_id) {
			printable=window.open("reprintDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate and val(getCommunity.recordlicenseplateonallvisits)>
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function ReissueAndPrintPop(v_id,g_id) {
			printable=window.open("reissueDP.cfm?v_id="+v_id+"&g_id="+g_id,"printable","status=0,toolbar=0,width=825,height=700");
			<cfif getCommunity.recordLicensePlate and val(getCommunity.recordlicenseplateonallvisits)>
			GuestCheckin(v_id,g_id,1,0);
			</cfif>
		}
		function checkInAndPrintPop(vID) {
			printable=window.open("reprintDP.cfm?vid="+vID,"printable","status=0,toolbar=0,width=800,height=600");
			<cfif getCommunity.recordLicensePlate>
			GuestCheckin(v_id,g_id,1);
			</cfif>
		}
		function EmailPass(vID) {
			jThickboxNewLink="/staff/popup/emailPass.cfm?v_id="+vID+"&checkin=0&height=500&width=700";
			$.ajax({
					type        : "GET",
					cache       : false,
					url         : jThickboxNewLink,
					success: function(data) {
						$.fancybox({
							'content' : data,
							'height':200,
							'width':460,
							'autoDimensions':false
						});
					}
				});	
			//tb_show('Email DashPass',jThickboxNewLink,null);
		}
		function fancyCheckin(dashpass,recordPlate) {
			jThickboxNewLink="guestdetails.cfm?fancyCheckin=1&barcode="+dashpass+"&checkin=1&height=500&width=700";
			/*if (recordPlate){
				tb_show('Record License Plate',jThickboxNewLink,null);
			}
			else */
			self.location=jThickboxNewLink;			
		}