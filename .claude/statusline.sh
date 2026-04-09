#!/bin/bash

# Claude Code Custom Status Line
# v3.5.0 - Three-line compact layout for narrower terminals
# Line 1: Model | Repo:Branch | git status | lines changed
# Line 2: [commit] commit message
# Line 3: Context bricks | percentage | free | duration | cost
#
# Uses new percentage fields (Claude Code 2.1.6+) for accurate context display.
# Falls back to current_usage calculation for older versions.
# See: https://code.claude.com/docs/en/statusline#context-window-usage

# Read JSON from stdin
input=$(cat)

# Parse Claude data
model=$(echo "$input" | jq -r '.model.display_name // "Claude"' | sed 's/Claude //')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // env.PWD')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Get git information (change to workspace directory)
cd "$current_dir" 2>/dev/null || cd "$HOME"

# Check if we're in a git repo
if git rev-parse --git-dir > /dev/null 2>&1; then
    repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" || echo "")
    branch=$(git branch --show-current 2>/dev/null || echo "detached")
    commit_short=$(git rev-parse --short HEAD 2>/dev/null || echo "")
    commit_msg=$(git log -1 --pretty=%s 2>/dev/null | cut -c1-40 || echo "")

    # Get GitHub repo (if remote exists)
    github_url=$(git config --get remote.origin.url 2>/dev/null)
    if [[ $github_url =~ github.com[:/](.+/.+)(\.git)?$ ]]; then
        github_repo="${BASH_REMATCH[1]%.git}"
    else
        github_repo=""
    fi

    # Git status indicators
    git_status=""
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        git_status="*"
    fi

    # Check ahead/behind remote
    upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    if [[ -n "$upstream" ]]; then
        ahead=$(git rev-list --count "$upstream"..HEAD 2>/dev/null || echo "0")
        behind=$(git rev-list --count HEAD.."$upstream" 2>/dev/null || echo "0")
        [[ "$ahead" -gt 0 ]] && git_status="${git_status}↑${ahead}"
        [[ "$behind" -gt 0 ]] && git_status="${git_status}↓${behind}"
    fi
else
    repo_name="no-repo"
    branch=""
    commit_short=""
    commit_msg=""
    github_repo=""
    git_status=""
fi

# Build Line 1: Model + Repo:Branch + Status + Changes (compact)
line1=""

# Model in brackets
line1+="\033[1;36m[$model]\033[0m "

# Repo:Branch
if [[ -n "$repo_name" && "$repo_name" != "no-repo" ]]; then
    line1+="\033[1;32m$repo_name\033[0m"
    if [[ -n "$branch" ]]; then
        line1+=":\033[1;34m$branch\033[0m"
    fi
fi

# Git status indicators
if [[ -n "$git_status" ]]; then
    line1+=" \033[1;31m$git_status\033[0m"
fi

# Lines changed
if [[ "$lines_added" -gt 0 || "$lines_removed" -gt 0 ]]; then
    line1+=" | \033[0;32m+$lines_added\033[0m/\033[0;31m-$lines_removed\033[0m"
fi

# Build Line 2: Commit hash + message (truncated to ~60 chars)
line2=""
if [[ -n "$commit_short" ]]; then
    line2+="\033[1;33m[$commit_short]\033[0m"
    if [[ -n "$commit_msg" ]]; then
        # Truncate message to fit narrow terminal
        truncated_msg=$(echo "$commit_msg" | cut -c1-55)
        if [[ ${#commit_msg} -gt 55 ]]; then
            truncated_msg="${truncated_msg}..."
        fi
        line2+=" $truncated_msg"
    fi
fi

# Build Line 3: Context bricks + session info
# Get session duration (convert ms to HHh MMm format)
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
duration_hours=$((duration_ms / 3600000))
duration_min=$(((duration_ms % 3600000) / 60000))

# Get session cost (only show if > 0, for API users)
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

# Get context window data - prefer v2.1.6+ percentage fields, fallback to calculation
total_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')

# Try new percentage fields first (Claude Code 2.1.6+)
used_pct_raw=$(echo "$input" | jq -r '.context_window.used_percentage // null')
remaining_pct_raw=$(echo "$input" | jq -r '.context_window.remaining_percentage // null')

if [[ "$used_pct_raw" != "null" && -n "$used_pct_raw" ]]; then
    # Use official percentage (more accurate)
    usage_pct=${used_pct_raw%.*}  # Truncate to integer for display
    remaining_pct=${remaining_pct_raw%.*}

    # Calculate tokens from percentages for display
    used_tokens=$(( (total_tokens * usage_pct) / 100 ))
    free_tokens=$(( (total_tokens * remaining_pct) / 100 ))
else
    # Fallback: Calculate from current_usage (Claude Code 2.0.70+)
    current_usage=$(echo "$input" | jq -r '.context_window.current_usage // null')

    if [[ "$current_usage" != "null" ]]; then
        input_tokens=$(echo "$current_usage" | jq -r '.input_tokens // 0')
        cache_creation=$(echo "$current_usage" | jq -r '.cache_creation_input_tokens // 0')
        cache_read=$(echo "$current_usage" | jq -r '.cache_read_input_tokens // 0')
        used_tokens=$((input_tokens + cache_creation + cache_read))
    else
        used_tokens=0
    fi

    free_tokens=$((total_tokens - used_tokens))
    if [[ $total_tokens -gt 0 ]]; then
        usage_pct=$(( (used_tokens * 100) / total_tokens ))
    else
        usage_pct=0
    fi
fi

# Convert to 'k' format for display
used_k=$(( used_tokens / 1000 ))
total_k=$(( total_tokens / 1000 ))
free_k=$(( free_tokens / 1000 ))

# Generate brick visualization (30 bricks for narrower display)
total_bricks=30
if [[ $total_tokens -gt 0 ]]; then
    used_bricks=$(( (used_tokens * total_bricks) / total_tokens ))
else
    used_bricks=0
fi
free_bricks=$((total_bricks - used_bricks))

# Build brick line with single colour (cyan for used, dim white for free)
brick_line="["

# Used bricks (cyan)
for ((i=0; i<used_bricks; i++)); do
    brick_line+="\033[0;36m■\033[0m"
done

# Free bricks (dim/gray hollow squares)
for ((i=0; i<free_bricks; i++)); do
    brick_line+="\033[2;37m□\033[0m"
done

brick_line+="]"

# Compact stats: percentage | free | duration
brick_line+=" \033[1m${usage_pct}%\033[0m"
brick_line+=" | \033[1;32m${free_k}k free\033[0m"
brick_line+=" | ${duration_hours}h${duration_min}m"

# Add cost only if non-zero, rounded to 2 decimal places
if command -v bc &> /dev/null; then
    if (( $(echo "$cost_usd > 0" | bc -l 2>/dev/null || echo "0") )); then
        cost_formatted=$(printf "%.2f" "$cost_usd" 2>/dev/null || echo "0.00")
        brick_line+=" | \033[0;33m\$${cost_formatted}\033[0m"
    fi
else
    # Fallback without bc: simple string comparison
    if [[ "$cost_usd" != "0" && "$cost_usd" != "0.0" && "$cost_usd" != "0.00" && -n "$cost_usd" ]]; then
        brick_line+=" | \033[0;33m\$${cost_usd}\033[0m"
    fi
fi

# Output all three lines
echo -e "$line1"
[[ -n "$line2" ]] && echo -e "$line2"
echo -e "$brick_line"
