function Day-1-1 {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$InputFile
    )
    BEGIN {
        Write-Output "Solving Day 1"
        #Write-Output "InputFile: $InputFile"
        $left_col = @()
        $right_col = @()
    }
    PROCESS {
        Write-Output "InputFile: $InputFile"
        Get-Content -Path $InputFile | ForEach-Object {
            # Split each line into (max) 2 parts
            $line_parts = ($_ -split '\s+',2)
            $left_col += [int]$line_parts[0]
            $right_col += [int]$line_parts[1]
        }
        $left_col = $left_col | Sort-Object
        $right_col = $right_col | Sort-Object
        Write-Output "Sorted columns"
        #Write-Output "Left Column: $left_col"
        for ($i=0; $i -lt $left_col.Count; $i++) {
            $absoluteDifference = [math]::Abs($left_col[$i] - $right_col[$i])
            $diff += $absoluteDifference
        }
    }   
   END {
        Write-Output "Difference: $diff"
        Write-Verbose "Completed Day 1"
    }
}