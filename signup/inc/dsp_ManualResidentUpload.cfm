<cfoutput>
	<form class="form-horizontal" role="form" method="post" action="?action=#xfa.submit#">	
		<h1>Your Community</h1>
		<fieldset>
			<h3>LET'S GET YOU SET-UP!</h3>
			<h4>What you will need before we begin:</h4>
				<ul>
					<li>   The physical address (mailing address) for each residence within your community.</li>
					<li>   The names of each resident user residing in the residence (who has the authority to announce guests into your community).</li>
					<li>    The email address of each resident user.</li>
					<li>    The names of every Personnel (Staff) who manage the community entry point(s).</li>
					<li>   An email address for each of the Personnel (Staff) that is listed.</li>
					<li>   Upload Resident and Personnel Data (in the format provided):</li>
				</ul>
			<div class="form-group">	
				<label>Resident Data:</label> <input type="file" name="file_residentData"> 			
				<label>Personnel (Staff) Data:</label> <input type="file" name="file_residentData"> 
			</div>
			
			<h2>Or, Manually enter data for each Resident and Personnel user.</h2>
				Resident User Information:<p>

Enter the Physical Address (mailing address) for every residence within your community then add each 

resident user’s information.

Street Address (information field), City (information field), State (information field), Zip code 

(information field)

Resident Last Name (information field), Resident First Name (information field), Resident Email Address 

(information field)

ADD USER (button to add an additional user WITHIN the address)

NEXT ADDRESS (button to load the users to the address and move to the next address)

SAVE (button to save all inputted data)

Personnel (Staff) Information:

Enter the Names and Email addresses for all personnel who manage the community entry point(s).

An instruction letter will be emailed to each person.

Last Name (information field), First Name (information field) and Email Address (information field)

ADD USER (button - create new fields for additional personnel users)

DONE (button to continue when all names are added)

COMMUNITY ADMIN USER'S HOME PAGE:

Combine the "Community Admin" functions and the Staff Home Page.

- Add/Edit Home sites

- Add/Edit Additional Users

- add/Edit Staff Users

- Resident Log in Banner

- Staff Log in Banner

- DashPass Message LEFT

- DassPass Message RIGHT

- Add/Edit Community Documents
			 </div>
		  <fieldset/>		
	  <div class="form-group">
		<div class="col-sm-offset-8 col-sm-10">
		  <button type="button" id="btn_back" class="btn btn-default">
	 	 	<span class="glyphicon glyphicon-arrow-left"></span> BACK</button>
		  <button type="submit" class="btn btn-primary">CONTINUE</button>
		</div>
	  </div>
	</form>
</cfoutput>