# TOPICS
# TOPOLOGOCAL SORTING, GRAPH THEORY, Directed Acyclic Graph (DAG), Kahn's Algorithm, Hash Sets

# Solution from https://github.com/xavdid/advent-of-code/blob/main/solutions/2024/day_05/solution.py
# https://advent-of-code.xavd.id/writeups/2024/day/5/

# Pages in each 'update' ie input :: 2,44,12,85,66
# Page ordering rules:: 44|64
function Parse-IntList{
    param (
        [Parameter(Mandatory = $true)]
        [string]$str,              # Input string to parse

        [Parameter(Mandatory = $true)]
        [string]$delimiter         # Delimiter to split the string
    )
    return ($str -split $delimiter | ForEach-Object { [int]$_ })
}
function Adheres-ToRule($rule, $update) {
    # $rule is a list of two integers
    # $update is a list of integers
    if ($rule.Count -ne 2) {
        throw "Rule must contain exactly two elements."
    }

    $l = $rule[0]
    $r = $rule[1]

    # If both elements are in $update, check order
    if ($update -contains $l -and $update -contains $r) {
        $lIndex = [Array]::IndexOf($update, $l)
        $rIndex = [Array]::IndexOf($update, $r)
        return ($lIndex -lt $rIndex)
    }

    # If we don't have both rule items, we ignore it (return true)
    return $true
}

function Middle-Element($list) {
    return $list[[math]::Floor($list.Count / 2)]
}

# Topological Sorting is a linear ordering of vertices such that for every directed edge u -> v, 
#   where vertex u comes before v in the ordering.
function Topological-Sort {
    param (
        [Parameter(Mandatory = $true)]
        [System.Object[]]$edges
    ) 
    # $edges is a list of tuples (l, r) representing l -> r
    # Edges is a list of ints which appear in the update

    # Extract all unique nodes - turns 2,3 ; 77,4 ; 3,54 into 2,3,77,4,54
    # Generic HashSets stores unique nodes only
    $nodes = New-Object System.Collections.Generic.HashSet[int]
    foreach ($edge in $edges) {
        # | out-null to suppress output
        $nodes.Add($edge[0]) | Out-Null
        $nodes.Add($edge[1]) | Out-Null
    }

    # Build in-degree map and adjacency list
    # An adjacency list is a data structure that represents a graph by storing a list of vertices and their connected neighbors
    # Changed to use ::new() instead of New-Object as it cant handle creation of generic types with non standard params
    $adj = [System.Collections.Generic.Dictionary[int, System.Collections.Generic.List[int]]]::new()
    $inDegree = [System.Collections.Generic.Dictionary[int, int]]::new()

    #$adj = New-Object System.Collections.Generic.Dictionary[int, System.Collections.Generic.List[int]]
    #$inDegree = New-Object System.Collections.Generic.Dictionary[int, int]
    
    # $adj is an adjacency list represented as a dictionary where each key is a node, and the value is a list of nodes that the key node points to.
    # indegree is an in-degree map represented as a dictionary where each key is a node, and the value is the count of edges directed towards that node.
    
    # for each node add it to the adjacency and in degree dictionaries, adjacency will be a list of ints associated with that node
    foreach ($node in $nodes) {
        $adj[$node] = New-Object System.Collections.Generic.List[int]
        $inDegree[$node] = 0
    }
    
    # for each edge (int, int)
    foreach ($edge in $edges) {
        $u = $edge[0]
        $v = $edge[1]
        # Add to adjacency list and increment in-degree
        $adj[$u].Add($v)
        $inDegree[$v] = $inDegree[$v] + 1
    }

    # Kahn's algorithm
    # Queue keeps track of nodes with in-degree 0 (number of edges directed towards the node)
    $queue = New-Object System.Collections.Generic.Queue[int]
    foreach ($node in $nodes) {
        if ($inDegree[$node] -eq 0) {
            $queue.Enqueue($node)
        }
    }

    # Sorted list to store the topological order
    $sortedList = New-Object System.Collections.Generic.List[int]
    while ($queue.Count -gt 0) {
        # Dequeue a node and add it to the sorted list
        $curr = $queue.Dequeue()
        $sortedList.Add($curr)
        # Then, find all the nodes dependent on the current node ($adj[$curr])
        foreach ($next in $adj[$curr]) {
            # Decrement in-degree of the dependent node as the current node is removed
            $inDegree[$next] = $inDegree[$next] - 1
            # If there are no more dependencies, add it to the queue
            if ($inDegree[$next] -eq 0) {
                $queue.Enqueue($next)
            }
        }
    }

    # If there's a cycle, you might want to handle it.
    # For this problem, assume no cycle invalid scenario or handle as needed.
    return $sortedList
}

# Main solve function equivalent
function Solve($inputData) {
    # Split input by double newline
    $parts = $inputData -split "\r?\n\r?\n", 2
    #write-host $parts
    $raw_rules = $parts[0].Trim()
    $raw_updates = $parts[1].Trim()

    # Parse rules (split by lines, then by "|")
    $rules = @()
    foreach ($rLine in $raw_rules -split "\n") {
        # Add each rule as a list of two integers the ',' forces the array to be a list
        #Write-Host "Parsing  $rLine"
        $rules += ,(Parse-IntList $rLine "\|")
    }

    # Parse updates (split by lines, then by ",")
    $updates = @()
    foreach ($uLine in $raw_updates -split "\n") {
        # Adding each update as a list of integers
        $updates += ,(Parse-IntList $uLine ",")
    }

    $part_1 = 0
    $part_2 = 0

    foreach ($update in $updates) {
        $allAdhere = $true
        # Check if all rules are adhered to in the update (list of integers)
        foreach ($r in $rules) {
            if (-not (Adheres-ToRule $r $update)) {
                $allAdhere = $false
                break
            }
        }

        if ($allAdhere) {
            $part_1 += (Middle-Element $update)
        } else {
            # Update does not adhere to all rules
            # Build a rule list of edges for only nodes present in update
            $filteredEdges = @()
            foreach ($r in $rules) {
                $l = $r[0]
                $right = $r[1]
                if (($update -contains $l) -and ($update -contains $right)) {
                    # Update contains both ints
                    $filteredEdges += ,($r)
                }
            }
            #Write-Host $fileredEdges
            $fixed_update = Topological-Sort $filteredEdges
            $part_2 += (Middle-Element $fixed_update)
        }
    }

    return $part_1, $part_2
}

$inputData = Get-Content -Path ".\Public\Day-5\input.txt" -Raw
# Example usage (assuming you have the input data in a variable $inputData)
$result = Solve($inputData)
Write-Host "Part 1: $($result[0])"
Write-Host "Part 2: $($result[1])"
