# Multi-stage Dockerfile: build WAR with Maven, run on Tomcat
FROM maven:3.8.8-openjdk-8 AS build
WORKDIR /build

# Copy only what is needed for Maven to download dependencies first
COPY pom.xml ./
COPY src ./src

RUN mvn -B -DskipTests package

FROM tomcat:9.0-jdk8
# Remove default webapps (optional) and deploy our WAR as ROOT
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /build/target/SIH3-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
