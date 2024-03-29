FROM openjdk:11

USER root
RUN apt-get update
RUN apt-get -y install curl
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -
RUN apt-get -y install nodejs
RUN npm install -g wait-on

ENV APP_HOME=/usr/local/app/

COPY ./wait-for.sh $APP_HOME
CMD chmod +x ./wait-for.sh

WORKDIR $APP_HOME

COPY ./build/libs/*service*.jar ./app.jar

EXPOSE 8761
EXPOSE 8888

ENTRYPOINT bash ./wait-for.sh "${WAIT_HOSTS}" && java -jar -Dspring.profiles.active=docker app.jar
