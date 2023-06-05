# Set the directory where you want to search for repositories
$search_directory = $PWD.Path

# Set the path to the directory to exclude
$excluded_directory = Join-Path -Path $search_directory -ChildPath ".Other"

# Change to the search directory
Set-Location $search_directory

# Find all directories that are Git repositories excluding the specified directory and its subdirectories
$repos = Get-ChildItem -Path $search_directory -Recurse -Directory -Filter ".git" -Force |
    ForEach-Object { $_.Parent.FullName } |
    Where-Object { $_ -ne $excluded_directory -and $_ -notlike "$excluded_directory\*" }

# Iterate over each repository, fetch changes from origin, and check local branches
foreach ($repo in $repos) {
    Write-Host "Checking repository $repo"
    Set-Location $repo

    # Fetch the latest changes from the origin
    & git fetch

    # Get the name of the main branch dynamically
    $main_branch = & git symbolic-ref --short HEAD

    # List all local branches
    $branches = & git branch

    # Iterate over each local branch and check for changes
    foreach ($branch in $branches) {
        # Remove leading whitespace and asterisk from the branch name
        $branchName = $branch.TrimStart("* ").Trim()

        # Check if the local branch is different from its remote counterpart
        $diff_output = & git diff --quiet $branchName origin/$branchName --exit-code
        if ($diff_output) {
            Write-Host "Local branch '$branchName' has changes compared to the remote branch"
        } else {
            # Check if the local branch has been merged
            $merged_output = & git branch --merged $main_branch | Select-String -Pattern $branchName
            if ($merged_output) {
                Write-Host "Local branch '$branchName' has been merged into the main branch"
            } else {
                Write-Host "Local branch '$branchName' is up to date with the remote branch"
            }
        }
    }

    Set-Location $search_directory
}
