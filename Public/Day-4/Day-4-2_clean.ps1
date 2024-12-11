function Day-4-2 {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$inputFile
    )
    BEGIN {
        Write-Output "Solving Day 4-2"
        $multiDimList = [System.Collections.Generic.List[object]]::new()
        $totalFound = 0
    }
    PROCESS {
        Get-Content -Path $inputFile | ForEach-Object {
            $charList = [System.Collections.Generic.List[object]]::new()
            $_.ToCharArray() | ForEach-Object { $charList.Add($_) }
            $multiDimList.Add($charList)
        }
        for($i=0; $i -lt $multiDimList.Count; $i++){
            for($j=0; $j -lt $multiDimList[$i].Count; $j++){
                if ($multiDimList[$i][$j] -eq "A") {
                    write-verbose "Found X at row $i, column $j"
                    $totalFound += (check-surrounding -column $j -row $i -multiDimList $multiDimList)
                }
            }
        }
    }
    END {
        Write-Output "Completed Day 4-2"
        Write-Output "Total XMAS found: $totalFound"
    }
}
function check-surrounding{
    param(
        [int]$row,
        [int]$column,
        [string]$diagonal,
        [System.Collections.Generic.List[object]]$multiDimList
    )
    $diagonalPoints = switch ($diagonal) {
        "left" {
            @(
                @{Row = -1; Col = -1}, 
                @{Row = 1; Col = 1}    
            )
        }
        "right" {
            @(
                @{Row = -1; Col = 1},
                @{Row = 1; Col = -1}
            )
        }
    }
    write-verbose "Checking surrounding characters of $i, $j"
    $numRows = $multiDimList.Count
    $numColumns = $multiDimList[0].Count
    $rowIndexToCheck = $row + $diagonalPoints[0].Row
    $colIndexToCheck = $column + $diagonalPoints[0].Col
    Write-Verbose "Checking $rowIndexToCheck, $colIndexToCheck"
    if ($rowIndexToCheck -ge 0 -and $rowIndexToCheck -lt $numRows -and $colIndexToCheck -ge 0 -and $colIndexToCheck -lt $numColumns) {
        $charToCheck = $multiDimList[$rowIndexToCheck][$colIndexToCheck]
        if ($charToCheck -eq "M" -or $charToCheck -eq "S") {
            $verify = if ($charToCheck -eq "M") { "S" } else { "M" }
            $rowIndexToCheck = $row + $diagonalPoints[1].Row
            $colIndexToCheck = $column + $diagonalPoints[1].Col
            if ($rowIndexToCheck -ge 0 -and $rowIndexToCheck -lt $numRows -and $colIndexToCheck -ge 0 -and $colIndexToCheck -lt $numColumns) {
                $charToCheck = $multiDimList[$rowIndexToCheck][$colIndexToCheck]
                if($charToCheck -eq $verify){
                    $leftDiagValid = $true
                }
            }                       
        }
    }
    if ($leftDiagValid -and $rightDiagValid){
        write-verbose "Found valid X-MAS at row $row, column $column"
        return 1
    }
}