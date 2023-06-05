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

# Iterate over each repository and list all local branches with their corresponding remote branches
foreach ($repo in $repos) {
    Write-Host "Checking repository $repo"
    Set-Location $repo

    # Get the current branch
    $currentBranch = & git rev-parse --abbrev-ref HEAD
    Write-Host "Current branch: $currentBranch"

    # Determine the remote branch based on the upstream branch
    $upstreamBranch = (& git rev-parse --abbrev-ref "$currentBranch@{u}").Split('/')[2]
    if ($null -eq $upstreamBranch) {
        Write-Host "Upstream branch not found for $currentBranch"
        continue
    }
    $remoteBranch = $upstreamBranch

    # Fetch the latest changes from the remote repository
    git fetch

    # Find the merge base between the current branch and the remote branch
    $baseBranch = git merge-base $currentBranch "$remoteBranch"

    Write-Host "Local branches:"
    $branches = & git branch
    Write-Host $branches

    Write-Host "Base branch for $($currentBranch) and $($remoteBranch): $($baseBranch)"

    Set-Location $search_directory
}
