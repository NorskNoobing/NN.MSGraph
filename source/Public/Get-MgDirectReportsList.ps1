function Get-MgDirectReportsList {
    param (
        [Parameter(Mandatory)][string]$identifier
    )
    $splat = @{
        "Method" = "GET"
        "Uri" = "https://graph.microsoft.com/v1.0/users/$identifier/directReports"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
        }
    }
    Invoke-RestMethod @splat
}