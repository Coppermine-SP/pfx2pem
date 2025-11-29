$pfxPath = $args[0]

if([string]::IsNullOrWhiteSpace($pfxPath)){
    Write-Host "Usage: pfx2pem <pfx file location>"
	exit 1
}
if (-not (Test-Path $pfxPath)) {
    Write-Error "$pfxPath is not a vaild location."
    exit 1
}

$baseName = [System.IO.Path]::GetFileNameWithoutExtension($pfxPath)
$crtPath  = "$baseName.crt"
$keyPath  = "$baseName.key"

Write-Host ''
$pfxPassSecure = Read-Host 'Enter the passphrase for the PKCS#12 file' -AsSecureString
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($pfxPassSecure)
try   { 
    $pfxPassPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto($ptr)
}
finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)
}

function Invoke-OpenSsl {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$ArgumentList
    )

    $output = & openssl @ArgumentList 2>&1

    if ($LASTEXITCODE -ne 0) {
        throw "OpenSSL Error:`n$($output -join "`n")"
    }
}

try {
    Write-Host "Exporting PEM encoded certificate..."
    $certArgs = @(
        'pkcs12',
        '-in', $pfxPath,
        '-clcerts',
        '-nokeys',
        '-out', $crtPath,
        '-passin', "pass:$pfxPassPlain"
    )
    Invoke-OpenSsl -ArgumentList $certArgs

    Write-Host "Exporting PKCS#8 private key..."
    $keyArgs = @(
        'pkcs12',
        '-in', $pfxPath,
        '-nocerts',
        '-nodes',
        '-out', $keyPath,
        '-passin', "pass:$pfxPassPlain"
    )
    Invoke-OpenSsl -ArgumentList $keyArgs
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}

Write-Host "Export completed."
Write-Host "Certificate: $crtPath"
Write-Host "Private key: $keyPath"