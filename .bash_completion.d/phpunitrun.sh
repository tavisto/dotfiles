_phpunitrun()
{
	local cur prev opts
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts="--log-json --log-tap --log-xml--coverage-html --coverage-clover --coverage-source--test-db-dsn --test-db-log-rev --test-db-prefix --test-db-log-info--story-html --story-text--testdox-html --testdox-text--filter --group --exclude-group --list-groups--loader --repeat--story --tap --testdox--colors --no-syntax-check --stop-on-failure --verbose --wait--skeleton-class --skeleton-test--process-isolation --no-globals-backup --no-static-backup --bootstrap --configuration --no-configuration --include-path -d --help --version "

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
complete -F _phpunitrun phpunit.php
