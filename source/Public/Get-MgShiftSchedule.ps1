function Get-MgShiftSchedule {
    param (
        #Id of the Team to get shifts from
        [Parameter(Mandatory)][string]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)][string]$actAsUID
    )

    $Splat = @{
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule"
        "Method" = "GET"
        "Headers" = @{
            "Accept" = "application/json"
            "Content-Type" = "application/json"
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "MS-APP-ACTS-AS" = $actAsUID
        }
    }
    Invoke-RestMethod @Splat
}