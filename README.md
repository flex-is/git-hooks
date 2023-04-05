# Git hooks

[![Version](https://img.shields.io/github/v/tag/flex-is/git-hooks?label=stable&sort=semver)](https://github.com/flex-is/git-hooks/releases/latest)
[![Build](https://img.shields.io/github/actions/workflow/status/flex-is/git-hooks/ci.yaml?branch=main&logo=github)](https://github.com/flex-is/git-hooks/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-informational.svg)](https://opensource.org/licenses/MIT)

This repository contains useful bash functions for git hooks, including sharing hooks with your team.

## Installation

`$ curl -s https://raw.githubusercontent.com/flex-is/git-hooks/VERSION/dist/all.sh -o ~/.bash_functions`

Download the latest distributable file to the desired location. To eliminate conflicts, you can create a dedicated file `~/.bash_functions` and import it in `~/.bash_aliases`:

```bash
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi
```

> 💡 When you invoke script non-interactively, these functions will not be recognized by default. You must either import them in the beginning of every script or set up variable `BASH_ENV=/.../.bash_functions`.

## Usage

Manually create a local git hook. Here is the list of currently provided functions:
-   git
    -   `git_is_merge_commit` - check whether current commit is a merge commit
-   php
    -   `php_lint_cached` - validate coding standards only on cached/staged files
    -   `php_analyse` - run static analysis tool

## Share

If you are developing in a team, you can create and share hooks inside the same repository.

Create `.githooks` directory in the root of your project and commit hook files inside it. Hook names are identical to the [ones used by git](https://git-scm.com/docs/githooks).

```
└── .githooks
    ├── pre-commit
    └── pre-push
```

Generate local hooks using `git_install_hooks_local`. If you are developing on a remote server, you can use `git_install_hooks_remote`, where you will be asked for SSH host and remote path.

### Remote example

#### `.git/hooks/pre-commit`:

```bash
#!/bin/sh
ssh remote_host "cd /remote/path; sh .githooks/pre-commit"
########## @auto-generated ##########
```

#### `.githooks/pre-commit`:

```bash
#!/bin/bash

# Validate coding standards
php_lint_cached
```

## Contributing

When creating a new version, please generate distributable files with MakeFile `dist` target. This process is not yet fully automated.

`$ make dist`

## License

This package is licensed using the MIT License.
