# Import all private functions
Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -recurse | ForEach-Object {
    . $_.FullName
}

# Import all public functions
Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -recurse | ForEach-Object {
    . $_.FullName
}

# The dot sourcing operator (. ) is used to execute each script so that the functions are available in the module.
# This effectively imports the functions defined in those files into the module.
# The PSD1 file also specifies which functions to export from the module using the FunctionsToExport key.

# The $PSScriptRoot automatic variable contains the directory where the script is located.