
	<cfoutput>
		<div class="accordion">
			<div>
				<h3><a href="##">Photo Gallery</a></h3>
				<div style="height:300px;overflow:auto;">
				<table width="100%">
					<tr>
					<th class="community">File</th>
					<th>Caption</th>
					<td></td>
				</tr>
					<cfloop query="qGallery">
					<tr class="#iif(qGallery.currentrow mod 2,de("dataB"),de("dataA"))#" onmouseover="this.className='rowHover'" onmouseout="this.className='#iif(qGallery.currentrow mod 2,de("dataB"),de("dataA"))#'">
						<td align="center"><a href="/uploadimages/gallery/#filename#" class="thickbox" style="font-weight:600;">#qGallery.filename#</a></td>
						<td align="center">#caption#</td>
						<td align="center"><a href="processor/galleryphoto.cfm?deleteitem=#galleryitemid#"><img src="/images/icons/cancel.png"></td>						
					</tr>
					</cfloop>
				</table>
				<p><a href="forms/addgalleryphoto.cfm?height=440&width=410" id="dialog_link" class="thickbox ui-state-default ui-corner-all"><span class="ui-icon ui-icon-newwin"></span>Add Photo</a> 
			
				</div>
			</div><!-- end first accordian block -->
		</div><!-- end of accordian -->
	</cfoutput>	