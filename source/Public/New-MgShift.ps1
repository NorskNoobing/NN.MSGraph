function New-MgShift {
    param (
        [Parameter(Mandatory)][string]$userId,
        [Parameter(Mandatory)][datetime]$startDateTime,
        [Parameter(Mandatory)][datetime]$endDateTime,
        [Parameter(Mandatory)][string]$displayName,
        [Parameter(Mandatory)][string]$theme,
        [Parameter(Mandatory)][string]$schedulingGroupId,
        #Id of the Team to get shifts from
        [Parameter(Mandatory)][string]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)][string]$actAsUID,
        [Parameter(Mandatory)][ValidateSet("sharedShift","draftShift")][string]$shiftType,
        [string]$notes
    )

    #Convert to "ISO 8601" date format and UTC timezone, which is supported in json queries
    $convertedStartDateTime = [Xml.XmlConvert]::ToString($startDateTime,[Xml.XmlDateTimeSerializationMode]::Utc)
    $convertedEndDateTime = [Xml.XmlConvert]::ToString($endDateTime,[Xml.XmlDateTimeSerializationMode]::Utc)

    $Body = @{
        "userId" = $userId
        "schedulingGroupId" = $schedulingGroupId
        "$shiftType" = @{
            "@odata.type" = "microsoft.graph.shiftItem"
            "displayName" = $displayName
            "startDateTime" = $convertedStartDateTime
            "endDateTime" = $convertedEndDateTime
            "notes" = $notes
            "theme" = $theme
        }
    }

    $splat = @{
        "Method" = "POST"
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule/shifts"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "Content-type" = "application/json"
            "MS-APP-ACTS-AS" = $actAsUID
        }
        "Body" = [System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))
    }
    Invoke-RestMethod @splat
}