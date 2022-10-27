function New-MgShiftTimeOff {
    param (
        [Parameter(Mandatory)]$userId,
        [Parameter(Mandatory)]$startDateTime,
        [Parameter(Mandatory)]$endDateTime,
        [Parameter(Mandatory)]$timeOffReasonId,
        #Id of the Team to get shifts from
        [Parameter(Mandatory)]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)]$actAsUID,
        [string]$notes,
        $theme = "gray"
    )

    #Convert from current TZ to UTC
    $strCurrentTZ = (Get-CimInstance win32_timezone).StandardName
    $TZ = [System.TimeZoneInfo]::FindSystemTimeZoneById($strCurrentTZ)
    $shiftStartDateTime = [System.TimeZoneInfo]::ConvertTimeToUtc($startDateTime, $TZ)
    $shiftEndDateTime = [System.TimeZoneInfo]::ConvertTimeToUtc($endDateTime, $TZ)

    #Convert to "ISO 8601" date format, which is supported in json queries
    $convertedStartDateTime = [Xml.XmlConvert]::ToString($shiftStartDateTime,[Xml.XmlDateTimeSerializationMode]::Utc)
    $convertedEndDateTime = [Xml.XmlConvert]::ToString($shiftEndDateTime,[Xml.XmlDateTimeSerializationMode]::Utc)
    
    $splat = @{
        "Method" = "POST"
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule/timesOff"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "Content-type" = "application/json"
            "MS-APP-ACTS-AS" = $actAsUID
        }
        "Body" = @{
            "userId" = $userId
            "sharedTimeOff" = @{
                "@odata.type" = "microsoft.graph.timeOffItem"
                "timeOffReasonId" = $timeOffReasonId
                "notes" = $notes
                "startDateTime" = $convertedStartDateTime
                "endDateTime" = $convertedEndDateTime
                "theme" = $theme
            }
        } | ConvertTo-Json
    }
    Invoke-RestMethod @splat
}