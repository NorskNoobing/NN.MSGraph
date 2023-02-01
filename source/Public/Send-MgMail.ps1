function Send-MgMail {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Identifier,
        [string]$Subject,
        [Parameter(Mandatory,ParameterSetName="Send txt mail")][string]$Content,
        [Parameter(Mandatory,ParameterSetName="Send html mail")][string]$HtmlContent,
        [Parameter(Mandatory)][array]$ToRecipients,
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

        switch ($PsCmdlet.ParameterSetName) {
            "Send txt mail" {
                $MsgBody = @{
                    "contentType" = "Text"
                    "content" = $Content
                }
            }
            "Send html mail" {
                $MsgBody = @{
                    "contentType" = "HTML"
                    "content" = $HtmlContent
                }
            }
        }

        $Body = @{
            "message" = @{
                "subject" = $Subject
                "body" = $MsgBody
                "toRecipients" = $ToRecipientsArr
                "ccRecipients" = $CcRecipientsArr
            }
            "saveToSentItems" = $SaveToSentItems
        } | ConvertTo-Json -Depth 10

        $Splat = @{
            "Method" = "POST"
            "Uri" = "https://graph.microsoft.com/v1.0/users/$Identifier/sendMail"
            "Headers" = @{
                "Authorization" = "Bearer $(Get-MgAccessToken)"
                "Content-type" = "application/json"
            }
            "Body" = [System.Text.Encoding]::UTF8.GetBytes($Body)
        }
        Invoke-RestMethod @Splat
    }
}