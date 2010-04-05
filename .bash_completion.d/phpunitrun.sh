_phpunitrun()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="--log-junit --log-tap --log-json --coverage-html --coverage-clover --coverage-source --story-html --story-text --testdox-html --testdox-text --filter --group --exclude-group --list-groups --loader --story --tap --testdox --colors --stderr --stop-on-failure --verbose --wait --skeleton-class --skeleton-test --process-isolation --no-globals-backup --no-static-backup --syntax-check --bootstrap --configuration --no-configuration --include-path -d --help --version"

    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur} ) )
        return 0
    fi

    case "${prev}" in
        --@(help|version))
            return 0
            ;;
        # Directory completion options
        --@(coverage-html|coverage-source))
            _filedir -d
            return 0;
            ;;
        --@(group|exclude-group))
            GROUP=$(fgrep -ih '@group' *.php | sed 's/@group //' | tr '\n' ' ') 
            COMPREPLY=( $(compgen -W "${GROUP}" ${cur} ) )
            return 0;
            ;;
        *)
        COMPREPLY=( $(compgen -f ${cur}) )
        return 0
        ;;
    esac

}
complete -F _phpunitrun phpunitrun
complete -F _phpunitrun phpunit.php
complete -F _phpunitrun phpunit
