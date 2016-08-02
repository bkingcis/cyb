<script>
	    YAHOO.namespace("skin.container");
	
	var handletab2Success = function(o)
		{
			divtoupdate = document.getElementById('homeContent2');
			if(o.responseText !== undefined)
				{
				divtoupdate.innerHTML = o.responseText;
				}
		}
				
	var handletab2Failure = function(o)
		{
		divtoupdate = document.getElementById('homeContent2');
		if(o.responseText !== undefined)
			{
			divtoupdate.innerHTML = "<ul><li>Transaction id: " + o.tId + "</li>";
			divtoupdate.innerHTML += "<li>HTTP status: " + o.status + "</li>";
			divtoupdate.innerHTML += "<li>Status code message: " + o.statusText + "</li></ul>";
			}
		}
		
	YAHOO.skin.container.wait =  
        new YAHOO.widget.Panel("wait",   
            { width:"240px",  
              fixedcenter:true,  
              close:false,  
              draggable:false,  
              zindex:4, 
              modal:true, 
              visible:false 
            }  
        ); 
 	divtoupdate = document.getElementById('homeContent');
					
	YAHOO.skin.container.wait.setHeader("Loading, please wait..."); 
	YAHOO.skin.container.wait.setBody('<img src="http://us.i1.yimg.com/us.yimg.com/i/us/per/gr/gp/rel_interstitial_loading.gif" />'); 
	YAHOO.skin.container.wait.render(divtoupdate); 
					
	var callbacks =
			{
			  success:function(o)
				{
					divtoupdate = document.getElementById('homeContent');
					if(o.responseText !== undefined)
						{
						divtoupdate.innerHTML = o.responseText;
						}
					
			        YAHOO.skin.container.wait.hide(); 
				},
			  failure: function(o) {
			  		divtoupdate = document.getElementById('homeContent');
			        divtoupdate.innerHTML = o.responseText; 
			        divtoupdate.style.visibility = "visible"; 
			        divtoupdate.innerHTML = "CONNECTION FAILED!"; 
			        YAHOO.skin.container.wait.hide(); 
			    } 
			}
			
	var callbacksearch =
			{
			  success:function(o)
				{
					divtoupdate = document.getElementById('homeContent2');
					if(o.responseText !== undefined)
						{
						divtoupdate.innerHTML = o.responseText;
						}
					
			        YAHOO.skin.container.wait.hide(); 
				},
			  failure: function(o) {
			  		divtoupdate = document.getElementById('homeContent2');
			        divtoupdate.innerHTML = o.responseText; 
			        divtoupdate.style.visibility = "visible"; 
			        divtoupdate.innerHTML = "CONNECTION FAILED!"; 
			        YAHOO.skin.container.wait.hide(); 
			    } 
			}
			
	function getVisitCalendar(theDate) {
		YAHOO.util.Connect.asyncRequest('GET',"act/getCalendar.cfm?showDate="+theDate, callbacks);
		YAHOO.skin.container.wait.show();
	}
	
	function getReport(theDate) {
		YAHOO.util.Connect.asyncRequest('GET',"act/getReport.cfm", callbacks);
		YAHOO.skin.container.wait.show();
	}
	
	function submitForm(url) {//,theForm
		YAHOO.util.Connect.asyncRequest('GET',url,callbacksearch);
		YAHOO.skin.container.wait.show();
	}
	
	function refreshVisitTab() {
		YAHOO.util.Connect.asyncRequest('GET',"act/getVisitTab.cfm", callbacks);
		YAHOO.skin.container.wait.show();
	}
	
	function refreshSearchTab() {
		YAHOO.util.Connect.asyncRequest('GET',"act/getSearchTab.cfm", callbacksearch);
		YAHOO.skin.container.wait.show();
	}
</script>
<cfoutput>
<p style="margin: 0px;padding:0px;">Capture Period: January 01, 2008 12:00:00am – March 31, 2008 11:59:59</p>
<p style="font-family:Arial;font-size:14px;text-align:left;margin-left: 100;">Guest Reporting</p>

