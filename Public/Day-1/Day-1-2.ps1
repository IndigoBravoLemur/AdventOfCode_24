function Day-1-2 {
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
        $hashtable = @{}
    }
    PROCESS {
        Write-Output "InputFile: $InputFile"
        # Go through each line and split it into 2 parts
        Get-Content -Path $InputFile | ForEach-Object {
            $line_parts = ($_ -split '\s+',2)
            $left_col += [int]$line_parts[0]
            # If the key exists, add the value to the key (total sum), otherwise create a new key with the value
            if ($hashtable.ContainsKey([int]$line_parts[1])) {
                $hashtable[[int]$line_parts[1]] += [int]$line_parts[1]
            } else {
                $hashtable[[int]$line_parts[1]] = [int]$line_parts[1]
            }
        }
        # For loop generally faster than foreach, foreach-object (better on pipelines)
        for ($i=0; $i -lt $left_col.Count; $i++) {
            if ($hashtable.ContainsKey($left_col[$i])) {
                $value = $hashtable[$left_col[$i]] 
            }
            else {$value = 0 }
            $valueSum += $value
        }
    }   
   END {
        Write-Output "Difference: $valueSum"
        Write-Verbose "Completed Day 1"
    }
}