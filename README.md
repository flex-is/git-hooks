# Git hooks

[![Version](https://img.shields.io/github/v/tag/flex-is/git-hooks?label=stable&sort=semver)](https://github.com/flex-is/git-hooks/releases/latest)
[![Build](https://img.shields.io/github/actions/workflow/status/flex-is/git-hooks/ci.yaml?branch=main&logo=github)](https://github.com/flex-is/git-hooks/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-informational.svg)](https://opensource.org/licenses/MIT)

This repository contains useful bash functions for git hooks, including sharing hooks with your team.

> 💡 See [documentation](/docs/functions.md) for the list of all functions.

# Installation

First, download the distributable file and save it to the desired location. To eliminate conflicts, create a dedicated file, e.g. `~/.bash_functions`.

`$ curl -s https://raw.githubusercontent.com/flex-is/git-hooks/VERSION/dist/all.sh -o ~/.bash_functions`

# Import

To actually use the functions, you have to "import" or "include" them into your shell environment. You can import them directly in `~/.bash_aliases`:

```bash
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi
```

> ⚠ When you invoke script non-interactively, these functions will not be recognized by default. You must either import them in the beginning of every script or set up variable `BASH_ENV=/.../.bash_functions`.

# Usage

Create a dedicated directory in your project and commit hook files inside it. Hook names are identical to the [ones used by git](https://git-scm.com/docs/githooks). We use `scripts/git/hooks` in our example.

`project_root`:

```
└── scripts
    └──  git
        └── hooks
            ├── pre-commit
            └── pre-push
```

`scripts/git/hooks/pre-commit`:

```bash
#!/bin/bash

git_check_whitespace_cached
```

## Local server

Generate local hooks using `git_install_hooks_local`. You will be asked to provide a relative path to hook scripts.

```bash
$ git_install_hooks_local
Enter script directory (scripts/git/hooks): # relative path to hook scripts
```

## Remote server

Generate local hooks, with calls to a remote server, using `git_install_hooks_remote`. In addition to local hooks, you will be asked to provide SSH host and remote project root.

```bash
$ git_install_hooks_remote
Enter SSH host: # remote host
Enter project root directory (pwd): # project root
Enter script directory (scripts/git/hooks): # relative path to hook scripts
```

> 💡 You can add custom logic directly into your local git hooks (`.git/hooks/` directory), provided that you only change the lines after this placeholder:  
> ########## @auto-generated ##########

# Development

When creating a new version, please update `VERSION` file and generate distributable files with MakeFile `dist` recipe. This process is not automated.

`$ make dist`

# License

This package is licensed using the MIT License.
