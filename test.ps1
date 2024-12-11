    # Initialize a multidimensional array
    $multiDimArray = @()

    # Process the file line by line
    Get-Content -Path ".\Public\Day-4\test.txt" | ForEach-Object {
        # Convert each line into a character array and add it to the multidimensional array
        $multiDimArray += ,($_.ToCharArray())
        #The , (comma) before ($_.ToCharArray()) ensures that the output of ToCharArray() is treated as an array element (specifically, a nested array), even if there's only one line being processed.


    }
    # Print each character array on a single line
    foreach ($charArray in $multiDimArray) {
        Write-Output ($charArray -join "")
    }
    # Output the multidimensional array (optional) which
    $multiDimArray