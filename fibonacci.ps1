# Fibonacci.ps1

param(
    [int]$d = -1
)

function Get-Fibonacci {
    param([int]$d)

    if ($d -eq 0) {
        return 0
    } elseif ($d -eq 1) {
        return 1
    } else {
        return (Get-Fibonacci($d - 1)) + (Get-Fibonacci($d - 2))
    }
}

if ($d -eq -1) {
    $i = 0
    while ($true) {
        Write-Output (Get-Fibonacci -d $i)
        Start-Sleep -Seconds 0.5
        $i++
    }
} else {
    Write-Output (Get-Fibonacci -d $d)
}
