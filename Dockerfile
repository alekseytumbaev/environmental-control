FROM amazoncorretto:17-alpine-jdk as builder
WORKDIR /app
COPY . .
RUN ./gradlew bootJar

FROM amazoncorretto:17-alpine-jdk
COPY --from=builder /app/build/libs/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]