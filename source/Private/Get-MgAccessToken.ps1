function Get-MgAccessToken {
    param (
        #Azure tenantID
        $tenantIdPath = "$env:USERPROFILE\.creds\MSGraph\msgraphTenantId.xml",
        #AppID of the Azure app
        $appIdPath = "$env:USERPROFILE\.creds\MSGraph\msgraphAppId.xml",
        $accessTokenPath = "$env:USERPROFILE\.creds\MSGraph\msgraphAccessToken.xml"
    )

    #Create folder to store credentials
    if (!(Test-Path $accessTokenPath)) {
        #Create parent folders of the access token file 
        mkdir -p $accessTokenPath.Substring(0, $accessTokenPath.lastIndexOf('\')) | Out-Null
    }

    #Create tenantId file
    if (Test-Path $tenantIdPath) {
        $tenantId = Import-Clixml $tenantIdPath | ConvertFrom-SecureString -AsPlainText
    } else {
        $tenantId = Read-Host "Enter tenantId"
        $tenantId | ConvertTo-SecureString -AsPlainText | Export-Clixml $tenantIdPath
    }

    #Create appId file
    if (Test-Path $appIdPath) {
        $appId = Import-Clixml $appIdPath | ConvertFrom-SecureString -AsPlainText
    } else {
        $appId = Read-Host "Enter appId"
        $appId | ConvertTo-SecureString -AsPlainText | Export-Clixml $appIdPath
    }

    #Conditions to refresh access token
    if (Test-Path $accessTokenPath) {
        [datetime]$accessTokenExpiryDate = (Import-Clixml $accessTokenPath | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json).expiry_date

        #Refresh access token if there's less than 5 minutes till token expiry
        if (($accessTokenExpiryDate.AddMinutes(-5)) -lt (Get-Date)) {
            $refreshAccessToken = $true
        }
    } else {
        $refreshAccessToken = $true
    }

    #Request new access token
    if ($refreshAccessToken) {
        $splat = @{
            "Method" = "POST"
            "Uri" = "https://login.microsoftonline.com/$tenantId/oauth2/token"
            "Body" = @{
                "resource" = "https://graph.microsoft.com"
                "client_id"     = $appId
                "client_secret" = Get-MgSecret
                "grant_type"    = "client_credentials"
                "scope"         = "openid"
            }
        }
        $result = Invoke-RestMethod @splat

        #Adds access token and expiry date to access token file
        [PSCustomObject]@{
            access_token = $result.access_token
            expiry_date = (Get-Date).AddSeconds($result.expires_in)
        } | ConvertTo-Json | ConvertTo-SecureString -AsPlainText | Export-Clixml -Path $accessTokenPath

        #Output the new access token
        $result.access_token
    } else {
        #Import the existing access token
        (Import-Clixml $accessTokenPath | ConvertFrom-SecureString -AsPlainText | ConvertFrom-Json).access_token
    }
}