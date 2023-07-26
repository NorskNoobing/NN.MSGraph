function Invoke-MgShiftScheduleShare {
    param (
        #Id of the Team to get shifts from
        [Parameter(Mandatory)][string]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)][string]$actAsUID,
        [Parameter(Mandatory)][bool]$notifyTeam,
        [Parameter(Mandatory)][datetime]$startDateTime,
        [Parameter(Mandatory)][datetime]$endDateTime
    )

    $ParameterExclusion = @("teamId","actAsUID")
    $Body = $null
    $PSBoundParameters.Keys.ForEach({
        [string]$Key = $_
        $Value = $PSBoundParameters.$key
    
        if ($ParameterExclusion -contains $Key) {
            return
        }
    
        $Body += @{
            $Key = $Value
        }
    })

    $Splat = @{
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule/share"
        "Method" = "POST"
        "Headers" = @{
            "Accept" = "application/json"
            "Content-Type" = "application/json"
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "MS-APP-ACTS-AS" = $actAsUID
        }
        "Body" = ($Body | ConvertTo-Json)
    }
    Invoke-RestMethod @Splat
}