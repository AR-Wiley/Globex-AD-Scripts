if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as Administrator."
    return 
}
else {
    Write-Host "Running as Administrator."
}

$dnPath = "DC=Globex,DC=com"
$ouPath = "OU=Users,$dnPath"

$usersOU = @("Executives", "Finance", "Advisors", "HR", "IT", "Sales")


function AD-Module-Installed{

    if(-not(Get-Module -name ActiveDirectory )){
        try {
            Import-Module -Name ActiveDirectory
            Write-Host "ActiveDirectory has been installed..."
        }
        catch {
            Write-Host "Failed to Create..." -ForegroundColor Red
        }
    } 
}

function Validate-Globex-DC {
    
        if (-not(Get-ADDomain $dnPath)) {
            Write-Host "Domain does not exist" -BackgroundColor Red -ForegroundColor Black
            return 
        }

}

function Validate-Users-OU {
    
        if (-not(Get-ADOrganizationalUnit $ouPath)) {
            Write-Host "Parent OU does not exist" -BackgroundColor Red -ForegroundColor Black
            return  
        }

}


function Create-OUs {

    forEach($i in $usersOU) {
            
        if (Get-ADOrganizationalUnit -Filter "$i -eq '$i'" -SearchBase $OUPath) {    
            Write-Host "Organizational Unit '$i' already exists" -ForegroundColor Yellow
            return
        }
    
        Try {        
            New-ADOrganizationalUnit -Name $i -Path $ouPath -ProtectedFromAccidentalDeletion $false 
            Write-Host "Organizational Unit '$i' was successfully created." -ForegroundColor Green
        } 
        
        Catch {
            Write-Host "Failed to Create: $i" -ForegroundColor Red 
        }   
    
    }

}

AD-Module-Installed
Validate-Globex-DC
Validate-Users-OU
Create-OUs
