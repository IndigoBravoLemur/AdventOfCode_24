function Day-4-1 {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$inputFile
    )
    BEGIN {
        Write-Output "Solving Day 4-1"
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
                if ($multiDimList[$i][$j] -eq "X") {
                    write-verbose "Found X at row $i, column $j" 
                    $totalFound += (check-surrounding -column $j -row $i -multiDimList $multiDimList)
                }
            }
        }
        #find-horizontal -multiDimArray $multiDimArray
    }
    END {
        Write-Output "Completed Day 4-1"
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
    $directions = @(
        @{Row = -1; Col = 0},  # Up
        @{Row = 1; Col = 0},   # Down
        @{Row = 0; Col = -1},  # Left
        @{Row = 0; Col = 1},   # Right
        @{Row = -1; Col = -1}, # Up-Left
        @{Row = -1; Col = 1},  # Up-Right
        @{Row = 1; Col = -1},  # Down-Left
        @{Row = 1; Col = 1}    # Down-Right
    )
    write-verbose "Checking surrounding characters of $i, $j"
    # Get the dimensions of the array
    $numRows = $multiDimList.Count
    $numColumns = $multiDimList[0].Count
    $numFound = 0
    # Check the surrounding characters in each direction
    foreach ($direction in $directions) {
        $rowIndexToCheck = $row + $direction.Row
        $colIndexToCheck = $column + $direction.Col
        Write-Verbose "Checking $rowIndexToCheck, $colIndexToCheck"
        # Ensure the new position is within the bounds of the array
        if ($rowIndexToCheck -ge 0 -and $rowIndexToCheck -lt $numRows -and $colIndexToCheck -ge 0 -and $colIndexToCheck -lt $numColumns) {
            if ($multiDimList[$rowIndexToCheck][$colIndexToCheck] -eq "M") {
                write-verbose "Found M"
                # char was found, search for A in the same direction
                $rowIndexToCheck = $rowIndexToCheck + $direction.Row
                $colIndexToCheck = $colIndexToCheck + $direction.Col
                if ($rowIndexToCheck -ge 0 -and $rowIndexToCheck -lt $numRows -and $colIndexToCheck -ge 0 -and $colIndexToCheck -lt $numColumns) {
                    if ($multiDimList[$rowIndexToCheck][$colIndexToCheck] -eq "A") {
                        write-verbose "Found A"
                        # char was found, search for S in the same direction
                        $rowIndexToCheck = $rowIndexToCheck + $direction.Row
                        $colIndexToCheck = $colIndexToCheck + $direction.Col
                        if ($rowIndexToCheck -ge 0 -and $rowIndexToCheck -lt $numRows -and $colIndexToCheck -ge 0 -and $colIndexToCheck -lt $numColumns) {
                            if ($multiDimList[$rowIndexToCheck][$colIndexToCheck] -eq "S") {
                                write-verbose "Found S"
                                write-verbose "Found XMAS at row $row, column $column"
                                # char was found, return true
                                $numFound += 1
                            }
                        }
                    }
                }

            }
        }
    }
    return $numFound
    



}