FROM openjdk:11-jre-slim

WORKDIR /acid-java-app
COPY target/acid-java-app.jar acid-java-app.jar

CMD ["java", "-jar", "acid-java-app.jar"]
