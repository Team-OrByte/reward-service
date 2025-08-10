FROM ballerina/ballerina:2201.12.7

WORKDIR /app
COPY . .

RUN addgroup -g 10001 appgroup && \
    adduser -S -u 10001 -G appgroup appuser

USER 10001

RUN bal build

EXPOSE 9092
CMD ["bal", "run", "target/bin/reward_service.jar"]
