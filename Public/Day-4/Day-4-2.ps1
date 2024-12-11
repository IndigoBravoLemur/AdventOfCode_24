function Day-4-2 {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$inputFile
    )
    BEGIN {
        Write-Output "Solving Day 4-2"
        # Create a List to store the multidimensional array
        $multiDimList = [System.Collections.Generic.List[object]]::new()
        $totalFound = 0
    }
    PROCESS {
        #Array vs .NET lists.
        # Arrays are immutable in size. Adding elements (+=) creates a new array, which can be slow for large datasets.
        # Arrays provide fewer built-in methods compared to .NET collections.

        # Process the file line by line
        Get-Content -Path $inputFile | ForEach-Object {
            # Convert each line to a character array and add it to the List
            # the array is a list of arrays, where each array represents a row of the input file
            ### $multiDimArray.Add($_.ToCharArray())
            
            # Convert each line into a char array, then for each add it to make instead list of characters
            # Because i want a list of lists not a list of arrays
            $charList = [System.Collections.Generic.List[object]]::new()
            $_.ToCharArray() | ForEach-Object { $charList.Add($_) }
        
            # Add the character list to the parent list
            $multiDimList.Add($charList)
        }
        
        # For each row in the multidimensional list
        for($i=0; $i -lt $multiDimList.Count; $i++){
            # For each element in the row
            for($j=0; $j -lt $multiDimList[$i].Count; $j++){
                if ($multiDimList[$i][$j] -eq "A") {
                    write-verbose "Found X at row $i, column $j" 
                    $totalFound += (check-surrounding -column $j -row $i -multiDimList $multiDimList)
                }
            }
        }
        #find-horizontal -multiDimArray $multiDimArray
    }
    END {
        Write-Output "Completed Day 4-2"
        Write-Output "Total XMAS found: $totalFound"
    }
}
function check-surrounding{
    # Finds XMAS surrounding the X
    param(
        [Parameter(Mandatory = $true)]
        [int]$column,
        [Parameter(Mandatory = $true)]
        [int]$row,
        [Parameter(Mandatory = $true)]
        [System.Collections.Generic.List[object]]$multiDimList
    )
    $leftDiagonal = @(
        @{Row = -1; Col = -1}, # Up-Left
        @{Row = 1; Col = 1}    # Down-Right
    )
    $rightDiagonal = @(
        @{Row = -1; Col = 1},  # Up-Right
        @{Row = 1; Col = -1}  # Down-Left
    )
    write-verbose "Checking surrounding characters of $i, $j"
    # Get the dimensions of the array
    $numRows = $multiDimList.Count
    $numColumns = $multiDimList[0].Count
    # Check the surrounding characters in each direction
    
    $rowIndexToCheck = $row + $leftDiagonal[0].Row
    $colIndexToCheck = $column + $leftDiagonal[0].Col
    Write-Verbose "Checking $rowIndexToCheck, $colIndexToCheck"
    # Ensure the new position is within the bounds of the array
    if ($rowIndexToCheck -ge 0 -and $rowIndexToCheck -lt $numRows -and $colIndexToCheck -ge 0 -and $colIndexToCheck -lt $numColumns) {
        $charToCheck = $multiDimList[$rowIndexToCheck][$colIndexToCheck]
        if ($charToCheck -eq "M" -or $charToCheck -eq "S") {
            # Powershell 7+ ternary operator. If M then S, else M - ? is alias to where-object
            # $charToCheck = ($var -eq "M") ? "S" : "M"
            $verify = if ($charToCheck -eq "M") { "S" } else { "M" }
            $rowIndexToCheck = $row + $leftDiagonal[1].Row
            $colIndexToCheck = $column + $leftDiagonal[1].Col
            if ($rowIndexToCheck -ge 0 -and $rowIndexToCheck -lt $numRows -and $colIndexToCheck -ge 0 -and $colIndexToCheck -lt $numColumns) {
                $charToCheck = $multiDimList[$rowIndexToCheck][$colIndexToCheck]
                if($charToCheck -eq $verify){
                    $leftDiagValid = $true
                }
            }                       
        }
    }

    $rowIndexToCheck = $row + $rightDiagonal[0].Row
    $colIndexToCheck = $column + $rightDiagonal[0].Col
    Write-Verbose "Checking $rowIndexToCheck, $colIndexToCheck"
    # Ensure the new position is within the bounds of the array
    if ($rowIndexToCheck -ge 0 -and $rowIndexToCheck -lt $numRows -and $colIndexToCheck -ge 0 -and $colIndexToCheck -lt $numColumns) {
        $charToCheck = $multiDimList[$rowIndexToCheck][$colIndexToCheck]
        if ($charToCheck -eq "M" -or $charToCheck -eq "S") {
            # Powershell 7+ ternary operator. If M then S, else M - ? is alias to where-object
            # $charToCheck = ($var -eq "M") ? "S" : "M"
            $verify = if ($charToCheck -eq "M") { "S" } else { "M" }
            $rowIndexToCheck = $row + $rightDiagonal[1].Row
            $colIndexToCheck = $column + $rightDiagonal[1].Col
            if ($rowIndexToCheck -ge 0 -and $rowIndexToCheck -lt $numRows -and $colIndexToCheck -ge 0 -and $colIndexToCheck -lt $numColumns) {
                $charToCheck = $multiDimList[$rowIndexToCheck][$colIndexToCheck]
                if($charToCheck -eq $verify){
                    $rightDiagValid = $true
                }
            }                       
        }
    }
    if ($leftDiagValid -and $rightDiagValid){
        write-verbose "Found valid X-MAS at row $row, column $column"
        return 1
    }
    



}
function find-horizontal{
    # Finds XMAS along the horizontal
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Generic.List[object]]$multiDimArray
    )
   
}