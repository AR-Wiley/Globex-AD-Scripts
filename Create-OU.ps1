
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as Administrator."
    return 
}
else {
    Write-Host "Running as Administrator."
}


$OUPath = "DC=Globex,DC=com"

function AD-Module-Installed {

    if (-not(Get-Module -name ActiveDirectory )) {
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
    
    if (-not (Get-ADDomain -Identity "globex.com" -ErrorAction SilentlyContinue)) {
         Write-Host "Domain does not exist" -ForegroundColor Black -BackgroundColor Red
         exit
    }
}


function Create-OU {

    param (
        [string]$name
    )

    if (Get-ADOrganizationalUnit -Filter "Name -eq '$name'" -SearchBase $OUPath) {    
        Write-Host "Organizational Unit '$name' already exists" -ForegroundColor Yellow
        return
    }

    Try {        
        New-ADOrganizationalUnit -Name $name -Path "$OUPath" -ProtectedFromAccidentalDeletion $false 
        Write-Host "Organizational Unit '$name' was successfully created." -ForegroundColor Green
    }
    Catch {
        Write-Host "Failed to Create" -ForegroundColor Red 
    }
}

AD-Module-Installed 
Validate-Globex-DC
Create-OU -Name "Name"
