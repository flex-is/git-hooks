# Install git hooks with provided commands
git_install_hooks() {
    local -r separator='### @auto-generated'
    local -i line=0

    commands=("$@")

    find .githooks -type f | while read source
    do
        hook=".git/hooks/$(basename -- $source)"
        line=$(sed -n -e "/${separator}/=" $hook | sed -n '$p')
        touch $hook

        if ! [ -z $line ]; then
            sed -i "1,${line}d" $hook
        fi

        sed -i '1i #!/bin/sh' $hook
        line=1
        for command in "${commands[@]}"; do
            line+=1
            command="${command//\@source/$source}"
            sed -i "${line}i $command" $hook
        done
        line+=1
        sed -i "${line}i $separator" $hook

    done
}

# Install git hooks with local calls
git_install_hooks_local() {
    local commands=("sh @source")

    git_install_hooks "${commands[@]}"
}

# Install git hooks with remote calls
git_install_hooks_remote() {
    local commands=()

    read -p "Enter SSH host: " remoteHost
    read -p "Enter remote path ($(pwd)): " remoteDir
    if [ -z $remoteDir ]; then
        remoteDir=$(pwd)
    fi

    commands+=("ssh $remoteHost \"cd $remoteDir; sh @source\"")

    git_install_hooks "${commands[@]}"
}

# Returns true if current commit is a merge commit
git_is_merge_commit() {
    if git rev-parse -q --verify MERGE_HEAD; then
        true
        return
    fi

    false
}
