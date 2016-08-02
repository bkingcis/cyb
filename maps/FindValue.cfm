<CFPARAM name="attributes.String" DEFAULT="">
<CFPARAM name="attributes.VariableName" DEFAULT="">
<CFPARAM name="attributes.DataEndIndicator" DEFAULT="#Chr(10)#">
<CFPARAM name="attributes.StartPosition" DEFAULT="1">

<CFSET Data = "">
<CFSET String = attributes.String>
<CFSET VariableName = attributes.VariableName>
<CFSET DataEndIndicator = attributes.DataEndIndicator>
<CFSET StartPosition = attributes.StartPosition>

<CFIF DataEndIndicator IS "">
  <CFSET DataEndIndicator = Chr(10)>
</CFIF>

<CFSET VariableStartPosition = 0>

<CFIF (Trim(VariableName) IS NOT "") AND (Trim(String) IS NOT "")>
  <CFSET VariableStartPosition = FindNoCase(VariableName,String,StartPosition)>
  <CFIF VariableStartPosition IS NOT 0>
    <CFSET VariableLength = Len(VariableName)>
    <CFSET DataStartPosition = VariableStartPosition + VariableLength>
    <CFSET EndOfLinePosition = FindNoCase(DataEndIndicator,String,DataStartPosition)>
    <CFIF EndOfLinePosition IS 0>
      <CFSET EndOfLinePosition = Len(String) + 1>
    </CFIF>
    <CFSET DataLength = EndOfLinePosition - DataStartPosition>
    <CFSET Data = Mid(String,DataStartPosition,DataLength)>
  </CFIF>
</CFIF>

<CFSET Caller.FindValueData = Trim(Data)>
<CFSET Caller.FoundPosition = VariableStartPosition>