<div id="bottomContainer">
	<ul id="Tab1" class="homeShadeTabs">
		<li class="selected"><a href="##" rel="monthbymonthTab">Visit Count</a></li>
		<li class="selected"><a href="##" rel="searchTab">Visitor Search</a></li>
		<li class="selected"><a href="##" rel="messagesTab">Stored Messages</a></li>		
		<li class="selected"><a href="##" rel="noshowsTab">No Shows</a></li>
	</ul>
	<div class="homeTabsStyle">
		<!--- First Tab --->
		<div id="monthbymonthTab" class="tabcontent">
			<div id="homeContent">
				<p>Choose a link below to drill-down to the date for visitors for a specific date.
			 	<ul>
				<cfoutput><cfloop from="-3" to="0" step="1" index="monthAdd">
				<li><a href="javascript:getVisitCalendar('#month(dateAdd("m",monthAdd,now()))#/1/#year(dateAdd("m",monthAdd,now()))#');">1,222 
				Visits for #monthasstring(month(dateAdd("m",monthAdd,now())))# #year(dateAdd("m",monthAdd,now()))#</a><br /><br /></li>
			 	</cfloop></cfoutput>
				</ul>
				</p>
			</div>
		</div>	
		<!-- Second Tab -->
		<div id="searchTab" class="tabcontent">
			<div id="homeContent2">
			<strong>Search Guest Visits Database</strong>
			<form action="admin.cfm?fa=submitCaptureSearch" method="post">
				<table>
					<tr>
						<td><input type="checkbox"></td>
						<td><strong>Resident Name</strong></td>
						<td>Last <input type="text"> First <input type="text"> </td>
					</tr>
					<tr>
						<td><input type="checkbox"></td>
						<td><strong>Guest Name</strong></td>
						<td>Last <input type="text"> First <input type="text"> </td>
					</tr>
					<tr>
						<td><input type="checkbox"></td>
						<td><strong>Resident Address</strong></td>
						<td>House Number <input type="text"> Street Name <input type="text"></td>
					</tr>
					<tr>
						<td><input type="checkbox"></td>
						<td><strong>Include No Shows</strong></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td><input type="checkbox"></td>
						<td><strong>Staff Member</strong></td>
						<td>Employee Number <input type="text"> Staff Name <input type="text"></td>
					</tr>
					<tr>
						<td><input type="checkbox"></td>
						<td><strong>Entry Point</strong></td>
						<td><input type="text"></td>
					</tr>
					<tr>
						<td><input type="checkbox"></td>
						<td><strong>Search Date</strong></td>
						<td>From 
			              <select name="frommonth" id="frommonth" class="field">
			                <option value="01">January</option>
			                <option value="02">February</option>
			                <option value="03" selected>March</option>
			                <option value="04">April</option>
			                <option value="05">May</option>
			                <option value="06">June</option>
			                <option value="07">July</option>
			                <option value="08">August</option>
			                <option value="09">September</option>
			                <option value="10">October</option>
			                <option value="11">November</option>
			                <option value="12">December</option>
			              </select> <select name="fromday" id="fromday" class="field">
			                <option>01</option>
			                <option>02</option>
			                <option>03</option>
			                <option>04</option>
			                <option>05</option>
			                <option>06</option>
			                <option>07</option>
			                <option>08</option>
			                <option>09</option>
			                <option>10</option>
			                <option>11</option>
			                <option>12</option>
			                <option>13</option>
			                <option>14</option>
			                <option>15</option>
			                <option>16</option>
			                <option>17</option>
			                <option>18</option>
			                <option>19</option>
			                <option>20</option>
			                <option>21</option>
			                <option>22</option>
			                <option>23</option>
			                <option>24</option>
			                <option>25</option>
			                <option>26</option>
			                <option>27</option>
			                <option>28</option>
			                <option>29</option>
			                <option selected>30</option>
			                <option>31</option>
			              </select> <select name="fromyear" id="fromyear" class="field">
			                <option>2003</option>
			                <option>2004</option>
			                <option>2005</option>
			                <option>2006</option>
			                <option>2007</option>
			                <option selected>2008</option>
			                <option>2009</option>
			                <option>2010</option>
			                <option>2011</option>
			                <option>2012</option>
			                <option>2013</option>
			              </select>
			              to 
			              <select name="tomonth" id="tomonth" class="field">
			                <option value="01">January</option>
			                <option value="02">February</option>
			                <option value="03" selected>March</option>
			                <option value="04">April</option>
			                <option value="05">May</option>
			                <option value="06">June</option>
			                <option value="07">July</option>
			                <option value="08">August</option>
			                <option value="09">September</option>
			                <option value="10">October</option>
			                <option value="11">November</option>
			                <option value="12">December</option>
			              </select> <select name="today" id="today" class="field">
			                <option>01</option>
			                <option>02</option>
			                <option>03</option>
			                <option>04</option>
			                <option>05</option>
			                <option>06</option>
			                <option>07</option>
			                <option>08</option>
			                <option>09</option>
			                <option>10</option>
			                <option>11</option>
			                <option>12</option>
			                <option>13</option>
			                <option>14</option>
			                <option>15</option>
			                <option>16</option>
			                <option>17</option>
			                <option>18</option>
			                <option>19</option>
			                <option>20</option>
			                <option>21</option>
			                <option>22</option>
			                <option>23</option>
			                <option>24</option>
			                <option>25</option>
			                <option>26</option>
			                <option>27</option>
			                <option>28</option>
			                <option>29</option>
			                <option selected>30</option>
			                <option>31</option>
			              </select> <select name="toyear" id="toyear" class="field">
			                <option>2003</option>
			                <option>2004</option>
			                <option>2005</option>
			                <option>2006</option>
			                <option>2007</option>
			                <option selected>2008</option>
			                <option>2009</option>
			                <option>2010</option>
			                <option>2011</option>
			                <option>2012</option>
			                <option>2013</option>
			              </select></td>
			        </tr>
					<tr>
						<td><input type="checkbox"></td>
						<td><strong>Access Time</strong></td>
						<td>From <input type="text" value="6:00" size="4"><select><option selected>AM<option>PM</select> To <input type="text" value="11:59"  size="4"><select><option>AM<option selected>PM</select></td>
					</tr>
					<tr>
						<td><input type="checkbox"></td>
						<td><strong>Dashpass Number</strong></td>
						<td><input type="text"></td>
					</tr>
				  	<tr>
						<td colspan="3" align="right"><input type="Reset" tabindex="99" value="Clear All">
						<input type="Button" value="Submit Search" onclick="submitForm('act/getSearchResults.cfm')"></td>
						<!--- if(objForm.submitCheck()){ submitForm('/mailform/',this.form)}--->
					</tr>
				  	</table>
				</form>
			</div>
		</div>
		<!-- Third Tab -->
		<div id="messagesTab" class="tabcontent">
			<div id="homeContent3">
				<div class="messageLeft"><strong>Staff Sign-in Messages</strong><br>
					<div style="width: 350px; height: 250px; overflow-y: scroll; border: 1px solid ##043A5E;">
					<table class="tableData">
						<tr>
							<td nowrap>3/17/08 - 3/24/08</td>
							<td><a href="">Message About Special Event</a></td>
						</tr>
						<tr class="rowon">
							<td nowrap>2/4/08</td>
							<td><a href="">Groundhog Day Party in Main Club House</a></td>
						</tr>
					</table>
					</div>
				</div>
				<div class="messageRight">Resident Sign-in Messages
					<div style="width: 350px; height: 250px; overflow-y: scroll; border: 1px solid ##043A5E;">
					<table class="tableData">
						<tr>
							<td nowrap>3/17/08 - 3/24/08</td>
							<td><a href="">Parking Lot Lines Painted</a></td>
						</tr>
						<tr class="rowon">
							<td nowrap>2/4/08</td>
							<td><a href="">High-Alert Announcement</a></td>
						</tr>
					</table>
					</div>
				</div>
			</div>
		</div>	
		<!-- Fourth Tab -->
		<div id="noshowsTab" class="tabcontent">
			<div id="homeContent4">
				<table class="tableData">
					<tr><th>Guest Name</th><th>Expected Date(s)</th><th>Resident Name</th><th>Resident Address</th><th>Resident Phone</th></tr>
					<tr>
						<td>Fredrick Johnson</td>
						<td>3/17/08 - 3/24/08</td>
						<td>Smith, Carol</td>
						<td>&nbsp;1800 Vanueys Pkwy, Unit ##789&nbsp;</td>
						<td>&nbsp;567.987.432&nbsp;1</td>
					</tr>
					<tr class="rowon">
						<td>Lloyd Weber</td>
						<td>2/4/08</td>
						<td>Smith, Carol</td>
						<td>&nbsp;1800 Vanueys Pkwy, Unit ##456&nbsp;</td>
						<td>&nbsp;567.987.432&nbsp;1</td>
					</tr>
					<tr>
						<td>Angie Smith</td>
						<td>1/14/08 - 1/15/07</td>
						<td>Arment, Thomas</td>
						<td>&nbsp;1800 Vanueys Pkwy, Unit ##212&nbsp;</td>
						<td>&nbsp;567.987.432&nbsp;1</td>
					</tr>
					<tr class="rowon">
						<td>David Crocket</td>
						<td>12/24/07 - 1/3/08</td>
						<td>Arment, Thomas</td>
						<td>&nbsp;1800 Vanueys Pkwy, Unit ##900&nbsp;</td>
						<td>&nbsp;567.987.432&nbsp;1</td>
					</tr>
				</table><br>
				<br>
				
			</div>
		</div>	
				
	</div>
</div><script type="text/javascript">
	initializetabcontent("Tab1");
</script></cfoutput>