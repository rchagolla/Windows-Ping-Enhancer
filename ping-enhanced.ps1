param (
    [string]$TargetIP
)

if (-not $TargetIP) {
    Write-Host "Usage: .\ping-enhanced.ps1 <Target IP or Hostname>"
    exit
}

$sent = 0
$received = 0
$errors = 0

try {
    while ($true) {
        $result = Test-Connection -ComputerName $TargetIP -Count 1 -ErrorAction SilentlyContinue
        $sent += 1

        if ($result) {
            # Windows default ICMP payload is 32 bytes
            $bytes = 32 

            # Mimic Windows ping output
            Write-Host "Reply from $($result.Address): bytes=$bytes time=$($result.ResponseTime)ms TTL=$($result.TimeToLive)"
            $received += 1
        }
        else {
            # Capture failures
            $errors += 1
            Write-Host "PING ERROR"
        }

        Start-Sleep -Seconds 1  # Wait 1 second before next ping
    }
}
finally {
    # Display all collected errors after stopping
    Write-Host "`nPing statistics for $($TargetIP):"
    
    $percentLost = [Math]::round(($received / $sent) * 100, 2)
    Write-Host "`tPackets: Sent = $($sent), Received = $($received), Lost = $($errors.count) ($($percentLost)% loss)"
}