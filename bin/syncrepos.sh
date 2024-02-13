#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;33m'
NC='\033[0m' 

for dir in */; do
    cd "$dir" || continue
    
    if [ -d ".git" ]; then
        status=$(git status --porcelain)
        if [ -n "$status" ]; then
            echo -e "${RED}$dir has uncommitted changes --skipping${NC}"
        else
            branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
            git fetch origin $branch -q
            incoming_changes=$(git rev-list --count HEAD..origin/$branch)

            echo -e "Pulling ${GREEN}$incoming_changes${NC} changes from $branch in $dir"

            git co $branch -q
            git pull origin $branch -q
        fi
    else
        echo "$dir is not a git repository"
    fi
    
    cd ..
done
