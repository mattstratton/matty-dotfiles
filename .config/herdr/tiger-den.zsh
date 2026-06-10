# tiger-den herdr helpers — sourced from ~/.zshrc
#
#   tw <slug>        bare `claude -w <slug>` worktree pane (ad-hoc work)
#   twissue <n>      `/implement issue #<n>` in plan mode, in an issue-<n> worktree
#
# Both spawn a *status-tracked* pane in the tiger-den herdr workspace (vs `issue`,
# which takes over the current terminal). Creation stays `claude -w`, so
# .worktreeinclude + session-init schema isolation still run. Verified vs herdr 0.6.8.

TIGERDEN_DIR="$HOME/src/github.com/timescale/tiger-den"

# Resolve the tiger-den herdr workspace id, creating it (+ anchor shell pane) if absent.
_tigerden_ws() {
  local ws
  ws=$(herdr workspace list 2>/dev/null \
    | jq -r '.result.workspaces[]|select(.label=="tiger-den")|.workspace_id')
  if [[ -z "$ws" ]]; then
    ws=$(herdr workspace create --cwd "$TIGERDEN_DIR" --label "tiger-den" --no-focus 2>/dev/null \
      | jq -r '.result.workspace.workspace_id')
  fi
  echo "$ws"
}

# _tigerden_spawn <agent-name> <argv...>  → tracked pane in the tiger-den workspace.
_tigerden_spawn() {
  local name="$1"; shift
  local ws; ws=$(_tigerden_ws)
  # zsh does not word-split ${ws:+...}, so build an array to keep --workspace and
  # its value as two separate argv tokens.
  local -a wsarg=()
  [[ -n "$ws" ]] && wsarg=(--workspace "$ws")
  herdr agent start "$name" --cwd "$TIGERDEN_DIR" "${wsarg[@]}" -- "$@"
}

tw() {
  local slug="${1:?usage: tw <slug>   # e.g. tw tden-1234}"
  _tigerden_spawn "$slug" claude -w "$slug"
}

twissue() {
  local n="${1:?usage: twissue <issue-number>   # e.g. twissue 1234}"
  _tigerden_spawn "issue-$n" \
    claude --permission-mode plan -w "issue-$n" "/implement issue #$n"
}
