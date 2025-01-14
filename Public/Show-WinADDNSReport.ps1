﻿function Show-WinADDNSRecords {
    <#
    .SYNOPSIS
    Small command that gathers quick information about DNS Server records and shows them in HTML output

    .DESCRIPTION
    Small command that gathers quick information about DNS Server records and shows them in HTML output

    .PARAMETER FilePath
    Path to HTML file where it's saved. If not given temporary path is used

    .PARAMETER HideHTML
    Prevents HTML output from being displayed in browser after generation is done

    .PARAMETER Online
    Forces use of online CDN for JavaScript/CSS which makes the file smaller. Default - use offline.

    .EXAMPLE
    Show-WinADDNSRecords

    .EXAMPLE
    Show-WinADDNSRecords -FilePath C:\Temp\test.html

    .NOTES
    General notes
    #>
    [cmdletBinding()]
    param(
        [parameter(Mandatory)][string] $FilePath,
        [switch] $HideHTML,
        [switch] $Online
    )
    # Gather data
    $DNSByName = Get-WinDNSRecords -Prettify -IncludeDetails
    $DNSByIP = Get-WinDNSIPAddresses -Prettify -IncludeDetails

    # Create HTML :-)
    New-HTML {
        New-HTMLTab -Name "DNS by Name" {
            New-HTMLTable -DataTable $DNSByName -Filtering {
                New-HTMLTableCondition -Name 'Count' -ComparisonType number -Value 1 -BackgroundColor LightGreen
                New-HTMLTableCondition -Name 'Count' -ComparisonType number -Value 1 -Operator gt -BackgroundColor Orange
                New-HTMLTableConditionGroup -Logic AND {
                    New-HTMLTableCondition -Name 'Count' -ComparisonType number -Value 1 -Operator gt
                    New-HTMLTableCondition -Name 'Types' -Operator like -ComparisonType string -Value 'static'
                    New-HTMLTableCondition -Name 'Types' -Operator like -ComparisonType string -Value 'dynamic'
                } -BackgroundColor Rouge -Row -Color White
            } -DataStore JavaScript
        }
        New-HTMLTab -Name 'DNS by IP' {
            New-HTMLTable -DataTable $DNSByIP -Filtering {
                New-HTMLTableCondition -Name 'Count' -ComparisonType number -Value 1 -BackgroundColor LightGreen
                New-HTMLTableCondition -Name 'Count' -ComparisonType number -Value 1 -Operator gt -BackgroundColor Orange
                New-HTMLTableConditionGroup -Logic AND {
                    New-HTMLTableCondition -Name 'Count' -ComparisonType number -Value 1 -Operator gt
                    New-HTMLTableCondition -Name 'Types' -Operator like -ComparisonType string -Value 'static'
                    New-HTMLTableCondition -Name 'Types' -Operator like -ComparisonType string -Value 'dynamic'
                } -BackgroundColor Rouge -Row -Color White
            } -DataStore JavaScript
        }
    } -ShowHTML:(-not $HideHTML.IsPresent) -Online:$Online.IsPresent -TitleText "DNS Configuration" -FilePath $FilePath
}