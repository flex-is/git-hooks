# Helpers for Git hooks

[![Version](https://img.shields.io/github/v/tag/flex-is/git-hooks?label=stable&sort=semver)](https://github.com/flex-is/git-hooks/releases/latest)
[![Build](https://img.shields.io/github/actions/workflow/status/flex-is/git-hooks/ci.yaml?branch=main&logo=github)](https://github.com/flex-is/git-hooks/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-informational.svg)](https://opensource.org/licenses/MIT)

This repository contains useful bash functions for git hooks.

## Installation

Simply download latest distributable into a destination of your choosing. To eliminate conflicts, you can create a dedicated file, e.g. `~/.bash_functions`.

`$ curl -s https://raw.githubusercontent.com/flex-is/git-hooks/vX.Y.Z/dist/all.sh -o ~/.bash_functions`

Then include it in `~/.bash_aliases`.

```bash
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi
```

> 💡 When you invoke script non-interactively, these functions will not be recognized by default. You must either import them in the beginning of every script or set up variable `BASH_ENV=/.../.bash_functions`.

## Usage

Commit `.githooks` directory in the root of your project and place hooks inside it. Hook names are identical to the [ones used by git](https://git-scm.com/docs/githooks).

```
└── .githooks
    ├── pre-commit
    └── pre-push
```

Then generate git hooks using `git_install_hooks_local` or `git_install_hooks_remote`, if you are developing on a remote server.

### Remote example

#### `.git/hooks/pre-commit`:

```bash
#!/bin/sh
ssh dev "cd /path/to/project; sh .githooks/pre-commit"
### @auto-generated
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
