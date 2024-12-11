function Day-5-1 {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$inputFile,
        [Parameter(Mandatory = $true)]
        [string]$ruleFile
    )
    BEGIN {
        Write-Output "Solving Day 5-1"

    }
    PROCESS {
        $rules = get-rules -ruleFile $ruleFile
        #print-dictionary -dictionary $rules
        get-content -Path $inputFile | foreach-object {
            $line = $_ -split(",")
            $totalSum += check-rules -rules $rules -line $line
        }
    }
    END {
        Write-Output "Completed Day 5-1"
        Write-Output "Total sum: $totalSum"
    }
}
function check-rules {
    param(
    [hashtable]$rules,
    [string[]]$line
    )
    write-verbose "Checking rules - $line"
    # For each number in the line
    for($i=0; $i -lt $line.Count; $i++){
        $num = $line[$i]
        Write-verbose "Checking $num"
        if ($rules.ContainsKey($num)){
            $numsToCheck = $rules[$num]
            write-verbose "Checking $numsToCheck"
            # For each number to check 
            foreach ($check in $numsToCheck){
                Write-verbose "Checking $check"
                # make sure it exists in the line
                if($line -contains $check){
                    # check if it exists after the current number
                    if($line[($i+1)..($line.Count-1)] -notcontains $check){
                        Write-Verbose "Line does not contain $check"
                        return 0
                    }
                }
            }
        }
    }
    $midpoint = [math]::Floor($line.Count/2)
    [int]$val = $line[$midpoint]
    return $val
}
function get-rules{
    # Read rules file and create dictionary of rules
    param([string]$ruleFile)
    $rules = @{}
    get-content -Path $ruleFile | foreach-object {
        $k,$v=$_.split("|")
        if ($rules.ContainsKey($k)){
            $rules[$k].Add($v)
        }
        else {
            $rules[$k] = [System.Collections.Generic.List[int]]::new()
            $rules[$k].Add($v)
        }
    }
    return $rules
}
function print-dictionary {
    param([hashtable]$dictionary)

    foreach ($key in $dictionary.Keys) {
        $values = $dictionary[$key] -join ", "
        Write-Output "Key: $key, Values: $values"
    }
    # Golf
    # $dictionary.GetEnumerator() | % { "$($_.Key): $($_.Value -join ', ')" }
}