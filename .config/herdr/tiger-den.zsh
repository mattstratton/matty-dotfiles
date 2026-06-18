# tiger-den herdr helpers — sourced from ~/.zshrc
#
#   tw <slug>        bare `claude -w <slug>` worktree pane (ad-hoc work)
#   twissue <n>      `/implement issue #<n>` in plan mode, in an issue-<n> worktree
#
# Both spawn a *status-tracked* pane in the tiger-den herdr workspace (vs `issue`,
# which takes over the current terminal). Creation stays `claude -w`, so
# .worktreeinclude + session-init schema isolation still run. Verified vs herdr 0.6.8.

TIGERDEN_DIR="$HOME/src/github.com/timescale/tiger-den"

# Resolve the tiger-den herdr workspace id, creating it (+ "control" tab) if absent.
_tigerden_ws() {
  local ws
  ws=$(herdr workspace list 2>/dev/null \
    | jq -r '.result.workspaces[]|select(.label=="tiger-den")|.workspace_id')
  if [[ -z "$ws" ]]; then
    local create_out
    create_out=$(herdr workspace create --cwd "$TIGERDEN_DIR" --label "tiger-den" --no-focus 2>/dev/null)
    ws=$(echo "$create_out" | jq -r '.result.workspace.workspace_id')
    local control_tab
    control_tab=$(echo "$create_out" | jq -r '.result.tab.tab_id')
    [[ -n "$control_tab" ]] && herdr tab rename "$control_tab" "control" 2>/dev/null
  fi
  echo "$ws"
}

# _tigerden_spawn <agent-name> <argv...>  → agent in its own named tab in the tiger-den workspace.
# Creates a fresh tab, then sends `exec <cmd>` to the root pane's shell so claude replaces
# the shell in-place (no split, no orphan pane). `exec` also means the pane closes cleanly
# when claude exits rather than dropping back to a shell prompt.
_tigerden_spawn() {
  local name="$1"; shift
  local ws; ws=$(_tigerden_ws)
  local -a wsarg=()
  [[ -n "$ws" ]] && wsarg=(--workspace "$ws")
  local tab_out
  tab_out=$(herdr tab create "${wsarg[@]}" --cwd "$TIGERDEN_DIR" --label "$name" --no-focus 2>/dev/null)
  local pane_id
  pane_id=$(echo "$tab_out" | jq -r '.result.root_pane.pane_id')
  herdr pane send-text "$pane_id" "exec $*"
  herdr pane send-keys "$pane_id" Enter
}

tw() {
  local slug="${1:?usage: tw <slug>   # e.g. tw tden-1234}"
  _tigerden_spawn "$slug" claude -w "$slug"
}

twrelease() {
  _tigerden_spawn "release" \
    claude --model sonnet --permission-mode auto "/release"
}

twissue() {
  local n="${1:?usage: twissue <issue-number>   # e.g. twissue 1234}"
  _tigerden_spawn "issue-$n" \
    claude --permission-mode plan -w "issue-$n" "/implement issue #$n"
}
