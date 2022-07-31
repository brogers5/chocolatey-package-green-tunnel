$installerFileNameRegex = 'green-tunnel-windows.zip$'
$repo = 'SadeghHayeri/GreenTunnel'

$gitHubApiReleases = "https://api.github.com/repos/$repo/releases"
$latestReleaseUri = "$gitHubApiReleases/latest"

function Get-LatestStableVersion
{
    $releaseDetails = Invoke-RestMethod -Uri $latestReleaseUri -Method Get -UseBasicParsing

    return [Version] $releaseDetails.tag_name.Substring(1)
}

function Get-SoftwareUri
{
    [CmdletBinding()]
    param(
        [Version] $Version
    )

    $uri = $null
    if ($null -eq $Version)
    {
        # Default to latest stable version
        $uri = $latestReleaseUri
    }
    else 
    {
        $uri = "$gitHubApiReleases/tags/v$($Version)"
    }
    $releaseDetails = Invoke-RestMethod -Uri $uri -Method Get -UseBasicParsing
    $releaseAssets = Invoke-RestMethod -Uri $releaseDetails.assets_url -Method Get -UseBasicParsing

    $windowsArchiveAsset = $null
    foreach ($asset in $releaseAssets)
    {
        if ($asset.name -match $installerFileNameRegex)
        {
            $windowsArchiveAsset = $asset
            break;
        }
        else {
            continue;
        }
    }

    if ($null -eq $windowsArchiveAsset)
    {
        throw "Cannot find published Windows archive asset!"
    }

    return $windowsArchiveAsset.browser_download_url
}