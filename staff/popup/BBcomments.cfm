<cfinclude template="header.cfm">
<cfparam name="residentLabel" default="Resident">
<cfoutput>
<div id="popUpContainer">
<h1 style="color:black;text-transform: uppercase;">#residentLabel# Opinions:</h1>

</cfoutput>
	<cfquery datasource="#datasource#" name="qBB">
		select bb.bbid,bb.label,bb.insertdate,bb.body, r.r_fname, r.r_lname, r.r_id
		from residentBB bb join residents r on bb.r_id = r.r_id
		join communities c on c.c_id = r.c_id
		where category_id = 99
		order by insertdate desc
	</cfquery>

<div id="listings">	

	<div style="padding: 0px;"><cfif qBB.recordcount>
	<cfoutput query="qBB">
	<div style="padding:2px;text-align:left;">
		<!--- <span class="BBheading">#label#</span><br /> --->
		<div class="commentMeta"><br /><br />
		<strong>#ucase(r_lname)#, #ucase(r_fname)#</strong><br />
		<em>(<cfif dateCompare(dateAdd('d',-1,now()),insertdate) eq 0>#timeFormat(insertdate)#<cfelse>#dateFormat(insertdate,'m/d/yyyy')#</cfif>)</em>
		</div>
		<div class="speechBubble"><strong>#ucase(label)#</strong>
		<br />
		<em  style="color:white;">#left(body, 350)#<span class="morelink"><cfif len(body) gt 800>...<a href="Javascript: void(0);">more</a></span><span class="morecontent" style="display:none;">#mid(body, 351, len(body) - 350)#</span></cfif></em></div>
		<div class="speechBubble-bottom">&nbsp;</div>
		<div style="clear:both;"></div>
	</div>
	</cfoutput>
	
	
	<cfelse>
	<!--- <strong style="color:white">** No Comments Posted **</strong> --->
	<div class="commentMeta"><br />
		<strong>VELMA WARE:</strong>
		</div>
		<div class="speechBubble"><strong></strong>
		<br />
		<em  style="color:white;">"I think it would be a great idea to add a Stop Sign at the gatehouse."</em><br />
		<em>Posted: September 24, 2015  8:25am</em>
		<div class="speechBubble-bottom">&nbsp;</div>
		<div style="clear:both;"></div>
	</div>

	<div class="commentMeta"><br />
		<strong>BARB NELLIS:</strong>
		</div>
		<div class="speechBubble"><strong></strong>
		<br />
		<em  style="color:white;">"Great idea, Velma!  I agree."</em><br />
		Posted: September 24, 2015  8:49 AM
		<div class="speechBubble-bottom">&nbsp;</div>
		<div style="clear:both;"></div>
	</div>

	<div class="commentMeta"><br />
		<strong>JANE TIERNEY:</strong>
		</div>
		<div class="speechBubble"><strong></strong>
		<br />
		<em  style="color:white;">"How about a community garage sale this winter?"</em><br />
		Posted: September 27, 2015  12:42pm<div class="speechBubble-bottom">&nbsp;</div>
		<div style="clear:both;"></div>
	</div>
	</cfif>
	</div>
	
</div>
	

</div>

<script>
	$(document).ready(function(){
		$('.morelink a').click(function(){
			$(this).closest('.speechBubble').find('.morecontent').show();
			$(this).hide();
		});
	});
</script>
