#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

sync_repo() {
    local dir="$1"

    if [ ! -d "$dir/.git" ]; then
        echo "$dir is not a git repository"
        return
    fi

    local status
    status=$(git -C "$dir" status --porcelain)
    if [ -n "$status" ]; then
        echo -e "${YELLOW}$dir has uncommitted changes -- skipping${NC}"
        return
    fi

    local branch
    branch=$(git -C "$dir" remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5)
    if [ -z "$branch" ]; then
        echo -e "${RED}$dir could not determine default branch -- skipping${NC}"
        return
    fi

    git -C "$dir" fetch origin "$branch" -q
    local incoming_changes
    incoming_changes=$(git -C "$dir" rev-list --count HEAD..origin/"$branch")

    if [ "$incoming_changes" -eq 0 ]; then
        echo -e "$dir is up to date"
        return
    fi

    echo -e "Pulling ${GREEN}$incoming_changes${NC} changes from $branch in $dir"
    git -C "$dir" checkout "$branch" -q
    git -C "$dir" pull origin "$branch" -q
}

export -f sync_repo
export RED GREEN YELLOW NC

if command -v xargs >/dev/null 2>&1; then
    find . -maxdepth 1 -mindepth 1 -type d -print0 | xargs -0 -P 8 -I {} bash -c 'sync_repo "$@"' _ {}
else
    for dir in */; do
        sync_repo "$dir"
    done
fi
