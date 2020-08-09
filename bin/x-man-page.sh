URL=$1
SECTION=$(echo $URL | awk -F '/' '{print $1}')
COMMAND=$( echo $URL | awk -F '/' '{print $2}' )
man $SECTION $COMMAND
