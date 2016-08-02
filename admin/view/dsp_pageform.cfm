<style>
    .yui-skin-sam .yui-toolbar-container .yui-toolbar-editcode span.yui-toolbar-icon {
        background-image: url( http://developer.yahoo.com/yui/examples/editor/assets/html_editor.gif );
        background-position: 0 1px; left: 5px;
    }
    .yui-skin-sam .yui-toolbar-container .yui-button-editcode-selected span.yui-toolbar-icon {
        background-image: url( http://developer.yahoo.com/yui/examples/editor/assets/html_editor.gif );
        background-position: 0 1px; left: 5px;
    }
    .editor-hidden {
        visibility: hidden;
        top: -9999px; left: -9999px;
        position: absolute;
    }
    textarea {
        border: 0; margin: 0; padding: 0;
    }	
    #msgpost_container span.yui-toolbar-insertimage, #msgpost_container span.yui-toolbar-insertimage span.first-child {
        border-color: blue;	height: 120px;
    }
</style>

      <script type="text/javascript">
	    var BodyConfig = {
                    height: '400px',
                    width: '730px',
                    animate: true,
                    dompath: true,
                    focusAtStart: false
                };
		//build YUI editor  
		pagebodyEditor = new YAHOO.widget.Editor('pagebody', BodyConfig);			
        pagebodyEditor.render();
     </script>
<table width="92%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td class="header">Web Site Page Content Management</td>
	</tr>
</table>
<cfoutput>
<cfif isdefined("session.message") and len(session.message)>
	<div style="color:red;font-weight:600">#session.message#</div><cfset session.message="">
	<button onclick="self.location='admin.cfm?fa=cmspagelist'">return to page list</button><br>
	<br>
</cfif>
<form action="##" method="post" onsubmit="pagebodyEditor.saveHTML()">
	<input type="hidden" name="fa" value="#url.fa#" />
	<input type="hidden" name="id" value="#qPage.id#" />
	<strong>Page Title:</strong><br>
	<input type="text" name="pagetitle" value="#qPage.pagetitle#" size="55" /><br>
	<br><input type="submit" value="Save Changes"><br>
	<strong>Page Text:</strong><br>
	<textarea name="pagetext" id="pagebody" >#qPage.pagetext#</textarea><br>
	<input type="submit" value="Save Changes">
</form>
</cfoutput>


<a href="/admin/admin.cfm">Admin Home</a> | <a href="/admin/admin.cfm?fa=cmspagelist">Content Mgmt Home</a>