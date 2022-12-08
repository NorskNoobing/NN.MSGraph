function Send-MgMail {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Identifier,
        [string]$Subject,
        [string]$Content,
        [array]$ToRecipients,
        [array]$CcRecipients,
        [bool]$SaveToSentItems = $true
    )

    begin {
        $ToRecipientsArr = New-Object -TypeName System.Collections.ArrayList
        $CcRecipientsArr = New-Object -TypeName System.Collections.ArrayList
    }

    process {
        #Convert toRecipients
        $ToRecipients.ForEach({
            $null = $ToRecipientsArr.Add(
                @{
                    "emailAddress" = @{
                        "address" = "$_"
                    }
                }
            )
        })
        #Convert ccRecipients
        $CcRecipients.ForEach({
            $null = $CcRecipientsArr.Add(
                @{
                    "emailAddress" = @{
                        "address" = "$_"
                    }
                }
            )
        })

        $Splat = @{
            "Method" = "POST"
            "Uri" = "https://graph.microsoft.com/v1.0/users/$Identifier/sendMail"
            "Headers" = @{
                "Authorization" = "Bearer $(Get-MgAccessToken)"
                "Content-type" = "application/json"
            }
            "Body" = @{
                "message" = @{
                    "subject" = $Subject
                    "body" = @{
                        "contentType" = "Text"
                        "content" = $Content
                    }
                    "toRecipients" = $ToRecipientsArr
                    "ccRecipients" = $CcRecipientsArr
                }
                "saveToSentItems" = $SaveToSentItems
            } | ConvertTo-Json -Depth 10
        }
        Invoke-RestMethod @Splat
    }
}