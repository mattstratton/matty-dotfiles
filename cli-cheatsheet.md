# cli cheat sheet: the new stuff

installed 2026-10-10. all via Brewfile except gh-dash (gh extension, installed by yadm bootstrap).

---

## diff-so-fancy: git diffs for humans

already wired as git's pager, so you don't run it directly. makes `git diff`, `git show`, `git log -p`
readable: highlights the *changed words* inside a line, cleaner file headers, no wall of `+`/`-`.
also kicks in for `git add -p` (via `interactive.diffFilter`).

```sh
git diff                         # just works
git log -p -3                    # last 3 commits with pretty diffs
diff -u old.txt new.txt | diff-so-fancy   # works on non-git diffs too
git --no-pager diff              # escape hatch: raw output
```

## gh-dash: PRs + issues in a TUI

```sh
gh dash
```

- `?` shows every keybinding (start here)
- `d` view diff · `o` open in browser · `s` switch PRs ↔ issues
- default sections: your PRs, PRs needing your review, PRs you're involved in

want a tiger-den-only tab? add to `~/.config/gh-dash/config.yml`:

```yaml
prSections:
  - title: tiger-den
    filters: is:open repo:timescale/tiger-den
```

## hyperfine: benchmarks with actual statistics

warmups, outlier detection, mean ± σ, min/max. replaces hand-rolled `time` loops.

```sh
hyperfine 'psql "$PGURL" -c "select 1"'                 # quick check
hyperfine -w 3 -r 20 'cmd'                              # 3 warmups, 20 runs
hyperfine 'cmd-a' 'cmd-b'                               # head-to-head, prints "X times faster"
hyperfine -N 'tiger service list'                       # -N = no shell (less noise on fast cmds)
```

branch bench across providers (db-branch-bench):

```sh
hyperfine -r 5 \
  -L provider neon,planetscale,supabase,tigerdata \
  'bash bench/timers/{provider}_branch.sh' \
  --export-markdown results.md --export-json results.json
```

- `-p/--prepare 'cmd'` runs before *every* timed run (reset state, drop the branch)
- `-c/--cleanup 'cmd'` runs after each command's batch
- `-s/--setup 'cmd'` runs once per command, before its batch of runs
- `-i` keeps going if a command exits non-zero
- `--export-markdown` output drops straight into a README or the benchmarks hub

> if a timer script already loops/times internally, keep `-r` low or you're benchmarking your benchmark.

## vhs: scripted terminal recordings (replaces asciinema + agg)

write a `.tape` file, render a gif/mp4/webm. when the tiger CLI output changes, re-render instead of re-recording.

```sh
vhs new demo.tape        # starter file with all the commands documented inline
vhs demo.tape            # render it
vhs record > demo.tape   # do it live, get a tape file to edit afterwards
vhs themes               # 348 of them
vhs validate *.tape      # lint without rendering
```

```tape
Output tiger-demo.gif
Require tiger

Set FontSize 22
Set Width 1200
Set Height 600
Set Theme "Catppuccin Mocha"
Set WindowBar Colorful
Set TypingSpeed 60ms

Hide
Type "export PS1='$ '" Enter
Type "clear" Enter
Show

Type "tiger service list"
Sleep 500ms
Enter
Sleep 3s
```

- `Hide` / `Show`: do setup off-camera (env vars, cd, auth)
- `Ctrl+C`, `Enter 2`, `Backspace 5`, `Type@20ms "fast typing"`
- `Output demo.mp4` for video (multiple `Output` lines = multiple formats)
- ⚠️ `vhs publish` uploads to a **public** URL. don't publish anything with real hostnames/creds on screen.

## freeze: pretty code + terminal screenshots

for slides, linkedin, blog posts. png/svg/webp based on the `-o` extension.

```sh
freeze main.go -o code.png                              # syntax-highlighted code image
freeze -x "tiger service list" -o out.png               # run a command, screenshot its output
freeze query.sql --lines 10,30 --show-line-numbers      # just a slice
freeze main.go --window -t dracula -o code.png          # mac window chrome + theme
freeze -i main.go                                       # interactive form for all the knobs
```

## chafa: images in the terminal

ghostty speaks the kitty graphics protocol, so these are real pixels, not ascii mush.
`imgcat` and `imgls` are aliased to it, so muscle memory still works.

```sh
imgcat photo.png          # = chafa photo.png
imgls *.jpg               # = chafa -g (contact-sheet grid)
chafa -s 60x30 logo.png   # constrain size
chafa tiger-demo.gif      # animated gifs play: preview vhs output without leaving the terminal
```

## pspg: a real pager for psql

wired via `PSQL_PAGER=pspg`, so just use psql like normal. kicks in when results don't fit on screen.

- arrows / mouse scroll · `0`–`4` freeze that many leading columns (keep `id` visible while scrolling right)
- `/` search · `?` search backward · `n` next match
- `s` save results to a file · `F9` menu · `q` quit
- escape hatch for one query: `\pset pager off`

## eza: ls, but it knows about git

