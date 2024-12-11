return part_1, part_2
# prompt: https://adventofcode.com/2024/day/5
# Solution from https://github.com/xavdid/advent-of-code/blob/main/solutions/2024/day_05/solution.py
# https://advent-of-code.xavd.id/writeups/2024/day/5/

# Parse out rules as pairs of ints and the updates as a list of ints
# 3 | 4
#
# 4,77,21,34 ...
function Parse-IntList {
    param (
        [string]$str
    )
    return $str -split '\D+' | ForEach-Object { [int]$_ }
}

function Adheres-ToRule {
    param (
        [int[]]$rule,
        [int[]]$update
    )
    $l, $r = $rule
    if ($update -contains $l -and $update -contains $r) {
        return ($update.IndexOf($l) -lt $update.IndexOf($r))
    }
    return $true
}

function Middle-Element {
    param (
        [int[]]$list
    )
    return $list[$list.Count / 2]
}

class Solution {
    [int]$Year = 2024
    [int]$Day = 5

    [tuple[int, int]] Solve() {
        # Read in input file and split into rules and updates
        $input = Get-Content -Path ".\Public\Day-5\input.txt" -Raw
        $rawRules, $rawUpdates = $input -split "\n\n"

        $rules = $rawRules -split "`n" | ForEach-Object { Parse-IntList $_ -split "\|" }
        $updates = $rawUpdates -split "`n" | ForEach-Object { Parse-IntList $_ -split "," }

        $part1 = 0
        $part2 = 0

        foreach ($update in $updates) {
            if ($rules | ForEach-Object { Adheres-ToRule $_ $update }) {
                $part1 += Middle-Element $update
            } else {
                $sorter = [System.Collections.Generic.List[System.Tuple[int, int]]]::new()
                foreach ($rule in $rules) {
                    $l, $r = $rule
                    if ($update -contains $l -and $update -contains $r) {
                        $sorter.Add([System.Tuple[int, int]]::new($l, $r))
                    }
                }

                $fixedUpdate = $sorter | Sort-Object -Property Item1, Item2 | ForEach-Object { $_.Item1, $_.Item2 }

                $part2 += Middle-Element $fixedUpdate
            }
        }

        return [tuple[int, int]]::new($part1, $part2)
    }
}

$solution = [Solution]::new()
$solution.Solve()