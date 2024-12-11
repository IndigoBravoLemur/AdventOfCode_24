<#
.SYNOPSIS
    Brief description of the script.

.DESCRIPTION
    Detailed description of the script.

.PARAMETER Parameter1
    Description of the first parameter.

.PARAMETER Parameter2
    Description of the second parameter.

.EXAMPLE
    Example of how to use the script.

.NOTES
    Additional notes about the script.

#>

# Requires -Version 5.1

# Import necessary modules
# Import-Module -Name ModuleName

# Define parameters
param (
    [Parameter(Mandatory = $true)]
    [string]$Parameter1,

    [Parameter(Mandatory = $false)]
    [int]$Parameter2 = 42
)

# Main script logic
function Main {
    try {
        # Your code here
        Write-Output "Parameter1: $Parameter1"
        Write-Output "Parameter2: $Parameter2"
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

# Call the main function
Main