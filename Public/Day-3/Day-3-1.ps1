function Day-3-1 {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]$InputFile
    )
    BEGIN {
        Write-Output "Solving Day 3-1"
        $totalSum = 0
    }
    PROCESS {
        Write-Output "InputFile: $InputFile"
        Get-Content -Path $InputFile | ForEach-Object {
            # alternative :: $Value = ForEach ($Line in Get-Content -path C:\temp\logfile.log)
            # foreach is best when you have a collection that you want to iterate over, better for in-memory operation
            # ForEach-Object is best for iterating via pipeline and processes each item as it passes through the pipeline

            # select-string is native to powershell, you dont need to instantiate .net classes etc
            # and could avoid get-content and pass in the file directly
            # eg Select-String -Path 'file.txt' -Pattern '\d+'
            $mulMatches = Select-String -Pattern "mul\((\d+),(\d+)\)" -InputObject $_ -AllMatches
            #$mulmatches | get-member
            # Loop through matchinfo object to get the matches
            foreach ($match in $mulMatches.Matches){
                # write-output "$match"
                # for each match, get the value of the two capture groups
                $num1 = [int]$match.Groups[1].Value
                $num2 = [int]$match.Groups[2].Value
                $totalSum += $num1 * $num2
            }
        }   
    }   
   END {
        Write-Output "Total Sum : $totalSum"
        Write-Verbose "Completed Day 3-1"
    }
}
