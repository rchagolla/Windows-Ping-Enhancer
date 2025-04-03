param (
    [string]$TargetIP
)

if (-not $TargetIP) {
    Write-Host "Usage: .\ping-enhanced.ps1 <Target IP or Hostname>"
    exit
}

$errors = @()  # Initialize an array to store errors
$sent = 0
$received = 0

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
            $errors += "Request Timed Out"
            Write-Host "PING ERROR"
        }




        # else {
        #     # Get the detailed error reason
        #     $pingError = $result.StatusCode

        #     if ($pingError -eq 11010) {
        #         $errors += "Request Timed Out"
        #         Write-Host "Request Timed Out"
        #     }
        #     elseif ($pingError -eq 11003) {
        #         $errors += "Destination Host Unreachable"
        #         Write-Host "Destination Host Unreachable"
        #     }
        #     elseif (-not $result) {
        #         $errors += "General Failure"
        #         Write-Host "General Failure"
        #     }
        #     else {
        #         $errors += "Unknown Error: $pingError"
        #         Write-Host "Unknown Error: $pingError"
        #     }
        # }





        # try {
        #     $result = Test-Connection -ComputerName $TargetIP -Count 1 -ErrorAction SilentlyContinue
        #     $sent = $sent + 1
        #     if ($result) {
        #         # Mimic Windows ping output
        #         Write-Host "Reply from $($result.Address): bytes=32 time=$($result.ResponseTime)ms TTL=$($result.TimeToLive)"
        #         $received = $received + 1
        #     }
        # }
        # catch {
        #     $errorMessage = $_.Exception.Message

        #     if ($errorMessage -match "Destination host unreachable") {
        #         $errors += "Destination Host Unreachable"
        #         Write-Host "Destination Host Unreachable"
        #     }
        #     elseif ($errorMessage -match "Request timed out") {
        #         $errors += "Request Timed Out"
        #         Write-Host "Request Timed Out"
        #     }
        #     elseif ($errorMessage -match "General failure") {
        #         $errors += "General Failure"
        #         Write-Host "General Failure"
        #     }
        #     else {
        #         $errors += "Unknown Error: $errorMessage"
        #         Write-Host "Unknown Error: $errorMessage"
        #     }
        # }








        Start-Sleep -Seconds 1  # Wait 1 second before next ping
    }
}
catch {
    Write-Host "`nPing stopped. Analyzing results..."
}
finally {
    # Display all collected errors after stopping
    if ($errors.Count -gt 0) {
        Write-Host "`nPing statistics for $($TargetIP):"
        $errors | Group-Object | ForEach-Object {
            Write-Host "`tPackets: Sent = $($sent), Received = $($received), Lost = $($_.count)"
        }
    }
    else {
        Write-Host "No errors encountered."
    }
}