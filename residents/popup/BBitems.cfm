<cfinclude template="header.cfm">
 <script type="text/javascript">
   $(document).ready(function(){
		$('#postAdButton').click(function(e){
			e.preventDefault();
 			$('#listings').hide();
			$('#postForm').show();
		});	
	});
 </script>

<cfquery datasource="#datasource#" name="qBB">
	select bb.bbid,bb.label,bb.insertdate,bb.body, r.r_fname, r.r_lname, r.r_id
	from residentBB bb join residents r on bb.r_id = r.r_id
	join communities c on c.c_id = r.c_id
	where 	
	<cfif isDefined('url.cat')>category_id = <cfqueryparam value="#val(url.cat)#" cfsqltype="CF_SQL_INTEGER" /><cfelse>category_id <> 99</cfif>
	<!--- and c.c_id = <cfqueryparam value="#val(session.user_community)#" cfsqltype="CF_SQL_INTEGER" /> --->
	order by insertdate desc
</cfquery>

<div class="modal-body row-fluid">
	 
	  <div class="form-group">
		<div class="col-sm-12 col-md-12"><cfparam name="url.cat" default="0" />
		<a ahref="bbitems.cfm" class="btn btn-xs <cfif NOT val(url.cat)>btn-info<cfelse>btn-default</cfif>">All Ads</a>	
		<a ahref="bbitems.cfm?cat=1" class="btn btn-xs <cfif val(url.cat) eq 1>btn-info<cfelse>btn-default</cfif>">Real Estate</a>
		<a ahref="bbitems.cfm?cat=2" class="btn btn-xs <cfif val(url.cat) eq 2>btn-info<cfelse>btn-default</cfif>">  &nbsp;&nbsp;Vehicles  &nbsp;&nbsp;</a>
		<a ahref="bbitems.cfm?cat=3" class="btn btn-xs <cfif val(url.cat) eq 3>btn-info<cfelse>btn-default</cfif>">  &nbsp;&nbsp;Pets  &nbsp;&nbsp;</a>
		<a ahref="bbitems.cfm?cat=5" class="btn btn-xs <cfif val(url.cat) eq 5>btn-info<cfelse>btn-default</cfif>">  &nbsp;&nbsp;Services  &nbsp;&nbsp;</a>		
		<a ahref="bbitems.cfm?cat=6" class="btn btn-xs <cfif val(url.cat) eq 6>btn-info<cfelse>btn-default</cfif>">  &nbsp;&nbsp;Jobs  &nbsp;&nbsp;</a>
		<a ahref="bbitems.cfm?cat=4" class="btn btn-xs <cfif val(url.cat) eq 4>btn-info<cfelse>btn-default</cfif>">  &nbsp;&nbsp;Other  &nbsp;&nbsp;</a>
		<!---<a href="bbitems.cfm?cat=7">  &nbsp;&nbsp;Wanted  &nbsp;&nbsp;</a>
		<a ahref="bbitems.cfm?cat=8">  &nbsp;&nbsp;Needed  &nbsp;&nbsp;</a> --->
		</div>
	  </div>
	
	<cfif qBB.recordcount><br />
	<cfoutput query="qBB">
	<div class="row">
		<div class="col-md-4 classifiedMeta">
			<strong>#ucase(r_lname)#, #ucase(r_fname)# </strong><br />
			<em>(<cfif dateCompare(dateAdd('d',-1,now()),insertdate) eq 0>#timeFormat(insertdate)#<cfelse>#dateFormat(insertdate,'m/d/yyyy')#</cfif>)</em>
		</div>
		<div class="col-md-8">
			<div class="well">
				<strong>#ucase(label)#</strong>
				<cfif r_id eq session.user_id>
					<div class="manageBBitem"><a href="action/BBcomments.cfm?itemtodelete=#bbid#">delete</a></div>
				</cfif>
				<br />#body#&nbsp;
			</div>
		</div>
	</div>
	</cfoutput>
	<cfelse>
	<strong style="color:white">** No Classifieds Posted **</strong>
	</cfif>
	
		<div id="postForm" style="display:none;">		
			<form action="action/BBcomments.cfm" method="post">
			<label style="display:block;width: 100%;text-align:left;"><strong>Select Category:</strong>
			<blockquote>			
			<input type="radio" name="category_id" value="1"> Real Estate <br />
			<input type="radio" name="category_id" value="2"> Vehicles <br />
			<input type="radio" name="category_id" value="3"> Pets <br />
			<input type="radio" name="category_id" value="4"> Items For Sale <br />
			<input type="radio" name="category_id" value="5"> Services <br />
			<input type="radio" name="category_id" value="6"> Jobs / Employment <br />
			<!--- <input type="radio" name="category_id" value="7"> Wanted <br />
			<input type="radio" name="category_id" value="8"> Needed --->
			</blockquote>
			</label>
				<label style="display:block;width: 100%;text-align:left;"><strong>Title:</strong> <br />
				<input type="text" style="width:100%;" name="label"><br /></label><br />
				<label style="display:block;width: 100%;text-align:left;">
				<strong>Listing:</strong><br />
				<textarea style="width: 100%" rows="6" name="body"></textarea>
				</label><br />
				<label style="display:block;width: 100%;text-align:left;"><strong>Contact:</strong> <br />
				<input type="text" style="width:100%;" name="contact"><br /></label><br />
				
				<label style="display:block;width: 100%;text-align:left;"><strong>Duration:</strong> <blockquote>
				<input type="radio" name="durationDays" value="7"> 7 days <br />
				<input type="radio" name="durationDays" value="14"> 14 days <br />
				<input type="radio" name="durationDays" value="30"> 30 days <br />
				<input type="radio" name="durationDays" value="60"> 60 days <br />
				<input type="radio" name="durationDays" value="90"> 90 days </blockquote></label>				
				<input type="submit" name="Post">
			</form>
		</div>
		
</div>
