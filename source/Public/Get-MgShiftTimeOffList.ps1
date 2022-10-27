function Get-MgShiftTimeOffList {
    param (
        #Id of the Team to get shifts from
        [Parameter(Mandatory)]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)]$actAsUID,
        #Timespan to fetch shifts from
        [Parameter(Mandatory)][datetime]$dateFrom,
        [datetime]$dateTo = $dateFrom.AddDays(1)
    )

    #Convert to "ISO 8601" date format, which is supported in json queries
    $convertedDateFrom = [Xml.XmlConvert]::ToString($dateFrom,[Xml.XmlDateTimeSerializationMode]::Utc)
    $convertedDateTo = [Xml.XmlConvert]::ToString($dateTo,[Xml.XmlDateTimeSerializationMode]::Utc)

    $splat = @{
        "Method" = "GET"
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule/timesOff"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "MS-APP-ACTS-AS" = $actAsUID
        }
        "Body" = @{
            '$filter' = "sharedTimeOff/startDateTime ge $convertedDateFrom and sharedTimeOff/endDateTime le $convertedDateTo"
        }
    }
    Invoke-RestMethod @splat
}