FROM anapsix/alpine-java:jdk8
MAINTAINER Mike Czabaj

RUN apk --no-cache add \
      wget

RUN wget -O /usr/local/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
RUN chmod a+x /usr/local/bin/lein

ENV LEIN_ROOT true
# Update bashrc file for user
ENV APP_HOME_DIR /usr/src/app
RUN mkdir -p $APP_HOME_DIR
WORKDIR $APP_HOME_DIR

# Do this step to "pre-fetch" the project dependencies
# - this caches the docker container at this step for all dependencies, and
#   bypasses the dependency fetch step for every code change
COPY project.clj project.clj
RUN lein deps

# add the rest of the assets
RUN mkdir src test resources env
COPY src src/
COPY test test/
COPY resources resources/
COPY env env/
COPY bootstrap_app.sh ./

RUN lein uberjar

# Start the server
ENTRYPOINT ["/usr/src/app/bootstrap_app.sh"]

# No default params need to be passed, leaving them blank intentionally
CMD []
