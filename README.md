Introduction
============

The project used to create a docker-image for python3 (default with django) container.

Build
-----

Just simply execute the build command.

		git clone https://github.com/kensonman/python kenson.python
		cd kenson.python
		docker build -t kensonman/python:latest .

Usage
-----

The project will creating the iamge base on [python:alpine](https://hub.docker.com/_/python/) image.
It will provide an [entrypoint](https://github.com/kensonman/python/blob/master/scripts/entrypoint.sh) for execution.


### Create command
Create the Django project with basic application.

		docker run --rm kensonman/python:latest create newapp

### Make Messages command
Make the specific translation messages.

		docker run --rm kensonman/python:latest makemessages newapp zh_hant

### Compile Message command
Compile the translation messages.

		docker run --rm kensonman/python:latest compilemessages newapp

### Run command
Execute the Django testing environment.

		docker run --rm kensonman/python:latest run 0.0.0.0:8000

### Exec command
Execute the specific [Django command](https://docs.djangoproject.com/en/2.0/ref/django-admin/).

		docker run --rm kensonman/python:latest exec createsuperuser --username kenson
