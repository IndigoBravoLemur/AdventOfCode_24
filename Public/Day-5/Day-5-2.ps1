function Day-5-2 {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$inputFile,
        [Parameter(Mandatory = $true)]
        [string]$ruleFile
    )
    BEGIN {
        Write-Output "Solving Day 5-2"

    }
    PROCESS {
        $failingLines = @()
        $rules = get-rules -ruleFile $ruleFile
        #print-dictionary -dictionary $rules
        get-content -Path $inputFile | foreach-object {
            $line = [System.Collections.Generic.List[string]]::new()
            $_ -split(",") | foreach-object({$line.Add($_)})
            $needsFixing = check-rules -rules $rules -line $line
            #Write-Output "-------------------Needs fixing: $needsFixing"
            if($needsFixing){
                write-output "Line failed: $line"
                # ,$line to add the list as a single element, otherwise the list would be flattened and id just have a long list of numbers
                $failingLines += ,$line
            }
        }
        Write-Output "N Failing lines: $($failingLines.Count)"
        foreach($line in $failingLines){
            write-output "Failing line: $line"
            $fixedLine = fix-line -rules $rules -line $line
            write-output "return val $fixedLine"
            $midpoint = [math]::Floor($line.Count/2)
            [int]$val = $line[$midpoint]
            Write-output " midpoint: $val"
            $totalSum += $val
        }
    }
    END {
        Write-Output "Completed Day 5-2"
        Write-Output "Total sum: $totalSum"
    }
}
function check-rules {
    param(
    [hashtable]$rules,
    [System.Collections.Generic.List[string]]$line
    )
    Write-verbose "Checking rules - $line"
    $needsFixing = $false
    # For each number in the line
    for($i=0; $i -lt $line.Count; $i++){
        $num = $line[$i]
        Write-verbose "Checking $num"
        if ($rules.ContainsKey($num)){
            $numsToCheck = $rules[$num]
            write-verbose "rule to $num : $numsToCheck"
            # For each number to check  
            foreach ($check in $numsToCheck){
                Write-verbose "checking $check is in list and after $num"
                # make sure it exists in the line,
                if($line.Contains($check)){
                    write-verbose "line contains $check"
                    #check if it exists after the current number
                    $sublist = $line.GetRange($i + 1, $line.Count - ($i + 1))
                    if(-not $sublist.Contains($check)){
                        $needsFixing = $true
                    }
                    write-verbose "line contains $check after $num"
                }
                write-verbose "line does not contain $check"
            }
        }
    }
    Write-verbose "Needs fixing: $needsFixing"
    return $needsFixing
}
function fix-line {
    param(
    [hashtable]$rules,
    [System.Collections.Generic.List[string]]$line
    )
    write-verbose "Checking rules - $line"
    # For each number in the line
    for($i=0; $i -lt $line.Count; $i++){
        $num = $line[$i]
        Write-verbose "Checking $num"
        if ($rules.ContainsKey($num)){
            $numsToCheck = $rules[$num]
            write-verbose "rule to $num : $numsToCheck"
            # For each number to check  
            foreach ($check in $numsToCheck){
                Write-verbose "checking $check is in list and after $num"
                # make sure it exists in the line,
                if($line.Contains($check)){
                    write-verbose "line contains $check"
                    #check if it exists after the current number
                    $sublist = $line.GetRange($i + 1, $line.Count - ($i + 1))
                    if(-not $sublist.Contains($check)){
                        write-verbose "Line does not contain $check after $num"
                        $indexToRemove = $line.IndexOf($check)
                        $line.RemoveAt($indexToRemove)
                        $line.Insert($i, $check)
                        fix-line -rules $rules -line $line
                        #write-output "new line : $line"
                        # part 2 reorder
                    }
                    write-verbose "line contains $check after $num"
                }
            }
        }
    }
    #$midpoint = [math]::Floor($line.Count/2)
    #[int]$val = $line[$midpoint]
    #Write-Debug " midpoint: $val"
    return $line
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