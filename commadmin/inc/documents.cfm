<cfoutput>
	<h2 style="font: 16px 'Trebuchet MS', sans-serif;font-weight:bold;">Documents</h2>
		<p style="font-size:1.2em">Uploaded files are viewable on the Resident Control Panel.
				<ul><li> To ADD a new document, click ADD DOCUMENT and upload the file.</li>
				<li>To REMOVE a document, click on the "x".</li>
				<li> To view an existing document, click on the file name. <br /></li>	</ul></p>
		<div class="accordion">
			<div style="height:300px;overflow:auto;">
				<h3><a href="##">Documents</a></h3>
						<table width="100%">
							<tr>
							<th class="community">File</th>
							<th>Label</th>
							<th>Remove</th>
						</tr>
							<cfloop query="qDownloads">
							<tr class="#iif(qDownloads.currentrow mod 2,de("dataB"),de("dataA"))#" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qHomesites.currentrow mod 2,de("dataB"),de("dataA"))#'">
								<td align="center"><a href="/uploaddocuments/#qDownloads.filename#" target="_new" style="font-weight:600;">#ucase(qDownloads.filename)#</a></td>
								<td align="center">#label#</td>	
								<td align="center"><a href="processor/download.cfm?deleteitem=#downloadid#"><img src="/images/icons/cancel.png"></td>												
							</tr>
							</cfloop>
						</table>
						<p><a href="forms/adddocument.cfm?height=440&width=410" id="dialog_link" class="thickbox ui-state-default ui-corner-all"><span class="ui-icon ui-icon-newwin"></span>Add Document</a> 
			
			</div><!-- end first accordian block -->
		</div><!-- end of accordian -->
	</cfoutput>	