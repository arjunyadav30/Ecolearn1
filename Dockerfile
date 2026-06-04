# Multi-stage Dockerfile: build WAR with Maven, run on Tomcat
FROM maven:3.6.3-jdk-11 AS build
WORKDIR /build

# Copy only what is needed for Maven to download dependencies first
COPY pom.xml ./
COPY src ./src

RUN mvn -B -DskipTests package

FROM tomcat:9.0-jdk11
# Remove default webapps (optional) and deploy our WAR as ROOT
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /build/target/SIH3-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
# Disable Tomcat shutdown port to avoid external probes hitting it
RUN sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml || true
EXPOSE 8080
CMD ["catalina.sh", "run"]
