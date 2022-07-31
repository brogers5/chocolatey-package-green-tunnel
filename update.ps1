Import-Module au

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
. $currentPath\helpers.ps1

$toolsPath = Join-Path -Path $currentPath -ChildPath 'tools'
$softwareRepo = 'SadeghHayeri/GreenTunnel'

function global:au_GetLatest {
    $version = Get-LatestStableVersion
    $script:softwareTag = "v$version"

    return @{
        Url32 = Get-SoftwareUri
        Version = $version #This may change if building a package fix version
    }
}

function global:au_BeforeUpdate ($Package)  {
    Get-RemoteFiles -Purge -NoSuffix -Algorithm sha256

    $templateFilePath = Join-Path -Path $toolsPath -ChildPath 'VERIFICATION.txt.template'
    $verificationFilePath = Join-Path -Path $toolsPath -ChildPath 'VERIFICATION.txt'
    Copy-Item -Path $templateFilePath  -Destination $verificationFilePath -Force

    Set-DescriptionFromReadme -Package $Package -ReadmePath ".\DESCRIPTION.md"
}

function global:au_AfterUpdate ($Package)  {
    $licenseUri = "https://raw.githubusercontent.com/$($softwareRepo)/$softwareTag/LICENSE"
    $licenseContents = Invoke-WebRequest -Uri $licenseUri -UseBasicParsing

    $licensePath = Join-Path -Path $toolsPath -ChildPath 'LICENSE.txt'
    Set-Content -Path $licensePath -Value "From: $licenseUri`r`n`r`n$licenseContents"
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "<packageSourceUrl>[^<]*</packageSourceUrl>" = "<packageSourceUrl>https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)</packageSourceUrl>"
            "<licenseUrl>[^<]*</licenseUrl>" = "<licenseUrl>https://github.com/$($softwareRepo)/blob/$($softwareTag)/LICENSE</licenseUrl>"
            "<projectSourceUrl>[^<]*</projectSourceUrl>" = "<projectSourceUrl>https://github.com/$($softwareRepo)/tree/$($softwareTag)</projectSourceUrl>"
            "<copyright>[^<]*</copyright>" = "<copyright>Copyright © $(Get-Date -Format yyyy) Sadegh Hayeri</copyright>"
        }
        'tools\VERIFICATION.txt' = @{
            '%checksumValue%' = "$($Latest.Checksum32)"
            '%checksumType%' = "$($Latest.ChecksumType32.ToUpper())"
            '%tagReleaseUrl%' = "https://github.com/$($softwareRepo)/releases/tag/$($softwareTag)"
            '%archiveUrl%' = "$($Latest.Url32)"
            '%archiveFileName%' = "$($Latest.FileName32)"
        }
    }
}

Update-Package -ChecksumFor None -NoReadme
