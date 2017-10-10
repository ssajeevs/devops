#####################################################################################################################################
#NAME:Bulk User Account Extension by 180 days 
#PURPOSE: Bulk User account extension by changing the Account valid Date by 180 days And appending the description With Change number 
#VERSION : 1
#Date:3-Aug-2017
#AUTHOR : sajeev S  
#added this file to Git-Hub account
#####################################################################################################################################
$pwd = Get-location # To get the current working directory
$users_list = "Users_list.txt" # Input file
$Renewed_Accounts = "Renewed_Accounts.txt" # To Store the Renewed accounts informations 
$Strunalocate = "Unalocated_users.txt" # To Store the unallocated informations
$Disabledusers = "Disabled_users.txt" # To Store the disabled account informations
$NonExpiry_Accounts = "NonExpiry_Accounts.txt" # To Store the expired account informations
$Input_file = Join-Path $pwd $users_list 

If (Test-Path $Input_file)
	{
	Import-Module -Name Active* # To import Active Directory module in the script 
	$UserContent = Get-Content Users_list.txt    
	$Des = Read-Host -Prompt 'Enter the change request ID ' # To input the change request number
	$Renewed_Accounts_path = Join-Path $pwd $Renewed_Accounts
If (Test-Path $Renewed_Accounts_path) # To clear the content of Renewed_Accounts.txt file 
	{
	Clear-Content $Renewed_Accounts_path         
	}
$Strunalocate_path = Join-Path $pwd $Strunalocate
If (Test-Path $Strunalocate_path) # To clear the content of Unalocated_users.txt file
	{
	Clear-Content $Strunalocate_path	    
	}
$Disabledusers_path = Join-Path $pwd $Disabledusers
If (Test-Path $Disabledusers_path) # To clear the content Disabled_users.txt file
	{
	Clear-Content $Disabledusers_path	    
	}
$NonExpiry_Accounts_path = Join-Path $pwd $NonExpiry_Accounts # To clear the content of NonExpiry_Accounts.txt file
        If (Test-Path $NonExpiry_Accounts_path)
	    {
	    Clear-Content $NonExpiry_Accounts_path	    
	    }
$Set_Exp_Date = (Get-Date).Addmonths(6)
$Cal_Day = (Get-Date).Day
$Cal_Month = (Get-Date).month
If ( ($Cal_Day -eq 29 -or $Cal_Day -eq 30 -or $Cal_Day -eq 31)  -and $Cal_Month -eq 8)
{
$Set_Exp_Date = $Set_Exp_Date.AddDays(1)
}
If ( $Cal_Day -eq 31  -and ($Cal_Month -eq 3 -or $Cal_Month -eq 5 -or $Cal_Month -eq 10 -or $Cal_Month -eq 12) )
{
$Set_Exp_Date = $Set_Exp_Date.AddDays(1)
}
$Set_Exp_Date = $Set_Exp_Date.AddDays(1)

foreach ($users In $UserContent) # To fetch one-by-one users from the users_list file
		{
              $User_exist = Get-ADUser -Filter {sAMAccountName -eq $users}
                    If($User_exist -eq $Null)  # To Check the users is exist in the AD
                        {
                        $users  >>$Strunalocate_path # To Store unallacated user information
                        }
                    else
                        {
		                    $UserStore = Get-ADUser -LDAPFilter "(samaccountname=$users)" | Select-Object -Property enabled	# To check the user status Enabled/disavled	
		                    $UserStore = $UserStore -Replace "@{enabled=" , ""
		                    $UserStore = $UserStore -Replace "}" , ""
                            $ExpirationDate=(Get-ADUser $users -Properties 'AccountExpirationDate').AccountExpirationdate # To get the account expiration date
                    				If ($UserStore -eq "True" -and $ExpirationDate -ne $Null) # To check the account expiration date is NULL
					                    {
      				                    Set-ADAccountExpiration  $users $Set_Exp_Date # To set the account expiration date
					                    $current_desc=$Null
					                    $add_Desc =  $Null
					                    $current_desc = Get-ADUser -Identity $users -Properties Description | Select Description # To append the user description with new ticket number
					                    $current_desc = $current_desc -Replace "@{Description=" , " "
					                    $current_desc = $current_desc -Replace "}" , ""
					                    $add_Desc = $Des + $current_desc
					                    Set-ADUser $users -Description $add_Desc
					                    $users   >>$Renewed_Accounts_path # To store renewed account(s) information
					                    }
				                    ElseIf($UserStore -eq "False")
					                    {
					                    $users  >>$Disabledusers_path # To store disabled account(s) information
					                    }
                                    else
                                        {
                                        $users   >>$NonExpiry_Accounts_path # To store non-expiry account information
                                        }
                    
				            }
    	  }
}

Else

{
Write-Host ""
Write-Host "Error : Users_list.txt - file does not exist in the working dirctory." 
Write-Host ""
Write-Host "Press any key to exit... "
Write-Host ""
[void][System.Console]::ReadKey($True) # Screen to wait
}
					
########################################################################################################				