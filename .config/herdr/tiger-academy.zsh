# tiger-academy herdr helpers — sourced from ~/.zshrc_shared
#
#   ta <slug>         plain Claude in a new worktree `<slug>`, for ad-hoc work
#   taissue <n>...    /implement-issue EDU-<n> in plan mode; several ids = one package worktree
#   tahelp            this list
#
# Same shape as tiger-den.zsh: each command spawns a *status-tracked* tab in the tiger-academy herdr
# workspace, creation stays `claude -w` so .worktreeinclude + session-init still run.
# No claude() wrapper / Artifact deny here: that trim is a tiger-den thing (TDEN-1076), and defining
# claude() twice would clobber den's. Add tadesign/tareview/tarelease once those skills exist in
# tiger-academy/.claude/skills. tahelp prints the indented lines above, so keep that list current.

TIGERACADEMY_DIR="$HOME/src/github.com/timescale/tiger-academy"
_TIGERACADEMY_HELPERS="${(%):-%x}"   # this file's path, captured at source time for tahelp

tahelp() {
  print "tiger-academy helpers (${_TIGERACADEMY_HELPERS/#$HOME/~}):"
  sed -n 's/^#   /  /p' "$_TIGERACADEMY_HELPERS"
}

# Resolve the tiger-academy herdr workspace id, creating it (+ "control" tab) if absent.
_tigeracademy_ws() {
  local ws
  ws=$(herdr workspace list 2>/dev/null \
    | jq -r '.result.workspaces[]|select(.label=="tiger-academy")|.workspace_id')
  if [[ -z "$ws" ]]; then
    local create_out
    create_out=$(herdr workspace create --cwd "$TIGERACADEMY_DIR" --label "tiger-academy" --no-focus 2>/dev/null)
    ws=$(echo "$create_out" | jq -r '.result.workspace.workspace_id')
    local control_tab
    control_tab=$(echo "$create_out" | jq -r '.result.tab.tab_id')
    [[ -n "$control_tab" ]] && herdr tab rename "$control_tab" "control" 2>/dev/null
  fi
  echo "$ws"
}

# _tigeracademy_spawn <agent-name> <argv...>  → agent in its own named tab in the tiger-academy workspace.
# `exec` replaces the pane's shell with claude, so the pane closes cleanly when claude exits.
_tigeracademy_spawn() {
  local name="$1"; shift
  local ws; ws=$(_tigeracademy_ws)
  local -a wsarg=()
  [[ -n "$ws" ]] && wsarg=(--workspace "$ws")
  local tab_out
  tab_out=$(herdr tab create "${wsarg[@]}" --cwd "$TIGERACADEMY_DIR" --label "$name" --no-focus 2>/dev/null)
  local pane_id
  pane_id=$(echo "$tab_out" | jq -r '.result.root_pane.pane_id')
  # Quote each argv element ((@q)) before joining, or the pane's shell re-splits the prompt.
  herdr pane send-text "$pane_id" "exec ${(j: :)${(@q)@}}"
  herdr pane send-keys "$pane_id" Enter
}

ta() {
  local slug="${1:?usage: ta <slug>   # e.g. ta edu-905}"
  _tigeracademy_spawn "$slug" claude -w "$slug"
}

# One id  → worktree issue-EDU-<n>.
# Several → one "package" worktree (pkg-<n>-<n>) and ONE /implement-issue run over all of them.
# Accepts "905", "EDU-905" or "edu-905".
taissue() {
  (( $# )) || { echo "usage: taissue <n> [<n> ...]   # e.g. taissue 905 906" >&2; return 1; }
  local -a ids=()
  local a
  for a in "$@"; do ids+=("EDU-${${(U)a}#EDU-}"); done
  local slug
  if (( $# == 1 )); then
    slug="issue-${ids[1]}"
  else
    slug="pkg-${(j:-:)${(@)ids#EDU-}}"
  fi
  _tigeracademy_spawn "$slug" \
    claude --permission-mode plan -w "$slug" "/implement-issue ${ids[*]}"
}
