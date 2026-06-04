# syntax=docker/dockerfile:1

FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# Copy build scripts first for better layer caching
COPY gradlew gradlew.bat build.gradle settings.gradle /app/
COPY gradle /app/gradle

# Copy sources
COPY src /app/src

RUN sed -i 's/\r$//' /app/gradlew \
    && chmod +x /app/gradlew \
    && /app/gradlew --no-daemon clean war

FROM tomcat:10.1-jre17-temurin

# Keep image small and avoid stale default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Gradle config builds ROOT.war for context-root deployment
COPY --from=build /app/build/libs/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
