<cfinclude template="header.cfm">
<cfsilent>
<cfset location = getCommunity.C_ZIPCODE>
<cfset forcastRSS = xmlParse('http://xml.weather.yahoo.com/forecastrss/#location#_f.xml')> 
<cfset resultsArr = xmlSearch(forcastRSS,'/rss/channel/item/')>
<cfset TodayXML = resultsArr[1].xmlChildren[8]>
<cfset forcastConditions = resultsArr[1].xmlChildren>
</cfsilent>
<div id="popUpContainer">
	<cfoutput>
	<h1 style="color:black;">5 Day Forecast:<!--- #xmlSearch(forcastRSS,'/rss/channel/item/title/')[1].XmlText# ---></h1>
	<h2 style="border-bottom: 1px solid silver;"> &nbsp;</h2>
	<cfset subtitle = mid(forcastConditions[1].XmlText,1,find(' at ',forcastConditions[1].XmlText))>
	<h2>#ucase(subtitle)#</h2>
	<table width="95%" border="0" style="border-collapse:collapse;background-color: white;" align="center">
		<tr><th colspan="2">Forcast Conditions</th><th>Temp. (low/high)</th></tr>
		<cfloop from="8" to="12" index="arrIndex">
			<cfset dataStruct = forcastConditions[arrIndex].xmlAttributes>
		<tr style="background-color: <cfif arrIndex mod 2>##ffffff<cfelse>##7eB1F0</cfif>">
			<td align="center">#dataStruct.day#<br/>#dataStruct.date#</td>
			<td style="text-align: center"><img src="http://l.yimg.com/a/i/us/we/52/#dataStruct.code#.gif"/>
			<br />#dataStruct.text#</td>
			<td align="center">#dataStruct.low#/#dataStruct.high#</td>
		</tr>
		</cfloop>	
	</table>
	</cfoutput>
</div>

