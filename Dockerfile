FROM ballerina/ballerina:2201.9.0
WORKDIR /app
COPY . .
CMD ["bal", "run"]
