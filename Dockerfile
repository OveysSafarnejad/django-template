FROM python:3.9-alpine3.13

LABEL maintainer="safarnejad@outlook.com"

# printing logs when creating container
ENV PYTHONUNBUFFERD 1

COPY ./requirements.txt /source/requirements.txt
COPY ./src /source/src
COPY ./scripts /source/scripts

# this is like cd /src
WORKDIR /source/src

# make container open by port 8000
EXPOSE 8000


# it's a single line command because it will add multiple layers to the container 
# if we use seprate line commnads for eahc of them
RUN python3 -m venv /source/.venv && \
    # packages for psycopg2 in alpine version of base image
    apk add --update --no-cache postgresql-client && \
    # unneccessary packages can be removed after installing requirements using --virtual .tmp-deps 
    apk add --update --no-cache --virtual .tmp-deps \
    build-base postgresql-dev musl-dev linux-headers && \
    #
    /source/.venv/bin/pip install --upgrade pip && \
    /source/.venv/bin/pip install -r /source/requirements.txt && \
    # removing unneccessary packages
    apk del .tmp-deps && \
    # creating non-root user for limitted permissions
    adduser --disabled-password --no-create-home appuser && \
    # creating static and media dirs and giving access for R/W to the appuser
    mkdir -p /source/vol/web/static && \
    mkdir -p /source/vol/web/media && \
    chown -R appuser:appuser /source/vol && \
    chmod -R 755 /source/vol && \
    chmod -R +x /source/scripts

# adding python environment from /.venv to the path
# now-on any python command will use /.venv python interpreter 
ENV PATH="/source/scripts:/source/.venv/bin:$PATH"

# switching root user to appuser 
# the appuser does not have full access
USER appuser

CMD ["run.sh"]