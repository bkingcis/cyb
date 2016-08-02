<cftry>
  <cfmail to="todd_makeever@yahoo.com,bkingcis@gmail.com" type="html" from="signup@cybatrol.com" subject="New property signup: #session.signup.c_name#">
    New property signup: #session.signup.c_name# <br />
    Number of Units:  #session.signup.HOMESITE_COUNT#<br /><br />

    Admin Name: #session.signup.F_NAME# #session.signup.L_NAME#<br />
    Email: #session.signup.email#<br />
    Phone:  #session.signup.phone#<br /><br />
    
   <cfif isDefined("PaymentOption")> PaymentOption: #PaymentOption#<br /><br /></cfif>


    <a href="http://secure.cybatrol.com/admin/admin.cfm?fa=editCommunity&c_id=#pull_qry.c_id#">View Community</a>
  </cfmail>
  <cfcatch>
      <cfdump var="#cfcatch#"><cfabort>
  </cfcatch>
</cftry>