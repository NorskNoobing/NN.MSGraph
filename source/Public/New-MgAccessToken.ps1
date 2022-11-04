function New-MgAccessToken {
    param (
        #Azure tenantID
        $tenantIdPath = "$env:USERPROFILE\.creds\MSGraph\msgraphTenantId.xml",
        #AppID of the Azure app
        $appIdPath = "$env:USERPROFILE\.creds\MSGraph\msgraphAppId.xml",
        $accessTokenPath = "$env:USERPROFILE\.creds\MSGraph\msgraphAccessToken.xml"
    )
    
    #Create folder to store credentials
    $accessTokenDir = $accessTokenPath.Substring(0, $accessTokenPath.lastIndexOf('\'))
    if (!(Test-Path $accessTokenDir)) {
        $null = New-Item -ItemType Directory $accessTokenDir
    }

    #Get tenantId
    if (Test-Path $tenantIdPath) {
        $tenantId = Import-Clixml $tenantIdPath | ConvertFrom-SecureString -AsPlainText
    } else {
        #Create tenantId file
        $tenantId = Read-Host "Enter MSGraph tenantId"
        $tenantId | ConvertTo-SecureString -AsPlainText | Export-Clixml $tenantIdPath
    }

    #Get appId    
    if (Test-Path $appIdPath) {
        $appId = Import-Clixml $appIdPath | ConvertFrom-SecureString -AsPlainText
    } else {
        #Create appId file
        $appId = Read-Host "Enter MSGraph appId"
        $appId | ConvertTo-SecureString -AsPlainText | Export-Clixml $appIdPath
    }

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
    } | ConvertTo-Json | ConvertTo-SecureString -AsPlainText | Export-Clixml -Path $accessTokenPath -Force
}