_phpunitrun()
{
	local cur prev opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts="--help --verbose --coverage-html --coverage-xml --filter --group --exclude-group --stop-on-failure --wait --log-json --log-tap --log-xml --log-metrics --log-pmd --configuration"

	if [[ ${cur} == -* ]]; then
		COMPREPLY=( $(compgen -W "${opts}" -- ${cur} ) )
		return 0
	fi

	case "${prev}" in
		 --help)
			return 0
			;;
		 --version)
		 	return 0
			;;
		*)
			COMPREPLY=( $(compgen -f ${cur}) )
			return 0
			;;
	esac

}
complete -F _phpunitrun phpunitrun
