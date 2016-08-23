 <!-- include/currentAccess -->
 <cfoutput>
 <h3>Current Access</h3>
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
                  <td>Todd Makeever</td>
                  <td>729-900-8765</td>
                  <td>980-C</td>
                  <td>
                    <input type="button" value="print" class="action-btn" onclick="ReissueAndPrintPop(1903,890);">
                    <a href="/staff/popup/emailPass.cfm?g_id=890&amp;v_id=1903" class="extlink action-btn">email</a>
                  </td>
                  <td><input type="button" value="Check-In" class="action-btn" onclick="GuestCheckin(1903,890);"></td>
              </tr>
               <tr>
                  <td>Todd Makeever</td>
                  <td>729-900-8765</td>
                  <td>980-C</td>
                  <td>
                    <input type="button" value="print" class="action-btn" onclick="ReissueAndPrintPop(1903,890);">
                    <a href="/staff/popup/emailPass.cfm?g_id=890&amp;v_id=1903" class="extlink action-btn">email</a>
                  </td>
                  <td><input type="button" value="Check-In" class="action-btn" onclick="GuestCheckin(1903,890);"></td>
              </tr> 
              <tr>
                  <td>Todd Makeever</td>
                  <td>729-900-8765</td>
                  <td>980-C</td>
                  <td>
                    <input type="button" value="print" class="action-btn" onclick="ReissueAndPrintPop(1903,890);">
                    <a href="/staff/popup/emailPass.cfm?g_id=890&amp;v_id=1903" class="extlink action-btn">email</a>
                  </td>
                  <td><input type="button" value="Check-In" class="action-btn" onclick="GuestCheckin(1903,890);"></td>
              </tr>
          </tbody>
      </table>
  </div>
  <!-- /.table-responsive -->
  </cfoutput>