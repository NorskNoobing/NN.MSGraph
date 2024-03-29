function Get-MgShiftSchedulingGroupList {
    param (
        #Id of the Team to get shifts from
        [Parameter(Mandatory)]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)]$actAsUID
    )

    $splat = @{
        "Method" = "GET"
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule/schedulingGroups"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "MS-APP-ACTS-AS" = $actAsUID
        }
    }
    $result = Invoke-RestMethod @splat
    $result.value
}