function New-MgShiftSchedulingGroup {
    param (
        #Id of the Team to get shifts from
        [Parameter(Mandatory)][string]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)][string]$actAsUID,
        [Parameter(Mandatory)][string]$displayName,
        [array]$userIds
    )

    $ParameterExclusion = @()
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
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule/schedulingGroups"
        "Method" = "POST"
        "Headers" = @{
            "Accept" = "application/json"
            "Content-Type" = "application/json"
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "MS-APP-ACTS-AS" = $actAsUID
        }
        "Body" = [System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json -Depth 99))
    }
    Invoke-RestMethod @Splat
}