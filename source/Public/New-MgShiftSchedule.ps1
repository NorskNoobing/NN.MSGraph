function New-MgShiftSchedule {
    param (
        #Id of the Team to get shifts from
        [Parameter(Mandatory)][string]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)][string]$actAsUID,
        [Parameter(Mandatory)][bool]$enabled,
        [Parameter(Mandatory)][string]$timeZone,
        [bool]$offerShiftRequestsEnabled,
        [bool]$openShiftsEnabled,
        [bool]$swapShiftsRequestsEnabled,
        [bool]$timeClockEnabled,
        [bool]$timeOffRequestsEnabled
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
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule"
        "Method" = "PUT"
        "Headers" = @{
            "Accept" = "application/json"
            "Content-Type" = "application/json"
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "MS-APP-ACTS-AS" = $actAsUID
        }
        "Body" = $Body | ConvertTo-Json -Depth 99
    }

    Write-Warning @"
Are you sure you want to perform destructive action that replaces the shift schedule on the team
`"$teamId`"
"@
    $confirmation = Read-Host "Press [y] to confirm:"
    if ($confirmation -ne 'y') {
        Write-Host "Destructive action successfully cancelled"
        return
    }

    Invoke-RestMethod @Splat
}