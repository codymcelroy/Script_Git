# PowerShell Git Scripts

## List-Branches

Searches for all Git repositories in the current directory and its subdirectories, excluding a specified directory. It then iterates over each repository, checks and displays the local branches.

## Graph-Branches

Displays a tree-node diagram of their branches. It excludes a specified directory and its subdirectories from the search. The script retrieves the branches as tree nodes and replaces ASCII characters with custom graphics for better visualization. It also identifies the current branch and outputs the branch diagram for each Git repository found. Improve your understanding of Git branch structure with this script.

## Prune-Branches

Prunes local branches in Git repositories within a specified directory while excluding a particular directory and its subdirectories. It provides an option for a dry run (`-dryRun` switch) to preview branch deletions without executing them. The following steps outline how to use the script:

1. Save the script as a `.ps1` file.
2. Open a PowerShell terminal.
3. Navigate to the directory where the script is saved.
4. Run the script with the desired options, such as `.\prune_local.ps1 -dryRun`.
5. Modify the `$search_directory` and `$excluded_directory` variables within the script to specify the target directory and excluded directory, respectively.
6. If not in dry run mode, the script prompts for confirmation before deleting each branch.
