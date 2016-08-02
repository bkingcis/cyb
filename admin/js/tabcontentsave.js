//** Tab Content script- © Dynamic Drive DHTML code library (http://www.dynamicdrive.com)
//** Last updated: June 29th, 06

var enabletabpersistence=1 //enable tab persistence via session only cookies, so selectedA tab is remembered?

////NO NEED TO EDIT BELOW////////////////////////
var tabcontentIDs=new Object()

function expandcontentA(linkobj){
var ulid=linkobj.parentNode.parentNode.id //id of UL element
var ullist=document.getElementById(ulid).getElementsByTagName("li") //get list of LIs corresponding to the tab contents
for (var i=0; i<ullist.length; i++){
ullist[i].className=""  //deselect all tabs
if (typeof tabcontentIDs[ulid][i]!="undefined") //if tab content within this array index exists (exception: More tabs than there are tab contents)
document.getElementById(tabcontentIDs[ulid][i]).style.display="none" //hide all tab contents
}
linkobj.parentNode.className="selectedA"  //highlight currently clicked on tab
document.getElementById(linkobj.getAttribute("relA")).style.display="block" //expand corresponding tab content
saveselectedAtabcontentidA(ulid, linkobj.getAttribute("relA"))
}

function savetabcontentidsA(ulid, relAattribute){// save ids of tab content divs
if (typeof tabcontentIDs[ulid]=="undefined") //if this array doesn't exist yet
tabcontentIDs[ulid]=new Array()
tabcontentIDs[ulid][tabcontentIDs[ulid].length]=relAattribute
}

function saveselectedAtabcontentidA(ulid, selectedAtabid){ //set id of clicked on tab as selectedA tab id & enter into cookie
if (enabletabpersistence==1) //if persistence feature turned on
setCookieA(ulid, selectedAtabid)
}

function getullistlinkbyIdA(ulid, tabcontentid){ //returns a tab link based on the ID of the associated tab content
var ullist=document.getElementById(ulid).getElementsByTagName("li")
for (var i=0; i<ullist.length; i++){
if (ullist[i].getElementsByTagName("a")[0].getAttribute("relA")==tabcontentid){
return ullist[i].getElementsByTagName("a")[0]
break
}
}
}

function initializetabcontentA(){
for (var i=0; i<arguments.length; i++){ //loop through passed UL ids
if (enabletabpersistence==0 && getCookieA(arguments[i])!="") //clean up cookie if persist=off
setCookieA(arguments[i], "")
var clickedontab=getCookieA(arguments[i]) //retrieve ID of last clicked on tab from cookie, if any
var ulobj=document.getElementById(arguments[i])
var ulist=ulobj.getElementsByTagName("li") //array containing the LI elements within UL
for (var x=0; x<ulist.length; x++){ //loop through each LI element
var ulistlink=ulist[x].getElementsByTagName("a")[0]
if (ulistlink.getAttribute("relA")){
savetabcontentidsA(arguments[i], ulistlink.getAttribute("relA")) //save id of each tab content as loop runs
ulistlink.onclick=function(){
expandcontentA(this)
return false
}
if (ulist[x].className=="selectedA" && clickedontab=="") //if a tab is set to be selectedA by default
expandcontentA(ulistlink) //auto load currenly selectedA tab content
}
} //end inner for loop
if (clickedontab!=""){ //if a tab has been previously clicked on per the cookie value
var culistlink=getullistlinkbyIdA(arguments[i], clickedontab)
if (typeof culistlink!="undefined") //if match found between tabcontent id and relA attribute value
expandcontentA(culistlink) //auto load currenly selectedA tab content
else //else if no match found between tabcontent id and relA attribute value (cookie mis-association)
expandcontentA(ulist[0].getElementsByTagName("a")[0]) //just auto load first tab instead
}
} //end outer for loop
}


function getCookieA(Name){ 
var re=new RegExp(Name+"=[^;]+", "i"); //construct RE to search for target name/value pair
if (document.cookie.match(re)) //if cookie found
return document.cookie.match(re)[0].split("=")[1] //return its value
return ""
}

function setCookieA(name, value){
document.cookie = name+"="+value //cookie value is domain wide (path=/)
}