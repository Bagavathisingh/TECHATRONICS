# Build stage
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# Copy maven wrapper and pom.xml first to cache dependencies
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
# Make sure the wrapper is executable
RUN chmod +x ./mvnw
RUN ./mvnw dependency:go-offline

# Copy the rest of the source code and build it
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Run stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/backend-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
