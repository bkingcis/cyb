  <cftry>    
    <cfquery datasource="#request.dsn#" name="visitor_list">
				select g.g_lname,g.g_fname,gv.v_id,s.visit_date
				from   guests g join guestvisits gv on g.g_id = gv.g_id
            join schedule s  on s.v_id = gv.v_id
				where  g.r_id = #session.user_id#
				and    s.visit_date >= #CreateODBCDate(now())#
        order by s.visit_date, gv.v_id <!--- g_lname, g_fname  --->
		</cfquery>
			<div class="form-group row">
				<label for="jumpto" class="col-lg-offset-2 col-sm-3 col-lg-3 control-label text-right">List of <cfoutput>#labels.visitor#</cfoutput>s:</label>
        <div class="col-sm-5 col-lg-5">
          <select id="jumptoDropdown" name="jumpto" class="form-control">
            <option>  - choose - </option>
            <cfoutput query="visitor_list" group="v_id">
							<cfset month_string = left(monthAsString(month(visit_date)),3)>
							<cfset list_of_dates = ''>
							<!--- internal loop/grouping of dates for this visit  --->
							<cfoutput><cfset list_of_dates = listAppend(list_of_dates,left(monthAsString(month(visit_date)),3) & ' ' &  day(visit_date))></cfoutput>
										<!--- format the date for the dropdown --->
							<cfsavecontent variable="date_range_this_visitor">
								#listFirst(list_of_dates)#
								<cfif listLen(list_of_dates) gt 1>
								 to
									<cfif left(listLast(list_of_dates),3) eq month_string>
											#Replace(listLast(list_of_dates),month_string,'')#
									<cfelse>
											#listLast(list_of_dates)#
									</cfif>
								</cfif>
							</cfsavecontent>
							
							<option value="#dateFormat(visit_date,'yyyymd')#" data-vid="#v_id#" data-toggle="modal" data-target="##baseModal" data-action="modifyschedule2" data-vid="#v_id#">
								#g_fname# #g_lname# (#trim(date_range_this_visitor)#)
							</option>
				
            </cfoutput>
          </select>
        </div>
      </div>
    <cfcatch><cfdump var="#cfcatch#"></cfcatch>
   </cftry>
   
   <script type="text/javascript">
        $(function () {
            //Attach click event to your Dropdownlist
            $("#jumptoDropdown").change(function (event) {
						  
							var $calDayBox = $( "#guestcalbox_" + $(this).val() );
							//console.log($calDayBox);
							$calDayBox.trigger( "click" );
							
               // $this = $(this);
               // $this.data['action'] = 'announce2';
               // $this.data['vid'] =  $(this).val();
               // $('#baseModal').modal('show',function($this){  
               // });
            });
        });
    </script>