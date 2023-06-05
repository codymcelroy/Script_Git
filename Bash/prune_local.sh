#!/bin/bash

# Parse the command-line arguments
dryRun=false
while getopts ":d" opt; do
  case $opt in
    d)
      dryRun=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Set the directory where you want to search for repositories
search_directory=$(pwd)

# Set the path to the directory to exclude
excluded_directory="$search_directory/DirectoryName"

# Change to the search directory
cd "$search_directory" || exit 1

# Find all directories that are Git repositories excluding the specified directory and its subdirectories
repos=()
while IFS= read -r -d '' repo; do
  repos+=("$repo")
done < <(find "$search_directory" -type d -name ".git" -print0 |
         awk -F/ -v excluded="$excluded_directory" '$0 != excluded')

for repo in "${repos[@]}"; do
  echo "Checking repository $repo"
  cd "$repo" || continue

  git fetch -p --quiet
  branchesToDelete=$(git for-each-ref --format '%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)' 'refs/heads/**')

  while IFS= read -r branch; do
    if [[ -n $branch ]]; then
      if $dryRun; then
        echo "$branch will be deleted locally"
      else
        read -r -p "Do you want to delete the branch $branch locally? (Y/N) " confirmation
        if [[ $confirmation == [Yy] ]]; then
          git branch -D "$branch"
        else
          echo "Branch deletion skipped."
        fi
      fi
    fi
  done <<< "$branchesToDelete"
  
  echo ""
  cd "$search_directory" || exit 1
done