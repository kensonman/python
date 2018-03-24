#!/bin/bash
#
# The entrypoint of the container.

CWD="/usr/src/app"
REQUIREMENTS=${REQUIREMENTS:-/usr/src/app/requirements.txt}
USERID=${UID:-1000}

create()
{
	APPNAME=${2:-app}
	echo "Going to create the django app<${APPNAME}>..."

	#Change current working directory
	cd $CWD

	#Install the django
	pip install django

	#Creating conf
	django-admin startproject conf
	mv conf/conf/* conf/
	rmdir conf/conf
	mv conf/manage.py .

	#Creating app
	django-admin startapp ${APPNAME}
	sed -i "/MIDDLEWARE/iINSTALLED_APPS+=['${APPNAME}',]" conf/settings.py 

	#Set user
	chown -R ${USERID} ${CWD}

	#Create the basic requirements.txt
	pip freeze > requirements.txt
}

# Init the django environments
init()
{
	echo "Going to init the container..."
	if [ -f ${REQUIREMENTS} ]; then
		pip install -r ${REQUIREMENTS}
		pip freeze > ${REQUIREMENTS}
	fi
}


makemessages()
{
	init
	APPNAME=${2:-app}
	LANG=${3:-zh_hant}
	echo "Going to makeing messages<${LANG}> in project<${APPNAME}>..."
	cd ${CWD}
	cd ${APPNAME}

	# Create the locale directory
	if [ ! -d "locale" ]; then
		mkdir locale
	fi

	../manage.py makemessages -l ${LANG}
}

compilemessages()
{
	init
	APPNAME=${2:-app}
	echo "Going to compile messages in project<${APPNAME}>..."
	cd ${CWD}
	cd ${APPNAME}

	../manage.py compilemessages
}

run()
{
	init
	echo "Going to execute the Django testing server ...."
	ADDR=${2:-"0.0.0.0:8000"}
	cd ${CWD}

	./manage.py runserver ${ADDR}
}

cmd()
{
	init
	echo "Going to execute the Django command...."
	cd ${CWD}

	./manage.py ${*:2}
}

printhelp()
{
	echo "This entrypoint support belows commands:"
	echo "  create           - Create a Django project;"
	echo "    Usage: create <AppName>"
	echo "  init             - Init the Django environment and install the dependencies;"
	echo "    Usage: init"
	echo "  makemessages     - Make the specify translation by django command;"
	echo "    Usage: makemessages <AppName> [LangCode|default:zh_hant]"
	echo "  compilemessages  - Compile the specify translation by django command;"
	echo "    Usage: compilemessages <AppName>"
	echo "  run              - Execute the testing server"
	echo "    Usage: run [Addr|default:\"0.0.0.0:8000\"]"
	echo "  exec             - Execute the specific Django command by prepend ./manage.py"
	echo "    Usage: exec <cmd>"
	echo "  help             - Print this help message"
	echo "    Usage: help"
}


case "$1" in
	create)
		create "$@"
		;;
	init)
		init "$@"
		;;
	makemessages)
		makemessages "$@"
		;;
	compilemessages)
		compilemessages "$@"
		;;
	run)
		run "$@"
		;;
	exec)
		cmd "$@"
		;;
	help)
		printhelp
		;;
	*)
		echo "Executing runtime command \"$@\"..."
		exec "$@"
esac
