
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
<script>
     var initialEmailEditor = new YAHOO.widget.Editor('initialEmail', {
			height: '180px',
			width: '99%',
			dompath: false,
			animate: true,
			toolbar: {
				titlebar: '',
				buttons: [
					{ group: 'textstyle', label: 'Font Style',
						buttons: [
							{ type: 'select', label: 'Arial', value: 'fontname', disabled: true,
								menu: [
									{ text: 'Arial', checked: true },
									{ text: 'Arial Black' },
									{ text: 'Comic Sans MS' },
									{ text: 'Courier New' },
									{ text: 'Lucida Console' },
									{ text: 'Tahoma' },
									{ text: 'Times New Roman' },
									{ text: 'Trebuchet MS' },
									{ text: 'Verdana' }
								]
							},
							{ type: 'spin', label: '13', value: 'fontsize', range: [ 9, 75 ], disabled: true },
							{ type: 'separator' },
							{ type: 'color', label: 'Font Color', value: 'forecolor', disabled: true },
							{ type: 'color', label: 'Background Color', value: 'backcolor', disabled: true },
							{ type: 'separator' }, 						   
							{ type: 'push', label: 'Align Left CTRL + SHIFT + [', value: 'justifyleft' }, 
							{ type: 'push', label: 'Align Center CTRL + SHIFT + |', value: 'justifycenter' }, 
							{ type: 'push', label: 'Align Right CTRL + SHIFT + ]', value: 'justifyright' }, 
						    { type: 'push', label: 'Justify', value: 'justifyfull' }							
						]
					}
				]
			}
		});
		initialEmailEditor.render();
     </script>
	<fieldset>
	<legend >Resident Password Email Messages</legend>
	<div id="messageLeft">
		<strong>Initial Resident Email</strong>
		<cfoutput><form action="#request.self#" method="post" onsubmit="initialEmailEditor.saveHTML()"></cfoutput>
		<input type="Hidden" id="fa" name="fa" value="saveEmailText">
		<table width="92%" cellpadding="0" cellspacing="0" border="0">
		<tr><td class="messageCenter">
		<span class="txt">Message</span>
		<input type="hidden" name="type" value="initialemail">
		<cfoutput><textarea name="emailText" id="initialEmail" class="txtBox">#qInitialEmailText.emailText#</textarea></cfoutput>
		<input value="Update Message Text" id="messageSendBtn" type="submit">
		</td></tr>
		</table>
		</form>		
	</div>
	<script>
     var resetEmailEditor = new YAHOO.widget.Editor('resetEmail', {
			height: '180px',
			width: '99%',
			dompath: false,
			animate: true,
			toolbar: {
				titlebar: '',
				buttons: [
					{ group: 'textstyle', label: 'Font Style',
						buttons: [
							{ type: 'select', label: 'Arial', value: 'fontname', disabled: true,
								menu: [
									{ text: 'Arial', checked: true },
									{ text: 'Arial Black' },
									{ text: 'Comic Sans MS' },
									{ text: 'Courier New' },
									{ text: 'Lucida Console' },
									{ text: 'Tahoma' },
									{ text: 'Times New Roman' },
									{ text: 'Trebuchet MS' },
									{ text: 'Verdana' }
								]
							},
							{ type: 'spin', label: '13', value: 'fontsize', range: [ 9, 75 ], disabled: true },
							{ type: 'separator' },
							{ type: 'color', label: 'Font Color', value: 'forecolor', disabled: true },
							{ type: 'color', label: 'Background Color', value: 'backcolor', disabled: true },
							{ type: 'separator' }, 						   
							{ type: 'push', label: 'Align Left CTRL + SHIFT + [', value: 'justifyleft' }, 
							{ type: 'push', label: 'Align Center CTRL + SHIFT + |', value: 'justifycenter' }, 
							{ type: 'push', label: 'Align Right CTRL + SHIFT + ]', value: 'justifyright' }, 
						    { type: 'push', label: 'Justify', value: 'justifyfull' }							
						]
					}
				]
			}
		});
		resetEmailEditor.render();
     </script>
	<div id="messageRight">
		<strong>Password Reminder Resident Email</strong>
		<cfoutput><form action="#request.self#" method="post" onsubmit="resetEmailEditor.saveHTML()"></cfoutput>
		<input type="Hidden" id="fa" name="fa" value="saveEmailText">
			<table width="92%" cellpadding="0" cellspacing="0" border="0">
			<tr><td class="messageCenter">
			<span class="txt">Message</span>
			<input type="hidden" name="type" value="resetemail">
			<cfoutput><textarea name="emailText" id="resetEmail" class="txtBox" style="height:300px">#qresetEmailText.emailText#</textarea></cfoutput>
			<input value="Update Message Text" id="messageSendBtn" type="submit">							
			</td></tr>
			</table>
		</form>				
	</div>
	
	</fieldset>
	<script>
     var StaffInitialEmailEditor = new YAHOO.widget.Editor('StaffInitialEmail', {
			height: '180px',
			width: '99%',
			dompath: false,
			animate: true,
			toolbar: {
				titlebar: '',
				buttons: [
					{ group: 'textstyle', label: 'Font Style',
						buttons: [
							{ type: 'select', label: 'Arial', value: 'fontname', disabled: true,
								menu: [
									{ text: 'Arial', checked: true },
									{ text: 'Arial Black' },
									{ text: 'Comic Sans MS' },
									{ text: 'Courier New' },
									{ text: 'Lucida Console' },
									{ text: 'Tahoma' },
									{ text: 'Times New Roman' },
									{ text: 'Trebuchet MS' },
									{ text: 'Verdana' }
								]
							},
							{ type: 'spin', label: '13', value: 'fontsize', range: [ 9, 75 ], disabled: true },
							{ type: 'separator' },
							{ type: 'color', label: 'Font Color', value: 'forecolor', disabled: true },
							{ type: 'color', label: 'Background Color', value: 'backcolor', disabled: true },
							{ type: 'separator' }, 						   
							{ type: 'push', label: 'Align Left CTRL + SHIFT + [', value: 'justifyleft' }, 
							{ type: 'push', label: 'Align Center CTRL + SHIFT + |', value: 'justifycenter' }, 
							{ type: 'push', label: 'Align Right CTRL + SHIFT + ]', value: 'justifyright' }, 
						    { type: 'push', label: 'Justify', value: 'justifyfull' }							
						]
					}
				]
			}
		});
		StaffInitialEmailEditor.render();
     </script>
	<fieldset>
	<legend >Staff Password Email Messages</legend>
	<div id="messageLeft">
		<strong>Initial Staff Email</strong>
		<cfoutput><form action="#request.self#" method="post" onsubmit="StaffInitialEmailEditor.saveHTML()"></cfoutput>
		<input type="Hidden" id="fa" name="fa" value="saveEmailText">
		<table width="92%" cellpadding="0" cellspacing="0" border="0">
		<tr><td class="messageCenter">
		<span class="txt">Message</span>
		<input type="hidden" name="type" value="StaffInitialEmail">
		<cfoutput><textarea name="emailText" id="StaffInitialEmail" class="txtBox">#qStaffInitialEmailText.emailText#</textarea></cfoutput>
		<input value="Update Message Text" id="messageSendBtn" type="submit">
		</td></tr>
		</table>
		</form>		
	</div>
	<script>
     var staffresetEmailEditor = new YAHOO.widget.Editor('staffresetEmail', {
			height: '180px',
			width: '99%',
			dompath: false,
			animate: true,
			toolbar: {
				titlebar: '',
				buttons: [
					{ group: 'textstyle', label: 'Font Style',
						buttons: [
							{ type: 'select', label: 'Arial', value: 'fontname', disabled: true,
								menu: [
									{ text: 'Arial', checked: true },
									{ text: 'Arial Black' },
									{ text: 'Comic Sans MS' },
									{ text: 'Courier New' },
									{ text: 'Lucida Console' },
									{ text: 'Tahoma' },
									{ text: 'Times New Roman' },
									{ text: 'Trebuchet MS' },
									{ text: 'Verdana' }
								]
							},
							{ type: 'spin', label: '13', value: 'fontsize', range: [ 9, 75 ], disabled: true },
							{ type: 'separator' },
							{ type: 'color', label: 'Font Color', value: 'forecolor', disabled: true },
							{ type: 'color', label: 'Background Color', value: 'backcolor', disabled: true },
							{ type: 'separator' }, 						   
							{ type: 'push', label: 'Align Left CTRL + SHIFT + [', value: 'justifyleft' }, 
							{ type: 'push', label: 'Align Center CTRL + SHIFT + |', value: 'justifycenter' }, 
							{ type: 'push', label: 'Align Right CTRL + SHIFT + ]', value: 'justifyright' }, 
						    { type: 'push', label: 'Justify', value: 'justifyfull' }							
						]
					}
				]
			}
		});
		staffresetEmailEditor.render();
     </script>
	<div id="messageRight">
		<strong>Staff Password Reset Email</strong>
		<cfoutput><form action="#request.self#" method="post" onsubmit="staffresetEmailEditor.saveHTML()"></cfoutput>
		<input type="Hidden" id="fa" name="fa" value="saveEmailText">
			<table width="92%" cellpadding="0" cellspacing="0" border="0">
			<tr><td class="messageCenter">
			<span class="txt">Message</span>
			<input type="hidden" name="type" value="staffresetemail">
			<cfoutput><textarea name="emailText" id="staffresetEmail" class="txtBox" style="height:300px">#qStaffResetEmailText.emailText#</textarea></cfoutput>
			<input value="Update Message Text" id="messageSendBtn" type="submit">							
			</td></tr>
			</table>
		</form>				
	</div>
	</fieldset>
	<script type="text/javascript">
		initializetabcontent("homeTab");
	</script>
	
	</div>