function Get-MgSecret {
    param (
        #ObjectId of the Azure application
        $objectIdPath = "$env:USERPROFILE\.creds\MSGraph\msgraphObjectId.xml",
        $secretPath = "$env:USERPROFILE\.creds\MSGraph\msgraphSecret.xml"
    )

    #Create folder to store credentials
    if (!(Test-Path $secretPath)) {
        #Create parent folders of the access token file 
        mkdir -p $secretPath.Substring(0, $secretPath.lastIndexOf('\')) | Out-Null
    }

    #Create objectId file
    if (Test-Path $objectIdPath) {
        $objectId = Import-Clixml $objectIdPath | ConvertFrom-SecureString -AsPlainText
    } else {
        $objectId = Read-Host "Enter objectId"
        $objectId | ConvertTo-SecureString -AsPlainText | Export-Clixml $objectIdPath
    }

    #Check if secret file exists
    if (Test-Path $secretPath) {
        [datetime]$dateTomorrow = (Get-Date).AddDays(1)
        $secretExpiryDate = (Import-Clixml $secretPath | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json).endDateTime

        #Refresh secret if there's less than 1 day till secret expiry
        if ($dateTomorrow -gt $secretExpiryDate) {
            $refreshSecret = $true
        }
    } else {
        #Refresh secret if the secret file doesn't exist
        $refreshSecret = $true
    }

    #Check if a secret refresh is required, if not, import the existing secret key
    if ($refreshSecret) {
        #Install required modules
        if (!(Get-Module -Name Az.Accounts)) {
            Install-Module Az.Accounts -Force
        }
        if (!(Get-Module -Name Az.Resources)) {
            Install-Module Az.Resources -Force
        }

        #Login to sys_tbkiosk (interactive window)
        Connect-AzAccount | Out-Null
        #Create a new secret
        $result = New-AzADAppCredential -ObjectId $objectId -CustomKeyIdentifier "TeamBrukeropplevelse"
        #Export secret to the secret file
        $result | ConvertTo-SecureString -AsPlainText | Export-Clixml $secretPath -Force
        #Output the new secret key
        Write-Host $result.secretText
    } else {
        #Import the existing secret key
        (Import-Clixml $secretPath | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json).secretText
    }
}