function Get-MgShift {
    param (
        #Id of the Team to get shifts from
        [Parameter(Mandatory)]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)]$actAsUID,
        [Parameter(Mandatory)]$shiftId
    )

    $splat = @{
        "Method" = "GET"
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule/shifts/$shiftId"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "MS-APP-ACTS-AS" = $actAsUID
        }
    }
    Invoke-RestMethod @splat
}