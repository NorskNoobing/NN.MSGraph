function Get-MgShiftList {
    [CmdletBinding(DefaultParameterSetName="List shifts")]
    param (
        #Id of the Team to get shifts from
        [Parameter(Mandatory)]$teamId,
        #Id of the user that the request is sent on the behalf of
        [Parameter(Mandatory)]$actAsUID,
        #Timespan to fetch shifts from
        [Parameter(ParameterSetName="Get shifts within timeframe",Mandatory)][datetime]$dateFrom,
        [Parameter(ParameterSetName="Get shifts within timeframe")][datetime]$dateTo,
        [Parameter(ParameterSetName="List shifts")][switch]$ListShifts
    )
    
    $splat = $ExportObjects = $null

    switch ($PsCmdlet.ParameterSetName) {
        "Get shifts within timeframe" {
            if (!$dateTo) {
                $dateTo = $dateFrom.AddDays(1)
            }
            
            #Convert to "ISO 8601" date format, which is supported in json queries
            $convertedDateFrom = [Xml.XmlConvert]::ToString($dateFrom,[Xml.XmlDateTimeSerializationMode]::Utc)
            $convertedDateTo = [Xml.XmlConvert]::ToString($dateTo,[Xml.XmlDateTimeSerializationMode]::Utc)

            $splat += @{
                "Body" = @{
                    '$filter' = @"
sharedShift/startDateTime ge $convertedDateFrom and sharedShift/endDateTime le $convertedDateTo
"@
                }
            }
        }
    }

    $splat += @{
        "Method" = "GET"
        "Uri" = "https://graph.microsoft.com/v1.0/teams/$teamId/schedule/shifts"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-MgAccessToken)"
            "MS-APP-ACTS-AS" = $actAsUID
        }
    }
    $result = Invoke-RestMethod @splat
    $ExportObjects += $result.value

    while ($result.'@odata.nextLink') {
        $splat.Uri = $result.'@odata.nextLink'
        $result = Invoke-RestMethod @splat
        $ExportObjects += $result.value
    }
    
    Write-Output $ExportObjects
}