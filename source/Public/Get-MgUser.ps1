function Get-MgUser {
    param (
        [Parameter(Mandatory)]$identifier
    )
    
    $splat = @{
        "Method" = "GET"
        "Uri" = "https://graph.microsoft.com/v1.0/users/$identifier"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
        }
    }
    Invoke-RestMethod @splat
}