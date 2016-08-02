<cfoutput>
	<form class="form-horizontal" role="form" method="post" action="?action=#xfa.submit#" enctype="multipart/form-data">	
		<p>Use this page to upload a list of your residents.  Please add exactly one line per household.</p>
		<fieldset>
			<legend>Select a file to upload (XLS or CSV format only):</legend>
			 <p style="display:inline-block;max-width:720px;margin-bottom:25px;"></p> 
			<div class="form-group">
				<label for="FileContents" class="col-sm-2 control-label">Select File:</label>
				<div class="col-sm-3">
					<input type="file" class="form-control" name="FileContents" />
				</div>
			</div>
		  <fieldset/>
		  <fieldset>
		  	<p><a href="/userfiles/uploadTest.xls">Click here to download an example template file.</a></p>
		  </fieldset>
	  <div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		  <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-left"></span> BACK</button>
		  <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-right"></span> SKIP</button>
		  <button type="submit" class="btn btn-primary">UPLOAD & CONTINUE</button>
		</div>
	  </div>
	</form>
</cfoutput>