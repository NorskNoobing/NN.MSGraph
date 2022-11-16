#Requires -Module ModuleBuilder
[string]$moduleName = "NN.MSGraph"
[version]$version = "0.0.3"
[string]$author = "NorskNoobing"
[string]$ProjectUri = "https://github.com/$author/$moduleName"
[string]$releaseNotes = "Change name of Get-MgUser to Get-MgApiUser"
[string]$description = "MSGraph API integration"
[array]$tags = @("MSGraph","Graph","Microsoft","API")
[version]$PSversion = "7.2"

$manifestSplat = @{
    "Description" = $description
    "PowerShellVersion" = $PSversion
    "Tags" = $tags
    "ReleaseNotes" = $releaseNotes
    "Path" = "$PSScriptRoot\source\$moduleName.psd1"
    "RootModule" = "$moduleName.psm1"
    "Author" = $author
    "ProjectUri" = $ProjectUri
}
New-ModuleManifest @manifestSplat

$buildSplat = @{
    "SourcePath" = "$PSScriptRoot\source\$moduleName.psd1"
    "Version" = $version
}
Build-Module @buildSplat