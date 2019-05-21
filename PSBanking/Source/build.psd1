@{
    Path = "PSBanking.psd1"
    OutputDirectory = "..\bin\PSBanking"
    Prefix = '.\_PrefixCode.ps1'
    SourceDirectories = 'Classes','Private','Public'
    PublicFilter = 'Public\*.ps1'
    VersionedOutputDirectory = $true
}
