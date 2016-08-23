 <!-- include/247Access -->
 <cfoutput>
  <div class="panel panel-default">
      <div class="panel-heading">
          <i class="fa fa-play fa-fw"></i> <cfoutput>#labels.permanent_visitor# #labels.visitor#s</cfoutput>
          <div class="pull-right">
              <div class="btn-group">
                  <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown">
                      Actions
                      <span class="caret"></span>
                  </button>
                  <ul class="dropdown-menu pull-right" role="menu">
                      <li><a href="##">Action</a>
                      </li>
                      <li><a href="##">Another action</a>
                      </li>
                      <li><a href="##">Something else here</a>
                      </li>
                      <li class="divider"></li>
                      <li><a href="##">Separated link</a>
                      </li>
                  </ul>
              </div>
          </div>
      </div>
      <!-- /.panel-heading -->
      <div class="panel-body">
          <div class="row">
               <div class="table-responsive">
            <table class="table table-bordered table-hover table-striped">
                <thead>
                    <tr>
                        <th>#labels.Visitor#</th>
                        <th>Phone</th>
                        <th>Unit</th>
                        <th>DashPass</th>
                        <th>Action</th>                  
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Bill King</td>
                        <td>303-332-3373</td>
                        <td>1209-F</td>
                        <td>
                          <input type="button" value="print" class="action-btn" onclick="ReissueAndPrintPop(1903,890);">
                          <a href="/staff/popup/emailPass.cfm?g_id=890&amp;v_id=1903" class="extlink action-btn">email</a>
                        </td>
                        <td><input type="button" value="Check-In" class="action-btn" onclick="GuestCheckin(1903,890);"></td>
                    </tr>
                   <tr>
                        <td>Bill King</td>
                        <td>303-332-3373</td>
                        <td>1209-F</td>
                        <td>
                          <input type="button" value="print" class="action-btn" onclick="ReissueAndPrintPop(1903,890);">
                          <a href="/staff/popup/emailPass.cfm?g_id=890&amp;v_id=1903" class="extlink action-btn">email</a>
                        </td>
                        <td><input type="button" value="Check-In" class="action-btn" onclick="GuestCheckin(1903,890);"></td>
                    </tr>
                    <tr>
                         <td>Bill King</td>
                        <td>303-332-3373</td>
                        <td>1209-F</td>
                        <td>
                          <input type="button" value="print" class="action-btn" onclick="ReissueAndPrintPop(1903,890);">
                          <a href="/staff/popup/emailPass.cfm?g_id=890&amp;v_id=1903" class="extlink action-btn">email</a>
                        </td>
                        <td><input type="button" value="Check-In" class="action-btn" onclick="GuestCheckin(1903,890);"></td>
                    </tr>
                    <tr>
                        <td>Bill King</td>
                        <td>303-332-3373</td>
                        <td>1209-F</td>
                        <td>
                          <input type="button" value="print" class="action-btn" onclick="ReissueAndPrintPop(1903,890);">
                          <a href="/staff/popup/emailPass.cfm?g_id=890&amp;v_id=1903" class="extlink action-btn">email</a>
                        </td>
                        <td><input type="button" value="Check-In" class="action-btn" onclick="GuestCheckin(1903,890);"></td>
                    </tr>

                </tbody>
            </table>
             <!-- /.table-responsive -->
        </div>
        <!-- /.row -->
    </div>
    <!-- /.panel-body -->
</div>
<!-- /.panel -->
                    
  </cfoutput>