# Install git hooks with provided commands
git_install_hooks() {
    local -r separator='### @auto-generated'
    commands=("$@")

    find .githooks -type f | while read source
    do
        hook=".git/hooks/$(basename -- $source)"
        touch $hook

        line=$(sed -n -e "/$separator/=" $hook | sed -n '$p')
        if ! [ -z $line ]; then
            sed -i "1,${line}d" $hook
        fi

        if ! [ -s $hook ]; then
            echo '#!/bin/sh' > $hook
            echo $separator >> $hook
        else
            sed -i "2i $separator" $hook
        fi

        numcmd=$((${#commands[@]}-1))
        for i in $(seq $numcmd -1 0); do
            command="${commands[$i]//\@source/$source}"
            sed -i "2i $command" $hook
        done

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
