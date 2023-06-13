$directoriesWithoutSVG = Get-ChildItem -Recurse -Directory -Path $rootDirectory |
    ForEach-Object {
        $currentDirectory = $_.FullName
        $hasSVGFile = Get-ChildItem -Path $currentDirectory -Filter ".svg" -File -ErrorAction SilentlyContinue

        if (-not $hasSVGFile) {
            $currentDirectory
        }
    }

if ($directoriesWithoutSVG) {
    Write-Host "Subdirectories without .svg files:"
    $directoriesWithoutSVG
}
else {
    Write-Host "All subdirectories have .svg files."
}