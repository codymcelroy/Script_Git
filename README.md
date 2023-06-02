# PowerShell Git Scripts

## Prune Local

Prunes local branches in Git repositories within a specified directory while excluding a particular directory and its subdirectories. It provides an option for a dry run (`-dryRun` switch) to preview branch deletions without executing them. The following steps outline how to use the script:

1. Save the script as a `.ps1` file.
2. Open a PowerShell terminal.
3. Navigate to the directory where the script is saved.
4. Run the script with the desired options, such as `.\prune_local.ps1 -dryRun`.
5. Modify the `$search_directory` and `$excluded_directory` variables within the script to specify the target directory and excluded directory, respectively.
6. If not in dry run mode, the script prompts for confirmation before deleting each branch.
