# Get the current directory
$currentDirectory = Get-Location

# Define the function to rename and delete files
function RenameAndDeleteFiles($path) {
    # Get the parent directory name
    $parentDirectoryName = (Get-Item -Path $path).Directory.Name

    # Get the files that match the condition
    $files = Get-ChildItem -Path $path -Filter "*original*" -File -Recurse | Where-Object {
        $_.Name -like "*original*" -or $_.Name -like "*plain*"
    }

    # Check if there are two files matching the condition
    if ($files.Count -eq 2) {
        # Get the file with "plain" in its name
        $fileToDelete = $files | Where-Object { $_.Name -like "*plain*" }

        # Delete the file
        $fileToDelete | Remove-Item -Force
    }

    # Rename the remaining file(s)
    foreach ($file in $files) {
        $newFileName = $parentDirectoryName + $file.Extension
        $newFilePath = Join-Path -Path $file.DirectoryName -ChildPath $newFileName

        # Rename the file
        Rename-Item -Path $file.FullName -NewName $newFileName -Force

        Write-Host "Renamed '$($file.Name)' to '$newFileName'"
    }
}

# Call the function recursively for each subdirectory
function RecurseDirectories($path) {
    $subdirectories = Get-ChildItem -Path $path -Directory

    foreach ($subdirectory in $subdirectories) {
        # Call the function for the subdirectory
        RenameAndDeleteFiles -path $subdirectory.FullName

        # Recurse into the subdirectory
        RecurseDirectories -path $subdirectory.FullName
    }
}

# Call the function for the current directory
RenameAndDeleteFiles -path $currentDirectory

# Recurse into subdirectories
RecurseDirectories -path $currentDirectory
