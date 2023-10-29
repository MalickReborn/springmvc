FROM adoptopenjdk/openjdk11:alpine-jre

# the artifact path
ARG artifact=target/springmvc-for-my-CICD.jar

WORKDIR /opt/app

COPY ${artifact} app.jar

# This should not be changed
ENTRYPOINT ["java", "-jar" "app.jar"]
