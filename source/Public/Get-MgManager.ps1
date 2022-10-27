function Get-MgManager {
    param (
        [Parameter(Mandatory)][string]$identifier
    )
    $splat = @{
        "Method" = "GET"
        "Uri" = "https://graph.microsoft.com/v1.0/users/$identifier/manager"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
        }
    }
    Invoke-RestMethod @splat
}