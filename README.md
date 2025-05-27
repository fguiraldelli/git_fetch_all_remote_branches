
# 🧠 Line-by-Line Explanation: `track-all-remote-branches.sh`

This script helps you **track all remote Git branches locally**. Optionally, you can also:

- Force re-track existing branches (`-f`)
- Pull the latest commits after tracking (`-p`)

---

## ✅ Script Usage

```bash
./track-all-remote-branches.sh [-f] [-p]

# Options:
# -f   Force re-track even if local branch already exists
# -p   Pull the latest commits after tracking
```

---

## 📜 Full Script

```bash
#!/bin/bash

# Track and optionally pull all remote branches from origin
# Usage: ./track-all-remote-branches.sh [-f] [-p]
#   -f: Force re-track even if local branch exists
#   -p: Pull latest changes after tracking

force=false
pull=false

# Parse arguments
while getopts ":fp" opt; do
  case $opt in
    f) force=true ;;
    p) pull=true ;;
    *) echo "Usage: $0 [-f] [-p]"; exit 1 ;;
  esac
done

for remote_branch in $(git branch -r | grep -v '\->'); do
    local_branch="${remote_branch#origin/}"

    if git show-ref --verify --quiet "refs/heads/$local_branch"; then
        if [ "$force" = true ]; then
            echo "Force tracking: $local_branch -> $remote_branch"
            git branch -f "$local_branch" "$remote_branch"
        else
            echo "Skipping: local branch '$local_branch' already exists."
        fi
    else
        echo "Tracking new branch: $local_branch -> $remote_branch"
        git branch --track "$local_branch" "$remote_branch"
    fi

    if [ "$pull" = true ]; then
        echo "Pulling latest commits for $local_branch..."
        git checkout "$local_branch" >/dev/null 2>&1
        git pull origin "$local_branch"
    fi
done

# Go back to previous branch if changed
git checkout - >/dev/null 2>&1
```

---

## 🧠 Line-by-Line Breakdown

### `#!/bin/bash`

Defines the script to run in Bash.

---

### Argument flags:

```bash
force=false
pull=false
```

Initializes flags to control optional behavior.

---

### Argument parsing:

```bash
while getopts ":fp" opt; do
  case $opt in
    f) force=true ;;
    p) pull=true ;;
    *) echo "Usage: $0 [-f] [-p]"; exit 1 ;;
  esac
done
```

Parses CLI arguments:
- `-f` sets force to true
- `-p` sets pull to true
- invalid flags show usage

---

### Remote branch loop:

```bash
for remote_branch in $(git branch -r | grep -v '\->'); do
```

- Lists remote branches (e.g., `origin/main`, `origin/feature-x`)
- Excludes symbolic refs like `origin/HEAD -> origin/main`

---

### Extract local name:

```bash
local_branch="${remote_branch#origin/}"
```

Removes the `origin/` prefix using Bash parameter expansion.

---

### Check if local branch exists:

```bash
if git show-ref --verify --quiet "refs/heads/$local_branch"; then
```

- Uses `git show-ref` to check if a local branch already exists.

---

### Re-track if `-f` is used:

```bash
git branch -f "$local_branch" "$remote_branch"
```

Force resets the local branch to track the remote one.

---

### Else skip:

```bash
echo "Skipping: local branch '$local_branch' already exists."
```

Skips tracking if no `-f` is passed and branch exists.

---

### Otherwise, track it:

```bash
git branch --track "$local_branch" "$remote_branch"
```

Creates a new local branch that tracks the remote branch.

---

### Optionally pull changes:

```bash
git checkout "$local_branch" >/dev/null 2>&1
git pull origin "$local_branch"
```

- Switches to the new branch
- Pulls latest changes from the remote

---

### Return to previous branch:

```bash
git checkout - >/dev/null 2>&1
```

- `git checkout -` switches back to the branch you were on before the loop.

---

## ✅ Summary of Flags

| Flag | Description                              |
|------|------------------------------------------|
| `-f` | Force re-track local branches if exists  |
| `-p` | Pull changes for each newly tracked branch |
| none | Only tracks new local branches           |

---

## ✅ Example Usages

```bash
./track-all-remote-branches.sh
./track-all-remote-branches.sh -f
./track-all-remote-branches.sh -p
./track-all-remote-branches.sh -fp
```

---

Happy Git tracking! 🚀
