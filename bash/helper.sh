function __exists()
{
    declare -f -F $1 > /dev/null
    return $?
}

function __set_git_aliases()
{
    for al in `__git_aliases`; do
        # Set alias
        alias g$al="git $al"

        # Set autocompletion if exist
        local complete_func=_git_$(__git_aliased_command $al)
        __exists $complete_func && __git_complete g$al $complete_func
    done
}
