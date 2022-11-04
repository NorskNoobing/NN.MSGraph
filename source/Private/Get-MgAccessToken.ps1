function Get-MgAccessToken {
    param (
        $accessTokenPath = "$env:USERPROFILE\.creds\MSGraph\msgraphAccessToken.xml"
    )

    #Conditions to refresh access token
    if (Test-Path $accessTokenPath) {
        [datetime]$accessTokenExpiryDate = (Import-Clixml $accessTokenPath | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json).expiry_date

        #Refresh access token if there's less than 5 minutes till token expiry
        if (($accessTokenExpiryDate.AddMinutes(-5)) -lt (Get-Date)) {
            #Request new access token
            New-MgAccessToken
        }
    } else {
        #Request new access token
        New-MgAccessToken
    }

    #Import the access token
    (Import-Clixml $accessTokenPath | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json).access_token
}