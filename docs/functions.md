# Function index

-   [`git_check_whitespace_cached`](#git-validation) - Check whitespace errors on cached/staged files
-   [`git_current_branch`](#git-branch) - Returns short name of the current branch
-   [`git_install_hooks_local`](#git-hooks) - Install standard git hooks
-   [`git_install_hooks_remote`](#git-hooks) - Install git hooks with remote calls
-   [`git_is_merge_commit`](#git-branch) - Check whether the current commit is a merge commit
-   [`git_is_current_branch_in_list`](#git-branch) - Check whether the current branch is in provided list
-   [`msg_error`](#message-output) - Print a given string with a semantic error prefix
-   [`msg_info`](#message-output) - Print a given string with a semantic into prefix
-   [`php_analyse`](#php-analyse) - Run PHP static analysis tool
-   [`php_cs_cached`](#php-lint) - Alias for `php_lint_cached`
-   [`php_lint_cached`](#php-lint) - Run PHP linter tool on cached/staged files

# Message output

Use common format for message outputs with emphasis on semantic value.

```bash
msg_info "running php static analysis..."
# ~ [INFO] running php static analysis...

msg_error "php static analysis failed"
# ~ [ERROR] php static analysis failed
```

# Git

## Git validation

```bash
# Check whitespace errors on cached/staged files
git_check_whitespace_cached
```

## Git branch

```bash
# Get short name of the current branch
if [ git_current_branch == 'main' ]; then
    ...
fi
```

```bash
# Check whether the current branch is in provided list
if [ git_is_current_branch_in_list 'main' 'pu' 'next' ]; then
    ...
fi
```

```bash
# Check whether the current commit is a merge commit
if [ git_is_merge_commit ]; then
    ...
fi
```

## Git hooks

Install local hook.

```bash
$ git_install_hooks_local
Enter script directory (scripts/git/hooks): # relative path to hook scripts
```

Install remote hook.

```bash
$ git_install_hooks_remote
Enter SSH host: # remote host
Enter project root directory (pwd): # project root
Enter script directory (scripts/git/hooks): # relative path to hook scripts
```

# PHP

## PHP Analyse

Run PHP static analysis tool [PHPStan](https://phpstan.org) based on committed configuration file.

```bash
php_analyse
# php vendor/bin/phpstan analyse -c phpstan.dist.neon --memory-limit=4G --no-interaction --no-progress --quiet
```

## PHP Lint

Run [PHP Coding Standards Fixer](https://cs.symfony.com) on cached (or staged) files.

> 💡 `--dry-run` flag is used to prevent modifications, in the case of committing hunks instead of entire files.

```bash
php_lint_cached
# php vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.dist.php --no-interaction --dry-run --stop-on-violation --quiet $cached_files

# aliases
php_cs_cached
```
