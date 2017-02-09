# CLI support for jenkins.
#
#

: ${JENKINS_DEFAULT_ACTION:=home}



function jenkins() {
	emulate -L zsh
	local action=${1:=$JENKINS_DEFAULT_ACTION}

	local jenkins_url
	if [[ -f .jenkins-url ]]; then
		jenkins_url=$(cat .jenkins-url)
	elif [[ -f ~/.jenkins-url ]]; then
		jenkins_url=$(cat ~/.jenkins-url)
	elif [[ -n "${JENKINS_URL}" ]]; then
		jenkins_url=${JENKINS_URL}
	else
		_jenkins_url_help
		return 1
	fi

	if [[ $action == "home" ]]; then
		echo "Opening Jenkins home"
		open_command ${jenkins_url}
	elif [[ $action == "new" ]]; then
		echo "Opening new job"
		open_command ${jenkins_url}/view/All/newJob
	elif [[ $action == "node" ]]; then
		echo "Opening node $2"
		open_command "${jenkins_url}/computer/$(urlencode $2)"
	elif [[ $action == "search" ]]; then
		echo "Searching jenkins for $2"
		open_command "${jenkins_url}/search/?q=$(urlencode $2)"
	elif [[ $action == "job" ]]; then
		echo "Opening job"
		open_command "${jenkins_url}/job/$(urlencode $2)"
	else
		echo "Error: not a valid argument: $action"
		return 1
	fi



}

function _jenkins_job_open() {

}

function _jenkins_url_help() {
cat << EOF
error: JENKINS URL is not specified anywhere.

Valid options, in order of precedence:
.jenkins-url file
\$HOME/.jenkins-url file
\$JENKINS_URL environment variable
EOF
}
