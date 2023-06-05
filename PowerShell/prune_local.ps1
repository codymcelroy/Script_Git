param(
    [switch]$dryRun
)

# Set the directory where you want to search for repositories
$search_directory = $PWD.Path

# Set the path to the directory to exclude
$excluded_directory = Join-Path -Path $search_directory -ChildPath "DirectoryName"

# Change to the search directory
Set-Location $search_directory

# Find all directories that are Git repositories excluding the specified directory and its subdirectories
$repos = Get-ChildItem -Path $search_directory -Recurse -Directory -Filter ".git" -Force |
    ForEach-Object { $_.Parent.FullName } |
    Where-Object { $_ -ne $excluded_directory -and $_ -notlike "$excluded_directory\*" }

foreach ($repo in $repos) {
    Write-Host "Checking repository $repo"
    Set-Location $repo

    git fetch -p --quiet
    $branchesToDelete = git for-each-ref --format '%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)' 'refs/heads/**'

    foreach ($branch in $branchesToDelete) {
        if (![string]::IsNullOrWhiteSpace($branch)) {
            if ($dryRun) {
                Write-Host "$branch will be deleted locally"
            } else {
                $confirmation = Read-Host "Do you want to delete the branch $branch locally? (Y/N)"
                if ($confirmation -eq "Y" -or $confirmation -eq "y") {
                    git branch -D $branch
                } else {
                    Write-Host "Branch deletion skipped."
                }
            }
        }
    }
    Write-Host ""
    Set-Location $search_directory
}
