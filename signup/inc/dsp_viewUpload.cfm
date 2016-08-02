<cfoutput>

	<cfloop
		index="intSheet"
		from="1"
		to="1"
		step="1"><!--- to="#ArrayLen( arrSheets )#" this was originally set for looping over the SHEET NAMES --->
		
		<!--- Get a short hand to the current sheet. --->
		<cfset objSheet = arrSheets[ intSheet ] />
		<!--- 
			Output the name of the sheet. This is taken from 
			the Tabs at the bottom of the workbook.
		--->
		<br />
		<div class="container">
		<form class="form-horizontal" role="form" method="post" action="?action=#xfa.submit#">	
		
		<fieldset>
		<div class="row">
			<div  class="col-sm-11 col-med-10">
			<div class="well">
				<strong>Congratulations!  We were able to process Sheet Named <em>#objSheet.Name#</em></strong>
			</div>
			</div>
		</div>
		
		<cfset session.custDataQuery = objSheet.Query>
		
		<div class="row">
			<div class="col-sm-11 col-med-10">
			<strong>- Your first few rows are displayed below.</strong>
			<p>Select the fieldname that best matches you column value below.  [If your data does not look right, try reviewing and saving the file as another format (.XLS or .CSV)]</p>
			</div>
		</div>
		</fieldset>
		<fieldset>
		<table border="1" class="table">
			<tr><cfset index=0>
				<cfloop list="#objSheet.Query.columnList#" index="colname">
				<cfset index=index+1>
				<td>
					<select class="form-control" name="colMapCol#index#">
						<option value="r_fname">First Name</option>						
						<option value="r_lname">Last Name</option>											
						<option value="r_email">Email</option>
						<option value="r_phone">Phone</option>
						<option value="h_address1">Building Address</option>
						<option value="h_unit">Unit/Apt Number</option>
					</select>
				</td>
				</cfloop>
			</tr>
			<tr>
				<cfloop array="#objSheet.ColumnNames#" index="col">
					<th>
						#col#
					</th>
				</cfloop>
			</tr>
				
		<cfloop query="objSheet.Query" startrow="1" endrow="5">
			<tr>
			<cfloop list="#objSheet.Query.columnList#" index="colname">
				<cfif Len( objSheet.Query[colname][currentRow] )>
					<td>
						#objSheet.Query[colname][currentRow]#
					</td>
				<cfelse>
				<td> null </td>
				</cfif>
			</cfloop>
			</tr>
		</cfloop>
			
		</table>
	</cfloop><!--- END OF SHEETS LOOP --->
	</fieldset>
	<div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		  <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-left"></span> BACK</button>
		  <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-right"></span> SKIP</button>
		  <button type="submit" class="btn btn-primary">CONTINUE</button>
		</div>
	  </div>
	</form>
	</div>
</cfoutput>