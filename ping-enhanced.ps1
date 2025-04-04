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

# Track types of errors
$errorTypes = @{
    "Request timed out"            = 0
    "Destination host unreachable" = 0
    "General failure"              = 0
}

try {
    while ($true) {
        $sent += 1

        # Use ping.exe for better error info
        $output = ping.exe -n 1 $TargetIP

        if ($output -match "Reply from") {
            $received += 1

            # Extract useful info (optional)
            $match = $output | Select-String -Pattern "Reply from.*"
            Write-Host $match
        }
        elseif ($output -match "Request timed out") {
            $errorTypes["Request timed out"] += 1
            $errors += 1
            Write-Host "Request timed out."
        }
        elseif ($output -match "Destination host unreachable") {
            $errorTypes["Destination host unreachable"] += 1
            $errors += 1
            Write-Host "Destination host unreachable."
        }
        elseif ($output -match "General failure") {
            $errorTypes["General failure"] += 1
            $errors += 1
            Write-Host "General failure."
        }
        else {
            $errors += 1
            Write-Host "Unknown ping error."
        }

        Start-Sleep -Seconds 1
    }
}
finally {
    Write-Host "`nPing statistics for $($TargetIP):"
    $percentLost = [math]::Round(($received / $sent) * 100, 2)

    Write-Host "`tPackets: Sent = $sent, Received = $received, Lost = $errors ($percentLost% loss)"
}