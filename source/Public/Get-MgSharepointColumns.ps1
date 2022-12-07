function Get-MgSharepointColumns {
    [CmdletBinding(DefaultParameterSetName="List columns")]
    param (
        [Parameter(Mandatory)][string]$SiteId,
        [Parameter(Mandatory)][string]$ListId, 
        [Parameter(Mandatory,ParameterSetName="Get column by id")][string]$ColumnId,
        [Parameter(ParameterSetName="List columns")][switch]$ListColumns
    )

    process {
        $Uri = "https://graph.microsoft.com/v1.0/sites/$SiteId/lists/$ListId"

        switch ($PsCmdlet.ParameterSetName) {
            "Get column by id" {
                $Uri = "$Uri/columns/$ColumnId"
            }
            "List columns" {
                $Uri = "$Uri/columns"
            }
        }

        $Splat = @{
            "Method" = "GET"
            "Uri" = $Uri
            "Headers" = @{
                "Authorization" = "Bearer $(Get-MgAccessToken)"
            }
        }
        $result = Invoke-RestMethod @Splat

        switch ($PsCmdlet.ParameterSetName) {
            "Get column by id" {
                $Result
            }
            "List columns" {
                $Result.value
            }
        }
    }
}