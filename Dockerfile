FROM ballerina/ballerina:2201.12.7

WORKDIR /app
COPY . .

# Run as root to avoid permission issues
USER root

# Build and run
RUN bal build
EXPOSE 9092
CMD ["bal", "run", "target/bin/reward_service.jar"]