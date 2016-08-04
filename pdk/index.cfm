 <h1>Hello World</h1>
 Client ID: 5711250dfa29c412008f8077
Client Secret: 8wNZdjCpCZpOaLh7kYP5pJQNQAwJBL0n

<cfhttp url="https://accounts.pdk.io/oauth2/auth" method="post" result="blob">
	<cfhttpparam type="header" name="mimetype" value="text/javascript" />
	<cfhttpparam name="scope" value="openid" type="formfield">
	<cfhttpparam name="email" value="billking@cybatrol.com" type="formfield">
	<cfhttpparam name="password" value="pdk4ker" type="formfield">
	<cfhttpparam name="client_id" value="5711250dfa29c412008f8077" type="formfield">
	<cfhttpparam name="client_secret" value="8wNZdjCpCZpOaLh7kYP5pJQNQAwJBL0n" type="formfield">
	<cfhttpparam name="redirect_uri" value="https://cyb.fusiondevelopers.com/pdk/landing.cfm" type="formfield">
	<cfhttpparam name="response_type" value="code" type="formfield">
</cfhttp>

<cfif isJSoN(blob)>IS JSON
	<cfset bearerTokenResponse = DeserializeJSON(blob)>
	<cfif isDefined("bearerTokenResponse.access_token")>
		<cfset authorization2 = "Bearer " & bearerTokenResponse.access_token>
	<cfelse>
		<cfdump var="#bearerTokenResponse#">
	</cfif>
<cfelse>NOT JSON - DATA
	<cfdump var="#blob#">
</cfif>


