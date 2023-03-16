function New-MgShiftTimeOff {
    param (
        [Parameter(Mandatory)][string]$userId,
        [Parameter(Mandatory)][datetime]$startDateTime,
        [Parameter(Mandatory)][datetime]$endDateTime,
        [Parameter(Mandatory)][string]$timeOffReasonId,
        #Id of the Team to get shifts from
        [Parameter(Mandatory)][string]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)][string]$actAsUID,
        [Parameter(Mandatory)][string]$theme,
        [Parameter(Mandatory)][ValidateSet("draftTimeOff","sharedTimeOff")][string]$timeOffType,
        [string]$notes
    )

    #Convert to "ISO 8601" date format, which is supported in json queries
    $convertedStartDateTime = [Xml.XmlConvert]::ToString($startDateTime,[Xml.XmlDateTimeSerializationMode]::Utc)
    $convertedEndDateTime = [Xml.XmlConvert]::ToString($endDateTime,[Xml.XmlDateTimeSerializationMode]::Utc)

    $Body = @{
        "userId" = $userId
        "$timeOffType" = @{
            "@odata.type" = "microsoft.graph.timeOffItem"
            "timeOffReasonId" = $timeOffReasonId
            "startDateTime" = $convertedStartDateTime
            "endDateTime" = $convertedEndDateTime
            "theme" = $theme
            "notes" = $notes
        }
    }
    
    $splat = @{
        "Method" = "POST"
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule/timesOff"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "Content-type" = "application/json"
            "MS-APP-ACTS-AS" = $actAsUID
        }
        "Body" = [System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))
    }
    Invoke-RestMethod @splat
}