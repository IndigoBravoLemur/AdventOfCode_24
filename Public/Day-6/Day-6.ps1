# TOPICS
# Hash Sets, Cyclical lists

function map-file {
    param(
        [Parameter(Mandatory = $true)]
        [string]$inputFile
    )
    # Using a dictionary instead of a list of lists to store the grid, potentially easier.
    # Not using powershell hashtable as it complicates needing to use a tuple as a key
    $map = [System.Collections.Generic.Dictionary[System.Tuple[int, int], string]]::new()
    # Using foreach-object to read each line of the file rather than foreach 
    $fileContents = get-content -Path $inputFile -raw
    $lines = $fileContents -split("\n")

    for ($row=0; $row -lt $lines.Length; $row++) {
        $line = $lines[$row]
        for ($col=0; $col -lt $line.Length; $col++) {
            # Add tuple of coords and the associated char to the map (dict)
            $map.Add([System.Tuple]::Create($row, $col), $line[$col])
        }
    }
    #Write-Host "Type of map in map-file: $($map.GetType().FullName)"

    return $map
}

function Get-NextOffset {
    param (
        [array]$Array,
        [int]$Index
    )
    $key = $Index % $Array.Count
    return $Array[$key]
}
function Get-StartPosition {
    param (
        [System.Collections.Generic.Dictionary[System.Tuple[int, int], string]]$Map
        #[System.Object[]]$Map
    )
    # Cant pipe $map directly into where-object as it is a .net dict, so need to use getenumerator
    $start = $Map.getenumerator() | Where-Object { $_.Value -eq "^" }
    write-debug "Start position: $start"
    return $start
}
function solve {
    param (
        [string]$inputFile
    )
    $map = map-file -inputFile $inputFile
    #Write-Host "Type of map in solve: $($map.GetType().FullName)"
    $offsets = @(
    [ValueTuple]::Create(0, 1), # Right
    [ValueTuple]::Create(1, 0), # Down
    [ValueTuple]::Create(0, -1), # Left
    [ValueTuple]::Create(-1, 0) # Up
    )
    $index = 0
    $notcompleted = $true
    $startPosition = Get-StartPosition -Map $map
    $nextPosition = $startPosition
    while ($notcompleted) {
        if ($next -eq "^"){
            $tuple = Get-NextOffset -Array $offsets -Index $index
            #Write-Output "Key: $($tuple.Item1), Value: $($tuple.Item2)"
        }
        $index++
    }
}

solve -inputFile ".\Public\Day-6\test.txt"