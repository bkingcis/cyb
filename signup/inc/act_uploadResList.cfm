<cfset doProcess = true>
<!--- Check to see if the Form variable exists. ---> 
<cfif isDefined("Form.FileContents") > 
	<cftry>
		<!--- If TRUE, upload the file. --->
		<cffile action = "upload" 
			fileField = "FileContents" 
			destination = "#ExpandPath( "/userfiles/" )#"  
			accept = "text/csv,text/html,application/vnd.ms-excel,application/octet-stream" 
			nameConflict = "MakeUnique"
			result="theUpload"> <!---XSLX Format (Not used):  application/vnd.openxmlformats-officedocument.spreadsheetml.sheet --->
			<cfset newfile = theUpload.serverfile>
			<cfset doProcess = listLast(newfile,".")>
		<cfcatch>
			<!--- <cfdump var="#cfcatch#"> --->
			<blockquote><strong>Your file could not be processed.  Please be sure that it is in ".CSV" or ".XLS" format.</strong>
			</blockquote>
			<cfset doProcess = false>
		<form><div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		  <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-left"></span> BACK</button>
		</div> </div>
		</form>
		</cfcatch>
	</cftry> 
<cfelse> 
   <div class="container"><form>
   <h3>Error: Invalid Signup Path</h3>
   <a href="/signup/?action=addResidents_view">Click here</a> to return to the Resident Upload form.
  </form> </div>
</cfif>

