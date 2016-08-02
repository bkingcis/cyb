/*
   Google Map Magnifier control from GoogleMappers.com
   Version: 0.95 (BETA)
   Released: 09-Oct-2005
   Compatible with Google Maps API version: 1.0, as of maps.23.js
   This code lives at http://www.googlemappers.com/libraries/gxmagnifier/

   LEGAL:
   The code, which has been nurtured and slaved over, is hereby released
   into to the wild. Feel free to evolve/hack it as you see fit, but please
   always retain a reference in the source code to Richard Kagerer and
   GoogleMappers.com as the original source of the component.

   Use of this software is entirely at your own risk.  There are no warrantees of any
   kind implied, and the author shall not be held liable for any damages whatsoever
   resulting from its use.
*/

function GxMagnifierNamespace() {

var n4=(document.layers);var n6=(document.getElementById&&!document.all);var ie=(document.all);var o6=(navigator.appName.indexOf("Opera") != -1);
function GxMagnifierb(p44, p45, p46) { 
if (p45 == undefined || p45 == null) p45 = false;this.p1(p45, p46);this.um = p44;this.umc = this.um.container;if (p46) {
this.container = p46;this.p2(); 
} else {
this.p3(); 
}
this.p4(p45);this.p5();if (!this.parked) {
this.hide();p64(this.container, new GPoint(0,0));}
}

GxMagnifierb.prototype.p1 = function(p45, p46) { 

this.magnifyFactor = p76; 
this.p6 = true; 
this.p7 = true;this.p8 = true; 
this.p9 = false;  
this.p10 = true;  
this.p11 = false;  
this.p12 = false;  
this.p13 = (p46) ? false : true; 
this.p14 = !p45;this.borderWidth = 2;
this.p15 = (p46) ? true : false; 
this.parked = (p46) ? true : false; 
this.p17 = new GPoint(); 
this.p16 = new GPoint(); 
this.p18 = Math.round(Math.random() * 1000);this.p47 = 'GxMagnifier' + this.p18 + '_MapOverlay';this.um = undefined;  
this.umc = undefined; 
this.container = undefined; 
this.map = undefined; 
this.p49 = undefined; 
this.p17 = undefined; 
this.p16 = undefined; 
this.p19 = undefined;  
this.p20 = undefined; 
this.p21 = undefined; 
}
GxMagnifierb.prototype.p3 = function() { 
this.container = this.um.ownerDocument.createElement('div');this.p2();p62(this.container, "crosshair");with (this.container.style) {
left = '-1000px'; top = '-1000px';border = this.borderWidth + 'px solid black';}
this.umc.appendChild(this.container);}
GxMagnifierb.prototype.p2 = function() {           
this.container.style.position = 'absolute'; 
}
GxMagnifierb.prototype.p4 = function(p45) {  
if (!this.parked) {
this.setSize(new GSize(this.umc.offsetWidth / 3, this.umc.offsetHeight / 3));}
this.map = new GMap(this.container);this.p22();this.p23();this.p24(true, true); 
this.map.centerAndZoom(this.um.getCenterLatLng(), this.p25())
if (this.p14) this.syncOverlays();}
GxMagnifierb.prototype.p22 = function(p48) {  
for (var i = 0; i < this.container.childNodes.length; i++) {                     
if (this.container.childNodes[i].className.replace(" ", "") == "noprint") {    
this.container.childNodes[i].style.display = 'none';                         
}
}
this.map.disableDragging();this.map.disableInfoWindow();}
GxMagnifierb.prototype.p23 = function(msg) { 
this.p49 = this.map.ownerDocument.createElement('div'); 
with (this.p49.style) {
fontFamily = "Arial, Helvetica, sans-serif";fontSize = "10px";fontWeight = "bold";padding = "1px";}
var dmsg = '<span style="font-size:12pt; font-weight:bold">Loading tiles...</span><br />'
dmsg += '<span style="color:darkgreen">powered by GxMagnifier from <nobr>googlemappers.com'
dmsg += '</nobr></span>'
this.p49.innerHTML = (msg) ? msg : dmsg
this.container.appendChild(this.p49);}

GxMagnifierb.prototype.p5 = function() {  
GEvent.bind(this.um, "move", this,
function() {
if (this.p6 && !this.parked) this.p26();});GEvent.bind(this.um, "maptypechanged", this, this.p24);GEvent.bind(this.um, "zoom", this,
function() {
this.p27();this.p28();this.p26();});GEvent.bind(this.um, "addoverlay", this,
function(o) {
if (this.p14) {
this.p29(o); }
});GEvent.bind(this.um, "removeoverlay", this,
function(o) {
this.p30(o);});GEvent.bind(this.um, "clearoverlays", this,
function() {
if (this.p14) {
this.map.clearOverlays(); }
});GEvent.bindDom(this.map.ownerDocument, "mousemove", this, this.p31); 
GEvent.bindDom(this.container, "click", this, this.p32); 
}
GxMagnifierb.prototype.p31 = function(event) {
if (!this.p8) return;this.p17 = getMouseCoordinates(event);this.p16 = p66(this.p17, this.umc)
this.p19 = p54(this.p16, this.umc);   
if (this.parked) {
this.p20 = p60(this.p17, this.container);this.p33();this.p26();} else {
this.p34();}
}
GxMagnifierb.prototype.p33 = function() {
if (!this.isVisible()) return;if (this.p21 != this.p20) {
GEvent.trigger(this, this.p20 ? "mouseover" : "mouseout");this.p21 = this.p20;}
}
GxMagnifierb.prototype.p32 = function(event) {
GEvent.trigger(this, 'click', this.map.getCenterLatLng());if (!this.p13) return;if (this.p11 && this.map.getZoomLevel() < this.um.getZoomLevel()) {
this.um.recenterOrPanToLatLng(this.map.getCenterLatLng());this.p35();} else {
this.um.centerAndZoom(this.map.getCenterLatLng(), this.map.getZoomLevel());}
if (this.p10) this.hide();}
GxMagnifierb.prototype.p35 = function() {
this.p27();GxMagnifierDelayedZoomMap = this.um;var s = 'GxMagnifierDelayedZoom(' + this.umc.id + ', ' + this.map.getZoomLevel() + ');';this.delayedZoom_tmr = setTimeout(s, 300, this.um);}
GxMagnifierb.prototype.p27 = function() {
if (this.delayedZoom_tmr) clearTimeout(this.delayedZoom_tmr);GxMagnifierDelayedZoomMap = undefined;}
GxMagnifierb.prototype.createImage = function(imageSrc) {
return p61(imageSrc, this.container, this.map.ownerDocument);}


GxMagnifierb.prototype.show = function() {
if (this.isVisible()) return;GEvent.trigger(this, "show");if (!this.p12) this.p36(true);  
this.container.style.visibility = '';}
GxMagnifierb.prototype.hide = function() {
if (!this.isVisible()) return;GEvent.trigger(this, "hide");this.container.style.visibility = 'hidden';this.p37();}
GxMagnifierb.prototype.setSize = function(size) {
this.container.style.width = p50(size.width, 5, this.umc.offsetWidth) + 'px';this.container.style.height = p50(size.height, 5, this.umc.offsetHeight) + 'px';if (this.map) {
this.map.onResize();  
if (!this.parked) this.p34();}
}
GxMagnifierb.prototype.showLoadingMessage = function(html) {
this.p49.style.display = '';if (html) this.p49.innerHTML = html;}
GxMagnifierb.prototype.hideLoadingMessage = function() {
this.p49.style.display = 'none';}
GxMagnifierb.prototype.park = function(pt) {
if (this.p15) return;if (pt) p64(this.container, pt, this.borderWidth);this.p20 = p60(this.p17, this.container);this.parked = true;this.p38(pt);}
GxMagnifierb.prototype.parkAtMarker = function(m, offsetLeft, offsetTop) {
if (this.p15) return;if (!offsetLeft) offsetLeft = 0;if (!offsetTop) offsetTop = 0;var markerCenterPx = new GPoint(
m.iconImage.offsetLeft + m.icon.iconAnchor.x
+ m.iconImage.offsetParent.offsetLeft
+ offsetLeft,
m.iconImage.offsetTop + m.icon.iconAnchor.y
+ m.iconImage.offsetParent.offsetTop
+ offsetTop);this.park(markerCenterPx);}
GxMagnifierb.prototype.unpark = function(w) {
if (this.p15) return;this.parked = false;}

GxMagnifierb.prototype.syncOverlays = function() {  
this.map.clearOverlays();for (var i = 0; i < this.um.overlays.length; i++) {  
this.p29(this.um.overlays[i]);}
}
GxMagnifierb.prototype.p29 = function(orgOverlay) {
var ourCopy = orgOverlay.copy(); 
orgOverlay[this.p47] = ourCopy;this.map.addOverlay(ourCopy);return ourCopy;}
GxMagnifierb.prototype.p30 = function(orgOverlay) {
try {
var attr = this.p47;var ourCopy = orgOverlay[attr];if (ourCopy) {
orgOverlay[attr] = undefined;this.map.removeOverlay(ourCopy); }
} catch (e) {
}
}

GxMagnifierb.prototype.isVisible = function() {
return (this.container.style.visibility.toLowerCase() != 'hidden')
}
GxMagnifierb.prototype.p36 = function(force) {
if (!this.p39(force)) return;this.p24(force);this.p28(force);this.p26(force); 
}
GxMagnifierb.prototype.p39 = function(force) {

return (this.isVisible() || this.p12 || force) &&
(this.map) && (this.container.style.left != '-1000px');}
GxMagnifierb.prototype.p24 = function(force, p69) {
if (!this.p39(force)) return;if (!this.p6 && !p69) return;this.map.setMapType(this.um.getCurrentMapType());}
GxMagnifierb.prototype.p28 = function(force) {
if (!this.p39(force) || !this.p6
|| !this.p7) return;this.map.zoomTo(this.p25());}
GxMagnifierb.prototype.p25 = function() {
var z = this.um.getZoomLevel() - this.magnifyFactor;return p50(z, 0, this.map.spec.numZoomLevels); 
}
GxMagnifierb.prototype.p26 = function(force) {
if (!this.p39(force)) return;if (this.parked) {
if (!this.p16 || !this.p8) return;if (this.p19 && (this.p20 == false)) {
this.p38(this.p16);}
} else {
var pt = p63(this.container, this.borderWidth);pt.y += 0.6;pt.x += 0.6;this.p38(pt);}
}
GxMagnifierb.prototype.p38 = function(pt) {
this.map.centerAtLatLng(this.um.containerCoordToLatLng(pt));  
}
GxMagnifierb.prototype.p34 = function() {
if (!this.p16) return;var b = new GBounds(0, 0, this.umc.offsetWidth, this.umc.offsetHeight);b = p56(b,
(this.container.offsetWidth  / 2) * (this.p9 ? -1 : 1),
(this.container.offsetHeight / 2) * (this.p9 ? -1 : 1));b = p57(b, this.borderWidth); 
var newCenter = p55(this.p16, b);p64(this.container, newCenter, this.borderWidth);if (this.p9 && this.p19 && !p52(this.p16, b)) {
this.p40();} else {
this.p37();this.p26();}
}


GxMagnifierb.prototype.enableAutoPan = function() {
this.p9 = true;}
GxMagnifierb.prototype.disableAutoPan = function() {
this.p9 = false;this.p37(); 
}
var p70, p71, p72;  
GxMagnifierb.prototype.p40 = function() {
if (!this.p39()) return;p70 = this.p41(this.p16.x, 0, this.umc.offsetWidth,
this.container.offsetWidth, p70, 39, 37);p71 = this.p41(this.p16.y, 0, this.umc.offsetHeight,
this.container.offsetHeight, p71, 40, 38);return p72;}
GxMagnifierb.prototype.p37 = function() {
p72 = false;p70 = false;p71 = false
this.um.panKeys.remove(37);this.um.panKeys.remove(38);this.um.panKeys.remove(39);this.um.panKeys.remove(40);}
GxMagnifierb.prototype.p41 = function(x, umcLeft, umcWidth, p75, p72, rightKey, leftKey) {
var ratio = this.p42(x, umcLeft, umcWidth, p75);if (ratio != 0) {
if (!p72) {
p72=true;this.um.panKeys.add((ratio > 0) ? rightKey : leftKey);this.um.startContinuousPan();}
} else {
this.um.panKeys.remove(leftKey);this.um.panKeys.remove(rightKey);p72 = false;}
return p72;}
GxMagnifierb.prototype.p42 = function(x, p74, p73, p75) {
var n = this.p43(x,
(p74 + p73 - p75 / 2),  
(p74 + p73));                
if (n != 0) return n;n = this.p43(x,
(p74),                                  
(p74 + p75 / 2));                  
if (n != 0) return -(1-n);return 0;}
GxMagnifierb.prototype.p43 = function(x, left, right) {
if ((x > left) && (x < right)) {
return (x - left) / (right - left);} else {
 return 0;}
}

var p76 = 2;GxMagnifierb.prototype.setMagnification = function(levels) {
this.magnifyFactor = (levels != undefined && levels != null) ? (levels) : p76;this.p28(true);}
GxMagnifierb.prototype.enableMapSync = function() {
this.p6 = true;}
GxMagnifierb.prototype.disableMapSync = function() {
this.p6 = false;}
GxMagnifierb.prototype.enableAutoMagnify = function() {
this.p7 = true;}
GxMagnifierb.prototype.disableAutoMagnify = function() {
this.p7 = false;}
GxMagnifierb.prototype.enableMouseTracking = function() {
this.p8 = true;}
GxMagnifierb.prototype.disableMouseTracking = function() {
this.p8 = false;}
GxMagnifierb.prototype.enableAutoPan = function() {
this.p9 = true;}
GxMagnifierb.prototype.disableAutoPan = function() {
this.p37();this.p9 = false;}
GxMagnifierb.prototype.enablePanBeforeZoomIn = function() {
this.p11 = true;}
GxMagnifierb.prototype.disablePanBeforeZoomIn = function() {
this.p11 = false;}
GxMagnifierb.prototype.enablePrefetch = function() {
this.p12 = true;}
GxMagnifierb.prototype.disablePrefetch = function() {
this.p12 = false;}
GxMagnifierb.prototype.enableDefaultClickHandler = function() {
this.p13 = true;}
GxMagnifierb.prototype.disableDefaultClickHandler = function() {
this.p13 = false;}
GxMagnifierb.prototype.enableOverlaySync = function() {
this.p14 = true;}
GxMagnifierb.prototype.disableOverlaySync = function() {
this.p14 = false;}
GxMagnifierb.prototype.setBorderWidth = function(w) {
this.borderWidth = w;this.container.style.borderWidth = w + 'px';}
GxMagnifierb.prototype.setCursor = function(c) {
p62(this.container, c);}



function p50(val, minVal, maxVal) {
if (val < minVal) return minVal;if (val > maxVal) return maxVal;return val;}
function p51(val, minVal, maxVal) {
return ((val >= minVal) && (val <= maxVal));}
function p52(p, bound) {
return (p51(p.x, bound.minX, bound.maxX) &&
p51(p.y, bound.minY, bound.maxY));}

function p54(pt, el) {
return (p51(pt.x, 0, el.offsetWidth) &&
p51(pt.y, 0, el.offsetHeight));}
function p55(pt, bounds) {
var p = new GPoint();p.x = p50(pt.x, bounds.minX, bounds.maxX);p.y = p50(pt.y, bounds.minY, bounds.maxY);return p;}
function p56(bounds, p77, p78, p79) {
var b = new GBounds();if (!p78) p78 = p77
p79 = (p79) ? -1 : 1;b.minX = bounds.minX - p77 * p79;b.maxX = bounds.maxX + p77;b.minY = bounds.minY - p78 * p79;b.maxY = bounds.maxY + p78;return b;}
function p57(bounds, p77, p78) {
return p56(bounds, p77, p78, true);}

function p59(container) {
return new GSize(container.offsetWidth, container.offsetHeight);}
function p60(pt, el) {
return p54(p66(pt, el), el);}

function trace(s, p81, p80) {
var d = document.getElementById("GxMagnifierTraceOutput");if (d) {
if (p81 == undefined || p81 == null) p81 = true;if (p80) d.innerHTML = '';d.innerHTML += s + (p81 ? '<br />' : '');}
}
function p61(imageSrc, container, ownerDocument) {
var img = ownerDocument.createElement("img");if (ie) {
img.style.filter='progid:DXImageTransform.Microsoft.AlphaImageLoader(src="' +
imageSrc + '", sizingMethod="")';img.src = "spacer.png"; 
} else {                  
img.src = imageSrc;}
container.appendChild(img);return img;}
function p62(a,b){
try {
a.style.cursor=b
} catch (c) {
if (b=="pointer") {
p62(a,"hand")
}
}
}
function p63(el, p82) {
var p = new GPoint();if (!p82) p82 = 0;p.x = el.offsetLeft + el.offsetWidth / 2.0 + p82;p.y = el.offsetTop + el.offsetHeight / 2.0 + p82;return p;}
function p64(el, pt, p82) {
if (!p82) p82 = 0;el.style.left = pt.x - el.offsetWidth / 2.0 - p82 + 'px';el.style.top = pt.y - el.offsetHeight / 2.0 - p82 + 'px';}

function p66(pt, el) {
var p = new GPoint(pt.x, pt.y);for (var o = el; (o) && (o.offsetParent); o = o.offsetParent) {
p.x -= o.offsetLeft;p.y -= o.offsetTop;}
return p;}
function getMouseCoordinates(e) {
var p = new GPoint();if(!e) var e = window.event;if(e.pageX || e.pageY){
p.x = e.pageX;p.y = e.pageY;} else if(e.clientX || e.clientY) {
p.x = e.clientX + document.documentElement.scrollLeft;p.y = e.clientY + document.documentElement.scrollTop;}
return p;}
function GxMagnifierDelayedZoomb(mapContainer, level) {
if (GxMagnifierDelayedZoomMap) {
GxMagnifierDelayedZoomMap.zoomTo(level);GxMagnifierDelayedZoomMap = undefined;}
}

function GxMagnifierControlb(p84) {
this.p83 = p84;this.defaultPosition = new GxControlPositionHack(0, 8, 8);}
GxMagnifierControlb.prototype.initialize = function(map) {
if (!this.GxMagnifier) this.GxMagnifier = new GxMagnifier(map, this.p83);this.p85 = 'magnify.png';  
this.p67();        
this.div = this.buttons.container;  

return this.div;}
GxMagnifierControlb.prototype.map = function() {
return this.GxMagnifier.map;}
GxMagnifierControlb.prototype.setMagnifyImage = function(image) {
this.p85 = image;}
GxMagnifierControlb.prototype.show = function() {
this.buttons.container.style.display = '';}
GxMagnifierControlb.prototype.hide = function() {
this.GxMagnifier.hide();this.buttons.container.style.display = 'none';}
GxMagnifierControlb.prototype.p67 = function() {
var b = new GxButtons();this.buttons = b; 
b.p68(this.GxMagnifier.um.ownerDocument);this.magnifyButton = b.addImageButton((this.p85) ? this.p85 : 'magnify.png',
"Magnify region");GEvent.bindDom(this.magnifyButton, "click", this, this.onMagnifyClick);GEvent.bind(this.GxMagnifier.um, "zoom", this,
function() {
var MIN_ZOOM_LEVEL = 0;if (this.GxMagnifier.um.getZoomLevel() == MIN_ZOOM_LEVEL) {
this.magnifyButton.style.display = 'none';} else {
this.magnifyButton.style.display = '';}
});b.appendToDom(this.GxMagnifier.umc);}
GxMagnifierControlb.prototype.getDefaultPosition = function() {
return this.defaultPosition;}
GxMagnifierControlb.prototype.setDefaultPosition = function(p) {
this.defaultPosition = p;}
GxMagnifierControlb.prototype.remove=function(){
this.map.container.removeChild(this.div);this.div=null;this.GxMagnifier.hide();};GxMagnifierControlb.prototype.onMagnifyClick = function() {
if (this.GxMagnifier.isVisible()) this.GxMagnifier.hide();else this.GxMagnifier.show();}

function GxButtonsb() {}
GxButtonsb.prototype.p68 = function(ownerDocument) {
this.ownerDocument = (ownerDocument) ? ownerDocument : document;this.container = this.ownerDocument.createElement("div");return this.container;}
GxButtonsb.prototype.appendToDom = function(container) {
if (!this.container) this.p68();if (container) container.appendChild(this.container);else this.ownerDocument.appendChild(this.container);return this.div;}
GxButtonsb.prototype.addImageButton = function(imageSrc, tooltipText) {
if (!this.container) this.p68();var img = p61(imageSrc, this.container, this.ownerDocument);img.setAttribute('tooltip', tooltipText);  
p62(img, 'pointer');return img;}
GxButtonsb.prototype.addTextButton = function(text, tooltipText) {
if (!this.container) this.p68();var b = this.ownerDocument.createElement("div");b.setAttribute('tooltip', tooltipText);p62(b, 'pointer');b.innerHTML = text;b.style.width='16px'; b.style.height='16px';b.style.textAlign = "center";b.style.fontFamily = "Arial, Helvetica, sans serif";b.style.fontWeight = "bold";b.style.backgroundColor = '#FFFFFF';b.style.border = "1px solid black";b.style.textShadow = "Gray";b.style.verticalAlign = "top"; 
this.container.appendChild(b);return b;}

function GxControlPositionHackb(a,b,c){
this.anchor=a;this.offsetWidth=b||0;this.offsetHeight=c||0;}
GxControlPositionHackb.prototype.apply=function(a){
a.style.position="absolute";a.style[this.getWidthMeasure()]=this.offsetWidth+'px';a.style[this.getHeightMeasure()]=this.offsetHeight+'px';}
GxControlPositionHackb.prototype.getWidthMeasure=function(){
switch(this.anchor){
case 1:
case 3:
return"right";default:return"left";}
}
GxControlPositionHackb.prototype.getHeightMeasure=function(){
switch(this.anchor){
case 2:case 3:return"bottom";default:return"top";}
}


function makeInterface(a) {
var b = a || window;b.GxMagnifier = GxMagnifierb;b.GxMagnifierDelayedZoom = GxMagnifierDelayedZoomb;b.GxMagnifierDelayedZoomMap = undefined; 
b.GxMagnifierControl = GxMagnifierControlb;b.GxButtons = GxButtonsb;b.GxControlPositionHack = GxControlPositionHackb;b.gxTrace = trace;}
makeInterface();}
GxMagnifierNamespace();






