function New-MgSecret {
    param (
        #ObjectId of the Azure application
        $objectIdPath = "$env:USERPROFILE\.creds\MSGraph\msgraphObjectId.xml",
        $secretPath = "$env:USERPROFILE\.creds\MSGraph\msgraphSecret.xml"
    )

    #Create folder to store credentials
    $secretDir = $secretPath.Substring(0, $secretPath.lastIndexOf('\'))
    if (!(Test-Path $secretDir)) {
        $null = New-Item -ItemType Directory $secretDir
    }

    #Create objectId file
    if (Test-Path $objectIdPath) {
        $objectId = Import-Clixml $objectIdPath | ConvertFrom-SecureString -AsPlainText
    } else {
        $objectId = Read-Host "Enter MSGraph objectId"
        $objectId | ConvertTo-SecureString -AsPlainText | Export-Clixml $objectIdPath
    }

    #Install required modules
    $RequiredModulesNameArray = @("Az.Accounts","Az.Resources")
    $RequiredModulesNameArray.ForEach({
        if (Get-InstalledModule $_ -ErrorAction SilentlyContinue) {
            Import-Module $_ -Force
        } else {
            Install-Module $_ -Force -Repository PSGallery
        }
    })

    #Connect to the Azure account
    $null = Connect-AzAccount
    #Create a new secret
    $result = New-AzADAppCredential -ObjectId $objectId
    #Export secret to the secret file
    $result | ConvertTo-SecureString -AsPlainText | Export-Clixml $secretPath -Force
    #Output the eol date of the secret
    Write-Output "MSGraph secret expires $($result.endDateTime.ToString("dd/MM/yyyy hh:mm"))"
}