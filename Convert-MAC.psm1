function Convert-MAC {

    <#
    .SYNOPSIS
        Convert most MAC address formats.
        Reff: https://metacpan.org/pod/NetAddr::MAC
    .DESCRIPTION
        This function converts most MAC addresses, for example from Windows format to Cisco format
        by "(Convert-MAC -MACAddress "00-1A-2B-3C-4D-5E").CiscoMACformat"
    .PARAMETER MACAddress
        The MAC address you want to convert.
    .EXAMPLE
        Convert-MAC -MACAddress "00:1A:2B:3C:4D:5E"
    .EXAMPLE
        (Convert-MAC -MACAddress "00-1A-2B-3C-4D-5E").CiscoMACformat
    .NOTES
        Author: Henrik Bruun  Github.com @Henrik-Bruun
        Version: 1.0 2023 December.
    #>

    param(
        [string]$MACAddress
    )

    $BareMACAddress = $MACAddress.ToLower() -replace '[-:.\.]',''
    $mac = ($BareMACAddress -replace '(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})', '$1.$2.$3.$4.$5.$6').ToUpper()

    $SunMac = ($mac -split '\.' | ForEach-Object {
        ($_ -replace '^0+(?=\w)', '') 
    }) -join '.'

    $data = @(
        [pscustomobject]@{
            InputMAC                 = $MACAddress
            CompressesMACformatLower = $BareMACAddress
            CiscoMACformat           = $($BareMACAddress -replace '(.{4})(.{4})(.{4})', '$1.$2.$3')
            WindowsMACformat         = $($BareMACAddress -replace '(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})', '$1-$2-$3-$4-$5-$6').ToUpper()
            LinuxMACformat           = $($BareMACAddress -replace '(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})', '$1:$2:$3:$4:$5:$6').ToUpper()
            pgsqlMACformat           = $($BareMACAddress -replace '(.{6})(.{6})', '$1:$2')
            SingledashFormat         = $($BareMACAddress -replace '(.{6})(.{6})', '$1-$2')
            Dotformat                = $($BareMACAddress -replace '(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})', '$1.$2.$3.$4.$5.$6').ToUpper()
            Sunformat                = $SunMac
        }
    )
    $data
}
