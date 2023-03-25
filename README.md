# Helpers for Git hooks

[![Version](https://img.shields.io/github/v/tag/flex-is/git-hooks?label=stable&sort=semver)](https://github.com/flex-is/git-hooks/releases/latest)
[![Build](https://img.shields.io/github/actions/workflow/status/flex-is/git-hooks/ci.yaml?branch=main&logo=github)](https://github.com/flex-is/git-hooks/actions/workflows/ci.yaml)
[![License: MIT](https://img.shields.io/badge/license-MIT-informational.svg)](https://opensource.org/licenses/MIT)

This repository contains useful bash functions for git hooks.

## Installation

Download distributable file.

`$ curl -s https://raw.githubusercontent.com/flex-is/git-hooks/main/dist/all.sh -o ~/.bash_functions`

> 💡 When you invoke a script non-interactively, these functions will not be recognized by default. You must either import them in the beginning of every script using `. ~/.bash_functions`, or set up `BASH_ENV=/.../.bash_functions` path.

## Usage

Create simple git hooks using provided functions.

### pre-commit:

```bash
#!/bin/bash

# Validate coding standards
php_lint_cached
```

### pre-push:

```bash
#!/bin/bash

# Run static analysis tool
php_analyse
```

## Contributing

When creating a new version, please generate distributable files with MakeFile `dist` target. This process is not yet fully automated.

`$ make dist`

## License

This package is licensed using the MIT License.
