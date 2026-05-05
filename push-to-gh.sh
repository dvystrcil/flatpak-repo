#!/bin/bash
set -e

# Script to initialize git repo and prepare for push
# Run this after cloning the repo or creating it locally

cd /home/u3aa02715/flatpack-repo

# Initialize git if needed
if [ ! -d ".git" ]; then
    git init
fi

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: MekHQ Flatpak + CI/CD workflows"

# Add remote (replace with your actual repo URL)
git remote add origin https://github.com/dvystrcil/flatpack-repo.git 2>/dev/null || git remote set-url origin https://github.com/dvystrcil/flatpack-repo.git

# Push to main branch
git push -u origin main