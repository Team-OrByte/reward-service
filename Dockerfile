FROM ballerina/ballerina:2201.12.7 AS builder

WORKDIR /app

COPY Ballerina.toml .
COPY *.bal .

RUN bal build

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY --from=builder /app/target/bin/reward_service.jar .

RUN mkdir -p logs

EXPOSE 9092

CMD ["java", "-jar", "reward_service.jar"]