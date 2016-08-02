<cfset MaximumVisitDateSpacingDays = 14>
<cfset breaksRule = False>
<cfparam name="lastITTDate" default="" />
<cfparam name="session.message" default="" />


<!--- OrderDates:  Incoming Query Object - Lists all new requested dates 
######  RULE:  IF any Dates are spaced greater than 14 days the Rule will not be met. ###### --->

<cfloop query="OrderDates">
	<cfset thisIttDate = OrderDates.DATELIST>
	<cfif isDate(lastITTDate) AND DateDiff("d",lastITTDate,thisITTDate) gt MaximumVisitDateSpacingDays>		
		<cfsavecontent variable="session.message">
			<cfoutput>#session.message#<!--- any previous notes --->
			To help maintain the security of our community, please refrain from spacing guest visit dates more than #MaximumVisitDateSpacingDays# days apart.<br>
			<br>(Seperate this visit into two or more individual announcements.)</cfoutput>
		</cfsavecontent>
		<cfset breaksRule = True>
		<cfbreak />
	</cfif>
	<cfset lastITTDate = thisIttDate> <!--- sets up the last itteration date for the next loop --->
</cfloop>