
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as Administrator."
    return 
}
else {
    Write-Host "Running as Administrator."
}

function AD_Module_Installed{

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

function Create-OU {

    param (
        [string]$name
    )

    $OUPath = "DC=Globex,DC=com"

    if (Get-ADOrganizationalUnit -Filter "Name -eq '$name'" -SearchBase $OUPath) {    
        Write-Host "Organizational Unit '$name' already exists" -ForegroundColor Yellow
        return
    }

    Try {        
        New-ADOrganizationalUnit -Name $name -Path "DC=Globex,DC=com" -ProtectedFromAccidentalDeletion $false 
        Write-Host "Organizational Unit '$name' was successfully created." -ForegroundColor Green
    }
    Catch {
        Write-Host "Failed to Create" -ForegroundColor Red 
    }
}

AD_Module_Installed
Create-OU
