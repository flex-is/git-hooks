# Returns true if current commit is a merge commit
git_is_merge_commit() {
    if git rev-parse -q --verify MERGE_HEAD; then
        true
        return
    fi

    false
}
