# ISDS 4125 — team Git exercise tools

Instructor utilities for the team Git activity.
Open this page on any laptop and use the copy button on a code block.

---

## Reset a team repo to an earlier checkpoint

Use this when a team has gone down a rabbit hole and needs to restart from a
clean point. Run it **from inside that team's project folder**.

### 1. See the checkpoints

```
curl -fsSL https://raw.githubusercontent.com/is-courses-practice-org/isds4125-f26-tools/main/reset.sh | bash
```

Prints the last 20 commits on `main`, newest first:

```
f29b430 merge didi's footer          <- end of Step 3b
92e5fce add content to events page   <- Step 2 checkpoint
7a64054 initial bookshop site        <- Step 1
```

### 2. Reset to one of them

Copy the command below, then paste the commit ID on the end.

```
curl -fsSL https://raw.githubusercontent.com/is-courses-practice-org/isds4125-f26-tools/main/reset.sh | bash -s --
```

So it ends up looking like:

```
curl -fsSL https://raw.githubusercontent.com/is-courses-practice-org/isds4125-f26-tools/main/reset.sh | bash -s -- f29b430
```

### 3. Everyone else re-syncs

The other team members run these in their own project folder. They do **not**
run the script.

```
git checkout --force main
git fetch --prune origin
git reset --hard origin/main
git clean --force -d
```

If a teammate made a branch, they delete it too, or they cannot reuse the name
when they redo the step:

```
git branch --delete --force <your-branch>
```

Simplest alternative for a badly stuck teammate: delete the project folder and
clone again.

---

## What the reset does

- `main` goes back to the commit you name, locally and on GitHub
- Branches whose work is **not yet in that commit** are deleted, on GitHub and locally
- Branches that already existed and were merged by then are **kept**
- Uncommitted edits and untracked files in the folder are discarded

Resetting to **end of Step 3b** keeps the `-footer` branches and deletes the
`-card` branches. Resetting to the **Step 2 checkpoint** deletes all of them.
The target commit decides — there is nothing to configure.

## Before you run it

- You must be inside the team's project folder (`cd` there first)
- Your clone should have only `main` locally — check with `git branch`.
  Any other local branch would get pushed up instead of deleted. A fresh clone
  is always safe.
- Nothing is pushed until the reset line runs, so step 1 is harmless

## Files

| File | What it is |
|---|---|
| `reset.sh` | The reset script above |
| `README.md` | This page |

## Updating the script

Edit `reset.sh`, commit, push. The URL does not change.

```
git add reset.sh && git commit -m "tweak reset" && git push origin main
```

Raw GitHub caches for about five minutes. To force a fresh copy straight after
an edit, add `?v=2` to the end of the URL.
