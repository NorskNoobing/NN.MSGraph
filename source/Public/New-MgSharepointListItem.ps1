function New-MgSharepointListItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$SiteId,
        [Parameter(Mandatory)][string]$ListId,
        [Parameter(Mandatory)][hashtable]$RequestBody
    )

    process {
        $splat = @{
            "Method" = "POST"
            "Uri" = "https://graph.microsoft.com/v1.0/sites/$SiteId/lists/$ListId/items"
            "Headers" = @{
                "Authorization" = "Bearer $(Get-MgAccessToken)"
                "Content-type" = "application/json"
            }
            "Body" = @{
                "fields" = $RequestBody
            } | ConvertTo-Json
        }
        Invoke-RestMethod @splat
    }
}