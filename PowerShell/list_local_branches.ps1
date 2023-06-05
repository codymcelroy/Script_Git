# list local branches
$search_directory = $PWD.Path

# Set the path to the directory to exclude
$excluded_directory = Join-Path -Path $search_directory -ChildPath ".Other"

# Change to the search directory
Set-Location $search_directory

# Find all directories that are Git repositories excluding the specified directory and its subdirectories
$repos = Get-ChildItem -Path $search_directory -Recurse -Directory -Filter ".git" -Force |
    ForEach-Object { $_.Parent.FullName } |
    Where-Object { $_ -ne $excluded_directory -and $_ -notlike "$excluded_directory\*" }

# Iterate over each repository and list all local branches
foreach ($repo in $repos) {
    Write-Host "Checking repository $repo"
    Set-Location $repo

    # List all local branches
    $branches = & git branch

    Write-Host "Local branches:"
    Write-Host $branches

    Set-Location $search_directory
}