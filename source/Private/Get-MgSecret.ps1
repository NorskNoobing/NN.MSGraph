function Get-MgSecret {
    param (
        $secretPath = "$env:USERPROFILE\.creds\MSGraph\msgraphSecret.xml"
    )


    #Check if secret file exists
    if (Test-Path $secretPath) {
        [datetime]$dateTomorrow = (Get-Date).AddDays(1)
        $secretExpiryDate = (Import-Clixml $secretPath | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json).endDateTime

        #Refresh secret if there's less than 1 day till secret expiry
        if ($dateTomorrow -gt $secretExpiryDate) {
            New-MgSecret
        }
    } else {
        #Refresh secret if the secret file doesn't exist
        New-MgSecret
    }

    #Import the secret key
    (Import-Clixml $secretPath | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json).secretText
}