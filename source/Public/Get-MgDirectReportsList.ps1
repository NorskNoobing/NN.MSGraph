function Get-MgDirectReportsList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$identifier
    )

    process {
        $splat = @{
            "Method" = "GET"
            "Uri" = "https://graph.microsoft.com/v1.0/users/$identifier/directReports"
            "Headers" = @{
                "Authorization" = "Bearer $(Get-MgAccessToken)"
            }
        }
        $Result = Invoke-RestMethod @splat
        $Result.value
    }
}