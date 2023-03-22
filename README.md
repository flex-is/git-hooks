# Helpers for Git hooks

![Version](https://img.shields.io/github/v/tag/flex-is/git-hooks?label=stable&sort=semver)
[![License: MIT](https://img.shields.io/badge/license-MIT-informational.svg)](https://opensource.org/licenses/MIT)

This repository contains useful bash functions for git hooks.

## Installation

Download and execute scripts:

`$ . <(curl -s https://raw.githubusercontent.com/flex-is/git-hooks/main/dist/all.sh)`

## Usage

Create simple git hooks using provided functions.

### pre-commit:

```bash
#!/bin/bash

# Validate coding standards
if ! git_is_merge_commit; then
    php_lint_cached
fi
```

### pre-push:

```bash
#!/bin/bash

# Run static analysis tool
php_analyse
```

## Contributing

When creating a new version, please generate distributables with MakeFile recipe. This process is not yet fully automated.

`$ make`

## License

This package is licensed using the MIT License.
