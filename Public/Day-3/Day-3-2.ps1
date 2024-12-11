function Day-3-2 {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$InputFile
    )
    BEGIN {
        Write-Output "Solving Day 3-2"
        $totalSum = 0
    }
    PROCESS {
        Write-Output "InputFile: $InputFile"
        # Create pattern string and then create regex object using .net accelerator
        #$patterns = "mul\((\d+),(\d+)\)|don't\(\)|do\(\)"
        # New pattern to use named regex groups
        $patterns = "(?<mul>mul\((\d+),(\d+)\))|(?<dont>don't\(\))|(?<do>do\(\))"

        $regex = [regex]$patterns
        $countEnabled = $true
        Get-Content -Path $InputFile | ForEach-Object {
            # alternative :: $Value = ForEach ($Line in Get-Content -path C:\temp\logfile.log)
            # foreach is best when you have a collection that you want to iterate over, better for in-memory operation
            # ForEach-Object is best for iterating via pipeline and processes each item as it passes through the pipeline
            $line = $_
            $startIndex = 0 
            while ($startIndex -lt $line.Length) {
                # Find the next math starting at the next index
                $match = $regex.Match($line, $startIndex)
                if ($match.Success) {
                    write-output "$match"
                    if ($match.Groups["mul"].Success -and $countEnabled) {
                        # If we find a mul and counting is enabled add
                        $num1 = [int]$match.Groups[1].Value
                        $num2 = [int]$match.Groups[2].Value
                        $totalSum += $num1 * $num2
                        write-output "Adding $num1 * $num2"
                    }
                    if ($match.Groups["dont"].Success) {
                        # If we find a dont stop counting
                        write-output "Matched dont group"
                        $countEnabled = $false
                    }
                    if ($match.Groups["do"].Success) {
                        # If we find a dont stop counting
                        write-output "Matched do group"
                        $countEnabled = $true
                    }
                $startIndex = $match.Index + $match.Length
                } else {
                    break
                }
            }
        }   
    }   
   END {
        Write-Output "Total Sum : $totalSum"
        Write-Verbose "Completed Day 3-2"
    }
}
