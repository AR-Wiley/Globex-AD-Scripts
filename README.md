# Globex Active Directory Scripts

Create-OU.ps1
-This script is for quick creation of a AD Organizational Unit. 
-First the script will validate that the AD-Module is Installed. It will also validate that the root domain exists. 
-The script will contain a function that will take a name as an string input. It will first validate that the OU currently does not exist. If it OU already exists the script will exit. If OU does not exist it will creat the OU under the primary root domain. 


