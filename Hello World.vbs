Wscript.Echo "Hello World....."
Wscript.Echo "This is my first program"
Wscript.Echo "Hi Dude....."
Wscript.Echo "Just check Office Network"

'***********************************************************************************************************************
'NAME:HPESSAP0192-Virus And Malicious Code Scan-v2.1.vbs
'PURPOSE:It will check the AntiVirus is installed or not
'AUTHOR:Sajeev.S
'DATE WRITTEN:26-Oct-2011
'MODIFICATION HISTORY: Enhanced script for check for TrendMicro and Symantec in addtion to Mcaffee in V 2.1
'MOFICATION HISTORY
'Version         : 2.2
'MODIFIED OWNER  : Sajeev
'MODIFIED DATE   : 07-Feb-2017
'The script has been modified to check ONLY for McAfee antivirus has been installed on EON-Servers
'AV installed, Manual/Auto start and service running -> compliant 
'AV installed, Manual/Auto start and not running -> not compliant
'Version         : 2.3
'MODIFIED OWNER  : Sajeev
'MODIFIED DATE   : 14-Mar-2017
'As per the update from customer the following Non-Compliant message has been modified 
'1.	Non-Compliant: AV is installed but service is not running
'2.	Non-Compliant: AV is not installed
'Version         : 2.4
'MODIFIED OWNER  : Sajeev
'MODIFIED DATE   : 26-Apr-2017
'The script has been modified to support for the latest McAfee version
'The following service status has been checking for the latest version 
'	1. McAfee Agent Backwards Compatibility Service
'	2. McAfee Agent Common Services
'	3. McAfee Agent Service
'	4. McAfee McShield
'***********************************************************************************************************************
strSVCDisplayName = "McAfee Framework Service"
strComputer = "."
McAfeeFramework_Flag = 0
McShield_Flag = 0 
McAfee_Install = 0 
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colServices = objWMIService.ExecQuery("Select * from Win32_Service WHERE DisplayName = '" & strSVCDisplayName & "'")

For Each objService In colServices 
	McAfee_Install = 1
	McAfeeFramework_StartMode = objService.StartMode
	McAfeeFramework_State = objService.State
	AV_Version = 4.8 
Next

If McAfeeFramework_StartMode = "Auto" Or McAfeeFramework_StartMode = "Manual" Then
	If McAfeeFramework_State = "Running" Then
		McAfeeFramework_Flag = 1		
	End If
End If 

strSVCDisplayName = "McAfee McShield"
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colServices = objWMIService.ExecQuery("Select * from Win32_Service WHERE DisplayName = '" & strSVCDisplayName & "'")

For Each objService In colServices 
	McAfee_Install = 1
	McShield_StartMode = objService.StartMode
	McShield_State = objService.State
Next

If McShield_StartMode = "Auto" Or McShield_StartMode = "Manual" Then
	If McShield_State = "Running" Then
		McShield_Flag = 1
	End If
End If 

strSVCDisplayName = "McAfee Agent Backwards Compatibility Service"
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colServices = objWMIService.ExecQuery("Select * from Win32_Service WHERE DisplayName = '" & strSVCDisplayName & "'")

For Each objService In colServices 
	McAfee_Install = 1
	Agent_Backwards_StartMode = objService.StartMode
	Agent_Backwards_State = objService.State
Next

If Agent_Backwards_StartMode = "Auto" Or Agent_Backwards_StartMode = "Manual" Then
	If Agent_Backwards_State = "Running" Then
		Agent_Backwards_Flag = 1
	End If
End If 

strSVCDisplayName = "McAfee Agent Common Services"
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colServices = objWMIService.ExecQuery("Select * from Win32_Service WHERE DisplayName = '" & strSVCDisplayName & "'")

For Each objService In colServices 
	McAfee_Install = 1
	Agent_Common_StartMode = objService.StartMode
	Agent_Common_State = objService.State
Next

If Agent_Common_StartMode = "Auto" Or Agent_Common_StartMode = "Manual" Then
	If Agent_Common_State = "Running" Then
		Agent_Common_Flag = 1
	End If
End If 

strSVCDisplayName = "McAfee Agent Service"
Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colServices = objWMIService.ExecQuery("Select * from Win32_Service WHERE DisplayName = '" & strSVCDisplayName & "'")

For Each objService In colServices 
	McAfee_Install = 1
	Agent_StartMode = objService.StartMode
	Agent_State = objService.State
Next

If Agent_StartMode = "Auto" Or Agent_StartMode = "Manual" Then
	If Agent_State = "Running" Then
		Agent_State_Flag = 1
	End If
End If 

If McAfee_Install = 0 Then
	WScript.Echo "AV is not installed"
	WScript.Quit
End If 

If McShield_StartMode = "Auto" Or McShield_StartMode = "Manual" Then
	If McShield_State = "Running" Then
		McShield_Flag = 1
	End If
End If 

If McShield_StartMode = "Auto" Or McShield_StartMode = "Manual" Then
	If McShield_State = "Running" Then
		McShield_Flag = 1
	End If
End If 

If McShield_StartMode = "Auto" Or McShield_StartMode = "Manual" Then
	If McShield_State = "Running" Then
		McShield_Flag = 1
	End If
End If 

If AV_Version = 4.8 Then 
	If McAfeeFramework_Flag = 1 And McShield_Flag = 1 Then 
		WScript.Echo "AV is installed and Services are running"
	Else
		WScript.Echo "AV is installed but service is not running" 
	End If
Else 
	If Agent_Backwards_Flag = 1  And Agent_Common_Flag = 1 And Agent_Common_Flag = 1 And McShield_Flag = 1 Then 
		WScript.Echo "AV is installed and Services are running"
	Else
		WScript.Echo "AV is installed but service is not running" 
	End If
End If 

'***********************************************************************************************************************
