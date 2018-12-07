FROM library/alpine:latest AS build

RUN apk update
RUN apk add curl
RUN apk add unzip

RUN curl -O "http://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip"
RUN unzip newrelic-java.zip -d /


FROM gcr.io/distroless/java
COPY --from=build /newrelic /newrelic
ADD ./newrelic.yml /newrelic/newrelic.yml
