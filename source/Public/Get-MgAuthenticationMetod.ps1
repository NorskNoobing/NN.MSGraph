function Get-MgAuthenticationMethod {
    param (
        [Parameter(Mandatory)][string]$UPN
    )
    
    $splat = @{
        "Method" = "GET"
        "Uri" = "https://graph.microsoft.com/beta/users/$UPN/authentication/phoneMethods"
        "Headers" = @{
            "Authorization" = "Bearer $(Get-GraphAccessToken)"
        }
    }
    Invoke-RestMethod @splat
}