# =============================================
# Git Sync Script - MacroQuest Private Build
# =============================================

Write-Host "=== MacroQuest Private Build Sync ===" -ForegroundColor Cyan

# Detect correct branch (master or main)
$branch = git branch --show-current
if (-not $branch) {
    $branch = "master"  # fallback
}

Write-Host "Current branch: $branch" -ForegroundColor Yellow

# Pull latest changes
Write-Host "Pulling latest changes from GitHub..." -ForegroundColor Yellow
git pull origin $branch

# Add all changes
Write-Host "Adding changes..." -ForegroundColor Yellow
git add .

# Check if there are changes to commit
$status = git status --porcelain
if ($status) {
    $message = Read-Host "Enter commit message (or press Enter for default)"
    if ([string]::IsNullOrWhiteSpace($message)) {
        $message = "Auto sync - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }
    git commit -m $message
} else {
    Write-Host "No changes to commit." -ForegroundColor Green
    Write-Host "Sync completed!" -ForegroundColor Green
    return
}

# Push to GitHub
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
git push origin $branch

Write-Host "Sync completed successfully!" -ForegroundColor Green