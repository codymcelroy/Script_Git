# Set the path to the directory to search
$search_directory = $PWD.Path

# Set the path to the directory to exclude
$excluded_directory = Join-Path -Path $search_directory -ChildPath ".Other"

# Change to the search directory
Set-Location $search_directory

# Find all directories that are Git repositories excluding the specified directory and its subdirectories
$repos = Get-ChildItem -Path $search_directory -Recurse -Directory -Filter ".git" -Force |
    ForEach-Object { $_.Parent.FullName } |
    Where-Object { $_ -ne $excluded_directory -and $_ -notlike "$excluded_directory\*" }

# Check if there are any Git repositories found
if ($repos.Count -gt 0) {
    # Iterate over the found Git repositories
    foreach ($repo in $repos) {
        # Change to the repository directory
        Write-Host "Repository $repo"
        Set-Location $repo

        # Retrieve the branches as tree nodes
        $branches = git log --graph --abbrev-commit --decorate --simplify-by-decoration --branches --format="%C(auto)%h %d %s"

        # Replace ASCII characters with custom graphics
        $branches = $branches -replace '[*|/]--', '├──'
        $branches = $branches -replace '\|--', '└──'

        # Get the current branch name
        $currentBranch = git symbolic-ref --short HEAD

        # Output the tree-node diagram for Git branches with the branch name
        Write-Output "Branch: $currentBranch"
        Write-Output $branches
        Write-Output "---"
        Write-Output ""
        Set-Location $search_directory
    }
}
else {
    Write-Output "No Git repositories found in the search directory."
    Set-Location $search_directory
}