`ls` is aliased to it (dirs first, icons). the oh-my-zsh `l` / `ll` / `la` aliases run through it too, with a header row.

```sh
ls                  # dirs first + icons
ll                  # long listing (omz alias → eza -lh)
ls -l --git         # git status column per file (M modified, N new, I ignored…)
lt                  # tree view that skips .gitignored junk (node_modules, dist…)
lt -L 2             # tree, 2 levels deep
ls -l --total-size  # real directory sizes (slow on huge dirs)
command ls          # escape hatch: the real ls
```

## bat: cat with syntax highlighting

`cat` is aliased to `bat --paging=never`, so you get highlighting, line numbers and git change markers in the margin,
and it never drops you into a pager. **piped output is plain**, so `cat file | pbcopy` works exactly like before.

```sh
cat main.go                   # highlighted, numbered
bat -p main.go                # plain: no line numbers, for copying straight out of the terminal
bat -r 30:50 schema.sql       # just lines 30–50
bat -d main.go                # only the lines changed vs git
bat -A config.yaml            # show tabs / CRLF / trailing spaces, for "why won't this yaml parse"
curl -s localhost:3000/api | bat -l json   # force a language for piped input
command cat file              # escape hatch: the real cat
```

> the eza/bat aliases are skipped inside Claude Code and other agent shells, so agents still get plain `ls`/`cat` output.

## gum: pretty prompts for shell scripts

a toolkit of interactive pieces (menus, fuzzy pickers, confirms, spinners, styled boxes) you drop into shell scripts
instead of `read -p` and `echo`. each one reads args/stdin and prints the answer to stdout, so it composes with everything.

| piece | does | exits / prints |
|---|---|---|
| `gum choose a b c` | arrow-key menu (`--no-limit` = multi-select) | the choice(s) |
| `gum filter` | fuzzy-pick from stdin lines | the picked line |
| `gum confirm "sure?"` | yes/no | exit 0 / 1 |
| `gum input` / `gum write` | one-line / multi-line text entry | the text |
| `gum spin --title "…" -- cmd` | spinner while cmd runs (`--show-output` to see it) | cmd's exit code |
| `gum style --border rounded "hi"` | boxes, colors, padding | styled text |
| `gum table --print < x.csv` | renders a csv as a table | — |

### where it earns its keep

**1. bench runs: pick providers instead of editing the command** (db-branch-bench)

```sh
providers=$(gum choose --no-limit neon planetscale supabase tigerdata | paste -sd, -)
hyperfine -r 5 -L provider "$providers" 'bash bench/timers/{provider}_branch.sh' --export-csv results.csv
gum table --print < results.csv
```

**2. guard the destructive stuff**

```sh
gum confirm "nuke ALL bench branches on every provider?" && bash bench/cleanup/cleanup_all.sh
```

**3. jump around claude worktrees and branches**

```sh
cd "$(git worktree list | gum filter --placeholder 'worktree…' | awk '{print $1}')"
git switch "$(git branch --format='%(refname:short)' | gum filter)"
```

**4. workshop setup scripts** (where attendees need hand-holding)

```sh
#!/usr/bin/env bash
gum style --border rounded --padding "1 2" --border-foreground 212 "tiger data workshop setup"
NAME=$(gum input --placeholder "your name")
TARGET=$(gum choose "Tiger Cloud" "local docker")
gum spin --title "pulling images…" -- docker compose pull
gum confirm "ready, $NAME? start the $TARGET stack?" && docker compose up -d
```

**5. commit messages with a real body**

```sh
git commit -m "$(gum input --placeholder 'summary')" -m "$(gum write --placeholder 'why')"
```

### where NOT to use it

- **anything an agent or CI runs.** gum needs a real terminal and will hang or fail without one.
  if a script has to work both ways, guard it: `[ -t 0 ] && x=$(gum choose …) || x=default`
- **scripts you hand to other people**, unless they have gum too. for workshops, add `brew install gum`
  to the prereqs, or fall back to plain `read` when `command -v gum` fails.

## atuin + zsh: secret filter

commands matching these never hit history (atuin's `history_filter` in `~/.config/atuin/config.toml`
**and** a matching `zshaddhistory` hook in `~/.zshrc_shared`, so keep the two in sync if you edit them):

- neon api keys (`napi_…`)
- urls with inline passwords (`postgres://user:pass@…`, `mysql://…`, `https://user:token@…`)
- literal assignments like `FOO_TOKEN=abc123…`, `PGPASSWORD=…`, `--password=…`
  (references like `FOO_TOKEN=$(op read …)` or `=$VAR` are fine and still get saved)
- `Authorization: Bearer …`

atuin's built-in `secrets_filter` also catches AWS keys, GitHub PATs, Slack, Stripe.

```sh
atuin history prune --dry-run   # what existing history matches the filters
atuin history prune             # delete those entries
```

better habit than filtering: don't type secrets at all.

```sh
export NEON_API_KEY=$(op read "op://Private/Neon/credential")    # 1password
op run --env-file=.env -- ./bench.sh                              # .env holds op:// refs, not values
```
