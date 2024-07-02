# FROM eclipse-temurin:17-jdk-alpine
# VOLUME /tmp
# COPY target/Vchat-1.jar VChat.jar
# ENTRYPOINT ["java","-jar","/VChat.jar"]

# FROM eclipse-temurin:17-jdk-alpine
# VOLUME /tmp
# COPY target/*.jar app.jar
# ENTRYPOINT ["java","-jar","/app.jar"]

# Importing JDK and copying required files
FROM openjdk:19-jdk AS build
WORKDIR /app
COPY pom.xml .
COPY src src

# Copy Maven wrapper
COPY mvnw .
COPY .mvn .mvn

# Set execution permission for the Maven wrapper
RUN chmod +x ./mvnw
RUN ./mvnw clean package -DskipTests

# Stage 2: Create the final Docker image using OpenJDK 19
FROM openjdk:19-jdk
VOLUME /tmp

# Copy the JAR from the build stage
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
EXPOSE 8080
