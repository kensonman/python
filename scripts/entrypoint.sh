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

	#Set user
	chown -R ${USERID} ${CWD}
}

# Init the django environments
init()
{
	echo "Going to init the container..."
	if [ -f ${REQUIREMENTS} ]; then
		pip install -r ${REQUIREMENTS}
	fi
}


makemessages()
{
	init
	APPNAME=${2:-app}
	LANG=${3:-zh_hant}
	echo "Going to makeing messages in project<${APPNAME}>..."
	cd ${CWD}
	cd ${APPNAME}

	# Create the locale directory
	if [ ! -d "locale" ]; then
		mkdir locale
	fi

	../manage.py makemessages ${LANG}
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
	echo "Going to execute the djanto testing server ...."
	cd ${CWD}

	./manage.py runserver 0.0.0.0:8000
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
	*)
		echo "Executing runtime command \"$@\"..."
		exec "$@"
esac