curl 'https://accounts.pdk.io/api/ous/mine' -H 
'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJodHRwczovL2FjY291bnRzLnBkay5pby9yb2xlIjoiYWRtaW4iLCJhdF9oYXNoIjoiX01ZVVdRT3pSM3ZkbkRHQ1NvcWVGZSIsInNjb3BlIjpbIm9wZW5pZCJdLCJub25jZSI6IkVGRzBiZG1lYTVlUXVBZlV4MVhxZGFMZWE1STQzcm0xIiwiaXNMaWNlbmNlQWdyZWVtZW50QWNjZXB0ZWQiOnRydWUsImlhdCI6MTQ3MDE3Mjc5OSwiZXhwIjoxNDcwMTczMDk5LCJhdWQiOlsiaHR0cHM6Ly9hY2NvdW50cy5wZGsuaW8vIiwiNTQ0NTU3NzU5YTAxZGViOTg3NGMwMmVlIl0sImlzcyI6Imh0dHBzOi8vYWNjb3VudHMucGRrLmlvLyIsInN1YiI6IjU3MWU4MmI5ZTY4YjBhMTIwMDhjOGY4MSJ9.xAM7_OEtUwpIp9tU-HPJrHZAN4c5qqtfm_m2RDPuxHDZ6kMlJhggDwxPoVsqzXc5w5NTBi0M6JHszcdZkCrN1K1S2Vmrxa7f6KNCTEj90FA-LLkBXyxIBogGziO76rNgG9dLVr_Gqq4REFarQbNJDPcBAqVlqKxZWhyTxudyumbit7kxvW3ah4DBy9Q1kJaYNsriIwQuOTUQVKbSpmsIW2uKLzy1KCZf16E-cDN95tHDzD5XjPFsSsxFXEdfkkSCZcaDVm9-5IOnI7OmXbykny49AEIFJU6EKy5KmsbR3_SjWLbBsR5O6oTaS6bI3qT1K32Qc4Mv_vKGdtl63UdB6Q' -H 'Origin: https://pdk.io' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36' -H 'Accept: application/json, text/plain, */*' -H 
'Referer: https://pdk.io/systems/mine' -H 
'If-None-Match: W/"1be-9mYxGF7WHxysnTYlzQaZUw"' -H 'Connection: keep-alive' --compressed
<!---<cfhttp url="https://accounts.pdk.io/api/ous/mine" method="post" result="blob">
	<cfhttpparam type="header" name="mimetype" value="text/javascript" />
	<cfhttpparam name="scope" value="openid" type="formfield">
	<cfhttpparam name="client_id" value="5711250dfa29c412008f8077" type="formfield">
	<cfhttpparam name="client_secret" value="8wNZdjCpCZpOaLh7kYP5pJQNQAwJBL0n" type="formfield">
	<cfhttpparam name="redirect_uri" value="https://secure.cybatrol.com/pdk/landing.cfm" type="formfield">
	<cfhttpparam name="response_type" value="code" type="formfield">
</cfhttp> ---->

	<cfabort>


<!-- 
curl 'https://accounts.pdk.io/api/ous/mine' -H 'If-None-Match: W/"1aa-BlIuJjTNB+Mj/sGZyrfYnQ"' -H 'Origin: https://pdk.io' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: en-US,en;q=0.8' -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJodHRwczovL2FjY291bnRzLnBkay5pby9yb2xlIjoiYWRtaW4iLCJhdF9oYXNoIjoiQVJQWnFsczUyWW9sanY1bUxyUmRCeiIsInNjb3BlIjpbIm9wZW5pZCJdLCJub25jZSI6ImtHcEpOc0ZZWHNrMldEQ2pYQWdUaFNlV2VnVFpRdFlHIiwiaXNMaWNlbmNlQWdyZWVtZW50QWNjZXB0ZWQiOnRydWUsImlhdCI6MTQ2NTg3OTQ4NSwiZXhwIjoxNDY1ODc5Nzg1LCJhdWQiOlsiaHR0cHM6Ly9hY2NvdW50cy5wZGsuaW8vIiwiNTQ0NTU3NzU5YTAxZGViOTg3NGMwMmVlIl0sImlzcyI6Imh0dHBzOi8vYWNjb3VudHMucGRrLmlvLyIsInN1YiI6IjU3MWU4MmI5ZTY4YjBhMTIwMDhjOGY4MSJ9.zFX8rjxq0VDYHzlc7AXy5I7gOySJ8SOinh1L5tq9AjnK-hpkHOxNdqxdlojHfo-0btdsAsw5d322mpEXBHbbxdnXR0K9MuP-Y66HY-14aei0ldufQzAf0-hkDh1-t-IKsVrzi8LlcYU-n7vuAddASi7R3Ze_ZIHk18_IJ3JB-9IY4ZFCJHfwvUp9m3mVH1TfZeUR8F1uZw0w7nbCdRPpCsCe4Qz7UnWLVZLNWgmrl-_EY03MmYHsIUcNwfKiBGk484F3yqDzB55Rq1AHX0WAMf44BmeAl3MSc9dmSL4iECG2u03TTUMtTzKMKjowKoVCh90dTf-CA38ZORG63VaAZw' -H 'Accept: application/json, text/plain, */*' -H 'Referer: https://pdk.io/systems/mine' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36' -H 'Connection: keep-alive' --compressed
-->

<!--- TO DO:
So, the overall steps to unlock a door are:

1. Get an ID Token (this is done once to link to the customer’s account):
 - Do browser redirect and retrieve the authorization code
 - Send a POST request to /oauth2/token with the authorization code in the body
 - Retrieve id_token from the JSON response
2. Get a Panel API token (these tokens expire frequently and must be renewed as needed):
 - Send a PUT request to accounts.pdk.io/panels/{panel-id}/token, with the id_token in the authorization header
 - Get the panel_api_token from the JSON response
3. Connect to websocket server:
 - var ioSocket = io.connect("https://panel-{id}.pdk.io/api",  {query : "token=panel_api_token”})
4. Send unlock command to websocket:
 - ioSocket.emit('command', { topic: 'door.actuate.open', body: { doorId: 10 } }); 
 --->
