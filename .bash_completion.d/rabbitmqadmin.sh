# This is a bash completion script for rabbitmqadmin.
# Redirect it to a file, then source it or copy it to /etc/bash_completion.d
# to get tab completion. rabbitmqadmin must be on your PATH for this to work.
_rabbitmqadmin()
{
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    opts="list show declare delete close purge import export get publish help"
    fargs="--help --host --port --vhost --username --password --format --depth"

    case "${prev}" in
    list)
        COMPREPLY=( $(compgen -W 'connections channels nodes users exchanges vhosts queues bindings permissions' -- ${cur}) )
            return 0
            ;;
    show)
        COMPREPLY=( $(compgen -W 'overview' -- ${cur}) )
            return 0
            ;;
    declare)
        COMPREPLY=( $(compgen -W 'permission exchange binding queue vhost user' -- ${cur}) )
            return 0
            ;;
    delete)
        COMPREPLY=( $(compgen -W 'permission exchange binding queue vhost user' -- ${cur}) )
            return 0
            ;;
    close)
        COMPREPLY=( $(compgen -W 'connection' -- ${cur}) )
            return 0
            ;;
    purge)
        COMPREPLY=( $(compgen -W 'queue' -- ${cur}) )
            return 0
            ;;
    export)
        COMPREPLY=( $(compgen -f ${cur}) )
            return 0
            ;;
    import)
        COMPREPLY=( $(compgen -f ${cur}) )
            return 0
            ;;
    help)
            opts="subcommands config"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
    -@(H|-host))
        COMPREPLY=( $(compgen -A hostname ${cur}) )
            return 0
            ;;
    -@(V|-vhost))
            opts="$(rabbitmqadmin -q -f bash list vhosts)"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
    -@(u|-username))
            opts="$(rabbitmqadmin -q -f bash list users)"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
    -@(f|-format))
        COMPREPLY=( $(compgen -W "raw_json long pretty_json kvp tsv table bash"  -- ${cur}) )
            return 0
            ;;

        connection)
            opts="$(rabbitmqadmin -q -f bash list connections)"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
        channel)
            opts="$(rabbitmqadmin -q -f bash list channels)"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
        node)
            opts="$(rabbitmqadmin -q -f bash list nodes)"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
        user)
            opts="$(rabbitmqadmin -q -f bash list users)"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
        exchange)
            opts="$(rabbitmqadmin -q -f bash list exchanges)"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
        vhost)
            opts="$(rabbitmqadmin -q -f bash list vhosts)"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
        queue)
            opts="$(rabbitmqadmin -q -f bash list queues)"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
        binding)
            opts="$(rabbitmqadmin -q -f bash list bindings)"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
        permission)
            opts="$(rabbitmqadmin -q -f bash list permissions)"
        COMPREPLY=( $(compgen -W "${opts}"  -- ${cur}) )
            return 0
            ;;
        *)
        ;;
    esac

   COMPREPLY=($(compgen -W "${opts} ${fargs}" -- ${cur}))
   return 0
}
complete -F _rabbitmqadmin rabbitmqadmin

