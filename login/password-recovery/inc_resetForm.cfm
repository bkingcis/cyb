<form class="form" id="LoginFrm" action="index.cfm" method="post">
  <p></p>
  <fieldset>
    <legend>User Secured Access</legend>
    <cfif !qVerifyToken.recordcount>
      <h3>Invalid token.  Could not process your password update request.</h3>
      <a href="http://cybatrol.com"><span class="glyphicon glyphicon-arrow-left"></span> Return to Cybatrol Home Page</a>
    <cfelse>
      <cfoutput>
      <input type="hidden" name="token" value="#token#">
      <input type="hidden" name="login_type" value="#login_type#">
      </cfoutput>
      <p>Enter a new password for your account.  Passwords must be at least eight 
      characters and contain, at least, one letter and one number.</p>
      <div class="form-group row">
        <label for="pass1" class="col-sm-2 control-label">Password:</label>
        <div class="col-sm-3  col-md-3">
          <input type="password" class="form-control" name="pass1" />
        </div>
      </div>
      <div class="form-group row">
        <label for="pass2" class="col-sm-2 control-label">Password Confirm:</label>
        <div class="col-sm-3 col-md-3">
          <input type="password" class="form-control" name="pass2" />
          <br />
        </div>
      </div>
      <div class="form-group">
        <div class="col-sm-offset-2 col-sm-4 col-md-offset-2 col-md-4">
          <button id="btn_continue" type="submit" class="btn btn-primary">Save New Password</button>
        </div>
      </div>
    </cfif>
  <fieldset/>	
</form>