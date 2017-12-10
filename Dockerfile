FROM java:8-alpine
MAINTAINER Mike Czabaj

RUN lein deps
RUN lein uberjar

ADD target/uberjar/line_server.jar /line_server/app.jar

EXPOSE 3000

CMD ["java", "-jar", "/line_server/app.jar"]
