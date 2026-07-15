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


function Create-Group {

	param (
		[string]$name,
		[string]$OU,
		[ValidateSet("Global","Universal","DomainLocal")][string]$groupScope
	)

	$groupPath = "OU=$OU,DC=Globex,DC=Com"

	if (Get-ADGroup -Filter "Name -eq '$name'" -SearchBase $groupPath) {
		Write-Host "Group $name already exists" 
		return
	}

	Try {
		New-ADGroup -Name $name -Path $groupPath -GroupScope $groupScope -GroupCategory Security
		Write-Host "AD Group $name had been created"
	} Catch {
		Write-Host "Failed to create"
	}


}

AD_Module_Installed
Create-Group
