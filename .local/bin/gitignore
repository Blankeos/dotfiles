#!/bin/bash

# Script to download .gitignore files from GitHub's official gitignore repository
# Usage: ./gitignore.sh [options] <language>
# By default, downloads to .gitignore file
# Use -p|--print|--stdout to print to stdout instead
# Example: ./gitignore.sh python                    # Downloads to .gitignore
# Example: ./gitignore.sh -p python                 # Prints to stdout
# Example: ./gitignore.sh --stdout python > my.gitignore  # Redirect to custom file

set -euo pipefail

# Color codes for output (only used for status messages)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base URL for the gitignore repository
BASE_URL="https://raw.githubusercontent.com/github/gitignore/main"

# Initialize flags
PRINT_TO_STDOUT=false
APPEND_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -p | --print | --stdout)
    PRINT_TO_STDOUT=true
    shift
    ;;
  -a | --append)
    APPEND_MODE=true
    shift
    ;;
  -h | --help)
    echo "Usage: $0 [options] <language>"
    echo ""
    echo "Options:"
    echo "  -p, --print, --stdout    Print to stdout instead of writing to .gitignore"
    echo "  -a, --append            Append to existing .gitignore instead of overwriting"
    echo "  -h, --help              Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 python               # Download Python gitignore to .gitignore"
    echo "  $0 -a node              # Append Node gitignore to existing .gitignore"
    echo "  $0 -p python            # Print Python gitignore to stdout"
    echo "  $0 --stdout cpp > custom.gitignore  # Redirect C++ gitignore to custom file"
    exit 0
    ;;
  *)
    LANGUAGE="$1"
    shift
    ;;
  esac
done

# Check if language was provided
if [ -z "${LANGUAGE:-}" ]; then
  echo -e "${RED}Error: No language specified${NC}" >&2
  echo "Usage: $0 [options] <language>" >&2
  echo "Try '$0 --help' for more information." >&2
  exit 1
fi

# Convert to lowercase for comparison
LANGUAGE_LOWER=$(echo "$LANGUAGE" | tr '[:upper:]' '[:lower:]')

# Function to resolve aliases
resolve_alias() {
  case "$1" in
  "c++" | "cpp") echo "C++" ;;
  "csharp" | "c#") echo "CSharp" ;;
  "golang") echo "Go" ;;
  "node" | "nodejs" | "node.js") echo "Node" ;;
  "objective-c" | "objc") echo "Objective-C" ;;
  "vb" | "visualbasic") echo "VisualBasic" ;;
  "ts" | "typescript") echo "TypeScript" ;;
  "js" | "javascript") echo "JavaScript" ;;
  "py") echo "Python" ;;
  "rb") echo "Ruby" ;;
  "yml" | "yaml") echo "Yaml" ;;
  *) echo "" ;;
  esac
}

# Check if it's an alias
ALIAS_RESULT=$(resolve_alias "$LANGUAGE_LOWER")
if [ -n "$ALIAS_RESULT" ]; then
  GITIGNORE_NAME="$ALIAS_RESULT"
else
  # Capitalize first letter for standard naming
  GITIGNORE_NAME="$(echo "${LANGUAGE_LOWER:0:1}" | tr '[:lower:]' '[:upper:]')${LANGUAGE_LOWER:1}"
fi

# Function to try downloading a gitignore file
try_download() {
  local url="$1"
  local response

  response=$(curl -s -w "\n%{http_code}" "$url")
  local http_code=$(echo "$response" | tail -n1)
  local content=$(echo "$response" | sed '$d')

  if [ "$http_code" = "200" ]; then
    echo "$content"
    return 0
  else
    return 1
  fi
}

# Function to show status messages (only when not printing to stdout)
show_status() {
  if [ "$PRINT_TO_STDOUT" = false ]; then
    echo -e "$@" >&2
  fi
}

# Try different locations
LOCATIONS=(
  "${BASE_URL}/${GITIGNORE_NAME}.gitignore"
  "${BASE_URL}/Global/${GITIGNORE_NAME}.gitignore"
  "${BASE_URL}/community/${GITIGNORE_NAME}.gitignore"
)

# Try each location
for location in "${LOCATIONS[@]}"; do
  show_status "${YELLOW}Trying: $location${NC}"

  if content=$(try_download "$location"); then
    if [ "$PRINT_TO_STDOUT" = true ]; then
      # Print to stdout
      echo "$content"
    else
      # Write to .gitignore file
      if [ "$APPEND_MODE" = true ] && [ -f .gitignore ]; then
        # Append mode - add a separator if file exists and is not empty
        if [ -s .gitignore ]; then
          echo "" >>.gitignore
          echo "# ===== ${GITIGNORE_NAME} gitignore =====" >>.gitignore
        fi
        echo "$content" >>.gitignore
        show_status "${GREEN}Successfully appended ${GITIGNORE_NAME}.gitignore to .gitignore${NC}"
      else
        # Overwrite mode
        echo "$content" >.gitignore
        show_status "${GREEN}Successfully downloaded ${GITIGNORE_NAME}.gitignore to .gitignore${NC}"
      fi
    fi
    exit 0
  fi
done

# If we get here, we couldn't find the gitignore file
echo -e "${RED}Error: Could not find .gitignore for '${LANGUAGE}'${NC}" >&2
echo -e "${YELLOW}Tried the following locations:${NC}" >&2
for location in "${LOCATIONS[@]}"; do
  echo "  - $location" >&2
done
echo -e "\n${YELLOW}Tip: Check available templates at https://github.com/github/gitignore${NC}" >&2
exit 1
