# define python image 3.8-alpine3.13 as base image
FROM python:3.8-alpine3.13

# set maintainer
LABEL maintainer="Aamer"

# set environment variables for PYTHONUNBUFFERED to 1
ENV PYTHONUNBUFFERED 1

# copy requirements.txt file to /tmp/requirements.txt
COPY ./requirements.txt /tmp/requirements.txt

# copy DEV requirements.dev.txt file to /tmp/requirements.dev.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# set working directory to /app
WORKDIR /app

# copy working directory to /app
COPY .app/app /app

# expose port 8000
EXPOSE 8000

ARG DEV=false

# create a virtaul environment for python dependencies
RUN python -m venv /py 

# update pip
RUN /py/bin/pip install --upgrade pip 

# install the requirements
RUN /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi

# remove temp folder
RUN rm -rf /tmp 

# add user django-user, disable password and no home directory
RUN adduser --disabled-password --no-create-home django-user

# update the evvironment variables to /py/bin:$PATH
ENV PATH="/py/bin:$PATH"

# switch to django-user
USER django-user
