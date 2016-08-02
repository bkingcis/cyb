<cfcomponent name="Barcode" displayname="BBQ Barcode" output="false">
 
  <cffunction name="getBarcode" returntype="any" access="remote" output="true">
 
    <cfargument name="data" type="string" required="true" />
 
    <cfargument name="barWidth" type="numeric" required="false" default="0" />
 
    <cfargument name="barHeight" type="numeric" required="false" default="0" />
 
    <cfargument name="resolution" type="numeric" required="false" default="0" />
 
    <cfargument name="outputFormat" type="string" required="false" default="jpeg" />
 
    <cfset var barcode = __getBarcode(argumentCollection: arguments) />
 
    <!--- <cfsetting showdebugoutput="false" />
 
    <cfset getPageContext().getOut().clearBuffer() />
	<cfcontent type="image/#arguments.outputFormat#" variable="" /> --->
	<cfreturn __getBarcodeImage(barcode, arguments.outputFormat) />
 
  </cffunction>
 
 
 
  <cffunction name="__getBarcode" returntype="any" access="private" output="false">
 
    <cfargument name="data" type="string" required="true" />
 
    <cfargument name="barWidth" type="numeric" required="false" default="0" />
 
    <cfargument name="barHeight" type="numeric" required="false" default="0" />
 
    <cfargument name="resolution" type="numeric" required="false" default="0" />
 
    <cfset var barcode = createObject("java", "net.sourceforge.barbecue.BarcodeFactory").createCode128(arguments.data) />
 	
   
 
    <!—
 
      If we have barWidth and barHeight data, pass that on. 0 indicates
 
      that we don‘t want to change the width/height.
 
   —>
 
   <cfif arguments.barWidth GT 0>
 
     <cfset barcode.setBarWidth(javaCast("int", arguments.barWidth)) />
 
   </cfif>
 
   
 
   <cfif arguments.barHeight GT 0>
 
     <cfset barcode.setBarHeight(javaCast("int", arguments.barHeight)) />
 
   </cfif>
 
 
 
   <!—
 
     Set the resolution. 0 indicates that we don’t wish to change
 
      the default, which is usually 72 dpi. One may wish to change
 
      this for non-screen devices, such as a printer.
 
    —>
 
    <cfif arguments.resolution GT 0>
 
      <cfset barcode.setResolution(javaCast("int", arguments.resolution)) />
 
    </cfif>
 
   
 
    <cfreturn barcode />
 
  </cffunction>
 
 
 
  <cffunction name="__getBarcodeImage" returntype="any" access="private" output="false">
 
    <cfargument name="barcode" type="any" required="true" />
 
    <cfargument name="outputFormat" type="string" required="true" />
 
   
 
    <cfset var outStream = createObject("java", "java.io.ByteArrayOutputStream").init() />
 
    <cfset var bufferedImage = "" />
 
   
 
    <!—
 
      Write the barcode out to the output stream as a series of encoded bytes.
 
      The format is based on outputForamt. jpeg, gif, png.
 
    —>
 
    <cfswitch expression="#arguments.outputFormat#">
 
      <cfcase value="jpeg">
 
        <cfset bufferedImage = createObject("java", "net.sourceforge.barbecue.BarcodeImageHandler").writeJPEG(barcode, outStream) />
 
      </cfcase>
 
     
 
      <cfcase value="gif">
 
        <cfset bufferedImage = createObject("java", "net.sourceforge.barbecue.BarcodeImageHandler").writeGIF(barcode, outStream) />
 
      </cfcase>
 
     
 
      <cfcase value="png">
 
        <cfset bufferedImage = createObject("java", "net.sourceforge.barbecue.BarcodeImageHandler").writePNG(barcode, outStream) />
 
      </cfcase>
 
    </cfswitch>
 
   
 
    <cfreturn outStream.toByteArray() />
 
  </cffunction>
 
 
 
</cfcomponent>