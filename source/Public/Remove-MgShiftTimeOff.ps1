function Remove-MgShiftTimeOff {
    param (
        [Parameter(Mandatory)][string]$timeOffId,
        #Id of the Team to get shifts from
        [Parameter(Mandatory)][string]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)][string]$actAsUID
    )

    $splat = @{
        "Method" = "DELETE"
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule/timesOff/$timeOffId"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "Content-type" = "application/json"
            "MS-APP-ACTS-AS" = $actAsUID
        }
    }
    Invoke-RestMethod @splat
}