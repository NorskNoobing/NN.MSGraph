function Get-MgShiftSchedulingGroup {
    param (
        #Id of the Team to get shifts from
        [string][Parameter(Mandatory)]$teamId,
        #Id of the user that the request is sent on the behalf of
        [string][Parameter(Mandatory)]$actAsUID,
        [string][Parameter(Mandatory)]$schedulingGroupId
    )

    $splat = @{
        "Method" = "GET"
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule/schedulingGroups/$schedulingGroupId"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "MS-APP-ACTS-AS" = $actAsUID
        }
    }
    Invoke-RestMethod @splat
}