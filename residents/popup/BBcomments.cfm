<cfinclude template="header.cfm">

<div class="modal-body row-fluid">
	<!--- <cfquery datasource="#datasource#" name="qBB">
		delete from residentBB 
		where body = 'We have to test.'
	</cfquery> --->
	<cfquery datasource="#datasource#" name="qBB">
		select bb.bbid,bb.label,bb.insertdate,bb.body, r.r_fname, r.r_lname, r.r_id
		from residentBB bb join residents r on bb.r_id = r.r_id
		join communities c on c.c_id = r.c_id
		where category_id = 99
		<!--- AND c.c_id = <cfqueryparam value="#val(session.user_community)#" cfsqltype="CF_SQL_INTEGER" /> --->
		order by insertdate desc
	</cfquery>

<div id="listings">

<!--- height: 300px; overflow: auto; --->
	<div style="padding: 0px;">
	<cfif qBB.recordcount>
	<cfoutput query="qBB">
	<div class="well">
		<div class="commentMeta" class="col-sm-2 col-md-2">
			<strong>#ucase(r_lname)#, #ucase(r_fname)#</strong><br />
			<em>(<cfif dateCompare(dateAdd('d',-1,now()),insertdate) eq 0>#timeFormat(insertdate)#<cfelse>#dateFormat(insertdate,'m/d/yyyy')#</cfif>)</em>
		</div>
		<div class="speechBubble" class="col-sm-8 col-md-8"><strong>#ucase(label)#</strong><cfif r_id eq session.user_id><div class="manageBBitem"><a href="action/BBcomments.cfm?itemtodelete=#bbid#">x delete</a></div></cfif>
		<br />
		<em>#left(body, 350)#<span class="morelink"><cfif len(body) gt 800>...<a href="Javascript: void(0);">more</a></span><span class="morecontent" style="display:none;">#mid(body, 351, len(body) - 350)#</span></cfif></em></div>
		<div class="speechBubble-bottom">&nbsp;</div>
		<div style="clear:both;"></div>
	</div>
	</cfoutput>
	<cfelse>
	<strong>** No Comments Posted **</strong>
	</cfif>
	</div>
	
	<div id="postForm" style="display:none;">		
		<form action="BBcomments.cfm" method="post">
			<input type="hidden" name="category_id" value="99">
			<label style="display:block;width: 100%;text-align:left;"><strong>Title: </strong><br />
				<input type="text" style="width:100%;" name="label"><br /><br /></label>
			<label style="display:block;width: 100%;text-align:left;">
			<strong>Comment:</strong><br />
			<textarea style="width: 100%" rows="9" name="body"></textarea>
			</label><br /><br /><br />
			
			<input type="button" tabindex="99" name="Cancel" Value="Cancel" onclick="window.location='BBcomments.cfm';"> 
			<input type="submit" name="Submit" value="Submit">
		</form>
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
