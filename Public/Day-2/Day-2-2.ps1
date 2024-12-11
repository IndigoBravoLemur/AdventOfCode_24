function Day-2-2 {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$InputFile
    )
    BEGIN {
        Write-Output "Solving Day 2-2"
    }
    PROCESS {
        Write-Output "InputFile: $InputFile"
        Get-Content -Path $InputFile | ForEach-Object {
            # Split by whitespace to create report array
            $report = New-Object 'System.Collections.Generic.List[System.Int32]'
            ($_ -split '\s+') | ForEach-Object {
                # Casting to [void] suppresses any output of the command/expression
                [void]$report.Add([int]$_)
            }
            
            $isSafe = Check-Safety -report $report
            if ($isSafe) {
                $total_safe += 1
            } else {
                # If the original list is unsafe, it is safe up to one element removed, so loop and remove each
                for ($i = 0; $i -lt $report.Count; $i++) {
                    $temp = $report[$i]
                    $report.RemoveAt($i)
                    $isSafe = Check-Safety -report $report
                    if ($isSafe) {
                        $total_safe += 1
                        break
                    }
                    $report.Insert($i, $temp)
                }
            }
        }   
    }   
   END {
        Write-Output "Number Safe : $total_safe"
        Write-Verbose "Completed Day 2-2"
    }
}
function Check-Safety {
    param (
        [System.Collections.Generic.List[System.Int32]]$report
    )

    $allIncreasing = $true
    $allDecreasing = $true
    $safe = $true

    for ($i = 0; $i -lt $report.Count; $i++) {
        $current_number = [int]$report[$i]
        $previous = if ($i -gt 0) { [int]$report[$i - 1] } else { $null }
        $next = if ($i -lt $report.Count - 1) { [int]$report[$i + 1]}
        # Write-Output " Previous - $previous | Current - $current_number | Next - $next"
        # Checking if the levels stop increasing/decreasing
        if ($null -ne $previous -and $current_number -gt $previous) {
            $allDecreasing = $false
        }
        if ($null -ne $previous -and $current_number -lt $previous) {
            $allIncreasing = $false
        }

        # Checking if the levels differ by at least one and at most three
        # [] is a type accelerator, a shorthand to refer to .NET types
        # math is a type accelerator for System.Math
        # :: is used to access static members of a class - methods, properties, or fields of a .NET class
        if ($null -ne $next -and [math]::Abs($next - $current_number) -gt 3) {
            $safe = $false
            #Write-Output "Unsafe as $next - $current_number > 3"
        }
        if ($null -ne $next -and [math]::Abs($next - $current_number) -lt 1) {
            $safe = $false
            #Write-Output "Unsafe as $next - $current_number < 1"

        }
    }
    if (-not $allIncreasing -and -not $allDecreasing) {
        $safe = $false
    }
    return $safe
    #write-output "Line is : $safe"
}